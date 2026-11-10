BEGIN;
-- Delete existing products to ensure clean slate for tests
DELETE FROM fishing.products WHERE user_id = '8ec761ff-b716-411b-85d2-1b56980d1e8a';
DELETE FROM ibbagamuwa_customization.products WHERE user_id = '8ec761ff-b716-411b-85d2-1b56980d1e8a';
DELETE FROM public.products WHERE user_id = '8ec761ff-b716-411b-85d2-1b56980d1e8a';

INSERT INTO ibbagamuwa_customization.products (
    id, user_id, name, description, price, delivery_price, product_type, variations, images, video_url, is_active, created_at, updated_at
) VALUES (
'a4abd913-cb0b-4176-a938-6c72e6a89935', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 'frog lure', '🐸💛 **FROG LURE – සුපිරිම Fishing Lure එකක්!** 🎣🔥

මාළු අල්ලන වැඩේට අලුත්ම ආකර්ෂණීය Frog Lure එක දැන් අපෙන්! 😍

✅ ආකර්ෂණීය Yellow Colour 💛
✅ ශක්තිමත් Double Hooks
✅ Snakehead Fishing සඳහා සුදුසුයි 🐟
✅ පහසු භාවිතය සහ සුපිරි නිමාව

💰 **විශේෂ මිල රු. 750/- පමණයි!** 🔥

📦 දිවයින පුරා Delivery පහසුකම් ඇත.

🏪 **IBBAGAMUWA FISHING CENTER** 🎣', 650.0, 250, 'physical', '[]'::jsonb, ARRAY['https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/1268f4bd-de68-4d76-971d-75aec0bb9e26.jpeg', 'https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/f3af8bed-859e-4c58-b2dc-fb7523d5a4b2.jpeg', 'https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/616fd4f9-7878-417d-bbc3-e6ea3eae7de8.jpeg', 'https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/eaada3d7-59d3-48ca-897e-b702d5b0e8bb.jpeg', 'https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/6d606b50-12fa-41e8-b5a5-a902380a756e.jpeg', 'https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/c7f22c65-e27d-4eaf-9f4e-d343b38e98f6.jpeg']::text[], NULL, true, '2026-11-07T12:38:51.160252+00:00', '2026-11-08T04:11:57.08698+00:00'

) ON CONFLICT (id) DO NOTHING;
UPDATE ibbagamuwa_customization.products SET name = 'Frog Lure (Yellow Snakehead Frog / ගෙම්බා Lure)', description = 'High quality yellow hollow-body frog lure with sharp double hooks. Ideal for Snakehead (Lulla / ලූලා) topwater fishing in tanks and lakes. Available individually.', price = 650.0 WHERE id = 'a4abd913-cb0b-4176-a938-6c72e6a89935';

