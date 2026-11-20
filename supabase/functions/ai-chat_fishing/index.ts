import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type, x-supabase-client-platform, x-supabase-client-platform-version, x-supabase-client-runtime, x-supabase-client-runtime-version",
};

interface ConversationMessage {
  message: string;
  direction: string;
  created_at: string;
}

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const lovableApiKey = Deno.env.get("LOVABLE_API_KEY");
    const delegatesAi = !!(Deno.env.get("AI_GENERATE_URL") && Deno.env.get("BOT_API_KEY"));
    if (!lovableApiKey && !delegatesAi) {
      throw new Error("Neither LOVABLE_API_KEY nor AI_GENERATE_URL/BOT_API_KEY configured");
    }


    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const supabase = createClient(supabaseUrl, supabaseServiceKey, {
      db: { schema: "fishing" },
    });

    const { message, phoneNumber, conversationHistory, userId, sessionApiKey, senderName } = await req.json();

    console.log(`Processing AI chat for ${phoneNumber} (user: ${userId}): ${message}`);

    // Fetch products, FAQs, settings, profile, and platform limits
    const [productsRes, faqsRes, settingsRes, profileRes, platformLimitsRes] = await Promise.all([
      supabase.from("products").select("*").eq("is_active", true).eq("user_id", userId).order("name", { ascending: true }),
      supabase.from("faqs").select("*, products(name)").eq("is_active", true).eq("user_id", userId),
      supabase.from("settings").select("key, value").eq("user_id", userId),
      supabase.from("profiles").select("plan_tier, billing_cycle_start, is_paused, addon_contacts, addon_orders").eq("user_id", userId).single(),
      supabase.from("platform_settings").select("value").eq("key", "plan_limits").single(),
    ]);

    // Check if account is paused
    if (profileRes.data?.is_paused) {
      console.log(`Account paused for user ${userId}`);
      return new Response(
        JSON.stringify({ error: "Account paused", response: "Sorry, this business account is currently paused. Please try again later." }),
        { status: 403, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const planTier = profileRes.data?.plan_tier || "free";
    const allLimits = platformLimitsRes.data?.value || {};
    const tierLimits = allLimits[planTier] || {};
    const contactLimit = (tierLimits.contacts_per_month || 50) + (profileRes.data?.addon_contacts || 0);

    // Use billing cycle start for monthly count
    const billingStart = profileRes.data?.billing_cycle_start;
    let monthStart: string;
    if (billingStart) {
      const start = new Date(billingStart);
      const now = new Date();
      const current = new Date(start);
      while (true) {
        const next = new Date(current);
        next.setMonth(next.getMonth() + 1);
        if (next > now) break;
        current.setMonth(current.getMonth() + 1);
      }
      monthStart = current.toISOString();
    } else {
      const d = new Date();
      d.setDate(1);
      d.setHours(0, 0, 0, 0);
      monthStart = d.toISOString();
    }
    // Contact-based billing: only NEW contacts are blocked once the allowance is used up.
    const contactKey = String(phoneNumber || "").split("@")[0].replace(/\D/g, "");
    const { data: alreadyCounted } = await supabase
      .from("contact_usage")
      .select("id")
      .eq("user_id", userId)
      .eq("phone_number", contactKey)
      .gte("created_at", monthStart)
      .maybeSingle();

    const { data: contactsUsed } = await supabase.rpc("get_contact_usage", {
      _user_id: userId,
      _since: monthStart,
    });

    // Also check orders limit
    const ordersLimit = (tierLimits.max_orders_per_month || 50) + (profileRes.data?.addon_orders || 0);
    const { count: ordersCount } = await supabase
      .from("orders")
      .select("id", { count: "exact", head: true })
      .eq("user_id", userId)
      .gte("created_at", monthStart);

    if (!alreadyCounted && (contactsUsed || 0) >= contactLimit) {
      console.log(`Contact limit reached for user ${userId}: ${contactsUsed}/${contactLimit}`);
      return new Response(
        JSON.stringify({ error: "Monthly contact limit reached. Please upgrade your plan.", response: "Sorry, the monthly contact limit has been reached. Please contact the business owner." }),
        { status: 429, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }


    const ordersLimitReached = (ordersCount || 0) >= ordersLimit;

    const products = productsRes.data || [];
    const faqs = faqsRes.data || [];
    const settings = settingsRes.data || [];

    const welcomeMessage = settings.find(s => s.key === "welcome_message")?.value?.text || "Welcome! How can I help you?";
    const paymentInfo = settings.find(s => s.key === "payment_info")?.value || {};
    const deliverySettings = settings.find(s => s.key === "delivery_settings")?.value || {};
    const freeDeliveryThreshold = deliverySettings.free_delivery_threshold || 0;
    const staffPhoneSetting = settings.find(s => s.key === "staff_phone_numbers")?.value;
    const rawStaffNumbers: { name?: string; phone: string }[] = Array.isArray(staffPhoneSetting)
      ? staffPhoneSetting
      : (staffPhoneSetting?.phone_numbers || staffPhoneSetting?.numbers || []);
    const staffContactsList = rawStaffNumbers
      .filter((s: any) => s && s.phone && String(s.phone).trim())
      .map((s: any) => `- ${s.name ? `${s.name}: ` : ""}${s.phone}`)
      .join("\n");

    const productById = new Map<string, any>();
    const productImageMap: Record<string, string[]> = {};
    const productVideoMap: Record<string, string> = {};

    for (const p of products) {
      if (p.id) productById.set(p.id, p);
      if (p.images && Array.isArray(p.images) && p.images.length > 0) {
        productImageMap[p.name.toLowerCase()] = p.images.filter((img: string) => typeof img === "string" && img.trim().length > 0);
      }
      if (p.video_url) {
        productVideoMap[p.name.toLowerCase()] = p.video_url;
      }
    }

    const productCatalog = products.map(p => {
      let line = `[ID: ${p.id}] ${p.name} - LKR ${p.price}`;
      if (p.product_type === "physical" && p.delivery_price && p.delivery_price > 0) {
        line += ` | Delivery: LKR ${p.delivery_price}`;
      }
      if (p.description) line += ` | ${p.description}`;
      if (p.variations && Array.isArray(p.variations) && p.variations.length > 0) {
        const varLines = p.variations.map((v: any) => {
          const opts = v.options?.map((o: any) => {
            if (typeof o !== "object") return o;
            let optStr = `${o.label}: LKR ${o.price}`;
            if (o.subVariants && Array.isArray(o.subVariants) && o.subVariants.length > 0) {
              const subLines = o.subVariants.map((sv: any) => {
                const reqTag = sv.required ? " (REQUIRED)" : " (opt)";
                const subOpts = sv.options?.map((so: any) =>
                  typeof so === "object" ? `${so.label}: +LKR ${so.price}` : so
                ).join(", ");
                return `[${sv.name}${reqTag}: ${subOpts}]`;
              }).join(" ");
              optStr += ` ${subLines}`;
            }
            return optStr;
          }).join(", ");
          return `${v.name}: ${opts}`;
        }).join("; ");
        line += ` | Variations: ${varLines}`;
      }
      return line;
    }).join("\n");

    // Build FAQ context with IDs so AI can report which ones it used
    const faqContext = faqs.map(f =>
      `[FAQ_ID:${f.id}] Q: ${f.question}\nA: ${f.answer}${f.products?.name ? ` (Related to: ${f.products.name})` : ""}`
    ).join("\n\n");

    // Get list of tracked FAQ IDs
    const trackedFaqIds = faqs.filter(f => f.is_tracked).map(f => f.id);

    const conversationContext = (conversationHistory as ConversationMessage[])
      .map(msg => `${msg.direction === "inbound" ? "Customer" : "Assistant"}: ${msg.message}`)
      .join("\n");

    const systemPrompt = `You are a friendly, helpful WhatsApp assistant for a fishing gear store.
Answer questions, help customers pick fishing gear, and take orders.

RULES:
1. Language: Auto-detect and reply in the exact language the customer uses.
2. Brevity & Style: WhatsApp messages must be short and scannable (2-4 lines max). Use emojis nicely. NO markdown headers (#), NO markdown tables, NO raw URLs.
3. Catalog & Search: Check the PRODUCT CATALOG below. All listed items are in stock. When a customer inquires about a category, brand, or product type, present all matching items from the catalog. Never claim an item is unavailable if it exists in the catalog.
4. Conversation Continuity: When a customer sends a short follow-up or refinement while discussing a product, maintain the active topic. Filter or narrow down the product already being discussed instead of searching the entire catalog afresh. Only introduce other products if the customer explicitly asks to change products or explore alternatives.
5. Photos & Videos (MANDATORY): Whenever you mention, suggest, or describe ANY product(s), you MUST append their IDs at the very end in:
   <PRODUCT_MEDIA>id1, id2</PRODUCT_MEDIA>
   Never ask the customer if they want photos—always attach the tag so photos send immediately. Do not write image URLs yourself.
6. Ordering: To place an order, collect: Name, Phone, Shipping Address, District/City, Product selection & variation, and Payment Method (COD or Bank Transfer). Required sub-variants must be chosen.
   Ask the customer to confirm the order summary first. ONLY append <ORDER_JSON>...</ORDER_JSON> after the customer confirms. Never emit it while asking questions.
   <ORDER_JSON>{"customer_name":"...","customer_phone":"...","district":"...","customer_address":"...","order_items":[{"name":"...","price":...,"quantity":...,"product_type":"physical"}],"payment_method":"cod or bank_transfer","total_amount":...}</ORDER_JSON>
7. FAQ: If you use information from an FAQ below, append <USED_FAQS>id1,id2</USED_FAQS> at the end.
8. Payment Accounts:
${(() => {
        const accounts = paymentInfo.accounts;
        if (accounts && Array.isArray(accounts) && accounts.length > 0) {
          return accounts.map((a: any) => {
            const label = a.account_label || a.bank_name || "Bank";
            const number = a.account_number || "";
            const name = a.account_name || "";
            return `   🏦 ${label} | Acc: ${number} | Name: ${name}`;
          }).join("\n");
        }
        return `   🏦 Bank: ${paymentInfo.bank_name || "N/A"} | Acc: ${paymentInfo.account_number || "N/A"} | Name: ${paymentInfo.account_name || "N/A"}`;
      })()}
${freeDeliveryThreshold > 0 ? `9. Free Delivery: Orders LKR ${freeDeliveryThreshold}+ qualify for free delivery.` : ""}
${staffContactsList ? `10. Staff Contacts:\n${staffContactsList}` : ""}

PRODUCT CATALOG:
${productCatalog || "No products available"}

FAQS:
${faqContext || "No FAQs configured"}

IMPORTANT: Tags (<PRODUCT_MEDIA>, <ORDER_JSON>, <USED_FAQS>) are internal system commands and must ONLY appear at the very END of your message. Never display raw JSON, code, or tags to the customer.`;

    const messages = [
      { role: "system", content: systemPrompt },
    ];

    if (conversationHistory && conversationHistory.length > 0) {
      for (const msg of conversationHistory as ConversationMessage[]) {
        messages.push({
          role: msg.direction === "inbound" ? "user" : "assistant",
          content: msg.message,
        });
      }
    }

    // Handle photo/media messages - users often send payment slips
    const trimmedMessage = (message || "").trim();
    if (!trimmedMessage) {
      messages.push({ role: "user", content: "[Customer sent a photo/media file. This is likely a payment slip or receipt. Acknowledge it politely and ask them to confirm if it's a payment confirmation. Do NOT output any JSON, tags, or code.]" });
    } else {
      messages.push({ role: "user", content: trimmedMessage });
    }

    // ------------------------------------------------------------------
    // AI call.
    // If AI_GENERATE_URL + BOT_API_KEY are set (self-hosted deployment), the
    // model call is delegated to the Lovable-hosted `ai-generate` transport.
    // Otherwise we talk to the Lovable AI Gateway directly (Lovable-hosted).
    // Prompt, model and max_tokens are identical on both paths, so response
    // quality is unchanged.
    // ------------------------------------------------------------------
    const aiGenerateUrl = Deno.env.get("AI_GENERATE_URL");
    const botApiKey = Deno.env.get("BOT_API_KEY");
    const MODEL = "google/gemini-2.5-flash-lite";
    const MAX_TOKENS = 1200;

    let aiResponse: Response;
    if (aiGenerateUrl && botApiKey) {
      aiResponse = await fetch(aiGenerateUrl, {
        method: "POST",
        headers: { "Content-Type": "application/json", "x-bot-key": botApiKey },
        body: JSON.stringify({
          messages,
          model: MODEL,
          maxTokens: MAX_TOKENS,
        }),
      });
    } else {
      aiResponse = await fetch("https://ai.gateway.lovable.dev/v1/chat/completions", {
        method: "POST",
        headers: {
          Authorization: `Bearer ${lovableApiKey}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ model: MODEL, messages, max_tokens: MAX_TOKENS }),
      });
    }

    if (!aiResponse.ok) {
      if (aiResponse.status === 429) {
        return new Response(
          JSON.stringify({ error: "Rate limit exceeded. Please try again later." }),
          { status: 429, headers: { ...corsHeaders, "Content-Type": "application/json" } }
        );
      }
      if (aiResponse.status === 402) {
        return new Response(
          JSON.stringify({ error: "AI credits exhausted. Please add more credits." }),
          { status: 402, headers: { ...corsHeaders, "Content-Type": "application/json" } }
        );
      }
      const errorText = await aiResponse.text();
      console.error("AI Gateway error:", aiResponse.status, errorText);
      throw new Error("AI processing failed");
    }

    const aiData = await aiResponse.json();
    // `ai-generate` returns { text }, the raw gateway returns OpenAI-style choices.
    const responseText =
      aiData.text ||
      aiData.choices?.[0]?.message?.content ||
      "I'm sorry, I couldn't process your request. Please try again.";


    console.log(`AI Raw Response: ${responseText}`);

    // Extract used FAQ IDs and log tracked ones
    const usedFaqsMatch = responseText.match(/<USED_FAQS>([\s\S]*?)<\/USED_FAQS>/);
    const usedFaqIds: string[] = usedFaqsMatch
      ? usedFaqsMatch[1].split(",").map((id: string) => id.trim()).filter(Boolean)
      : [];
    if (usedFaqsMatch && trackedFaqIds.length > 0) {
      const usedIds = usedFaqIds;
      const trackedUsedIds = usedIds.filter((id: string) => trackedFaqIds.includes(id));

      if (trackedUsedIds.length > 0) {
        console.log(`Tracked FAQs used: ${trackedUsedIds.join(", ")} for phone ${phoneNumber}`);
        const usageLogs = trackedUsedIds.map((faqId: string) => ({
          faq_id: faqId,
          user_id: userId,
          phone_number: phoneNumber,
          sender_name: senderName || "Unknown",
        }));
        const { error: logError } = await supabase.from("faq_usage_logs").insert(usageLogs);
        if (logError) {
          console.error("Error logging FAQ usage:", logError);
        }
      }
    }

    // Check if the AI response contains order JSON
    let orderCreated = false;
    let orderJsonMatches = [...responseText.matchAll(/<ORDER_JSON>([\s\S]*?)<\/ORDER_JSON>/g)];

    // Fallback 1: Code fence or raw JSON block
    if (orderJsonMatches.length === 0) {
      const fenceMatch = responseText.match(/```(?:json)?\s*(\{[\s\S]*?"(?:customer_name|order_items|products|items)"[\s\S]*?\})\s*```/);
      if (fenceMatch) {
        orderJsonMatches = [fenceMatch];
      }
    }

    // Fallback 2: Confirmation text extraction if AI omitted tags completely
    if (orderJsonMatches.length === 0) {
      const isPendingPayment = /please\s+(?:confirm|select|choose|provide|let\s+me\s+know)\s+(?:your\s+)?(?:preferred\s+)?payment|select\s+your\s+payment\s+method|how\s+would\s+you\s+like\s+to\s+pay|choice\s*of\s*payment/i.test(responseText);
      const isConfirmation =
        !isPendingPayment && (
          /\b(?:order\s+(?:is\s+|has\s+been\s+|was\s+)?(?:confirmed|placed|scheduled|received)|order\s+confirmed|confirmed\b|order\s+placed|ඇණවුම\s*(?:තහවුරු|ලැබුණා|භාරගත්තා)|ஆர்டர்\s*(?:உறுதிப்படுத்தப்பட்டது|பதிவு))/i.test(responseText) ||
          (/(?:📦|🛒).*(?:💰|💵).*(?:👤|📍|📞)/s.test(responseText) && /(?:LKR|Rs\.?)\s*[0-9,]+/i.test(responseText))
        );
      if (isConfirmation) {
        // Exclude business support and configured staff phone numbers from text
        const cleanSupport = (text: string) => {
          let cleaned = text.replace(/(?:\+?94\s*|0)?77[\s.-]*123[\s.-]*4567/g, "");
          for (const s of rawStaffNumbers) {
            if (s?.phone) {
              const digits = String(s.phone).replace(/\D/g, "");
              if (digits.length >= 7) {
                cleaned = cleaned.replace(new RegExp(`(?:\\+?94\\s*|0)?${digits.slice(-9)}`, "g"), "");
              }
            }
          }
          return cleaned;
        };
        const historyText = conversationHistory ? (conversationHistory as ConversationMessage[]).slice(-4).map(m => m.message).join("\n") : "";
        const fullText = cleanSupport(`${historyText}\n${trimmedMessage}\n${responseText}`);
        const customerText = cleanSupport(`${trimmedMessage}\n${historyText}`);

        const amountMatch =
          responseText.match(/(?:Total(?:\s*Amount)?|මුළුத்\s*தொகை|மொத்த\s*(?:தொகை|விலை)?|மொத்தம்|එකතුව|මුළු\s*(?:ගණන|මුදල))[\s:*]+(?:LKR|Rs\.?)?[\s:*]+([0-9,]+(?:\.[0-9]{2})?)/i) ||
          responseText.match(/(?:விலை|මිල|Price)[\s:*]+(?:LKR|Rs\.?)?[\s:*]+([0-9,]+(?:\.[0-9]{2})?)/i) ||
          fullText.match(/(?:Total|Total Amount|මුදල|එකතුව)[\s:*]+(?:LKR|Rs\.?)?[\s:*]+([0-9,]+(?:\.[0-9]{2})?)/i) ||
          fullText.match(/(?:LKR|Rs\.?)[\s:*]+([0-9,]+(?:\.[0-9]{2})?)/i);

        const phoneMatch = customerText.match(/(?:(?:\+?94|0)\s*)?7(?:[\s.-]*\d){8}\b/) ||
          customerText.match(/\b0\d{9}\b/) ||
          fullText.match(/(?:(?:\+?94|0)\s*)?7(?:[\s.-]*\d){8}\b/);
        const extractedPhone = phoneMatch ? ("0" + phoneMatch[0].replace(/\D/g, "").slice(-9)) : phoneNumber;

        if (amountMatch) {
          const extractedAmount = parseFloat(amountMatch[1].replace(/,/g, "")) || 0;
          if (extractedAmount > 0) {
            const addrMatch = responseText.match(/(?:(?:Shipping\s*|Delivery\s*)?Address|will\s+be\s+delivered\s+to|ලිපිනය|முகவரி)[\s:*]+([^\n\r*.]+)/i) ||
              fullText.match(/(?:(?:Shipping\s*|Delivery\s*)?Address|will\s+be\s+delivered\s+to|ලිපිනය|முகவரி)[\s:*]+([^\n\r*.]+)/i) ||
              customerText.match(/(?:ලිපිනය|Address|haus|ampara|colombo|kandy|batticaloa|[a-zA-Z0-9\s,.-]{15,})/i);
            let extractedAddress: string | null = null;
            if (addrMatch) {
              let cand = (addrMatch[1] || addrMatch[0]).replace(/^(?:(?:🔹\s*)?ලිපිනය|(?:🔹\s*)?(?:Shipping\s*|Delivery\s*)?Address|(?:🔹\s*)?முகவரி)[\s:*]+/i, "").replace(/\*/g, "").trim();
              cand = cand.replace(/\s+(?:within\s+\d+.*|via\s+(?:cash|cod|bank).*)$/i, "").trim();
              if (cand && !/payment\s*method|district\s*and|full\s*address/i.test(cand)) {
                extractedAddress = cand;
              }
            }

            let extractedName = (senderName && senderName.toLowerCase() !== "customer") ? senderName : "Customer";
            const greetingMatch = responseText.match(/(?:Thank\s*you(?:\s*for\s*(?:your\s*)?(?:order|purchase))?[,\s]+|Order\s*confirmed\s+for\s+|ස්තූතියි[,\s]+|நன்றி[,\s]+)(?:\*\*)?([A-Za-z]{2,20})(?:\*\*)?(?:!|\.|\s|,)/i) ||
              fullText.match(/(?:Thank\s*you(?:\s*for\s*(?:your\s*)?(?:order|purchase))?[,\s]+|Order\s*confirmed\s+for\s+|ස්තූතියි[,\s]+|நன்றி[,\s]+)(?:\*\*)?([A-Za-z]{2,20})(?:\*\*)?(?:!|\.|\s|,)/i);
            const nameMatch = responseText.match(/(?:(?:🔹\s*)?Name|නම|பெயர்)[\s:*]+([^\n\r*]+)/i) ||
              fullText.match(/(?:(?:🔹\s*)?Name|නම|பெயர்)[\s:*]+([^\n\r*]+)/i);

            if (greetingMatch && !/^(?:customer|account|not\s*configured|bank|for|your|order|purchase|cash|cod|delivery)$/i.test(greetingMatch[1].trim())) {
              extractedName = greetingMatch[1].trim();
            } else if (nameMatch) {
              const cand = nameMatch[1].replace(/^[^\w\s]+/, "").replace(/\*/g, "").trim();
              if (cand && cand.length <= 25 && !/not\s*configured|bank|phone\s*number|full\s*name/i.test(cand)) {
                extractedName = cand;
              }
            }

            // Match against product catalog
            let extractedProduct = "Fishing Gear Order";
            for (const p of products) {
              const pClean = p.name.replace(/\(.*?\)/g, "").trim();
              if (pClean && new RegExp(pClean.replace(/[-/\\^$*+?.()|[\]{}]/g, "\\$&"), "i").test(fullText)) {
                extractedProduct = p.name;
                break;
              }
            }
            if (extractedProduct === "Fishing Gear Order") {
              const prodMatch = responseText.match(/(?:(?:🔹\s*)?Item|(?:🔹\s*)?Product)[\s:*]+([^\n\r*]+)/i) ||
                fullText.match(/(?:(?:🔹\s*)?Item|(?:🔹\s*)?Product)[\s:*]+([^\n\r*]+)/i);
              if (prodMatch) extractedProduct = prodMatch[1].replace(/^[^\w\s]+/, "").replace(/\*/g, "").trim();
            }

            const knownDistricts = ["Batticaloa", "Colombo", "Gampaha", "Kalutara", "Kandy", "Matale", "Nuwara Eliya", "Galle", "Matara", "Hambantota", "Jaffna", "Kilinochchi", "Mannar", "Vavuniya", "Mullaitivu", "Ampara", "Trincomalee", "Kurunegala", "Puttalam", "Anuradhapura", "Polonnaruwa", "Badulla", "Monaragala", "Ratnapura", "Kegalle"];
            let extractedDistrict = null;
            for (const d of knownDistricts) {
              if (new RegExp(`\\b${d}\\b`, "i").test(fullText)) {
                extractedDistrict = d;
                break;
              }
            }

            let extractedPayment = "cod";
            if (/\b(?:bank(?:\s*transfer)?|බැංකු|வங்கி)\b/i.test(trimmedMessage)) {
              extractedPayment = "bank_transfer";
            } else if (/\b(?:cod|cash\s*on\s*delivery)\b/i.test(trimmedMessage)) {
              extractedPayment = "cod";
            } else if (/\b(?:bank(?:\s*transfer)?|බැංකු|வங்கி)\b/i.test(responseText)) {
              extractedPayment = "bank_transfer";
            }

            const synthetic = {
              customer_name: extractedName,
              customer_phone: extractedPhone,
              customer_address: extractedAddress,
              district: extractedDistrict,
              payment_method: extractedPayment,
              total_amount: extractedAmount,
              order_items: [{ name: extractedProduct, price: extractedAmount, quantity: 1, product_type: "physical" }],
            };
            orderJsonMatches = [[JSON.stringify(synthetic), JSON.stringify(synthetic)]];
          }
        }
      }
    }

    for (const orderJsonMatch of orderJsonMatches) {
      if (ordersLimitReached) {
        console.log(`Orders limit reached for user ${userId}: ${ordersCount}/${ordersLimit}`);
      } else {
        try {
          let rawJson = orderJsonMatch[1].trim();
          if (rawJson.startsWith("```")) {
            rawJson = rawJson.replace(/^```(?:json)?\s*/i, "").replace(/\s*```$/, "").trim();
          }
          const orderData = JSON.parse(rawJson);
          console.log("Saving order to database:", JSON.stringify(orderData));

          const customerPhone = orderData.customer_phone || orderData.phone || orderData.customerPhone || phoneNumber;
          const cleanCustomerPhone = customerPhone ? String(customerPhone).replace(/\D/g, "") : phoneNumber;
          const customerName = orderData.customer_name || orderData.name || orderData.customerName || senderName || "Customer";
          const customerAddress = orderData.customer_address || orderData.delivery_address || orderData.shipping_address || orderData.address || null;
          const district = orderData.district || orderData.district_city || orderData.city || null;
          const paymentMethod = /bank/i.test(orderData.payment_method || "") ? "bank_transfer" : "cod";

          const rawItems = orderData.order_items || orderData.items || orderData.products || [];
          const orderItems = Array.isArray(rawItems) ? rawItems.map((it: any) => ({
            name: it.name || it.product_name || it.title || "Product",
            price: parseFloat(it.price || it.base_price || it.unit_price || 0) || 0,
            quantity: parseInt(it.quantity || it.qty || 1) || 1,
            product_type: it.product_type || "physical",
          })) : [];

          let totalAmount = parseFloat(orderData.total_amount || orderData.total || orderData.totalPrice || 0) || 0;
          if (totalAmount === 0 && orderItems.length > 0) {
            totalAmount = orderItems.reduce((acc: number, it: any) => acc + (it.price * it.quantity), 0);
            const deliveryFee = parseFloat(orderData.delivery_fee || orderData.delivery_price || (rawItems[0]?.delivery_fee) || 0) || 0;
            totalAmount += deliveryFee;
          }
          if (totalAmount === 0) {
            const amtMatch =
              responseText.match(/(?:Total(?:\s*Amount)?|முழுத்\s*தொகை|மொத்த\s*(?:தொகை|விலை)?|மொத்தம்|එකතුව|මුළු\s*(?:ගණන|මුදල))[\s:*]+(?:LKR|Rs\.?)?[\s:*]+([0-9,]+(?:\.[0-9]{2})?)/i) ||
              responseText.match(/(?:LKR|Rs\.?)[\s:*]+([0-9,]+(?:\.[0-9]{2})?)/i);
            if (amtMatch) totalAmount = parseFloat(amtMatch[1].replace(/,/g, "")) || 0;
          }

          // Deduplication: check if a pending order was created for this customer in the last 5 minutes
          const fiveMinAgo = new Date(Date.now() - 5 * 60 * 1000).toISOString();
          const phoneSuffix = cleanCustomerPhone.slice(-9);
          const { data: recentOrders } = await supabase
            .from("orders")
            .select("id, total_amount")
            .eq("user_id", userId)
            .or(`whatsapp_phone.eq.${phoneNumber},customer_phone.like.%${phoneSuffix}`)
            .gte("created_at", fiveMinAgo)
            .order("created_at", { ascending: false })
            .limit(1);

          if (recentOrders && recentOrders.length > 0) {
            const existingId = recentOrders[0].id;
            console.log("Duplicate/refining order detected, updating existing order:", existingId);
            await supabase
              .from("orders")
              .update({
                customer_name: customerName,
                customer_phone: cleanCustomerPhone,
                district: district,
                customer_address: customerAddress || undefined,
                order_items: orderItems.length > 0 ? orderItems : undefined,
                payment_method: paymentMethod,
                total_amount: totalAmount > 0 ? totalAmount : recentOrders[0].total_amount,
                updated_at: new Date().toISOString()
              })
              .eq("id", existingId);
            orderCreated = true;
          } else {
            const { data: orderResult, error: orderError } = await supabase
              .from("orders")
              .insert({
                customer_name: customerName,
                customer_phone: cleanCustomerPhone,
                whatsapp_phone: phoneNumber,
                district: district,
                customer_address: customerAddress,
                order_items: orderItems,
                payment_method: paymentMethod,
                total_amount: totalAmount,
                special_instructions: orderData.customer_email ? `Email: ${orderData.customer_email}` : null,
                status: "pending",
                user_id: userId,
              })
              .select()
              .single();

            if (orderError) {
              console.error("Error saving order:", orderError);
            } else {
              console.log("Order saved successfully:", orderResult.id);
              orderCreated = true;

              // Send order notification to owner
              try {
                const { data: notifSettings } = await supabase
                  .from("settings")
                  .select("value")
                  .eq("key", "order_notifications")
                  .eq("user_id", userId)
                  .single();

                let ownerPhone = notifSettings?.value?.phone ? String(notifSettings.value.phone).replace(/\D/g, "") : null;
                if (ownerPhone) {
                  if (ownerPhone.startsWith("0") && ownerPhone.length === 10) {
                    ownerPhone = "94" + ownerPhone.substring(1);
                  } else if (ownerPhone.length === 9) {
                    ownerPhone = "94" + ownerPhone;
                  }
                  const items = (orderData.order_items || [])
                    .map((item: any) => `${item.quantity}x ${item.name}`)
                    .join(", ");
                  const notifMessage = `📦 New Order #${orderResult.id.substring(0, 8)}\n👤 ${orderData.customer_name}\n📱 ${orderData.customer_phone || phoneNumber}\n🛒 ${items}\n💰 Total: ${orderData.total_amount}\n💳 ${orderData.payment_method === "cod" ? "Cash on Delivery" : "Bank Transfer"}${orderData.district ? `\n🏘️ District: ${orderData.district}` : ""}${orderData.customer_address ? `\n📍 ${orderData.customer_address}` : ""}`;

                  // Use the sessionApiKey passed from the webhook, fallback to DB lookup
                  let sendApiKey = sessionApiKey || null;
                  if (!sendApiKey) {
                    const { data: sessionData } = await supabase
                      .from("user_wsender_sessions")
                      .select("session_api_key")
                      .eq("user_id", userId)
                      .limit(1)
                      .maybeSingle();
                    sendApiKey = sessionData?.session_api_key || null;
                  }

                  const sendNotif = await fetch(`${supabaseUrl}/functions/v1/send-whatsapp_fishing`, {
                    method: "POST",
                    headers: {
                      Authorization: `Bearer ${supabaseServiceKey}`,
                      "Content-Type": "application/json",
                    },
                    body: JSON.stringify({
                      to: ownerPhone,
                      message: notifMessage,
                      sessionApiKey: sendApiKey,
                    }),
                  });
                  if (!sendNotif.ok) {
                    console.error("Failed to send owner notification:", await sendNotif.text());
                  } else {
                    console.log("Owner notification sent to", ownerPhone);
                  }
                }
              } catch (notifError) {
                console.error("Error sending owner notification:", notifError);
              }
            }
          }
        } catch (parseError) {
          console.error("Error parsing order JSON:", parseError);
        }
      }
    }

    // Resolve FAQ attachments: only for FAQs the AI actually used, first time per conversation,
    // max 4 attachments in one reply.
    let faqMedia: string[] = [];
    if (usedFaqIds.length > 0) {
      const candidates: string[] = [];
      for (const id of usedFaqIds) {
        const faq = faqs.find((f: any) => f.id === id);
        const urls = Array.isArray(faq?.media_urls) ? faq!.media_urls : [];
        for (const u of urls) {
          if (typeof u === "string" && u.trim() && !candidates.includes(u)) candidates.push(u);
        }
      }

      if (candidates.length > 0) {
        // Skip anything already sent to this customer before
        const { data: priorRows } = await supabase
          .from("conversations")
          .select("metadata")
          .eq("user_id", userId)
          .eq("phone_number", phoneNumber)
          .eq("direction", "outbound")
          .not("metadata", "is", null)
          .order("created_at", { ascending: false })
          .limit(200);

        const alreadySent = new Set<string>();
        for (const row of priorRows || []) {
          const sent = (row as any)?.metadata?.faqMedia;
          if (Array.isArray(sent)) sent.forEach((u: string) => alreadySent.add(u));
        }

        faqMedia = candidates.filter((u) => !alreadySent.has(u)).slice(0, 4);
        if (faqMedia.length > 0) {
          console.log(`FAQ attachments to send (${faqMedia.length}): ${faqMedia.join(", ")}`);
        }
      }
    }

    // 1. Identify matched products from <PRODUCT_MEDIA> tags
    const productMediaMatches = Array.from(responseText.matchAll(/<PRODUCT_MEDIA>([\s\S]*?)<\/PRODUCT_MEDIA>/gi));
    const mediaProductIds: string[] = [];
    for (const m of productMediaMatches) {
      const tokens = m[1].split(/[\s,]+/);
      for (const tok of tokens) {
        const cleaned = tok.trim();
        if (cleaned && !mediaProductIds.includes(cleaned)) {
          mediaProductIds.push(cleaned);
        }
      }
    }

    const matchedProducts: any[] = [];
    for (const pid of mediaProductIds) {
      const prod = productById.get(pid);
      if (prod && !matchedProducts.some(p => p.id === prod.id)) {
        matchedProducts.push(prod);
      }
    }

    // Fallback: If no products found via <PRODUCT_MEDIA>, match by product name or distinctive keywords
    if (matchedProducts.length === 0) {
      const respLower = responseText.toLowerCase();
      const userLower = trimmedMessage.toLowerCase();
      for (const p of products) {
        const pNameLower = p.name.toLowerCase();
        let isMatch = respLower.includes(pNameLower);
        if (!isMatch) {
          const cleanName = p.name.replace(/\(.*?\)/g, "").toLowerCase();
          const stopWords = new Set(["fishing", "reel", "rod", "rods", "only", "original", "set", "full", "combo", "gear", "pack"]);
          const distinctWords = cleanName.split(/[\s-]+/).filter(w => w.length >= 4 && !stopWords.has(w));
          if (distinctWords.length > 0 && distinctWords.every(w => respLower.includes(w) || userLower.includes(w))) {
            isMatch = true;
          }
        }
        if (isMatch && !matchedProducts.some(mp => mp.id === p.id)) {
          matchedProducts.push(p);
        }
      }
    }

    let imageUrls: string[] = [];
    let videoUrl: string | null = null;

    // Check customer intent
    const explicitPhotoIntent = /\b(images?|photos?|pics?|pictures?|දෙන්න|ෆොටෝ|පින්තූර|බලන්න|එවන්න|புகைப்படங்கள்|படங்கள்|அனுப்பு)\b/i.test(trimmedMessage);
    const isCheckoutOrConfirm = orderCreated || 
      /\b(confirm|confirmed|done|ok|yes|cod|cash\s*on\s*delivery|bank\s*transfer)\b/i.test(trimmedMessage) ||
      (/(?:(?:\+?94|0)\s*)?7(?:[\s.-]*\d){8}\b/.test(trimmedMessage) && /\b(?:rd|st|street|road|mawatha|colombo|kandy|galle|jaffna|ampara|kurunegala|no\.?|house)\b/i.test(trimmedMessage));

    // Suppress repeated images on checkout / confirmation turns unless customer explicitly asked for photos
    if (!isCheckoutOrConfirm || explicitPhotoIntent) {
      // Smart distribution:
      // If multiple products matched (>1), send 1 cover photo per product (up to 4 max)
      if (matchedProducts.length > 1) {
        for (const prod of matchedProducts) {
          if (imageUrls.length >= 4) break;
          const cover = prod.images?.[0];
          if (cover && typeof cover === "string" && cover.trim() && !imageUrls.includes(cover)) {
            imageUrls.push(cover);
          }
          if (!videoUrl && prod.video_url && typeof prod.video_url === "string" && prod.video_url.trim()) {
            videoUrl = prod.video_url.trim();
          }
        }
      } else if (matchedProducts.length === 1) {
        // Single product: send up to 4 photos of this specific item
        const prod = matchedProducts[0];
        if (prod.images && Array.isArray(prod.images)) {
          for (const img of prod.images) {
            if (imageUrls.length >= 4) break;
            if (typeof img === "string" && img.trim() && !imageUrls.includes(img)) {
              imageUrls.push(img);
            }
          }
        }
        if (!videoUrl && prod.video_url && typeof prod.video_url === "string" && prod.video_url.trim()) {
          videoUrl = prod.video_url.trim();
        }
      }
    }

    // Support legacy/explicit <IMAGE_URL> tags if emitted
    const legacyImgMatches = Array.from(responseText.matchAll(/<IMAGE_URL>([\s\S]*?)<\/IMAGE_URL>/gi));
    for (const m of legacyImgMatches) {
      if (imageUrls.length >= 4) break;
      const u = m[1].trim();
      if (u && !imageUrls.includes(u)) imageUrls.push(u);
    }
    const legacyVideoMatch = responseText.match(/<VIDEO_URL>([\s\S]*?)<\/VIDEO_URL>/i);
    if (!videoUrl && legacyVideoMatch) {
      videoUrl = legacyVideoMatch[1].trim();
    }

    // Video fallback if customer explicitly asked for video
    if (!videoUrl && /\b(videos?|vids?|වීඩියෝ|வீடியோ)\b/i.test(trimmedMessage + " " + responseText)) {
      const recentHistoryText = (conversationHistory as ConversationMessage[])
        .slice(-3)
        .map(m => m.message)
        .join(" ");
      const searchContext = (trimmedMessage + " " + responseText + " " + recentHistoryText).toLowerCase();
      for (const [prodName, vUrl] of Object.entries(productVideoMap)) {
        if (vUrl && (searchContext.includes(prodName) || (prodName.includes("kithul") && searchContext.includes("kithul")) || (prodName.includes("rod") && searchContext.includes("rod")))) {
          videoUrl = vUrl;
          break;
        }
      }
    }

    // Final safety: strictly cap to max 4 images
    imageUrls = imageUrls.slice(0, 4);
    const imageUrl = imageUrls.length > 0 ? imageUrls[0] : null;

    // Aggressively strip any JSON or technical markup from the response
    let cleanResponse = responseText;
    // Remove complete tagged blocks WITH their content first
    cleanResponse = cleanResponse.replace(/<PRODUCT_MEDIA>[\s\S]*?<\/PRODUCT_MEDIA>/gi, "");
    cleanResponse = cleanResponse.replace(/<ORDER_JSON>[\s\S]*?<\/ORDER_JSON>/g, "");
    cleanResponse = cleanResponse.replace(/<IMAGE_URL>[\s\S]*?<\/IMAGE_URL>/g, "");
    cleanResponse = cleanResponse.replace(/<VIDEO_URL>[\s\S]*?<\/VIDEO_URL>/g, "");
    cleanResponse = cleanResponse.replace(/<USED_FAQS>[\s\S]*?<\/USED_FAQS>/g, "");
    // Remove truncated/incomplete tags and everything after them
    cleanResponse = cleanResponse.replace(/<PRODUCT_MEDIA>[\s\S]*/gi, "");
    cleanResponse = cleanResponse.replace(/<ORDER_JSON>[\s\S]*/g, "");
    cleanResponse = cleanResponse.replace(/<IMAGE_URL>[\s\S]*/g, "");
    cleanResponse = cleanResponse.replace(/<VIDEO_URL>[\s\S]*/g, "");
    cleanResponse = cleanResponse.replace(/<USED_FAQS>[\s\S]*/g, "");
    // Remove any remaining orphan uppercase XML-like tags
    cleanResponse = cleanResponse.replace(/<\/?[A-Z_]+>/g, "");
    // Remove fenced code blocks (```json ... ``` or ``` ... ```)
    cleanResponse = cleanResponse.replace(/```[\s\S]*?```/g, "");
    // Remove markdown image syntax and markdown image links
    cleanResponse = cleanResponse.replace(/!\[.*?\]\([^\)]+\)/g, "");
    cleanResponse = cleanResponse.replace(/\[(?:View\s*)?Images?[^\]]*\]\(?[^\)]*\)?/gi, "");
    // Strip image URLs so raw links don't leak into message text
    for (const u of imageUrls) {
      cleanResponse = cleanResponse.split(u).join("");
    }
    // Remove any JSON object that looks like order data (greedy match for nested objects)
    cleanResponse = cleanResponse.replace(/\{[^{}]*"customer_name"[^}]*\}/g, "");
    cleanResponse = cleanResponse.replace(/\{[^{}]*"customername"[^}]*\}/g, ""); // catch typos from model
    cleanResponse = cleanResponse.replace(/\{[^{}]*"order_items"[^}]*\}/g, "");
    cleanResponse = cleanResponse.replace(/\{[^{}]*"payment_method"[^}]*\}/g, "");
    cleanResponse = cleanResponse.replace(/\{[^{}]*"total_amount"[^}]*\}/g, "");
    // Remove any remaining JSON-like structures with 2+ key-value pairs
    cleanResponse = cleanResponse.replace(/\{\s*"[^"]+"\s*:[\s\S]*?\}/g, "");
    // Remove any leftover image URLs on their own line (https://...supabase... patterns)
    cleanResponse = cleanResponse.replace(/^https?:\/\/[^\s]+$/gm, "");
    // Remove [ID:...] or [FAQ_ID:...] references that may leak from catalog
    cleanResponse = cleanResponse.replace(/\[(?:FAQ_)?ID:[^\]]*\]/gi, "");
    cleanResponse = cleanResponse.replace(/\[ID:\s*\]/gi, "");
    // Remove standalone UUIDs that leak from FAQ IDs or correlation IDs
    cleanResponse = cleanResponse.replace(/\b[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\b/gi, "");

    // WhatsApp Markdown Filtering & Cleanup
    // Convert Markdown headers (#, ##, ###) to WhatsApp bold (*text*)
    cleanResponse = cleanResponse.replace(/^#{1,6}\s*(.+)$/gm, "*$1*");
    // Convert standard Markdown bold (**text**) to WhatsApp bold (*text*)
    cleanResponse = cleanResponse.replace(/\*\*([^*\n]+)\*\*/g, "*$1*");
    // Convert standard Markdown strikethrough (~~text~~) to WhatsApp strikethrough (~text~)
    cleanResponse = cleanResponse.replace(/~~([^~\n]+)~~/g, "~$1~");
    // Convert Markdown links [label](url) to readable WhatsApp format
    cleanResponse = cleanResponse.replace(/\[([^\]]+)\]\((https?:\/\/[^\s\)]+)\)/g, "$1: $2");
    // Remove Markdown table divider lines (| --- | --- |)
    cleanResponse = cleanResponse.replace(/^\s*\|?(?:\s*:?-+:?\s*\|)+\s*$/gm, "");
    // Clean up empty bullets and orphan markers left after stripping tags/links
    cleanResponse = cleanResponse.replace(/(?:^\s*[-*•]\s*[-*•]?\s*$\n?)+/gm, "");
    // Remove empty parentheses/brackets left over from stripped links/images
    cleanResponse = cleanResponse.replace(/\(\s*\)/g, "");
    cleanResponse = cleanResponse.replace(/\[\s*\]/g, "");
    // Clean up trailing whitespace on lines and excessive newlines
    cleanResponse = cleanResponse.split("\n").map(l => l.trimEnd()).join("\n");
    cleanResponse = cleanResponse.replace(/\n{3,}/g, "\n\n").trim();

    // Log AI usage independently of conversations
    await supabase.from("ai_usage_logs").insert({
      user_id: userId,
      phone_number: contactKey || phoneNumber,
    });

    // If an order was created, check for follow-up message
    let followupMessage: string | null = null;
    if (orderCreated) {
      try {
        const { data: followupSettings } = await supabase
          .from("settings")
          .select("value")
          .eq("key", "order_followup_message")
          .eq("user_id", userId)
          .single();

        if (followupSettings?.value?.enabled && followupSettings?.value?.text?.trim()) {
          followupMessage = followupSettings.value.text.trim();
          console.log("Order follow-up message will be sent");
        }
      } catch (e) {
        console.warn("Could not fetch order followup setting:", e);
      }
    }

    return new Response(
      JSON.stringify({ response: cleanResponse, imageUrl, imageUrls, videoUrl, followupMessage, faqMedia }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } catch (error) {
    console.error("AI Chat error:", error);
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
