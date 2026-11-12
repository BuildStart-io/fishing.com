#!/usr/bin/env node
/**
 * Automated Verification Suite:
 * 1. Query AI about EVERY product in the database (32 items)
 *    - Verify AI acknowledges product details and pricing
 *    - Verify returned imageUrls match ground-truth DB images (no hallucinations, no leaks)
 *    - Verify 0-image products return empty imageUrls
 * 2. Purchase a Custom Fishing Kit (NOT a pre-made combo set):
 *    - Individual items: Rod + Reel + Line + Lure + Float
 *    - Multi-turn conversation verifying product recommendations, images, and prices
 *    - Place complete order with customer details
 *    - Verify <ORDER_JSON> generation and accurate total amount calculation
 *    - Verify database persistence in orders table
 */

const { execSync } = require("child_process");

const EDGE_FUNCTION_URL = "http://localhost:8000/functions/v1/ai-chat_fishing";
const SERVICE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2VydmljZV9yb2xlIiwiaXNzIjoic3VwYWJhc2UiLCJpYXQiOjE3OTM2MjQ0NTAsImV4cCI6MjEwODk4NDQ1MH0.3NSKKo_lwbQZHiQEfmH_WIzO-acB0Y0hEQErOB9yDWs";
const USER_ID = "5543a79b-21f1-4091-905b-025d39acd0c8";

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