INSERT INTO ibbagamuwa_customization.products (
    id, user_id, name, description, price, delivery_price, product_type, variations, images, video_url, is_active, created_at, updated_at
) VALUES (
'1fb4de3b-fc72-40c6-ac80-7952da30a1ba', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 'POPPER frog lure ', '🐸🔥 **අලුත්ම POPPER FROG LURE එක දැන් අපෙන්!** 🎣

දිය මතුපිට මාළු අල්ලන අයට සුපිරි තේරීමක්! 😍🐟

✅ Topwater Action 💦
✅ තියුණු Hook එකක් 🎯
✅ සැහැල්ලු සහ ශක්තිමත් 💪
✅ ආකර්ෂණීය වර්ණ 🔥

💰 **මිල රු. 750/- පමණයි!** 😱❤️

📦 දිවයින පුරා Delivery 🚚🇱🇰

🏪 **IBBAGAMUWA FISHING CENTER**
📍 Dambulla Road, Thorayaya, Kurunegala

📲 ඇණවුම් කිරීමට දැන්ම අපට Message එකක් දාන්න! ❤️', 750.0, 250, 'physical', '[]'::jsonb, ARRAY['https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/485be73c-63ce-4faa-bd35-08f04e6398e0.jpeg', 'https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/7870d247-6b7a-41ae-a285-04bd5d785f62.jpeg', 'https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/f47bcfe4-4a0d-4365-9884-741a66e67029.jpeg', 'https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/fae60998-27f3-44f8-a948-bc5698629901.jpeg', 'https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/fe12e52f-1340-4ff2-a8e5-1dafc8960397.jpeg', 'https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/4ec141ae-3dae-4acc-8318-acbbc8ebea03.jpeg', 'https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/4918e79b-1750-4db7-b756-5c7af3db4ee8.jpeg', 'https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/bdd347a2-bfbd-48f5-b410-188e0ba734fb.jpeg']::text[], NULL, true, '2026-11-07T12:37:33.431314+00:00', '2026-11-08T04:11:53.320708+00:00'

) ON CONFLICT (id) DO NOTHING;
UPDATE ibbagamuwa_customization.products SET name = 'Popper Frog Lure (Topwater Frog / පොපර් ගෙම්බා)', description = 'Topwater popping frog lure with sharp hooks and splash action to provoke aggressive predator strikes. Available individually.', price = 750.0 WHERE id = '1fb4de3b-fc72-40c6-ac80-7952da30a1ba';

INSERT INTO ibbagamuwa_customization.products (
    id, user_id, name, description, price, delivery_price, product_type, variations, images, video_url, is_active, created_at, updated_at
) VALUES (
'93e87c9c-deba-4d9f-8605-642957957822', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 'rediam lure', 'rediam lure
40grn 50 grm 
wite color 
red and silver', 1200.0, 250, 'physical', '[]'::jsonb, ARRAY['https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/c41ee88d-6b3b-4fc2-aa03-dd632e296bf6.jpeg', 'https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/dba17a16-54d3-49b6-a7d4-f2eabf255b62.png']::text[], NULL, true, '2026-11-07T12:14:12.531958+00:00', '2026-11-08T04:12:12.186851+00:00'

) ON CONFLICT (id) DO NOTHING;
UPDATE ibbagamuwa_customization.products SET name = 'Radium Lure (Glow in Dark / Rediam Lure / රේඩියම් ලූර්)', description = 'Glow in dark / radium finish lure (40g, 50g), colors: White, Red & Silver. Ideal for night and deep/murky water fishing. Available individually.', price = 1200.0 WHERE id = '93e87c9c-deba-4d9f-8605-642957957822';

INSERT INTO ibbagamuwa_customization.products (
    id, user_id, name, description, price, delivery_price, product_type, variations, images, video_url, is_active, created_at, updated_at
) VALUES (
'cfc40b98-a51e-4e4f-9cc5-363bd360e381', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 'Poppor lure', 'poppor lure 
🎣🔥 මාළු අල්ලන්න කැමති අයට සුපිරි POPPER LURE එකක්! 🔥
availble coler 
red and silver
green and black 
rose and red 
🐟 40g සහ 60g බරින් ලබාගත හැකියි.
💥 ආකර්ෂණීය නිමාව
🎯 මසුන් ආකර්ෂණය කරගැනීමට කදිමයි!

💰 **මිල රු. 1,500/- පමණයි!**

📍 Ibbagamuwa Fishing Center
🛒 අදම ඇණවුම් කරන්න!', 1500.0, 250, 'physical', '[]'::jsonb, ARRAY['https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/a4493c98-d715-4add-a40f-c4f4a8a209e2.jpeg', 'https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/80b8a736-6a6a-4b1a-bcd8-7582b79c4b0d.jpeg', 'https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/2e75c77c-bda4-426f-9bd1-3c9ecbf2d85f.jpeg', 'https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/27e6a18d-9f10-4015-ba64-266ec7dcc1ba.jpeg']::text[], NULL, true, '2026-11-07T10:46:26.281317+00:00', '2026-11-08T04:11:44.947984+00:00'

) ON CONFLICT (id) DO NOTHING;
UPDATE ibbagamuwa_customization.products SET name = 'Popper Lure (Surface Popper 40g / 60g)', description = 'Surface popper lure (40g, 60g). Colors: Red & Silver, Green & Black, Rose & Red. Excellent surface disturbance for predatory fish. Available individually.', price = 1500.0 WHERE id = 'cfc40b98-a51e-4e4f-9cc5-363bd360e381';

