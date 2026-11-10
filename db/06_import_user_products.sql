BEGIN;

-- 1. Clear existing products and faqs
DELETE FROM fishing.products;
DELETE FROM fishing.faqs;
DELETE FROM ibbagamuwa_customization.products;
DELETE FROM ibbagamuwa_customization.faqs;

-- 2. Insert Products for fishing schema (for active tenant 8ec761ff-b716-411b-85d2-1b56980d1e8a)
INSERT INTO fishing.products (id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url) VALUES 
('755087e0-bdca-4053-b7c9-5eb9b33dbed2', '🎣🔥 SPECIAL OFFER – FISHING ROD FULL SET! 🔥🎣', '🎣🔥 SPECIAL OFFER – FISHING ROD FULL SET! 🔥🎣

💥 Rs. 7,500/- ➡️ NOW ONLY Rs. 6,800/- 💥

🎯 Complete Set – Ready to Fish!
✅ Fishing Rod
✅ AC4000 Reel
✅ Fishing Line
✅ Lure
✅ Float
✅ Hooks & Accessories

🐟 Beginners & Experienced Anglers
🌊 Freshwater & General Fishing
💪 Strong & Durable Quality Set

🚚 Islandwide Delivery Available! 🇱🇰
📲 Order Now – Inbox Us!

🔥 මේ special price එක miss කරගන්න එපා! ', 6800.00, 'physical', '[]', '{}', true, '2026-11-04 13:57:01.40951+00', '2026-11-04 13:57:01.40951+00', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 0, NULL),

('cbcf1f9c-84db-4e3c-b850-86aa8858e3a1', 'diamond fishing rod full set', '8m rod
MQ6000 reel
100m line
hook box
float
cable
japan hook lure', 13500.00, 'physical', '[]', '{}', true, '2026-11-04 13:59:42.168783+00', '2026-11-04 13:59:42.168783+00', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 0, NULL),

('5a8a00bd-2c88-4ee6-9148-faa748d806a5', 'astika fishing set 68', '🎣🔥 FISHING ROD FULL SET – විශේෂ මිල රු. 6,800/- පමණයි! 🔥🎣

🐟 මාළු අල්ලන්න ආස ඔයාලට සුපිරි Fishing Set එකක්! 💯

✅ 🎣 Fishing Rod
✅ ⚙️ AC4000 Reel
✅ 🧵 Fishing Line
✅ 🐠 Lures
✅ 🎈 Float
✅ 🪝 Hooks & Accessories

💥 සම්පූර්ණ SET එකම රු. 6,800/- පමණයි!

🎯 ආධුනිකයන්ටත් පළපුරුදු ධීවරයන්ටත් සුදුසුයි!

🚚 දිවයින පුරා Delivery පහසුකම ඇත.
💵 Cash on Delivery පහසුකමත් ඇත!

📲 ORDER කිරීමට දැන්ම WhatsApp හරහා හෝ Inbox එකට Message එකක් දාන්න!

🏪 FISHINGRODS.COM 🎣
📍 Dambulla Road, Thorayaya, Kurunegala

🔥 අදම ඔබේ Fishing Set එක වෙන්කරවා ගන්න! 🐟💯', 6800.00, 'physical', '[]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/e1f6efdc-f378-47e9-9470-a084986810f7.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/1349428c-4523-4ebe-8ec4-a3b15ff23dc4.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/02c4045e-6648-40ce-8cd5-b58e9fd4e33d.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/7aec978c-a87a-4b49-9fd6-77be4fe97816.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/98343579-8a45-49a0-aac8-0cd8a09180c4.jpg}', true, '2026-11-05 07:21:35.667405+00', '2026-11-05 07:21:35.667405+00', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 550, NULL),

('b783b887-4284-4e8a-a891-a81b17f4e715', 'Astikas telcope fishing  set', '🎣🔥 FISHING CENTER – SPECIAL PRICE DROP! 🔥🎣

kg 2-5 drag 
🐟 ගඟේ, වැවේ මාළු අල්ලන ඔයාලට සුපිරි Fishing Setup එකක්! 💯😍

💥 Rs. 6,800/- වෙනුවට දැන් Rs. 6500/- පමණයි! 🔥

🎣 ASITIKA Telescopic Rod Set එකේ විශේෂත්වයන් 👇

✅ උස 6ft සිට 10ft දක්වා සකස් කරගත හැකියි 📏
✅ FF500 Thousand Reel එකක් 🎣
✅ 100m Fishing Line එකක් 🧵
✅ Hook Box එකක් 🪝
✅ ඉපියෝ (Float) එකක් 🔴⚪

🔥 අඩු මිලට සුපිරි Fishing Setup එකක් ගන්න දැන්ම අපිට කතා කරන්න!', 6500.00, 'physical', '[]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/79934111-c796-493f-9c4a-a5b15ad05cfc.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/88715eb2-77fe-47b3-acec-3d0f20d6ff0a.jpg}', true, '2026-11-05 11:50:31.885493+00', '2026-11-05 11:55:01.950593+00', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 550, NULL),

('6c5761fc-ace2-4c47-b7b4-aba762cf5164', 'Spine Master rod full set ', 'one week offer 
delevery charge 450 or 550 
drag wigjt 10-18kg
🎣🔥 **SUPER FISHING SET – JUST Rs. 9,900/-** 🔥🎣

🎯 HZ 5000 Reel
🎣 Premium Fishing Rod
🧵 Quality Fishing Line
🪝 Hook Box
🐟 Lure
🎈 Float
🔗 Cable

💥 **Full Fishing Setup – Rs. 9,900/- Only!**
🔥 Beginners முதல் experienced anglers வரை அனைவருக்கும் perfect setup!

📦 ලංකාවේ ඕනෑම තැනකට Delivery පහසුකම් ඇත 🚚🇱🇰', 9999.00, 'physical', '[]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/3f2be486-d599-4b54-b999-2d2989c4ae3f.jpg}', true, '2026-11-04 14:00:20.859386+00', '2026-11-05 12:43:14.672848+00', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 0, NULL),

('ab88c202-2f4e-42ed-b659-5033bf6e3f76', '🎣🔥 **FISHINGRODS.COM – SPECIAL PRICE DROP!** 🔥🎣', '🎣🔥 **FISHINGRODS.COM – SPECIAL PRICE DROP!** 🔥🎣

🐟 ගඟේ, වැවේ මාළු අල්ලන ඔයාලට සුපිරි Fishing Setup එකක්! 💯😍

💥 **Rs. 6,800/- වෙනුවට දැන් Rs. 5,800/- පමණයි!** 🔥

🎣 **ASITIKA Telescopic Rod Set එකේ විශේෂත්වයන්** 👇

✅ උස 6ft සිට 10ft දක්වා සකස් කරගත හැකියි 📏
✅ FF500 Thousand Reel එකක් 🎣
✅ 100m Fishing Line එකක් 🧵
✅ Hook Box එකක් 🪝
✅ ඉපියෝ (Float) එකක් 🔴⚪

🔥 අඩු මිලට සුපිරි Fishing Setup එකක් ගන්න දැන්ම අපිට කතා කරන්න!', 5800.00, 'physical', '[]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/ea7fe14b-7294-49a3-b7f4-562fef4f8a81.jpg}', true, '2026-11-04 14:01:00.246938+00', '2026-11-05 12:57:04.807083+00', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 0, NULL),

('5ee2e125-f4d7-486b-bf92-dc46404e5e1d', ' 🎣🔥  Premiam Quality Telescope Rod', '
🎣🔥 අකුළන Telescope Rod දැන් රු. 3,000 සිට!

💯 හොඳම Quality එකට සුපිරි Rod එකක්
🎣 පහසුවෙන් අරගෙන යන්න පුළුවන්
🔥 ඔබට ගැළපෙන Rod එක අදම තෝරාගන්න!
', 3000.00, 'physical', '[{"name": "hight", "options": [{"label": "6feet - 8feet", "price": 3000}, {"label": "9feet - 12feet", "price": 3500}, {"label": "12feet - 15", "price": 4100}]}]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/373ec0e0-d539-49df-ac1b-6b3b23b0e649.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/a07d0696-a499-4344-9859-22eb93644db8.jpg}', true, '2026-11-04 14:01:33.742664+00', '2026-11-05 14:09:51.935351+00', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 550, 'https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/videos/a6a55905-1082-48ed-8dc3-368ab20ecd01.mp4'),

('65f90e40-0ae5-4e7c-a1a5-b7fafc59502e', 'Astika Fiber Treat Rod  Full set', 'delevery charge 550 or 650 
reccomnd wghit drag kg10
drag wighht 10-15
🎣🔥 සතියක විශේෂ දීමනාවක්! 🔥🎣

💥 FULL FISHING SET එකම දැන් රු. 8500/- පමණයි! 💥

🐟 මසුන් ඇල්ලීම ආරම්භ කරන්න බලාගෙන ඉන්න ඔයාලට සුපිරි අවස්ථාවක්!

✅ ASTIKA Fishing Rod 🎣
✅ Spinning Reel
✅ Fishing Line
✅ Floats & Lures
✅ Hooks & Accessories
✅ Fishing Bag

⏳ මෙම විශේෂ මිල සතියක් පමණයි! ඉක්මනින් ඔබේ SET එක වෙන්කරවා ගන්න.

🚚 දිවයින පුරා Cash on Delivery පහසුකම ඇත!', 8500.00, 'physical', '[]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/4fb31f9d-c9d1-4c85-9a8a-ed8ca1db0ead.jpg}', true, '2026-11-05 12:08:57.561452+00', '2026-11-05 12:08:57.561452+00', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 0, NULL),

('526a97a2-b786-4798-812d-3704c77caafb', 'one week offer astika fiber rod 7999', 'one week offer 
delevery charge 550 or 650 
reccomnd wghit drag kg10
drag wighht 10-15
🎣🔥 සතියක විශේෂ දීමනාවක්! 🔥🎣

💥 FULL FISHING SET එකම දැන් රු. 7999/- පමණයි! 💥

🐟 මසුන් ඇල්ලීම ආරම්භ කරන්න බලාගෙන ඉන්න ඔයාලට සුපිරි අවස්ථාවක්!

✅ ASTIKA Fishing Rod 🎣
✅ Spinning Reel
✅ Fishing Line
✅ Floats & Lures
✅ Hooks & Accessories
✅ Fishing Bag

⏳ මෙම විශේෂ මිල සතියක් පමණයි! ඉක්මනින් ඔබේ SET එක වෙන්කරවා ගන්න.

🚚 දිවයින පුරා Cash on Delivery පහසුකම ඇත!', 7999.00, 'physical', '[]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/130f4f2f-daa2-457a-9891-285e18daacd9.jpg}', true, '2026-11-05 12:11:53.826257+00', '2026-11-05 12:11:53.826257+00', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 550, NULL),

('9be9a87e-7a6d-4212-97ee-32197dde259a', 'carbon fiber rod full set', '🎣🔥 CARBON FIBER FISHING COMBO SET 🔥🐟

💪 කිලෝ 15ක් දක්වා මාළු අල්ලන්න පුළුවන් සුපිරි Setup එකක්! 😍🎣

✅ Carbon Fiber 8 Feet Rod
✅ AC 7000 Reel
✅ Line Pack
✅ Hooks Box 🪝
✅ Lure 🎯
✅ Cable
✅ Float
✅ Rod Cover 🎒

🐟 Beginner කෙනෙක්ටත් සුපිරි Fishing Combo එකක්! 🔥

📦 Islandwide Delivery Available 🚚', 8900.00, 'physical', '[]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/78ff6c8f-0721-47b3-8045-b4b75b2b2035.jpg}', true, '2026-11-05 12:14:22.722492+00', '2026-11-05 12:14:22.722492+00', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 550, NULL),

('b23f45b9-6fa8-42d7-bfe1-ccd98b11c959', 'bankok spin master rod full set ', '🎣🔥 මාසයක විශේෂ දීමනාවක්! 🔥🎣

💥 FULL FISHING SET එකම 10500/- පමණයි! 💥

🐟 මාළු අල්ලන්න ආස ඔයාලට සුපිරි අවස්ථාවක්! 😍

✅ Spin Master Rod 🎣
✅ AC 7000 Reel ⚙️
✅ 100M Fishing Line 🧵
✅ Hook Box Mix 🪝
✅ Soft Lure 🐠
✅ Frog Lure 🐸
✅ Cable & Float 🎯

⏳ මෙම විශේෂ මිල මාසයක් පමණයි! 🔥

💯 සියලුම අවශ්ය දේවල් එකම SET එකකින්!

🚚 දිවයින පුරා Delivery පහසුකම ඇත.
💵 Cash on Delivery පහසුකමත් ඇත!

📍 IBBAGAMUWA FISHING CENTER
📌 Dambulla Road, Thorayaya, Kurunegala

📲 අදම WhatsApp හරහා හෝ Inbox එකට Message කරලා ORDER කරන්න! 🎣🐟

🔥 ඔබේ ඊළඟ මසුන් ඇල්ලීමේ අත්දැකීම අදම ආරම්භ කරන්න! 🔥
ඔයා බලලා oder එක දාන්න ❤️', 10500.00, 'physical', '[]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/63d431b7-225f-41ab-8d29-728ed5d13ea9.jpg}', true, '2026-11-05 12:16:36.720239+00', '2026-11-05 12:16:36.720239+00', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 650, NULL),

('614fd021-3ac1-4951-bfd5-a8187f8e653f', 'glaxy diamond 8 frt rod offer mq reel +', 'delvery cgrge 450 or 550🎣🔥 FULL FISHING SET – SPECIAL OFFER! 🔥🎣 15-20 kg drag

💥 සුපිරි Fishing Set එකක් දැන් රු. 11,999/- පමණයි! 😍

🎣 Fishing Rod
⚙️ AC 7000 Reel
🧵 NIKEES Ultracast Braid (PE X8)
🐟 Quality Fishing Lure
🎯 Float, Hooks & Accessories ඇතුළු තවත් දේවල්!

✅ Strong & Durable Quality
✅ Beginners & Experienced Anglers දෙගොල්ලන්ටම සුපිරි Setup එකක්! 💯

🚚 Islandwide Delivery Available
💵 Cash on Delivery Available!

📍 FishingRods.com
Dambulla Road, Thorayaya, Kurunegala

🔥 අදම Order කරන්න! Stock සීමිතයි! 🎣❤️
බලලා oder එක දෙන්න oky 👌❤️', 11999.00, 'physical', '[]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/453ff6ad-32cc-48c8-8a53-61453fdefc7a.jpg}', true, '2026-11-05 12:19:19.981402+00', '2026-11-05 12:19:19.981402+00', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 0, NULL),

('09356662-35fe-4975-b02c-27e4857da7a3', 'glaxy diamond full set', 'delevery charge 450 or 550 
kg 18-20  kg drag
🎣🔥 මුහුදු මාළු අල්ලන්න සුපිරි Fishing Set එකක්! 🌊🐟

💥 මිල රු. 10,500/- පමණයි!

✅ Diamond Rod + AC 7000 Reel
✅ 100m Fishing Line
✅ Hooks Box + Lure
✅ Cable + Floats
✅ Rod Cover

🎁 සියල්ලම එකම පැකේජයකින්! 💯

📲 අදම Order කරන්න! 🔥
🚚 දිවයින පුරා Delivery පහසුකම් ඇත.', 10500.00, 'physical', '[]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/7966faa9-6c53-4dc8-820d-5a0f43f6b9cd.jpg}', true, '2026-11-05 12:23:42.482218+00', '2026-11-05 12:23:42.482218+00', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 0, NULL),

('74dc410f-3b94-4ead-a159-6ef87c21480b', 'glaxy dioamond full set 9 ft rod ', '9 feet rod 
delevery chgargr 450 or 550 
drage 20-26 kg 
මුහුදේ මාළු අල්ලන කට්ටියට 👌🎣🔥 DIAMOND ROD SET – සුපිරි Fishing Pack එකක්! 🔥🎣

💰 මිල රු. 13,500/- පමණයි!

✅ Diamond Rod
✅ MQ Reel
✅ 100m Fishing Line
✅ Hooks Box
✅ Lure
✅ Cable
✅ Floats
✅ Rod Cover

🎯 මසුන් අල්ලන්න කැමති ඔබටම ගැළපෙන සුපිරි Set එකක්! 🐟🔥

📲 අදම Order කරන්න!', 13500.00, 'physical', '[]', '{}', true, '2026-11-05 12:26:24.449646+00', '2026-11-05 12:26:24.449646+00', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 0, NULL),

('c1b87617-e6c6-448a-852b-9e4ef0c19d9f', 'astika treat rod full set 2 ', '650 or 750 delevery charge 
kg with drg 10-14
මුහුදේ මාළු අල්ලන කට්ටියට 👌🎣🔥 DIAMOND ROD SET – සුපිරි Fishing Pack එකක්! 🔥🎣

💰 මිල රු. 13,500/- පමණයි!

✅ Diamond Rod
✅ MQ Reel
✅ 100m Fishing Line
✅ Hooks Box
✅ Lure
✅ Cable
✅ Floats
✅ Rod Cover

🎯 මසුන් අල්ලන්න කැමති ඔබටම ගැළපෙන සුපිරි Set එකක්! 🐟🔥

📲 අදම Order කරන්න!', 15000.00, 'physical', '[]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/f8e4c0f0-de9f-480d-8d48-5e7a54aec28a.jpg}', true, '2026-11-05 12:28:29.145674+00', '2026-11-05 12:28:29.145674+00', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 650, NULL),

('301ec663-1e04-4ee9-b794-17aa09d9431b', '🎣🔥 SPIN MASTER FISHING ROD ONLYT– SPECIAL PRICE! 🔥🎣', '🎣🔥 SPIN MASTER FISHING ROD – SPECIAL PRICE! 🔥🎣

🎯 අඩුවටම හොඳම Fishing Rod එකක් හොයනවද?
ඔන්න දැන් Spin Master Rod අපෙන් සුපිරි මිලකට! 😍💙

📏 උස 6 – Rs. 3,500/-
📏 උස 7/8 – Rs. 3,900/-
📏 උස 9 – Rs. 4,800/-
📏 උස 10 – Rs. 5,500/-

💥 ලංකාවේ අඩුම මිලකට අපෙන්!
🚚 Islandwide Cash on Delivery Available 🇱🇰
🎣 ගෙදරටම ගෙන්වාගෙන Fishing පටන් ගන්න!', 3500.00, 'physical', '[{"name": "height", "options": [{"label": "6", "price": 3500}, {"label": "7/8", "price": 3900}, {"label": "9", "price": 4800}, {"label": "10", "price": 5500}]}]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/dc5e209b-82c6-4426-bd1e-9f842c351d41.jpg}', true, '2026-11-04 13:56:01.381045+00', '2026-11-05 12:52:22.856316+00', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 0, 'https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/videos/26efdf24-509e-45cc-878c-a8df7804eb94.mp4'),

('97eef358-ba63-4a82-a70e-df21c461a67a', 'kithul stick  full set ', 'delevery charge 450 or 550 
🎣🔥 **2KG – 5KG මාළු අල්ලන්න සුපිරි Fishing Setup එකක්!** 🐟💪

✅ කිතුල් Stick  
✅ තද නූල්  
✅ ඉපියෝ  
✅ කටු Box  
✅ Lures  

💥 සියල්ලම එකම පැකේජයකින්!

💰 **විශේෂ මිල රු. 3,500/- පමණයි!**

🎯 මාළු අල්ලන්න ආස අයටම සුපිරි අවස්ථාවක්!

📩 අදම Order කරන්න!', 3500.00, 'physical', '[{"name": "hight", "options": [{"label": "6-9 feet full set", "price": 3500}, {"label": "6-15 feet full set", "price": 3900}]}]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/e1c15e37-4b3d-4fb1-a094-b71ad24b5424.png,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/01c50ddc-3ff9-415b-a356-d302c35464b8.png}', true, '2026-11-05 13:40:09.550332+00', '2026-11-05 13:40:09.550332+00', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 0, NULL),

('f27fbf45-b0a0-44d2-a230-c3443ff7b100', 'kithul stik one week offer 2900', 'delevery charge 450 or 550
🎣🔥 **2KG – 5KG මාළු අල්ලන්න සුපිරි Fishing Setup එකක්!** 🐟💪

Snakehead Hunters ලාටම විශේෂයි! 😍

✅ කිතුල් Stick  
✅ තද නූල්  
✅ ඉපියෝ  
✅ කටු Box  
✅ Lures  

💥 සියල්ලම එකම පැකේජයකින්!

💰 **විශේෂ මිල රු. 3,500/- පමණයි!**

🎯 මාළු අල්ලන්න ආස අයටම සුපිරි අවස්ථාවක්!

📩 අදම Order කරන්න!', 2900.00, 'physical', '[{"name": "hight ", "options": [{"label": "6-9 feet ", "price": 2900}, {"label": "10-15 feet ", "price": 3500}]}]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/89f794d8-09f3-40a3-aff2-88a69d2fa201.png,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/a1bd2ccd-7dbb-4d46-a940-343886f0028d.jpg}', true, '2026-11-05 13:46:43.824598+00', '2026-11-05 13:46:43.824598+00', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 0, NULL),

('fdc4efba-4722-41d6-906f-116b803ab43f', '7500 pkg crocodile rod', 'delevery charge 450 or 550
🔥🎣 අඩුම මිලට සුපිරි Fishing Set එකක්! 😍

💥 **SPECIAL OFFER – Rs. 7,500/- ONLY!**

🎣 Crocodile Fiber Rod  
⚙️ HZ 5000 Reel  
🧵 100M Fishing Line  
🐟 Lure  
🪝 Hooks  
🔗 Cable  
🎈 Float  

💯 Fishing ආරම්භ කරන්න අවශ්ය සියල්ල එකම පැකේජයකින්!

🚚 Islandwide Delivery Available  
💵 Cash on Delivery Available  

🌐 fishingrods.com

🔥 අදම Order කරන්න! Stock Limited!', 7500.00, 'physical', '[{"name": "hight ", "options": [{"label": "6feet ", "price": 6500}, {"label": "7feet", "price": 7500}, {"label": "8feet", "price": 8500}]}]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/594db4c0-6df8-4af8-ae96-2a5a62ad0cec.jpg}', true, '2026-11-05 13:58:53.246191+00', '2026-11-05 13:58:53.246191+00', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 550, NULL),

('a0e3e8e0-2591-4154-831b-73c9abc29d6f', 'norma quality telescope rod', 'delevery charge eka 450 or 550 
🎣 අඩු මිලට සුපිරි Fishing Rod එකක්! 🔥

💪 2–5KG Drag Weight
🎯 Telescope Rod – Normal Quality
💰 මිල රු. 2,000 සිට පමණයි!

🚚 Islandwide Delivery
💵 Cash on Delivery පහසුකමත් ඇත.

📲 අදම Order කරන්න! ❤️🎣', 2000.00, 'physical', '[{"name": "highit ", "options": [{"label": "6feet", "price": 2000}, {"label": "7feet", "price": 2200}, {"label": "8feet ", "price": 2500}, {"label": "9feet ", "price": 2900}, {"label": "10feet", "price": 3200}, {"label": "12-14feet", "price": 3500}]}]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/72a0265c-5015-4bc1-9ce2-ae48a084cf37.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/ea2dfc01-ae9f-4988-9efb-4ecee57677c8.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/23d73162-b1a7-4f31-bd25-d7a9ddf5e886.jpg}', true, '2026-11-05 16:25:39.089385+00', '2026-11-05 16:36:27.943976+00', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 0, NULL),

('86909be9-0454-4c10-b00b-07cc0c96c438', 'spin master rod carbin fiber original ', 'delevery charge 450 or 550 
rag kg 15 -18 ok 
reccomend 12kg
🎣🔥 Spin Master Fishing Rod දැන් අපෙන්!

💪 ශක්තිමත් බවින් ඉහළයි | සැහැල්ලුයි | සුපිරි Quality එකක් ❤️

💰 මිල ගණන්:
- අඩි 6 – Rs. 3,500/-
- අඩි 7/8 – Rs. 3,900/-
- අඩි 9 – Rs. 4,800/-
- අඩි 10 – Rs. 5,500/-
🚚 දිවයින පුරා Cash On Delivery පහසුකම!

📲 අදම Order කරන්න!

FishingRods.com 🎣
Gear Up & Go Fish!', 3500.00, 'physical', '[{"name": "highit ", "options": [{"label": "6feet", "price": 3500}, {"label": "7feet", "price": 3900}, {"label": "8feet ", "price": 4500}, {"label": "9feet", "price": 5500}, {"label": "10feet", "price": 6500}]}]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/da891318-1dd2-414e-81d8-ce0c90bce375.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/0d27c71f-02df-473e-906f-bbff41fcb19a.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/3f45714a-1ef9-474c-b047-469963a4cc5f.jpg}', true, '2026-11-05 16:51:11.257648+00', '2026-11-05 16:57:19.664675+00', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 0, NULL),

('41d68af7-3ef4-455f-8bec-132aab718195', 'astika bransd two piece rod ', 'delevery charge 450 or 550 
🎣 ASTIKA Brand Fishing Rod දැන් අපෙන් රු. 3,500 සිට! 🔥

💪 7–10KG දක්වා බරක් දරාගත හැකියි.
🎯 ශක්තිමත් සහ සුපිරි Quality එකක්!

🚚 දිවයින පුරා Delivery පහසුකම් ඇත.

📩 අදම Order කරන්න!', 3500.00, 'physical', '[{"name": "highit ", "options": [{"label": "6feet ", "price": 2500}, {"label": "7feet", "price": 2900}, {"label": "8feet ", "price": 3900}, {"label": "9 -12feet", "price": 4500}]}]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/5e2964c9-d31f-45a5-a0b4-df94996b0fc6.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/6696da9b-3583-460c-b900-84c7b75ffe8d.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/caa3c941-23c3-4caf-9317-bd2a60d43372.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/4dfbf128-9bb3-4240-8a7e-44b4b13058c9.jpg}', true, '2026-11-05 16:41:00.859211+00', '2026-11-05 17:23:53.577995+00', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 0, NULL),

('ff82036f-cf4f-4a9f-a539-5404a680e409', 'Diamond Glaxy  Rod only', 'glaxy diamond rod 
delevery charge 450 or 550
carbon fiber rod
🎣 මුහුදටත්, ලොකු මාළුන්ටත් සුපිරිම Fishing Rod එකක්! 🔥🐟

💪 KG 15–20 දක්වා බරක් දරාගත හැකියි.\
📏 අඩි 6 සිට 12 දක්වා Sizes उपलब्धයි.\
💰 මිල රු. 4,500 සිට පමණයි!

❤️ ශක්තියත්, ගුණාත්මකභාවයත් එකම Rod එකකින්!

📲 අදම ORDER කරන්න!

FISHINGRODS.COM\
🎣 Gear Up & Go Fish! 🔥', 4500.00, 'physical', '[{"name": "highit", "options": [{"label": "6-7 feet ", "price": 3900}, {"label": "8feet", "price": 5100}, {"label": "9feet", "price": 6500}, {"label": "10feet", "price": 7500}]}]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/c3ad993c-61e2-4d6c-b37d-de13ffb36104.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/a6b5030a-0e80-4235-893a-8f9192c3eb75.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/d027dc85-48fa-410a-8424-d8e36c0f1a2e.jpg}', true, '2026-11-05 17:04:25.113166+00', '2026-11-05 17:14:54.443393+00', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 0, NULL),

('86a369df-675f-4e54-bd49-bb15089e69e7', 'frog lure', '🐸 මසුන් අල්ලන්න සුපිරි POPPER FROG LURE එකක්! 🔥🎣
💥 මිල රු. 650/- පමණයි
🐟 මාළු අල්ලන්න අලුත්ම Choice එකක්!
📦 අදම Order කරන්න', 650.00, 'physical', '[{"name": "color", "options": [{"label": "red & wighite", "price": 650}, {"label": "wite & red", "price": 650}, {"label": "green ", "price": 650}, {"label": "wighite  & red", "price": 650}, {"label": "yellow & black", "price": 650}, {"label": "blue & wite ", "price": 650}, {"label": "army camah ", "price": 650}]}]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/ebd6065b-a490-4b7d-ba88-8fe121e99cab.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/384184a3-f9ca-4646-9692-01631f2be9df.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/d0af5813-9044-40d7-87dc-20ed13301a81.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/80e28cf8-2f75-4caa-bdb3-adae3087104c.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/eb642324-2fd8-4a2a-930f-42ffc21e365a.jpg}', true, '2026-11-05 19:16:56.899527+00', '2026-11-05 19:16:56.899527+00', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 250, NULL),

('39520327-ac92-466e-9a88-4a3fba3dae33', 'Popper frog lure', '🐸 මසුන් අල්ලන්න සුපිරි POPPER FROG LURE එකක්! 🔥🎣
💥 මිල රු. 750/- පමණයි
🐟 මාළු අල්ලන්න අලුත්ම Choice එකක්!
📦 අදම Order කරන්න', 750.00, 'physical', '[{"name": "color", "options": [{"label": "green ", "price": 750, "subVariants": [{"name": "", "options": [{"label": "", "price": 0}], "required": false}]}, {"label": "orange", "price": 750}, {"label": "red and black", "price": 750}, {"label": "yellow", "price": 750}]}]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/04e6dcf3-7d7b-4b47-a9bc-e3acaf6d5997.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/43be9b2a-9be0-4f12-b929-c0a6b2f901d3.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/95e20215-0da3-49be-aa2f-a61a8a3f6800.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/aa1cb0ed-592a-4d6b-a314-7457009c78ce.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/33890fba-2935-4d92-a37b-4daafb5dbef4.jpg}', true, '2026-11-05 19:10:58.591553+00', '2026-11-05 19:18:02.174855+00', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 250, NULL),

('17e685bb-04ae-4da4-a8dd-7ff0968ccb23', 'lure redium/luminess', '🎣 මාළු අල්ලන්න  Luminess /redium සුපිරි LURE එකක්! 🔥
💥 40 Gram Weight
💰 මිල රු. 1,200/- පමණයි!
🐟 මසුන් ඇල්ලීමේ අත්දැකීම තවත් සුපිරි කරගන්න අදම ඇණවුම් කරන්න.
📩 Order කරන්න දැන්ම Inbox කරන්න!', 1200.00, 'physical', '[{"name": "color ", "options": [{"label": "wite color redium", "price": 1200}, {"label": "red & silver", "price": 1200}]}]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/3664c6ae-9aad-4b5c-af9d-dfef4fae3967.jpg}', true, '2026-11-05 19:32:35.576168+00', '2026-11-05 19:32:35.576168+00', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 250, NULL),

('a2ca6805-c830-4572-ac75-6ab5fd7ea4e1', 'poppor lure', '🎣 මාළු අල්ලන වැඩේ තවත් සුපිරි කරගන්න! 🔥
🐟 Premium Popper Lure
💥 40g & 60g බරින් ලබාගත හැකියි.
🎯 මාළුන්ගේ අවධානය ඉක්මනින් දිනාගන්න සුපිරි Lure එකක්!
💰 මිල රු. 1,500/- පමණයි.
📦 අදම Order කරන්න!', 1500.00, 'physical', '[{"name": "color", "options": [{"label": "red & silver", "price": 1500}, {"label": "green & yellow ", "price": 1500}, {"label": "rose & silver", "price": 1500}]}]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/cb8ea7c9-5630-44c1-bf6e-bdf4f40a2f02.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/5838a9bc-a2a8-4f1a-94f5-bc158b3b0d6b.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/75466fa9-f47d-48c0-ac4a-621bba680fed.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/527526d1-27be-48b3-bd28-a4f8a697eb12.jpg}', true, '2026-11-05 19:45:40.115485+00', '2026-11-05 19:46:54.442039+00', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 350, NULL),

('20e39e23-8370-4087-8080-3f19e79b174f', 'lures', '🎣🔥 සුපිරි Fishing Lures Collection එකම එක තැනකින්! 🐟❤️

Minnow, Popper, Frog ඇතුළු විවිධ වර්ගයේ Lures දැන් අපෙන් ලබාගන්න පුළුවන්. 😍

💥 උසස් තත්ත්වයේ Lures
🎯 මසුන් ආකර්ෂණය කරන සුපිරි Designs
💰 සාධාරණ මිල ගණන් යටතේ

📩 ඔබට අවශ්ය Lure එක අදම Order කරන්න!', 1500.00, 'physical', '[]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/e8e05c6b-4d9e-4f16-857b-f37b0a8db1bc.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/af8d91db-6cdd-48bb-955e-80345db7443f.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/f43d55b4-581d-4959-a4cd-ec10a4ee9f74.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/a706e37c-8d07-497b-a675-6197953e07e6.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/6aa9943e-0aa5-4e4d-8787-81615aff340d.jpg}', true, '2026-11-05 20:02:28.062748+00', '2026-11-05 20:02:28.062748+00', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 350, NULL),

('6f241c2a-15f8-4dab-a047-c77fc299d87b', 'poppor frog lure', NULL, 750.00, 'physical', '[]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/4dc6646b-f3e9-4d6e-a015-8f80eaa02803.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/57c45211-a5a6-415f-a5a9-77572304f59d.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/b35ea2dd-5457-43df-aece-7eb45849d161.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/15968334-e22e-4ed7-8911-a1f46b5897e0.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/b2f5eaae-8916-4e88-868b-9c3621df70be.jpg}', true, '2026-11-06 05:14:21.626662+00', '2026-11-06 05:14:21.626662+00', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 250, NULL),

('78bd997e-fcca-44da-af2f-656769185f66', 'Fishing cable ', '🎣 FISHING WIRE LEADER – STRONG & DURABLE! 🔥

Get ready for big catches with our high-quality Fishing Wire Leaders! 🐟

💪 Available in 3 Strength Options:

🔹 40LB – Rs. 200/-
🔹 70LB – Rs. 250/-
🔹 90LB – Rs. 300/-

✅ High Strength
✅ Durable & Long Lasting
✅ Anti-Rust Material
✅ Smooth Swivel & Snap
✅ Easy to Connect

📍 FishingRods.com

📲 Order yours today!', 300.00, 'physical', '[]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/01cdf840-067c-43c1-8533-3c6c34b205f3.png,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/0769703a-75ab-4e8c-92b1-f90bd7299691.png}', true, '2026-11-07 13:43:08.540695+00', '2026-11-07 13:44:23.670687+00', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 150, NULL),

('f20adf71-92c7-4267-bb68-7c1fcbb53a6c', 'FLOAT', 'FLOAT VENAMA GANNA THIYANAWA', 150.00, 'physical', '[]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/65d4ac30-882e-43d1-80af-34c07a97011b.png}', true, '2026-11-09 09:57:52.834858+00', '2026-11-09 09:57:52.834858+00', '8ec761ff-b716-411b-85d2-1b56980d1e8a', 0, NULL);

-- 3. Insert FAQs
INSERT INTO fishing.faqs (id, question, answer, product_id, is_active, created_at, updated_at, user_id, is_tracked, media_urls) VALUES 
('9c8c239b-b8de-4c1c-8a33-21e8ffed7708', 'Do you provide delivery across Sri Lanka?', 'Yes, we offer secure All-Island Delivery to any town or district across Sri Lanka!', NULL, true, '2026-11-04 14:03:34.560797+00', '2026-11-04 14:03:34.560797+00', '8ec761ff-b716-411b-85d2-1b56980d1e8a', false, '{}'),
('1f277596-4113-4c46-8037-61eb16d4e6e5', 'What are the available rod heights and sizes?', 'Our fishing rods typically come in 6ft, 7ft, and 8ft extended lengths. They feature compact telescopic / 2-piece foldable designs (collapsed length ~42cm) making them very easy to carry on a bike or in a backpack.', NULL, true, '2026-11-04 14:03:51.963354+00', '2026-11-04 14:03:51.963354+00', '8ec761ff-b716-411b-85d2-1b56980d1e8a', false, '{}'),
('4fa3eada-871c-4619-b56c-e3729c74fe61', 'Can I pay using Cash on Delivery (COD)?', 'Yes! We support Cash on Delivery (COD) so you can pay once the package reaches your doorstep, as well as Bank Transfer.', NULL, true, '2026-11-04 14:04:05.174797+00', '2026-11-04 14:04:05.174797+00', '8ec761ff-b716-411b-85d2-1b56980d1e8a', false, '{}'),
('5565d23f-b97e-4065-adb8-1f771d558b62', 'How long does delivery take?', 'Orders are dispatched promptly and typically delivered within 2 to 4 working days to any location in Sri Lanka.', NULL, true, '2026-11-04 14:04:18.729406+00', '2026-11-04 14:04:18.729406+00', '8ec761ff-b716-411b-85d2-1b56980d1e8a', false, '{}'),
('c51b215a-91a1-4f7e-bd60-4ac4ffcb6ed9', 'What other fishing equipment do you have? Do you sell cast nets (Wisi Del)?', 'We specialize in complete fishing packages (combo kits), rods, spinning/baitcasting reels, braided/monofilament lines, lures, frogs, and hooks. Please contact us directly regarding cast net (wisi del) availability.', NULL, true, '2026-11-04 14:04:45.927914+00', '2026-11-04 14:04:45.927914+00', '8ec761ff-b716-411b-85d2-1b56980d1e8a', false, '{}');

-- 4. Duplicate into ibbagamuwa_customization for PostgREST & AI compatibility
INSERT INTO ibbagamuwa_customization.products 
SELECT * FROM fishing.products;

INSERT INTO ibbagamuwa_customization.faqs 
SELECT * FROM fishing.faqs;

COMMIT;

