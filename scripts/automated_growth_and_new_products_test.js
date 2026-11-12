#!/usr/bin/env node
/**
 * Automated Verification Suite: Newly Imported Products & Growth Plan Verification
 * Tests:
 * 1. Database ground truth: 31 products, 5 FAQs, Growth plan tier (enterprise, 999 max products/faqs).
 * 2. Edge Function AI Chat Engine using tenant: 5543a79b-21f1-4091-905b-025d39acd0c8
 *    - Full Set / Combo Kits discovery & pricing
 *    - Product variations (lengths, colors, strengths)
 *    - Delivery FAQs & Cash on Delivery (COD) handling
 *    - Multilingual inquiries (English, Sinhala, Tamil)
 *    - Quota & Growth tier limit checks
 */

const { execSync } = require("child_process");

const EDGE_FUNCTION_URL = "http://localhost:8000/functions/v1/ai-chat_fishing";
const SERVICE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2VydmljZV9yb2xlIiwiaXNzIjoic3VwYWJhc2UiLCJpYXQiOjE3OTM2MjQ0NTAsImV4cCI6MjEwODk4NDQ1MH0.3NSKKo_lwbQZHiQEfmH_WIzO-acB0Y0hEQErOB9yDWs";
const USER_ID = "5543a79b-21f1-4091-905b-025d39acd0c8";
const PHONE_NUMBER = "94771234567";