INSERT INTO ibbagamuwa_customization.products (
    id, user_id, name, description, price, delivery_price, product_type, variations, images, video_url, is_active, created_at, updated_at
) VALUES (
'9805c714-adab-4328-91d3-c61427d4ffb8', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 'noby brand lure', 'noby brand lure
 40grm
60grm', 1500.0, 250, 'physical', '[]'::jsonb, ARRAY['https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/f4e3b4ba-cfa3-4b2b-8184-e473338452a0.jpeg', 'https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/2af8872f-dfb7-471f-8210-945a44b1b67b.jpeg', 'https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/d17d5b51-55a1-4ffe-b969-94d1f0386417.jpeg', 'https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/b440ba9a-3506-4839-9650-1c6fc0313cdf.jpeg', 'https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/5a5928b9-32e4-464e-b205-eac507e1f99a.jpeg', 'https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/1f28bd4c-2efa-4cc6-8764-fc5264de7c32.jpeg']::text[], NULL, true, '2026-11-07T11:58:08.06889+00:00', '2026-11-08T04:11:49.939897+00:00'

) ON CONFLICT (id) DO NOTHING;
UPDATE ibbagamuwa_customization.products SET name = 'Noby Brand Metal Lure (40g / 60g)', description = 'High quality Noby brand metal casting lure available in 40g and 60g weights for long-distance casting. Available individually.', price = 1500.0 WHERE id = '9805c714-adab-4328-91d3-c61427d4ffb8';

INSERT INTO ibbagamuwa_customization.products (
    id, user_id, name, description, price, delivery_price, product_type, variations, images, video_url, is_active, created_at, updated_at
) VALUES (
'8e0938f1-8079-4ed8-a65c-586997547d5a', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 'Soft Bite Lure ', '
🎣🐟 මාළු අල්ලන වැඩේ තවත් පහසු කරගන්න සුපිරි Soft Bite Lure එකක්! 🔥

✨ ආකර්ෂණීය වර්ණ
💪 මාළුන් ආකර්ෂණය කරන නිර්මාණය
🎯 විශේෂ මසුන් ඇල්ලීම සඳහා

📦 1 Packet – 4 PCS

💰 මිල රු. 1,900/- පමණයි!

📲 අදම ඇණවුම් කරන්න!

', 1900.0, 250, 'physical', '[]'::jsonb, ARRAY['https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/ee47ad4c-c115-46fd-b3e5-039cd23f2e36.png', 'https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/279ace93-f84f-40b7-b9b5-05314d2c2133.png', 'https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/fca8746b-e823-46c3-9ed4-f5b3cdf43635.png', 'https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/607f287a-9fc2-4616-a0bc-63f4c8adc2ba.png', 'https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/9d56fb87-fecd-48a3-ac91-c78173c83ce8.jpeg', 'https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/cfd7b397-48be-4f67-81df-156fe72b8d15.jpeg', 'https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/02cdcc7e-c5cb-4e49-9116-8fb4b2a61f14.jpeg', 'https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/a72d739c-1929-4d99-8a2d-15d3ca8e710b.jpeg', 'https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/f1aad334-7ba1-4082-9d65-2249bba494ec.jpeg', 'https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/6f173233-7f33-4fc0-9ed5-5467a318e40b.png']::text[], NULL, true, '2026-11-07T17:59:54.885419+00:00', '2026-11-08T04:12:06.083103+00:00'

) ON CONFLICT (id) DO NOTHING;
UPDATE ibbagamuwa_customization.products SET name = 'Soft Bite Lure (Packet of 4 pcs / සොෆ්ට් බයිට්)', description = 'Soft silicone fish bite lures (Packet of 4 pcs). Lifelike tail swimming action for predator fish. Available individually.', price = 1900.0 WHERE id = '8e0938f1-8079-4ed8-a65c-586997547d5a';

