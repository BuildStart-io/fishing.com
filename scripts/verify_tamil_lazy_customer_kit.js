const { execSync } = require("child_process");

const EDGE_FUNCTION_URL = "http://localhost:8000/functions/v1/ai-chat_fishing";
const SERVICE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2VydmljZV9yb2xlIiwiaXNzIjoic3VwYWJhc2UiLCJpYXQiOjE3OTM2MjQ0NTAsImV4cCI6MjEwODk4NDQ1MH0.3NSKKo_lwbQZHiQEfmH_WIzO-acB0Y0hEQErOB9yDWs";
const USER_ID = "5543a79b-21f1-4091-905b-025d39acd0c8";
const PHONE_NUMBER = "94772221111";

async function queryAI(message, history = []) {
  const res = await fetch(EDGE_FUNCTION_URL, {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${SERVICE_KEY}`,
      "Content-Type": "application/json"
    },
    body: JSON.stringify({
      message,
      phoneNumber: PHONE_NUMBER,
      conversationHistory: history,
      userId: USER_ID
    })
  });
  return await res.json();
}

function getLatestOrder() {
  try {
    const raw = execSync(
      `docker exec -i supabase-db psql -U postgres -d postgres -t -A -c "SELECT json_agg(o) FROM (SELECT id, customer_name, customer_phone, customer_address, order_items, payment_method, total_amount, status, created_at FROM public.orders WHERE user_id = '${USER_ID}' ORDER BY created_at DESC LIMIT 1) o;"`,
      { encoding: "utf8" }
    ).trim();
    if (!raw || raw === "") return null;
    const parsed = JSON.parse(raw);
    return parsed && parsed.length > 0 ? parsed[0] : null;
  } catch (e) {
    console.error("Error querying latest order:", e.message);
    return null;
  }
}

async function runTest() {
  console.log("================================================================================");
  console.log("🎣 TAMIL LAZY CUSTOMER (1-2 WORDS PER MESSAGE) - CUSTOM FISHING KIT TEST");
  console.log("================================================================================\n");

  const conversationHistory = [];
  const testTurns = [
    { label: "Turn 1: Greeting", msg: "வணக்கம்" },
    { label: "Turn 2: Rod selection (Astika 2500)", msg: "அஸ்திகா 2500" },
    { label: "Turn 3: Reel selection (AC4000)", msg: "AC4000 ரீல்" },
    { label: "Turn 4: Line/Cable selection (40LB)", msg: "கேபிள் 40LB" },
    { label: "Turn 5: Lure selection (Popper Frog)", msg: "தவளை 750" },
    { label: "Turn 6: Float selection", msg: "மிதவை" },
    { label: "Turn 7: Request Photos", msg: "போட்டோ அனுப்புங்க" },
    { label: "Turn 8: Inquire Total Price", msg: "மொத்த விலை" },
    { label: "Turn 9: Express Intent to Order", msg: "ஆர்டர்" },
    { label: "Turn 10: Customer Name", msg: "கணேசன் குமார்" },
    { label: "Turn 11: Phone Number", msg: "0777123456" },
    { label: "Turn 12: Address / District", msg: "யாழ்ப்பாணம்" },
    { label: "Turn 13: Payment Method", msg: "COD" },
    { label: "Turn 14: Final Order Confirmation", msg: "உறுதி செய்" }
  ];

  const results = [];

  for (const t of testTurns) {
    const wordCount = t.msg.trim().split(/\s+/).length;
    console.log(`\n--------------------------------------------------------------------------------`);
    console.log(`📌 [${t.label}]`);
    console.log(`👤 Customer (${wordCount} words): "${t.msg}"`);

    conversationHistory.push({ direction: "inbound", message: t.msg, created_at: new Date().toISOString() });

    const historyPayload = conversationHistory.slice(0, -1);
    const start = Date.now();
    const aiRes = await queryAI(t.msg, historyPayload);
    const durationMs = Date.now() - start;

    console.log(`🤖 AI Response (${durationMs}ms):\n${aiRes.response}`);
    if (aiRes.imageUrls && aiRes.imageUrls.length > 0) {
      console.log(`📷 Photos Returned (${aiRes.imageUrls.length}):`);
      aiRes.imageUrls.forEach((u, i) => console.log(`   [${i + 1}] ${u}`));
    } else {
      console.log(`📷 Photos Returned: None`);
    }

    conversationHistory.push({ direction: "outbound", message: aiRes.response, created_at: new Date().toISOString() });

    results.push({
      turn: t.label,
      customerMsg: t.msg,
      wordCount,
      aiResponse: aiRes.response,
      images: aiRes.imageUrls || [],
      orderCreated: aiRes.orderCreated || false
    });
  }

  console.log("\n================================================================================");
  console.log("📊 CHECKING DATABASE ORDER CREATION");
  console.log("================================================================================");
  const dbOrder = getLatestOrder();
  console.log("Database Order Record:", JSON.stringify(dbOrder, null, 2));

  return { results, dbOrder };
}

runTest().then(() => {
  console.log("\n✅ Tamil Lazy Customer Test completed.");
}).catch(err => {
  console.error("❌ Test run failed:", err);
});