function executeSql(sql) {
  const escaped = sql.replace(/'/g, "'\\''");
  return execSync(`docker exec -i supabase-db psql -U postgres -d postgres -t -A -c '${escaped}'`, {
    encoding: "utf8"
  }).trim();
}

async function callAiChat(message, conversationHistory = []) {
  const res = await fetch(EDGE_FUNCTION_URL, {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${SERVICE_KEY}`,
      "Content-Type": "application/json"
    },
    body: JSON.stringify({
      message,
      phoneNumber: PHONE_NUMBER,
      conversationHistory,
      userId: USER_ID
    })
  });

  if (!res.ok) {
    const errorText = await res.text();
    throw new Error(`Edge function returned status ${res.status}: ${errorText}`);
  }

  return await res.json();
}

const results = [];

async function runTest(testName, fn) {
  process.stdout.write(`⏳ Running: ${testName}... `);
  const start = Date.now();
  try {
    await fn();
    const duration = ((Date.now() - start) / 1000).toFixed(1);
    console.log(`\x1b[32m✔ PASS\x1b[0m (${duration}s)`);
    results.push({ name: testName, status: "PASS", duration });
  } catch (err) {
    const duration = ((Date.now() - start) / 1000).toFixed(1);
    console.log(`\x1b[31m✖ FAIL\x1b[0m (${duration}s)`);
    console.error(`   \x1b[31mError: ${err.message}\x1b[0m`);
    results.push({ name: testName, status: "FAIL", error: err.message, duration });
  }
}

function assert(condition, message) {
  if (!condition) {
    throw new Error(message);
  }
}

async function main() {
  console.log("=================================================================");
  console.log("   AUTOMATED VERIFICATION: NEW PRODUCTS & GROWTH PLAN SUITE");
  console.log(`   Tenant User ID: ${USER_ID}`);
  console.log("=================================================================\n");

  // TEST 1: Database Growth Plan Verification
  await runTest("Test 1: Growth Plan Tier in Database", async () => {
    const plan = executeSql(`SELECT plan_tier FROM fishing.profiles WHERE user_id = '${USER_ID}'`);
    const maxProducts = executeSql(`SELECT max_products FROM fishing.profiles WHERE user_id = '${USER_ID}'`);
    const maxFaqs = executeSql(`SELECT max_faqs FROM fishing.profiles WHERE user_id = '${USER_ID}'`);
    const isActive = executeSql(`SELECT is_active FROM fishing.profiles WHERE user_id = '${USER_ID}'`);

    assert(plan === "enterprise", `Expected plan_tier 'enterprise' (Growth), got '${plan}'`);
    assert(parseInt(maxProducts, 10) === 999, `Expected max_products 999, got ${maxProducts}`);
    assert(parseInt(maxFaqs, 10) === 999, `Expected max_faqs 999, got ${maxFaqs}`);
    assert(isActive === "t", "Expected account to be active");
  });

  // TEST 2: Product Catalog Count & Integrity
  await runTest("Test 2: Product Catalog Count (31 items)", async () => {
    const count = parseInt(executeSql(`SELECT count(*) FROM fishing.products WHERE user_id = '${USER_ID}'`), 10);
    assert(count === 31, `Expected 31 products, got ${count}`);
  });

  // TEST 3: FAQ Catalog Count (5 items)
  await runTest("Test 3: FAQ Catalog Count (5 items)", async () => {
    const count = parseInt(executeSql(`SELECT count(*) FROM fishing.faqs WHERE user_id = '${USER_ID}'`), 10);
    assert(count === 5, `Expected 5 FAQs, got ${count}`);
  });

  // TEST 4: AI Chat - Combo Set Recommendations
  await runTest("Test 4: AI Chat Combo Sets ('What fishing rod sets do you have?')", async () => {
    const res = await callAiChat("What fishing rod sets do you have?");
    const reply = res.response || "";

    assert(/rod/i.test(reply), "Must recommend rods");
    assert(/6,?800|13,?500|6,?500|9,?900/i.test(reply), "Must include accurate combo prices");
  });

  // TEST 5: AI Chat - Specific High-End Rod Full Set
  await runTest("Test 5: Diamond Rod Full Set ('Tell me about the Diamond Fishing Rod Full Set')", async () => {
    const res = await callAiChat("Tell me about the Diamond Fishing Rod Full Set");
    const reply = res.response || "";

    assert(/13,?500/.test(reply), "Must state price LKR 13,500");
    assert(/MQ6000|8m|reel|line/i.test(reply), "Must mention included components (MQ6000 reel, line, etc.)");
  });

  // TEST 6: AI Chat - Traditional Kithul Stick Set
  await runTest("Test 6: Kithul Stick Set ('Do you have Kithul stick sets?')", async () => {
    const res = await callAiChat("Do you have Kithul stick sets?");
    const reply = res.response || "";

    assert(/kithul/i.test(reply), "Must confirm Kithul stick availability");
    assert(/2,?900|3,?500/i.test(reply), "Must include price for Kithul stick (2900 or 3500)");
  });

  // TEST 7: AI Chat - Product Variations (Length Options)
  await runTest("Test 7: Variation Options ('What heights does the Premium Quality Telescopic Rod come in?')", async () => {
    const res = await callAiChat("What heights does the Premium Quality Telescopic Rod come in?");
    const reply = res.response || "";

    assert(/6ft|8ft|9ft|12ft|15ft/i.test(reply), "Must mention available length options");
    assert(/3,?000|3,?500|4,?100/.test(reply), "Must mention price points for variations");
  });

  // TEST 8: AI Chat - FAQs (Delivery & COD)
  await runTest("Test 8: FAQ Retrieval ('Can I pay with Cash on Delivery and do you deliver to Kandy?')", async () => {
    const res = await callAiChat("Can I pay with Cash on Delivery and do you deliver to Kandy?");
    const reply = res.response || "";

    assert(/cash on delivery|cod/i.test(reply), "Must confirm Cash on Delivery");
    assert(/island|all-island|delivery|2 to 4/i.test(reply), "Must confirm delivery availability across Sri Lanka");
  });

  // TEST 9: AI Chat - Sinhala Query
  await runTest("Test 9: Sinhala Query ('Kithul stick fishing set eka kiyada?')", async () => {
    const res = await callAiChat("Kithul stick fishing set eka kiyada?");
    const reply = res.response || "";

    assert(/2,?900|3,?500|රු/i.test(reply), "Must return accurate price in Sinhala reply");
  });

  // TEST 10: AI Chat - Tamil Query
  await runTest("Test 10: Tamil Query ('மீன்பிடி கம்பிகள் என்ன விலையில் உள்ளன?')", async () => {
    const res = await callAiChat("மீன்பිடி கம்பிகள் என்ன விலையில் உள்ளன?");
    const reply = res.response || "";

    assert(/ரூ|LKR|Rs|2,?000|6,?800|3,?000/.test(reply), "Must provide rod prices in Tamil reply");
  });

  console.log("\n=================================================================");
  console.log("                     TEST EXECUTION SUMMARY");
  console.log("=================================================================");
  const passed = results.filter(r => r.status === "PASS").length;
  const failed = results.filter(r => r.status === "FAIL").length;
  console.log(`Total Tests: ${results.length} | Passed: ${passed} | Failed: ${failed}`);
  console.log("=================================================================\n");

  if (failed > 0) process.exit(1);
}

main().catch(err => {
  console.error("Fatal test error:", err);
  process.exit(1);
});