INSERT INTO ibbagamuwa_customization.products (
    id, user_id, name, description, price, delivery_price, product_type, variations, images, video_url, is_active, created_at, updated_at
) VALUES (
'b5075f6f-3e47-4ce2-a7ba-0fcf0ff29ab1', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 'lure set with tackle box', '🎣🔥 සුපිරි LURE SET එකක් දැන් ඔබටම!

🐟 14g LURE 5ක්
📦 පහසුකම් සහිත TACKLE BOX එකක් සමඟින්

💰 මිල රු. 1,900/- පමණයි!

🔥 මසුන් දඩයම් කරන ඔබට අනිවාර්යයෙන්ම තිබිය යුතු SET එකක්!

📍 Ibbagamuwa Fishing Center

📲 අදම ඇණවුම් කරන්න!', 1900.0, 250, 'physical', '[]'::jsonb, ARRAY['https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/015f8f73-72b1-4c4c-af4e-af8f883e1961.png']::text[], NULL, true, '2026-11-07T18:27:42.021339+00:00', '2026-11-08T04:12:09.087488+00:00'

) ON CONFLICT (id) DO NOTHING;
UPDATE ibbagamuwa_customization.products SET name = 'Lure Set with Tackle Box (5 pcs + Box)', description = 'Complete set of 5 pieces 14g lures packaged neatly with a clear multi-compartment tackle box. Available individually.', price = 1900.0 WHERE id = 'b5075f6f-3e47-4ce2-a7ba-0fcf0ff29ab1';

INSERT INTO ibbagamuwa_customization.products (
    id, user_id, name, description, price, delivery_price, product_type, variations, images, video_url, is_active, created_at, updated_at
) VALUES (
'e2773a81-9f4d-45b1-8e81-c811dcf0a6bb', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 'Normal quality telescope rod ', 'Delevery charge eka 450 or 550
2-5 kg darg
🎣 අඩු මිලට සුපිරි Fishing Rod එකක් හොයන අයට මෙන්න අනගි අවස්ථාවක්! 🔥
💥 TYP Telescope Rod
✅ Lightweight & Easy to Carry
✅ Strong & Durable
✅ Freshwater & Saltwater Fishing සඳහා සුදුසුයි
💰 මිල රු. 2,000 සිට පමණයි! ❤️
🚚 දිවයින පුරා Delivery පහසුකම්
💵 Cash on Delivery (COD) පහසුකමත් ඇත.
📲 අදම Order කරන්න! ', 2000.0, 0, 'physical', '[{"name": "Height ", "options": [{"label": "6feet", "price": 2000, "subVariants": [{"name": "", "options": [{"label": "", "price": 0}], "required": false}]}, {"label": "7feet ", "price": 2200}, {"label": "8feet ", "price": 2500}, {"label": "9feet", "price": 2900}, {"label": "10feet", "price": 3200}, {"label": "12-14feet", "price": 3500}]}]'::jsonb, ARRAY['https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/8b17a3b8-fbe4-458f-99e6-42a74174bad7.png', 'https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/c8c1ba23-5add-4811-b015-48157aa12419.png', 'https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/d648e669-5fb0-41e4-a7aa-3ec5e6a3138f.png']::text[], NULL, true, '2026-11-05T20:28:40.086696+00:00', '2026-11-06T13:14:36.225974+00:00'

) ON CONFLICT (id) DO NOTHING;
UPDATE ibbagamuwa_customization.products SET name = 'Normal Quality Telescopic Rod', description = 'Compact telescopic fishing rod (6ft - 14ft), 2-5kg drag. Lightweight and convenient to carry.' WHERE id = 'e2773a81-9f4d-45b1-8e81-c811dcf0a6bb';

