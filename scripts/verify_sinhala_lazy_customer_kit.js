const { execSync } = require("child_process");

const EDGE_FUNCTION_URL = "http://localhost:8000/functions/v1/ai-chat_fishing";
const SERVICE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2VydmljZV9yb2xlIiwiaXNzIjoic3VwYWJhc2UiLCJpYXQiOjE3OTM2MjQ0NTAsImV4cCI6MjEwODk4NDQ1MH0.3NSKKo_lwbQZHiQEfmH_WIzO-acB0Y0hEQErOB9yDWs";
const USER_ID = "5543a79b-21f1-4091-905b-025d39acd0c8";
const PHONE_NUMBER = "94773334455";

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

function getLatestOrder(phone) {
  try {
    const raw = execSync(
      `docker exec -i supabase-db psql -U postgres -d postgres -t -A -c "SELECT json_agg(o) FROM (SELECT id, customer_name, customer_phone, customer_address, order_items, payment_method, total_amount, status, created_at FROM public.orders WHERE user_id = '${USER_ID}' AND (customer_phone = '${phone}' OR whatsapp_phone = '${PHONE_NUMBER}') ORDER BY created_at DESC LIMIT 1) o;"`,
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

async function runSinhalaTest() {
  console.log("================================================================================");
  console.log("🎣 SINHALA LAZY CUSTOMER (1-2 WORDS PER MESSAGE) - CUSTOM FISHING KIT TEST");
  console.log("================================================================================\n");

  const conversationHistory = [];
  const testTurns = [
    { label: "Turn 1: Greeting", msg: "හායි", expectPhotos: false },
    { label: "Turn 2: Rod selection (Astika 2500)", msg: "අස්තික 2500", expectPhotos: true },
    { label: "Turn 3: Reel selection (AC4000)", msg: "AC4000 රීල්", expectPhotos: true },
    { label: "Turn 4: Line/Cable selection (40LB)", msg: "කේබල් 40LB", expectPhotos: true },
    { label: "Turn 5: Lure selection (Popper Frog)", msg: "ගෙම්බා 750", expectPhotos: true },
    { label: "Turn 6: Float selection", msg: "ෆ්ලෝට්", expectPhotos: true },
    { label: "Turn 7: Request Photos", msg: "ෆොටෝ එවන්න", expectPhotos: true },
    { label: "Turn 8: Inquire Total Price", msg: "ගාන කීයද", expectPhotos: false },
    { label: "Turn 9: Express Intent to Order", msg: "ඕඩර්", expectPhotos: false },
    { label: "Turn 10: Customer Name", msg: "සුනිල් පෙරේරා", expectPhotos: false },
    { label: "Turn 11: Phone Number", msg: "0773334455", expectPhotos: false },
    { label: "Turn 12: Address / District", msg: "ගම්පහ", expectPhotos: false },
    { label: "Turn 13: Payment Method", msg: "COD", expectPhotos: false },
    { label: "Turn 14: Final Order Confirmation", msg: "තහවුරු කරන්න", expectPhotos: false }
  ];

  const turnEvaluations = [];

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
    const photosCount = (aiRes.imageUrls && aiRes.imageUrls.length) || 0;
    if (photosCount > 0) {
      console.log(`📷 Photos Returned (${photosCount}):`);
      aiRes.imageUrls.forEach((u, i) => console.log(`   [${i + 1}] ${u}`));
    } else {
      console.log(`📷 Photos Returned: None`);
    }

    const photoCheckPassed = t.expectPhotos ? (photosCount > 0) : (photosCount === 0);
    console.log(`Rule Check: Expected Photos = ${t.expectPhotos} | Actual = ${photosCount} -> ${photoCheckPassed ? "✅ PASS" : "❌ FAIL"}`);

    conversationHistory.push({ direction: "outbound", message: aiRes.response, created_at: new Date().toISOString() });

    turnEvaluations.push({
      turn: t.label,
      customerMsg: t.msg,
      wordCount,
      expectPhotos: t.expectPhotos,
      actualPhotos: photosCount,
      photoCheckPassed,
      aiResponse: aiRes.response
    });
  }

  console.log("\n================================================================================");
  console.log("📊 CHECKING DATABASE ORDER CREATION");
  console.log("================================================================================");
  const dbOrder = getLatestOrder("0773334455");
  console.log("Database Order Record:", JSON.stringify(dbOrder, null, 2));

  const allPhotosPassed = turnEvaluations.every(t => t.photoCheckPassed);
  const wordCountPassed = turnEvaluations.every(t => t.wordCount <= 2);
  const orderCreated = !!dbOrder;

  console.log("\n================================================================================");
  console.log("📈 SINHALA LAZY CUSTOMER TEST SUMMARY");
  console.log("================================================================================");
  console.log(`Word Count Limit (<= 2 words): ${wordCountPassed ? "✅ PASS" : "❌ FAIL"}`);
  console.log(`Photo Delivery Rules:          ${allPhotosPassed ? "✅ PASS" : "❌ FAIL"}`);
  console.log(`Database Order Created:        ${orderCreated ? "✅ PASS" : "❌ FAIL"}`);
  if (dbOrder) {
    console.log(`Order ID:                      ${dbOrder.id}`);
    console.log(`Total Amount in DB:            LKR ${dbOrder.total_amount}`);
    console.log(`Item Count:                    ${(dbOrder.order_items || []).length} items`);
  }

  return { turnEvaluations, dbOrder, allPhotosPassed, orderCreated };
}

runSinhalaTest().then(res => {
  if (res.allPhotosPassed && res.orderCreated) {
    console.log("\n🎯 SINHALA TEST SUCCESSFULLY COMPLETED AND PASSED ALL CHECKS.");
    process.exit(0);
  } else {
    console.error("\n⚠️ SINHALA TEST FAILED SOME CHECKS.");
    process.exit(1);
  }
}).catch(err => {
  console.error("Execution error:", err);
  process.exit(1);
});
