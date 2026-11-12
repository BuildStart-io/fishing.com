const { execSync } = require("child_process");
const AI_GENERATE_URL = "https://ykzefldgpynswokdijur.supabase.co/functions/v1/ai-generate";
const BOT_API_KEY = "7b02ee4ab25ba1529bd11aef41484a5145c261fde14273e5050c2efe8003c965";

const p = execSync(`docker exec -i supabase-db psql -U postgres -d postgres -t -A -c "SELECT json_agg(p) FROM (SELECT name, price, product_type, delivery_price, description, images, video_url, variations FROM public.products WHERE user_id = '5543a79b-21f1-4091-905b-025d39acd0c8' AND is_active = true ORDER BY name) p;"`, { encoding: "utf8" }).trim();
const products = JSON.parse(p);

const f = execSync(`docker exec -i supabase-db psql -U postgres -d postgres -t -A -c "SELECT json_agg(f) FROM (SELECT id, question, answer FROM public.faqs WHERE user_id = '5543a79b-21f1-4091-905b-025d39acd0c8' AND is_active = true) f;"`, { encoding: "utf8" }).trim();
const faqs = JSON.parse(f);

const productCatalog = products.map((p, idx) => {
  let line = `[PRODUCT #${idx + 1}] ${p.name}\nBase price: LKR ${p.price} (${p.product_type})`;
  if (p.product_type === "physical" && p.delivery_price && p.delivery_price > 0) {
    line += ` | Delivery fee: LKR ${p.delivery_price}`;
  }
  if (p.description) line += `\nDescription: ${p.description}`;
  if (p.variations && Array.isArray(p.variations) && p.variations.length > 0) {
    const varLines = p.variations.map((v) => {
      const opts = (v?.options || []).map((o) => `${o.label}: LKR ${o.price}`).join(", ");
      return `${v.name || "option"}: ${opts}`;
    }).join("; ");
    line += `\nVariations: ${varLines}`;
  }
  if (p.images && Array.isArray(p.images) && p.images.length > 0) {
    line += `\nImages: ${p.images.join(", ")}`;
  } else {
    line += `\nImages: NONE (No photos exist for this product. Never send photos from other products)`;
  }
  if (p.video_url) {
    line += `\nVideo: ${p.video_url}`;
  }
  return line;
}).join("\n\n");

const faqContext = faqs.map(f => 
  `[FAQ_ID:${f.id}] Q: ${f.question}\nA: ${f.answer}`
).join("\n\n");

const systemPrompt = `You are the WhatsApp sales & support assistant for FishingRods'Com (fishing rods, packages, combo kits & tackle across Sri Lanka).
- All-Island Delivery (දිවයින පුරා බෙදාහැරීම) is available across Sri Lanka.

ALL 32 AVAILABLE PRODUCTS IN CATALOG:
${productCatalog}

IMPORTANT GUIDELINES:
- Respond in the SAME LANGUAGE the customer uses. If English, reply in English.
- Use emojis sparingly but effectively 🎯
- FORMATTING: Write plain text only. No *bold*, no **bold**, no _italic_.
- When asked about any product in the catalog above, provide its exact details, price, and variations.
- PRODUCT IMAGES: Include all image URLs from the product's "Images:" line in separate <IMAGE_URL>url</IMAGE_URL> tags at the END of your response. If a product says "Images: NONE", do NOT include any <IMAGE_URL> tags!
- CRITICAL ORDER INSTRUCTION:
  When an order is confirmed, include:
  <ORDER_JSON>{"customer_name":"...","customer_phone":"...","district":"...","customer_address":"...","order_items":[{"name":"...","price":...,"quantity":...,"product_type":"physical"}],"payment_method":"cod","total_amount":...}</ORDER_JSON>
`;

async function test(query) {
  const res = await fetch(AI_GENERATE_URL, {
    method: "POST",
    headers: { "Content-Type": "application/json", "x-bot-key": BOT_API_KEY },
    body: JSON.stringify({
      messages: [
        { role: "system", content: systemPrompt },
        { role: "user", content: query + " [Language: Respond in English]" }
      ],
      model: "google/gemini-2.5-flash-lite",
      maxTokens: 500
    })
  });
  const data = await res.json();
  console.log("Q:", query);
  console.log("A:", data.text);
  console.log("------------------------------------------");
}

async function run() {
  await test("Can you tell me about \"Spin Master Carbon Fiber Rod (Original)\" and send photos?");
  await test("Can you tell me about \"Standard Telescopic Fishing Rod\" and send photos?");
}
run();