INSERT INTO ibbagamuwa_customization.products (
    id, user_id, name, description, price, delivery_price, product_type, variations, images, video_url, is_active, created_at, updated_at
) VALUES (
'52710284-2d95-430a-8ec4-a98aff2eddb6', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 'AC7000 Fishing Reel /rod machine', 'metal reel 
drag kg 5-8
china 
🎣🔥 **සුපිරි Fishing Reel දෙකක් – දැන් විශේෂ මිලකට!**

💥 **AC5000 Fishing Reel** – රු. 2,900/-
💥 **AC7000 Fishing Reel** – රු. 3,900/-

✅ සුපිරි නිමාව
✅ ශක්තිමත් නිර්මාණය
✅ Smooth Performance
✅ මසුන් ඇල්ලීමට කදිමයි 🐟

📦 සීමිත තොගයක් පමණයි!

📍 Ibbagamuwa Fishing Center

📲 අදම Order කරන්න!', 3900.0, 450, 'physical', '[{"name": "size", "options": [{"label": "AC4000", "price": 2500}, {"label": "AC5000", "price": 2900}, {"label": "AC7000", "price": 3900}]}]'::jsonb, ARRAY['https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/f26f037b-6918-4139-9706-7ecc8fe09e59.png', 'https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/50ac2b17-889e-45f2-af0a-1df3a06ec047.png']::text[], NULL, true, '2026-11-08T13:25:51.071504+00:00', '2026-11-08T13:33:23.421024+00:00'

) ON CONFLICT (id) DO NOTHING;
UPDATE ibbagamuwa_customization.products SET name = 'AC7000 Fishing Reel (Metal Spool)', description = 'Metal spinning reel, available in AC4000, AC5000, and AC7000 sizes. 5-8kg drag.' WHERE id = '52710284-2d95-430a-8ec4-a98aff2eddb6';

INSERT INTO ibbagamuwa_customization.products (
    id, user_id, name, description, price, delivery_price, product_type, variations, images, video_url, is_active, created_at, updated_at
) VALUES (
'70e52f6e-e4da-4e71-bb4b-d0d7b1e3e0a2', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 'Glaxy Diamond Rod ', '🎣🔥 මහදියට සුපිරිම Fishing Rod එකක්! 🔥🎣

Carbon fiber 
Two piece 
💪 KG 15–20 අතර බරක් දරාගත හැකි ශක්තිමත් Rod එකක්!
📏 අඩි 6 සිට 12 දක්වා Sizes රැසක් उपलब्धයි.

💰 මිල රු. 4,500 සිට පමණයි! ❤️

🐟 ලොකු මාළු අල්ලන්න කැමති ඔබට සුපිරිම තේරීමක්!

📲 අදම ORDER කරන්න!
', 4500.0, 550, 'physical', '[{"name": "Highit", "options": [{"label": "6feet", "price": 3900}, {"label": "7feet", "price": 4500}, {"label": "8feet", "price": 5500}, {"label": "9feet", "price": 6500}, {"label": "10feer", "price": 7500}]}]'::jsonb, ARRAY['https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/2108b7ed-5cab-4b5c-a1cf-68bcacad7646.png', 'https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/2c8ee06c-aea5-4ea3-aaca-0a911a926d0b.png', 'https://supabase.buildstart.io/storage/v1/object/public/biz-b1120f27-7cd3-4429-a8d3-c678c93b9562/products/15c69d59-966f-4a6d-9c9b-b2e7a2c157d7.png']::text[], NULL, true, '2026-11-06T15:06:10.915154+00:00', '2026-11-06T15:06:10.915154+00:00'

) ON CONFLICT (id) DO NOTHING;
UPDATE ibbagamuwa_customization.products SET name = 'Galaxy Diamond Carbon Two-Piece Rod', description = 'Heavy-duty 2-piece carbon fiber rod (6ft - 10ft), 15-20kg drag capacity for large predatory fish.' WHERE id = '70e52f6e-e4da-4e71-bb4b-d0d7b1e3e0a2';