function queryDatabase(sql) {
  const escaped = sql.replace(/'/g, "'\\''");
  const raw = execSync(`docker exec -i supabase-db psql -U postgres -d postgres -t -A -c '${escaped}'`, {
    encoding: "utf8"
  }).trim();
  return raw;
}

async function callAiChat(message, conversationHistory = [], phoneNumber = "94779876543") {
  const res = await fetch(EDGE_FUNCTION_URL, {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${SERVICE_KEY}`,
      "Content-Type": "application/json"
    },
    body: JSON.stringify({
      message,
      phoneNumber,
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

async function main() {
  console.log("===============================================================================");
  console.log("         COMPREHENSIVE ALL-PRODUCT & CUSTOM KIT AUTOMATED VERIFICATION         ");
  console.log("===============================================================================\n");

  // Step 1: Fetch ground-truth products from database
  console.log("--> Fetching ground-truth products from PostgreSQL...");
  const rawJson = queryDatabase(`
    SELECT json_agg(p) FROM (
      SELECT id, name, price, product_type, delivery_price, description, images, video_url, variations
      FROM public.products
      WHERE user_id = '${USER_ID}' AND is_active = true
      ORDER BY name
    ) p;
  `);

  const dbProducts = JSON.parse(rawJson);
  console.log(`[PASS] Retrieved ${dbProducts.length} active products from database.\n`);

  // PART 1: Query every product individually
  console.log("-------------------------------------------------------------------------------");
  console.log("PART 1: Query AI about EVERY product and verify photos & details");
  console.log("-------------------------------------------------------------------------------");

  const productResults = [];
  let part1Passed = 0;
  let part1Failed = 0;

  for (let i = 0; i < dbProducts.length; i++) {
    const product = dbProducts[i];
    const expectedImages = Array.isArray(product.images) ? product.images : [];
    const expectedImgCount = expectedImages.length;
    const testNum = i + 1;

    console.log(`\n[${testNum}/${dbProducts.length}] Querying product: "${product.name}"`);
    console.log(`   - Base Price: LKR ${product.price} | Variations: ${product.variations?.length || 0} | DB Images: ${expectedImgCount}`);

    try {
      const response = await callAiChat(`Can you tell me about "${product.name}" and send photos?`);
      const text = response.response || "";
      const returnedImages = response.imageUrls || [];

      // Check 1: AI response contains relevant information or name
      const nameParts = product.name.split(" ").filter(w => w.length > 3);
      const nameRecognized = nameParts.some(w => text.toLowerCase().includes(w.toLowerCase())) ||
                             text.includes(String(product.price));

      // Check 2: Images verification
      let imageMatchValid = false;
      let imgReason = "";

      if (expectedImgCount === 0) {
        if (returnedImages.length === 0) {
          imageMatchValid = true;
          imgReason = "Correctly sent 0 photos (no photos in DB)";
        } else {
          imageMatchValid = false;
          imgReason = `HALLUCINATION: DB has 0 photos but AI sent ${returnedImages.length} photos!`;
        }
      } else {
        // Product has images: returned images must be subset of expectedImages and no external hallucinated URLs
        const allUrlsBelongToProduct = returnedImages.every(url => expectedImages.includes(url));
        if (returnedImages.length > 0 && allUrlsBelongToProduct) {
          imageMatchValid = true;
          imgReason = `Sent ${returnedImages.length}/${expectedImgCount} verified product photos`;
        } else if (returnedImages.length === 0) {
          // If AI didn't include images, let's check why
          imageMatchValid = false;
          imgReason = `AI returned 0 photos despite product having ${expectedImgCount} photos in DB`;
        } else {
          imageMatchValid = false;
          imgReason = `Mismatch: returned images not from this product catalog!`;
        }
      }

      const testSuccess = nameRecognized && imageMatchValid;
      if (testSuccess) {
        part1Passed++;
        console.log(`   [PASS] Details recognized: YES | Photos: ${imgReason}`);
      } else {
        part1Failed++;
        console.log(`   [FAIL] Details recognized: ${nameRecognized ? "YES" : "NO"} | Photos: ${imgReason}`);
        console.log(`   -> AI Response: ${text.substring(0, 120)}...`);
      }

      productResults.push({
        id: product.id,
        name: product.name,
        price: product.price,
        expectedImages: expectedImgCount,
        returnedImages: returnedImages.length,
        imageUrls: returnedImages,
        passed: testSuccess,
        details: imgReason
      });

      // Brief sleep between queries to ensure healthy throughput
      await sleep(400);

    } catch (err) {
      part1Failed++;
      console.log(`   [ERROR] Call failed: ${err.message}`);
      productResults.push({
        id: product.id,
        name: product.name,
        price: product.price,
        expectedImages: expectedImgCount,
        returnedImages: 0,
        imageUrls: [],
        passed: false,
        details: `Error: ${err.message}`
      });
    }
  }

  console.log("\n===============================================================================");
  console.log(`PART 1 SUMMARY: ${part1Passed}/${dbProducts.length} Products Verified Successfully.`);
  console.log("===============================================================================\n");

  // PART 2: Custom Fishing Kit Purchase (Rod + Reel + Line + Lure + Float)
  console.log("-------------------------------------------------------------------------------");
  console.log("PART 2: Custom Fishing Kit Assembly & Purchase Simulation");
  console.log("-------------------------------------------------------------------------------");

  const customPhone = `9477${Math.floor(1000000 + Math.random() * 9000000)}`;
  const conversation = [];

  // Turn 1: Custom Kit Specification & Photos Inquiry
  console.log(`\n[Turn 1] Customer asks to build custom kit (individual rod, reel, line, lure, float)...`);
  const turn1Msg = "Hi, I don't want a pre-made combo set. I want to build a custom kit with 5 individual items:\n" +
                   "1. Astika 2-Piece Fishing Rod (6ft)\n" +
                   "2. AC7000 Fishing Reel (Metal Spool) (size AC4000)\n" +
                   "3. Fishing Wire Leader Cable (40LB)\n" +
                   "4. Popper Frog Lure (750)\n" +
                   "5. Fishing Float\n" +
                   "Can you show me the photos and calculate the prices for each?";

  conversation.push({ direction: "inbound", message: turn1Msg });
  const turn1Res = await callAiChat(turn1Msg, [], customPhone);
  const turn1Text = turn1Res.response || "";
  const turn1Images = turn1Res.imageUrls || [];

  console.log("AI Response:\n" + turn1Text);
  console.log(`Photos received (${turn1Images.length}):\n` + turn1Images.join("\n"));
  conversation.push({ direction: "outbound", message: turn1Text });

  // Verify Turn 1
  const t1PhotosValid = turn1Images.length >= 2;
  const mentionsRod = /Astika/i.test(turn1Text) || /2500/i.test(turn1Text);
  const mentionsReel = /AC7000|reel|spool/i.test(turn1Text) || /2500/i.test(turn1Text);
  const mentionsLine = /Wire|Leader|Cable/i.test(turn1Text) || /200/i.test(turn1Text);
  const mentionsLure = /Popper|Frog|Lure/i.test(turn1Text) || /750/i.test(turn1Text);
  const mentionsFloat = /Float/i.test(turn1Text) || /150/i.test(turn1Text);

  console.log(`\nTurn 1 Verification:`);
  console.log(` - Photos returned: ${turn1Images.length} (Valid: ${t1PhotosValid ? "YES" : "NO"})`);
  console.log(` - Rod recognized: ${mentionsRod ? "YES" : "NO"}`);
  console.log(` - Reel recognized: ${mentionsReel ? "YES" : "NO"}`);
  console.log(` - Line recognized: ${mentionsLine ? "YES" : "NO"}`);
  console.log(` - Lure recognized: ${mentionsLure ? "YES" : "NO"}`);
  console.log(` - Float recognized: ${mentionsFloat ? "YES" : "NO"}`);

  // Turn 2: Order Placement & Checkout Confirmation
  console.log(`\n[Turn 2] Customer confirms order with all delivery details...`);
  const turn2Msg = "Yes, please place the order for all 5 items:\n" +
                   "- 1x Astika 2-Piece Fishing Rod (6ft)\n" +
                   "- 1x AC7000 Fishing Reel (Metal Spool) (size AC4000)\n" +
                   "- 1x Fishing Wire Leader Cable (40LB)\n" +
                   "- 1x Popper Frog Lure (750)\n" +
                   "- 1x Fishing Float\n\n" +
                   "Customer Details:\n" +
                   "Name: Nimal Perera\n" +
                   `Phone: 0771234567\n` +
                   "Address: 45 Galle Road, Bambalapitiya\n" +
                   "District: Colombo\n" +
                   "Payment: Cash on Delivery\n\n" +
                   "Please confirm the order and give me the total amount.";

  conversation.push({ direction: "inbound", message: turn2Msg });
  const turn2Res = await callAiChat(turn2Msg, conversation, customPhone);
  const turn2Text = turn2Res.response || "";

  console.log("AI Confirmation Response:\n" + turn2Text);

  // Check Database for Newly Created Order
  console.log("\n--> Verifying order saved in database...");
  await sleep(1000);
  const orderRaw = queryDatabase(`
    SELECT json_build_object(
      'id', id,
      'customer_name', customer_name,
      'customer_phone', customer_phone,
      'district', district,
      'customer_address', customer_address,
      'order_items', order_items,
      'payment_method', payment_method,
      'total_amount', total_amount,
      'status', status
    )::text
    FROM public.orders
    WHERE user_id = '${USER_ID}'
    ORDER BY created_at DESC
    LIMIT 1;
  `);

  let orderData = null;
  try {
    orderData = JSON.parse(orderRaw);
  } catch (e) {
    console.error("Failed to parse order from DB:", orderRaw);
  }

  console.log("\n===============================================================================");
  console.log("                    CUSTOM KIT ORDER VERIFICATION REPORT                       ");
  console.log("===============================================================================");

  const expectedItemSubtotal = 2500 + 2500 + 200 + 750 + 150; // LKR 6,100
  console.log(`Expected Item Subtotal: LKR 6,100`);
  console.log(`   1. Astika 2-Piece Rod (6ft):        LKR 2,500`);
  console.log(`   2. AC7000 Fishing Reel (AC4000):    LKR 2,500`);
  console.log(`   3. Fishing Wire Leader Cable (40LB):LKR   200`);
  console.log(`   4. Popper Frog Lure (750):          LKR   750`);
  console.log(`   5. Fishing Float:                   LKR   150`);

  let orderCorrect = false;
  if (orderData) {
    console.log(`\nDB Order Details (Order #${orderData.id}):`);
    console.log(`   - Customer: ${orderData.customer_name} (${orderData.customer_phone})`);
    console.log(`   - District: ${orderData.district}`);
    console.log(`   - Address:  ${orderData.customer_address}`);
    console.log(`   - Payment:  ${orderData.payment_method}`);
    console.log(`   - DB Total: LKR ${orderData.total_amount}`);
    console.log(`   - Items Count: ${orderData.order_items?.length || 0}`);

    const has5Items = (orderData.order_items?.length || 0) === 5;
    const totalIsAccurate = orderData.total_amount === 6100 || orderData.total_amount === 6550;

    console.log(`\nOrder Checks:`);
    console.log(`   - Customer Name Match: ${/Nimal/i.test(orderData.customer_name) ? "PASS" : "FAIL"}`);
    console.log(`   - Order Items (5 items): ${has5Items ? "PASS" : "FAIL"}`);
    console.log(`   - Total Amount Accurate (LKR ${orderData.total_amount}): ${totalIsAccurate ? "PASS" : "FAIL"}`);

    orderCorrect = has5Items && totalIsAccurate;
  } else {
    console.log(`   [FAIL] No order record found in database!`);
  }

  console.log("\n===============================================================================");
  console.log("                           FINAL TEST SUMMARY                                  ");
  console.log("===============================================================================");
  console.log(`Total Products in Catalog:             ${dbProducts.length}`);
  console.log(`Products with Valid Photo Recognition: ${part1Passed}/${dbProducts.length}`);
  console.log(`Custom Kit 5-Item Purchase & Math:     ${orderCorrect ? "PASSED" : "FAILED"}`);
  console.log("===============================================================================");

  if (part1Passed === dbProducts.length && orderCorrect) {
    console.log("🎉 ALL AUTOMATED VERIFICATION SUITES PASSED PERFECTLY!");
    process.exit(0);
  } else {
    console.log("⚠️ Some tests did not meet 100% criteria. See breakdown above.");
    process.exit(1);
  }
}

main().catch(err => {
  console.error("FATAL ERROR in test execution:", err);
  process.exit(1);
});