-- Copy the 10 products to fishing and public schemas
INSERT INTO fishing.products SELECT * FROM ibbagamuwa_customization.products WHERE user_id = '8ec761ff-b716-411b-85d2-1b56980d1e8a' ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description, price = EXCLUDED.price, images = EXCLUDED.images, is_active = EXCLUDED.is_active;
INSERT INTO public.products SELECT * FROM ibbagamuwa_customization.products WHERE user_id = '8ec761ff-b716-411b-85d2-1b56980d1e8a' ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description, price = EXCLUDED.price, images = EXCLUDED.images, is_active = EXCLUDED.is_active;

-- Trigger function to keep ibbagamuwa_customization, fishing, and public in sync
CREATE OR REPLACE FUNCTION sync_products_across_schemas()
RETURNS TRIGGER AS $$
BEGIN
  IF pg_trigger_depth() > 1 THEN
    RETURN COALESCE(NEW, OLD);
  END IF;

  IF TG_OP = 'INSERT' THEN
    INSERT INTO fishing.products (id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url)
    VALUES (NEW.id, NEW.name, NEW.description, NEW.price, NEW.product_type, NEW.variations, NEW.images, NEW.is_active, NEW.created_at, NEW.updated_at, NEW.user_id, NEW.delivery_price, NEW.video_url)
    ON CONFLICT (id) DO UPDATE SET
      name = EXCLUDED.name,
      description = EXCLUDED.description,
      price = EXCLUDED.price,
      product_type = EXCLUDED.product_type,
      variations = EXCLUDED.variations,
      images = EXCLUDED.images,
      is_active = EXCLUDED.is_active,
      delivery_price = EXCLUDED.delivery_price,
      video_url = EXCLUDED.video_url,
      updated_at = EXCLUDED.updated_at;

    INSERT INTO public.products (id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url)
    VALUES (NEW.id, NEW.name, NEW.description, NEW.price, NEW.product_type, NEW.variations, NEW.images, NEW.is_active, NEW.created_at, NEW.updated_at, NEW.user_id, NEW.delivery_price, NEW.video_url)
    ON CONFLICT (id) DO UPDATE SET
      name = EXCLUDED.name,
      description = EXCLUDED.description,
      price = EXCLUDED.price,
      product_type = EXCLUDED.product_type,
      variations = EXCLUDED.variations,
      images = EXCLUDED.images,
      is_active = EXCLUDED.is_active,
      delivery_price = EXCLUDED.delivery_price,
      video_url = EXCLUDED.video_url,
      updated_at = EXCLUDED.updated_at;

    RETURN NEW;
  ELSIF TG_OP = 'UPDATE' THEN
    UPDATE fishing.products SET
      name = NEW.name,
      description = NEW.description,
      price = NEW.price,
      product_type = NEW.product_type,
      variations = NEW.variations,
      images = NEW.images,
      is_active = NEW.is_active,
      delivery_price = NEW.delivery_price,
      video_url = NEW.video_url,
      updated_at = NEW.updated_at
    WHERE id = NEW.id;

    UPDATE public.products SET
      name = NEW.name,
      description = NEW.description,
      price = NEW.price,
      product_type = NEW.product_type,
      variations = NEW.variations,
      images = NEW.images,
      is_active = NEW.is_active,
      delivery_price = NEW.delivery_price,
      video_url = NEW.video_url,
      updated_at = NEW.updated_at
    WHERE id = NEW.id;

    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    DELETE FROM fishing.products WHERE id = OLD.id;
    DELETE FROM public.products WHERE id = OLD.id;
    RETURN OLD;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_sync_ibbagamuwa_products ON ibbagamuwa_customization.products;
CREATE TRIGGER trg_sync_ibbagamuwa_products
AFTER INSERT OR UPDATE OR DELETE ON ibbagamuwa_customization.products
FOR EACH ROW EXECUTE FUNCTION sync_products_across_schemas();

COMMIT;