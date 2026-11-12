BEGIN;

-- 1. Upgrade user 5543a79b-21f1-4091-905b-025d39acd0c8 to Growth plan ('enterprise' tier)
-- In public schema
UPDATE public.profiles
SET plan_tier = 'enterprise',
    max_products = 999,
    max_faqs = 999,
    updated_at = now()
WHERE user_id = '5543a79b-21f1-4091-905b-025d39acd0c8';

-- In fishing schema: insert or update profile
INSERT INTO fishing.profiles (
  id,
  user_id,
  full_name,
  email,
  business_name,
  plan_tier,
  max_products,
  max_faqs,
  is_active,
  is_paused,
  addon_products,
  addon_faqs,
  addon_orders,
  addon_ai_messages,
  addon_images,
  addon_staff,
  addon_contacts,
  created_at,
  updated_at
) VALUES (
  'd772e03a-30dc-4835-999f-69f8d22e35c0',
  '5543a79b-21f1-4091-905b-025d39acd0c8',
  'Astika Cloud',
  'cloud-5543a79b@buildstart.io',
  'FishingRods.Com',
  'enterprise',
  999,
  999,
  true,
  false,
  0, 0, 0, 0, 0, 0, 0,
  now(),
  now()
) ON CONFLICT (user_id) DO UPDATE SET
  plan_tier = 'enterprise',
  max_products = 999,
  max_faqs = 999,
  is_active = true,
  is_paused = false,
  updated_at = now();

-- Ensure user role in fishing schema
INSERT INTO fishing.user_roles (id, user_id, role, created_at)
VALUES (
  'ca7b0c6c-bfcf-445e-8d0f-697766c4f5a7',
  '5543a79b-21f1-4091-905b-025d39acd0c8',
  'business_user',
  now()
) ON CONFLICT DO NOTHING;

-- Ensure settings for 5543a79b-21f1-4091-905b-025d39acd0c8 in fishing schema
INSERT INTO fishing.settings (key, value, user_id)
VALUES 
  ('business_name', '"FishingRods.Com"'::jsonb, '5543a79b-21f1-4091-905b-025d39acd0c8'),
  ('welcome_message', '{"text": "Welcome! How can I help you today?"}'::jsonb, '5543a79b-21f1-4091-905b-025d39acd0c8'),
  ('payment_info', '{"bank_name": "", "account_name": "", "account_number": ""}'::jsonb, '5543a79b-21f1-4091-905b-025d39acd0c8'),
  ('auto_responses', '{"enabled": true}'::jsonb, '5543a79b-21f1-4091-905b-025d39acd0c8'),
  ('delivery_settings', '{"description": "අයිතම 5ක් හෝ ඊට වැඩි නම් නොමිලේ (Free Delivery 🚚). 5ට අඩු නම් Delivery ගාස්තුව රු. 450යි.", "delivery_fee": 450, "free_delivery_item_threshold": 5}'::jsonb, '5543a79b-21f1-4091-905b-025d39acd0c8')
ON CONFLICT DO NOTHING;

-- Grant staff access so qwe@buildstart.io (8ec761ff-b716-411b-85d2-1b56980d1e8a) can view/manage in dashboard
INSERT INTO fishing.staff_accounts (owner_id, staff_user_id, staff_email, staff_name, permissions, is_active)
VALUES (
  '5543a79b-21f1-4091-905b-025d39acd0c8',
  '8ec761ff-b716-411b-85d2-1b56980d1e8a',
  'qwe@buildstart.io',
  'Admin Staff',
  ARRAY['products', 'faqs', 'orders', 'conversations', 'leads', 'settings'],
  true
) ON CONFLICT (owner_id, staff_user_id) DO UPDATE SET
  permissions = ARRAY['products', 'faqs', 'orders', 'conversations', 'leads', 'settings'],
  is_active = true;

-- Also update ibbagamuwa_customization.profiles if present
UPDATE ibbagamuwa_customization.profiles
SET plan_tier = 'enterprise',
    max_products = 999,
    max_faqs = 999,
    updated_at = now()
WHERE user_id = '5543a79b-21f1-4091-905b-025d39acd0c8';

-- 2. Insert Products into fishing.products
INSERT INTO fishing.products (id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url) VALUES 
('755087e0-bdca-4053-b7c9-5eb9b33dbed2', 
 'Fishing Rod Full Set', 
 'Complete fishing combo set ready to fish. Includes Fishing Rod, AC4000 Reel, Fishing Line, Lure, Float, Hooks & Accessories. Suitable for beginners and experienced anglers in freshwater and general fishing. Strong and durable quality.', 
 6800.00, 'physical', '[]', '{}', true, '2026-11-04 13:57:01.40951+00', '2026-11-04 13:57:01.40951+00', '5543a79b-21f1-4091-905b-025d39acd0c8', 0, NULL) 
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  price = EXCLUDED.price,
  product_type = EXCLUDED.product_type,
  variations = EXCLUDED.variations,
  images = EXCLUDED.images,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  delivery_price = EXCLUDED.delivery_price,
  video_url = EXCLUDED.video_url;

INSERT INTO fishing.products (id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url) VALUES 
('cbcf1f9c-84db-4e3c-b850-86aa8858e3a1', 
 'Diamond Fishing Rod Full Set', 
 'Heavy duty 8m Diamond Fishing Rod full set. Includes MQ6000 Reel, 100m Fishing Line, Hook Box, Float, Cable, and Japan Hook Lure.', 
 13500.00, 'physical', '[]', '{}', true, '2026-11-04 13:59:42.168783+00', '2026-11-04 13:59:42.168783+00', '5543a79b-21f1-4091-905b-025d39acd0c8', 0, NULL) 
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  price = EXCLUDED.price,
  product_type = EXCLUDED.product_type,
  variations = EXCLUDED.variations,
  images = EXCLUDED.images,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  delivery_price = EXCLUDED.delivery_price,
  video_url = EXCLUDED.video_url;

INSERT INTO fishing.products (id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url) VALUES 
('5a8a00bd-2c88-4ee6-9148-faa748d806a5', 
 'Astika Fishing Rod Full Set', 
 'Complete Astika fishing setup. Includes Fishing Rod, AC4000 Reel, Fishing Line, Lures, Float, Hooks, and accessories. Suitable for freshwater fishing.', 
 6800.00, 'physical', '[]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/e1f6efdc-f378-47e9-9470-a084986810f7.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/1349428c-4523-4ebe-8ec4-a3b15ff23dc4.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/02c4045e-6648-40ce-8cd5-b58e9fd4e33d.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/7aec978c-a87a-4b49-9fd6-77be4fe97816.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/98343579-8a45-49a0-aac8-0cd8a09180c4.jpg}', true, '2026-11-05 07:21:35.667405+00', '2026-11-05 07:21:35.667405+00', '5543a79b-21f1-4091-905b-025d39acd0c8', 550, NULL) 
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  price = EXCLUDED.price,
  product_type = EXCLUDED.product_type,
  variations = EXCLUDED.variations,
  images = EXCLUDED.images,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  delivery_price = EXCLUDED.delivery_price,
  video_url = EXCLUDED.video_url;

INSERT INTO fishing.products (id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url) VALUES 
('b783b887-4284-4e8a-a891-a81b17f4e715', 
 'Astika Telescopic Rod Set', 
 'Adjustable telescopic rod (6ft to 10ft) with 2kg to 5kg drag capacity. Ideal for rivers and lakes. Includes FF500 Reel, 100m Fishing Line, Hook Box, and Float.', 
 6500.00, 'physical', '[]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/79934111-c796-493f-9c4a-a5b15ad05cfc.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/88715eb2-77fe-47b3-acec-3d0f20d6ff0a.jpg}', true, '2026-11-05 11:50:31.885493+00', '2026-11-05 11:55:01.950593+00', '5543a79b-21f1-4091-905b-025d39acd0c8', 550, NULL) 
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  price = EXCLUDED.price,
  product_type = EXCLUDED.product_type,
  variations = EXCLUDED.variations,
  images = EXCLUDED.images,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  delivery_price = EXCLUDED.delivery_price,
  video_url = EXCLUDED.video_url;

INSERT INTO fishing.products (id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url) VALUES 
('6c5761fc-ace2-4c47-b7b4-aba762cf5164', 
 'Spin Master Fishing Rod Full Set', 
 'Heavy duty fishing setup with 10kg to 18kg drag capacity. Includes Premium Fishing Rod, HZ 5000 Reel, Fishing Line, Hook Box, Lure, Float, and Cable. Great for both beginners and experienced anglers.', 
 9900.00, 'physical', '[]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/3f2be486-d599-4b54-b999-2d2989c4ae3f.jpg}', true, '2026-11-04 14:00:20.859386+00', '2026-11-05 12:43:14.672848+00', '5543a79b-21f1-4091-905b-025d39acd0c8', 0, NULL) 
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  price = EXCLUDED.price,
  product_type = EXCLUDED.product_type,
  variations = EXCLUDED.variations,
  images = EXCLUDED.images,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  delivery_price = EXCLUDED.delivery_price,
  video_url = EXCLUDED.video_url;

INSERT INTO fishing.products (id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url) VALUES 
('ab88c202-2f4e-42ed-b659-5033bf6e3f76', 
 'Astika Telescopic Rod Set (Standard)', 
 'Portable telescopic rod adjustable from 6ft to 10ft. Suitable for river and reservoir fishing. Package includes FF500 Reel, 100m Fishing Line, Hook Box, and Float.', 
 5800.00, 'physical', '[]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/ea7fe14b-7294-49a3-b7f4-562fef4f8a81.jpg}', true, '2026-11-04 14:01:00.246938+00', '2026-11-05 12:57:04.807083+00', '5543a79b-21f1-4091-905b-025d39acd0c8', 0, NULL) 
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  price = EXCLUDED.price,
  product_type = EXCLUDED.product_type,
  variations = EXCLUDED.variations,
  images = EXCLUDED.images,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  delivery_price = EXCLUDED.delivery_price,
  video_url = EXCLUDED.video_url;

INSERT INTO fishing.products (id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url) VALUES 
('5ee2e125-f4d7-486b-bf92-dc46404e5e1d', 
 'Premium Quality Telescopic Rod', 
 'High-quality foldable telescopic fishing rod. Lightweight, easy to transport and compact. Price varies by length. Rod only.', 
 3000.00, 'physical', '[{"name": "height", "options": [{"label": "6ft - 8ft", "price": 3000}, {"label": "9ft - 12ft", "price": 3500}, {"label": "12ft - 15ft", "price": 4100}]}]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/373ec0e0-d539-49df-ac1b-6b3b23b0e649.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/a07d0696-a499-4344-9859-22eb93644db8.jpg}', true, '2026-11-04 14:01:33.742664+00', '2026-11-05 14:09:51.935351+00', '5543a79b-21f1-4091-905b-025d39acd0c8', 550, 'https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/videos/a6a55905-1082-48ed-8dc3-368ab20ecd01.mp4') 
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  price = EXCLUDED.price,
  product_type = EXCLUDED.product_type,
  variations = EXCLUDED.variations,
  images = EXCLUDED.images,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  delivery_price = EXCLUDED.delivery_price,
  video_url = EXCLUDED.video_url;

INSERT INTO fishing.products (id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url) VALUES 
('65f90e40-0ae5-4e7c-a1a5-b7fafc59502e', 
 'Astika Fiber Thread Rod Full Set', 
 'Strong Astika fiber rod combo set with 10kg to 15kg drag capacity. Package includes Astika Fishing Rod, Spinning Reel, Fishing Line, Floats, Lures, Hooks, Accessories, and Fishing Bag.', 
 8500.00, 'physical', '[]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/4fb31f9d-c9d1-4c85-9a8a-ed8ca1db0ead.jpg}', true, '2026-11-05 12:08:57.561452+00', '2026-11-05 12:08:57.561452+00', '5543a79b-21f1-4091-905b-025d39acd0c8', 0, NULL) 
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  price = EXCLUDED.price,
  product_type = EXCLUDED.product_type,
  variations = EXCLUDED.variations,
  images = EXCLUDED.images,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  delivery_price = EXCLUDED.delivery_price,
  video_url = EXCLUDED.video_url;

INSERT INTO fishing.products (id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url) VALUES 
('526a97a2-b786-4798-812d-3704c77caafb', 
 'Astika Fiber Rod Full Set (Offer)', 
 'Special edition Astika fiber fishing setup with 10kg to 15kg drag capacity. Package includes Astika Fishing Rod, Spinning Reel, Fishing Line, Floats, Lures, Hooks, Accessories, and Fishing Bag.', 
 7999.00, 'physical', '[]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/130f4f2f-daa2-457a-9891-285e18daacd9.jpg}', true, '2026-11-05 12:11:53.826257+00', '2026-11-05 12:11:53.826257+00', '5543a79b-21f1-4091-905b-025d39acd0c8', 550, NULL) 
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  price = EXCLUDED.price,
  product_type = EXCLUDED.product_type,
  variations = EXCLUDED.variations,
  images = EXCLUDED.images,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  delivery_price = EXCLUDED.delivery_price,
  video_url = EXCLUDED.video_url;

INSERT INTO fishing.products (id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url) VALUES 
('9be9a87e-7a6d-4212-97ee-32197dde259a', 
 'Carbon Fiber Fishing Rod Full Set', 
 'Durable 8ft carbon fiber combo with up to 15kg drag capacity. Includes 8ft Carbon Fiber Rod, AC 7000 Reel, Line Pack, Hook Box, Lure, Cable, Float, and Rod Cover.', 
 8900.00, 'physical', '[]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/78ff6c8f-0721-47b3-8045-b4b75b2b2035.jpg}', true, '2026-11-05 12:14:22.722492+00', '2026-11-05 12:14:22.722492+00', '5543a79b-21f1-4091-905b-025d39acd0c8', 550, NULL) 
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  price = EXCLUDED.price,
  product_type = EXCLUDED.product_type,
  variations = EXCLUDED.variations,
  images = EXCLUDED.images,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  delivery_price = EXCLUDED.delivery_price,
  video_url = EXCLUDED.video_url;

INSERT INTO fishing.products (id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url) VALUES 
('b23f45b9-6fa8-42d7-bfe1-ccd98b11c959', 
 'Bangkok Spin Master Rod Full Set', 
 'Complete Spin Master fishing setup. Includes Bangkok Spin Master Rod, AC 7000 Reel, 100m Fishing Line, Hook Box Mix, Soft Lure, Frog Lure, Cable, and Float.', 
 10500.00, 'physical', '[]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/63d431b7-225f-41ab-8d29-728ed5d13ea9.jpg}', true, '2026-11-05 12:16:36.720239+00', '2026-11-05 12:16:36.720239+00', '5543a79b-21f1-4091-905b-025d39acd0c8', 650, NULL) 
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  price = EXCLUDED.price,
  product_type = EXCLUDED.product_type,
  variations = EXCLUDED.variations,
  images = EXCLUDED.images,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  delivery_price = EXCLUDED.delivery_price,
  video_url = EXCLUDED.video_url;

INSERT INTO fishing.products (id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url) VALUES 
('614fd021-3ac1-4951-bfd5-a8187f8e653f', 
 'Galaxy Diamond 8ft Rod Full Set', 
 'Heavy duty setup with 15kg to 20kg drag capacity. Package includes 8ft Diamond Fishing Rod, AC 7000 Reel, NIKEES Ultracast PE X8 Braid Line, Quality Fishing Lure, Float, Hooks, and Accessories.', 
 11999.00, 'physical', '[]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/453ff6ad-32cc-48c8-8a53-61453fdefc7a.jpg}', true, '2026-11-05 12:19:19.981402+00', '2026-11-05 12:19:19.981402+00', '5543a79b-21f1-4091-905b-025d39acd0c8', 0, NULL) 
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  price = EXCLUDED.price,
  product_type = EXCLUDED.product_type,
  variations = EXCLUDED.variations,
  images = EXCLUDED.images,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  delivery_price = EXCLUDED.delivery_price,
  video_url = EXCLUDED.video_url;

INSERT INTO fishing.products (id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url) VALUES 
('09356662-35fe-4975-b02c-27e4857da7a3', 
 'Galaxy Diamond Rod Full Set (Sea Fishing)', 
 'Designed for sea and saltwater fishing with 18kg to 20kg drag capacity. Includes Diamond Rod, AC 7000 Reel, 100m Fishing Line, Hook Box, Lure, Cable, Floats, and Rod Cover.', 
 10500.00, 'physical', '[]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/7966faa9-6c53-4dc8-820d-5a0f43f6b9cd.jpg}', true, '2026-11-05 12:23:42.482218+00', '2026-11-05 12:23:42.482218+00', '5543a79b-21f1-4091-905b-025d39acd0c8', 0, NULL) 
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  price = EXCLUDED.price,
  product_type = EXCLUDED.product_type,
  variations = EXCLUDED.variations,
  images = EXCLUDED.images,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  delivery_price = EXCLUDED.delivery_price,
  video_url = EXCLUDED.video_url;

INSERT INTO fishing.products (id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url) VALUES 
('74dc410f-3b94-4ead-a159-6ef87c21480b', 
 'Galaxy Diamond 9ft Rod Full Set', 
 '9ft heavy-duty setup with 20kg to 26kg drag capacity for sea and large predator fishing. Includes 9ft Diamond Rod, MQ Reel, 100m Fishing Line, Hook Box, Lure, Cable, Floats, and Rod Cover.', 
 13500.00, 'physical', '[]', '{}', true, '2026-11-05 12:26:24.449646+00', '2026-11-05 12:26:24.449646+00', '5543a79b-21f1-4091-905b-025d39acd0c8', 0, NULL) 
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  price = EXCLUDED.price,
  product_type = EXCLUDED.product_type,
  variations = EXCLUDED.variations,
  images = EXCLUDED.images,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  delivery_price = EXCLUDED.delivery_price,
  video_url = EXCLUDED.video_url;

INSERT INTO fishing.products (id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url) VALUES 
('c1b87617-e6c6-448a-852b-9e4ef0c19d9f', 
 'Astika Thread Rod Full Set 2', 
 'Heavy duty Astika rod combo with 10kg to 14kg drag capacity for sea and general fishing. Includes Astika Thread Rod, MQ Reel, 100m Fishing Line, Hook Box, Lure, Cable, Floats, and Rod Cover.', 
 15000.00, 'physical', '[]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/f8e4c0f0-de9f-480d-8d48-5e7a54aec28a.jpg}', true, '2026-11-05 12:28:29.145674+00', '2026-11-05 12:28:29.145674+00', '5543a79b-21f1-4091-905b-025d39acd0c8', 650, NULL) 
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  price = EXCLUDED.price,
  product_type = EXCLUDED.product_type,
  variations = EXCLUDED.variations,
  images = EXCLUDED.images,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  delivery_price = EXCLUDED.delivery_price,
  video_url = EXCLUDED.video_url;

INSERT INTO fishing.products (id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url) VALUES 
('301ec663-1e04-4ee9-b794-17aa09d9431b', 
 'Spin Master Fishing Rod (Rod Only)', 
 'Original Spin Master fishing rod available in multiple lengths. Lightweight and strong. Price varies by height.', 
 3500.00, 'physical', '[{"name": "height", "options": [{"label": "6ft", "price": 3500}, {"label": "7/8ft", "price": 3900}, {"label": "9ft", "price": 4800}, {"label": "10ft", "price": 5500}]}]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/dc5e209b-82c6-4426-bd1e-9f842c351d41.jpg}', true, '2026-11-04 13:56:01.381045+00', '2026-11-05 12:52:22.856316+00', '5543a79b-21f1-4091-905b-025d39acd0c8', 0, 'https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/videos/26efdf24-509e-45cc-878c-a8df7804eb94.mp4') 
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  price = EXCLUDED.price,
  product_type = EXCLUDED.product_type,
  variations = EXCLUDED.variations,
  images = EXCLUDED.images,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  delivery_price = EXCLUDED.delivery_price,
  video_url = EXCLUDED.video_url;

INSERT INTO fishing.products (id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url) VALUES 
('97eef358-ba63-4a82-a70e-df21c461a67a', 
 'Kithul Stick Fishing Full Set', 
 'Traditional Sri Lankan Kithul stick fishing kit with 2kg to 5kg holding capacity. Set includes Kithul Stick, strong fishing line, float, hook box, and lures.', 
 3500.00, 'physical', '[{"name": "height", "options": [{"label": "6ft - 9ft full set", "price": 3500}, {"label": "10ft - 15ft full set", "price": 3900}]}]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/e1c15e37-4b3d-4fb1-a094-b71ad24b5424.png,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/01c50ddc-3ff9-415b-a356-d302c35464b8.png}', true, '2026-11-05 13:40:09.550332+00', '2026-11-05 13:40:09.550332+00', '5543a79b-21f1-4091-905b-025d39acd0c8', 0, NULL) 
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  price = EXCLUDED.price,
  product_type = EXCLUDED.product_type,
  variations = EXCLUDED.variations,
  images = EXCLUDED.images,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  delivery_price = EXCLUDED.delivery_price,
  video_url = EXCLUDED.video_url;

INSERT INTO fishing.products (id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url) VALUES 
('f27fbf45-b0a0-44d2-a230-c3443ff7b100', 
 'Kithul Stick Fishing Set (Offer)', 
 'Traditional Kithul stick setup for snakehead (lula) and freshwater fishing (2kg - 5kg capacity). Includes Kithul Stick, strong line, float, hook box, and lures.', 
 2900.00, 'physical', '[{"name": "height", "options": [{"label": "6ft - 9ft", "price": 2900}, {"label": "10ft - 15ft", "price": 3500}]}]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/89f794d8-09f3-40a3-aff2-88a69d2fa201.png,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/a1bd2ccd-7dbb-4d46-a940-343886f0028d.jpg}', true, '2026-11-05 13:46:43.824598+00', '2026-11-05 13:46:43.824598+00', '5543a79b-21f1-4091-905b-025d39acd0c8', 0, NULL) 
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  price = EXCLUDED.price,
  product_type = EXCLUDED.product_type,
  variations = EXCLUDED.variations,
  images = EXCLUDED.images,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  delivery_price = EXCLUDED.delivery_price,
  video_url = EXCLUDED.video_url;

INSERT INTO fishing.products (id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url) VALUES 
('fdc4efba-4722-41d6-906f-116b803ab43f', 
 'Crocodile Fiber Rod Full Set', 
 'Complete beginner fishing kit. Includes Crocodile Fiber Rod, HZ 5000 Reel, 100m Fishing Line, Lure, Hooks, Cable, and Float. Available in multiple rod lengths.', 
 7500.00, 'physical', '[{"name": "height", "options": [{"label": "6ft", "price": 6500}, {"label": "7ft", "price": 7500}, {"label": "8ft", "price": 8500}]}]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/594db4c0-6df8-4af8-ae96-2a5a62ad0cec.jpg}', true, '2026-11-05 13:58:53.246191+00', '2026-11-05 13:58:53.246191+00', '5543a79b-21f1-4091-905b-025d39acd0c8', 550, NULL) 
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  price = EXCLUDED.price,
  product_type = EXCLUDED.product_type,
  variations = EXCLUDED.variations,
  images = EXCLUDED.images,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  delivery_price = EXCLUDED.delivery_price,
  video_url = EXCLUDED.video_url;

INSERT INTO fishing.products (id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url) VALUES 
('a0e3e8e0-2591-4154-831b-73c9abc29d6f', 
 'Standard Telescopic Fishing Rod', 
 'Affordable telescopic fishing rod with 2kg to 5kg drag capacity. Easy to fold and carry. Rod only.', 
 2000.00, 'physical', '[{"name": "height", "options": [{"label": "6ft", "price": 2000}, {"label": "7ft", "price": 2200}, {"label": "8ft", "price": 2500}, {"label": "9ft", "price": 2900}, {"label": "10ft", "price": 3200}, {"label": "12ft - 14ft", "price": 3500}]}]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/72a0265c-5015-4bc1-9ce2-ae48a084cf37.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/ea2dfc01-ae9f-4988-9efb-4ecee57677c8.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/23d73162-b1a7-4f31-bd25-d7a9ddf5e886.jpg}', true, '2026-11-05 16:25:39.089385+00', '2026-11-05 16:36:27.943976+00', '5543a79b-21f1-4091-905b-025d39acd0c8', 0, NULL) 
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  price = EXCLUDED.price,
  product_type = EXCLUDED.product_type,
  variations = EXCLUDED.variations,
  images = EXCLUDED.images,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  delivery_price = EXCLUDED.delivery_price,
  video_url = EXCLUDED.video_url;

INSERT INTO fishing.products (id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url) VALUES 
('86909be9-0454-4c10-b00b-07cc0c96c438', 
 'Spin Master Carbon Fiber Rod (Original)', 
 'Original carbon fiber Spin Master rod. Strong, lightweight, with 12kg to 15kg drag capacity. Rod only.', 
 3500.00, 'physical', '[{"name": "height", "options": [{"label": "6ft", "price": 3500}, {"label": "7ft", "price": 3900}, {"label": "8ft", "price": 4500}, {"label": "9ft", "price": 5500}, {"label": "10ft", "price": 6500}]}]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/da891318-1dd2-414e-81d8-ce0c90bce375.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/0d27c71f-02df-473e-906f-bbff41fcb19a.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/3f45714a-1ef9-474c-b047-469963a4cc5f.jpg}', true, '2026-11-05 16:51:11.257648+00', '2026-11-05 16:57:19.664675+00', '5543a79b-21f1-4091-905b-025d39acd0c8', 0, NULL) 
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  price = EXCLUDED.price,
  product_type = EXCLUDED.product_type,
  variations = EXCLUDED.variations,
  images = EXCLUDED.images,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  delivery_price = EXCLUDED.delivery_price,
  video_url = EXCLUDED.video_url;

INSERT INTO fishing.products (id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url) VALUES 
('41d68af7-3ef4-455f-8bec-132aab718195', 
 'Astika 2-Piece Fishing Rod', 
 'Durable 2-piece Astika brand fishing rod with 7kg to 10kg drag capacity. Strong build for freshwater and general fishing. Rod only.', 
 2500.00, 'physical', '[{"name": "height", "options": [{"label": "6ft", "price": 2500}, {"label": "7ft", "price": 2900}, {"label": "8ft", "price": 3900}, {"label": "9ft - 12ft", "price": 4500}]}]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/5e2964c9-d31f-45a5-a0b4-df94996b0fc6.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/6696da9b-3583-460c-b900-84c7b75ffe8d.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/caa3c941-23c3-4caf-9317-bd2a60d43372.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/4dfbf128-9bb3-4240-8a7e-44b4b13058c9.jpg}', true, '2026-11-05 16:41:00.859211+00', '2026-11-05 17:23:53.577995+00', '5543a79b-21f1-4091-905b-025d39acd0c8', 0, NULL) 
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  price = EXCLUDED.price,
  product_type = EXCLUDED.product_type,
  variations = EXCLUDED.variations,
  images = EXCLUDED.images,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  delivery_price = EXCLUDED.delivery_price,
  video_url = EXCLUDED.video_url;

INSERT INTO fishing.products (id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url) VALUES 
('ff82036f-cf4f-4a9f-a539-5404a680e409', 
 'Galaxy Diamond Fishing Rod (Rod Only)', 
 'Carbon fiber Galaxy Diamond rod designed for sea and big game fishing with 15kg to 20kg drag capacity. Rod only.', 
 3900.00, 'physical', '[{"name": "height", "options": [{"label": "6ft - 7ft", "price": 3900}, {"label": "8ft", "price": 5100}, {"label": "9ft", "price": 6500}, {"label": "10ft", "price": 7500}]}]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/c3ad993c-61e2-4d6c-b37d-de13ffb36104.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/a6b5030a-0e80-4235-893a-8f9192c3eb75.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/d027dc85-48fa-410a-8424-d8e36c0f1a2e.jpg}', true, '2026-11-05 17:04:25.113166+00', '2026-11-05 17:14:54.443393+00', '5543a79b-21f1-4091-905b-025d39acd0c8', 0, NULL) 
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  price = EXCLUDED.price,
  product_type = EXCLUDED.product_type,
  variations = EXCLUDED.variations,
  images = EXCLUDED.images,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  delivery_price = EXCLUDED.delivery_price,
  video_url = EXCLUDED.video_url;

INSERT INTO fishing.products (id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url) VALUES 
('86a369df-675f-4e54-bd49-bb15089e69e7', 
 'Popper Frog Lure (650)', 
 'Popper frog lure designed for topwater predatory fish like Snakehead. Available in multiple color combinations.', 
 650.00, 'physical', '[{"name": "color", "options": [{"label": "Red & White", "price": 650}, {"label": "Green", "price": 650}, {"label": "Yellow & Black", "price": 650}, {"label": "Blue & White", "price": 650}, {"label": "Army Camo", "price": 650}]}]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/ebd6065b-a490-4b7d-ba88-8fe121e99cab.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/384184a3-f9ca-4646-9692-01631f2be9df.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/d0af5813-9044-40d7-87dc-20ed13301a81.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/80e28cf8-2f75-4caa-bdb3-adae3087104c.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/eb642324-2fd8-4a2a-930f-42ffc21e365a.jpg}', true, '2026-11-05 19:16:56.899527+00', '2026-11-05 19:16:56.899527+00', '5543a79b-21f1-4091-905b-025d39acd0c8', 250, NULL) 
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  price = EXCLUDED.price,
  product_type = EXCLUDED.product_type,
  variations = EXCLUDED.variations,
  images = EXCLUDED.images,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  delivery_price = EXCLUDED.delivery_price,
  video_url = EXCLUDED.video_url;

INSERT INTO fishing.products (id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url) VALUES 
('39520327-ac92-466e-9a88-4a3fba3dae33', 
 'Popper Frog Lure (750)', 
 'High-grade topwater popper frog lure. Features lifelike swimming action for freshwater game fish.', 
 750.00, 'physical', '[{"name": "color", "options": [{"label": "Green", "price": 750}, {"label": "Orange", "price": 750}, {"label": "Red & Black", "price": 750}, {"label": "Yellow", "price": 750}]}]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/04e6dcf3-7d7b-4b47-a9bc-e3acaf6d5997.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/43be9b2a-9be0-4f12-b929-c0a6b2f901d3.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/95e20215-0da3-49be-aa2f-a61a8a3f6800.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/aa1cb0ed-592a-4d6b-a314-7457009c78ce.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/33890fba-2935-4d92-a37b-4daafb5dbef4.jpg}', true, '2026-11-05 19:10:58.591553+00', '2026-11-05 19:18:02.174855+00', '5543a79b-21f1-4091-905b-025d39acd0c8', 250, NULL) 
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  price = EXCLUDED.price,
  product_type = EXCLUDED.product_type,
  variations = EXCLUDED.variations,
  images = EXCLUDED.images,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  delivery_price = EXCLUDED.delivery_price,
  video_url = EXCLUDED.video_url;

INSERT INTO fishing.products (id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url) VALUES 
('17e685bb-04ae-4da4-a8dd-7ff0968ccb23', 
 'Luminous Radium Lure (40g)', 
 '40g glow-in-the-dark luminous radium metal jig lure. Ideal for night fishing and deep water.', 
 1200.00, 'physical', '[{"name": "color", "options": [{"label": "White Radium", "price": 1200}, {"label": "Red & Silver", "price": 1200}]}]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/3664c6ae-9aad-4b5c-af9d-dfef4fae3967.jpg}', true, '2026-11-05 19:32:35.576168+00', '2026-11-05 19:32:35.576168+00', '5543a79b-21f1-4091-905b-025d39acd0c8', 250, NULL) 
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  price = EXCLUDED.price,
  product_type = EXCLUDED.product_type,
  variations = EXCLUDED.variations,
  images = EXCLUDED.images,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  delivery_price = EXCLUDED.delivery_price,
  video_url = EXCLUDED.video_url;

INSERT INTO fishing.products (id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url) VALUES 
('a2ca6805-c830-4572-ac75-6ab5fd7ea4e1', 
 'Premium Popper Lure', 
 'Premium topwater popper lure available in 40g and 60g sizes. Excellent popping and splashing action to trigger aggressive strikes.', 
 1500.00, 'physical', '[{"name": "color", "options": [{"label": "Red & Silver", "price": 1500}, {"label": "Green & Yellow", "price": 1500}, {"label": "Rose & Silver", "price": 1500}]}]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/cb8ea7c9-5630-44c1-bf6e-bdf4f40a2f02.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/5838a9bc-a2a8-4f1a-94f5-bc158b3b0d6b.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/75466fa9-f47d-48c0-ac4a-621bba680fed.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/527526d1-27be-48b3-bd28-a4f8a697eb12.jpg}', true, '2026-11-05 19:45:40.115485+00', '2026-11-05 19:46:54.442039+00', '5543a79b-21f1-4091-905b-025d39acd0c8', 350, NULL) 
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  price = EXCLUDED.price,
  product_type = EXCLUDED.product_type,
  variations = EXCLUDED.variations,
  images = EXCLUDED.images,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  delivery_price = EXCLUDED.delivery_price,
  video_url = EXCLUDED.video_url;

INSERT INTO fishing.products (id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url) VALUES 
('20e39e23-8370-4087-8080-3f19e79b174f', 
 'Assorted Fishing Lures Collection', 
 'Diverse selection of high-quality fishing lures including Minnow, Popper, and Frog lures designed to attract predatory fish.', 
 1500.00, 'physical', '[]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/e8e05c6b-4d9e-4f16-857b-f37b0a8db1bc.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/af8d91db-6cdd-48bb-955e-80345db7443f.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/f43d55b4-581d-4959-a4cd-ec10a4ee9f74.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/a706e37c-8d07-497b-a675-6197953e07e6.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/6aa9943e-0aa5-4e4d-8787-81615aff340d.jpg}', true, '2026-11-05 20:02:28.062748+00', '2026-11-05 20:02:28.062748+00', '5543a79b-21f1-4091-905b-025d39acd0c8', 350, NULL) 
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  price = EXCLUDED.price,
  product_type = EXCLUDED.product_type,
  variations = EXCLUDED.variations,
  images = EXCLUDED.images,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  delivery_price = EXCLUDED.delivery_price,
  video_url = EXCLUDED.video_url;

INSERT INTO fishing.products (id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url) VALUES 
('6f241c2a-15f8-4dab-a047-c77fc299d87b', 
 'Popper Frog Lure (Classic)', 
 'Classic topwater frog popper lure for freshwater fish and snakehead angling.', 
 750.00, 'physical', '[]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/4dc6646b-f3e9-4d6e-a015-8f80eaa02803.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/57c45211-a5a6-415f-a5a9-77572304f59d.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/b35ea2dd-5457-43df-aece-7eb45849d161.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/15968334-e22e-4ed7-8911-a1f46b5897e0.jpg,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/b2f5eaae-8916-4e88-868b-9c3621df70be.jpg}', true, '2026-11-06 05:14:21.626662+00', '2026-11-06 05:14:21.626662+00', '5543a79b-21f1-4091-905b-025d39acd0c8', 250, NULL) 
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  price = EXCLUDED.price,
  product_type = EXCLUDED.product_type,
  variations = EXCLUDED.variations,
  images = EXCLUDED.images,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  delivery_price = EXCLUDED.delivery_price,
  video_url = EXCLUDED.video_url;

INSERT INTO fishing.products (id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url) VALUES 
('78bd997e-fcca-44da-af2f-656769185f66', 
 'Fishing Wire Leader Cable', 
 'High-strength anti-rust stainless steel wire leaders with smooth swivels and snaps. Protects fishing line from teeth of predator fish. Available in 40LB, 70LB, and 90LB strengths.', 
 200.00, 'physical', '[{"name": "strength", "options": [{"label": "40LB", "price": 200}, {"label": "70LB", "price": 250}, {"label": "90LB", "price": 300}]}]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/01cdf840-067c-43c1-8533-3c6c34b205f3.png,https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/0769703a-75ab-4e8c-92b1-f90bd7299691.png}', true, '2026-11-07 13:43:08.540695+00', '2026-11-07 13:44:23.670687+00', '5543a79b-21f1-4091-905b-025d39acd0c8', 150, NULL) 
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  price = EXCLUDED.price,
  product_type = EXCLUDED.product_type,
  variations = EXCLUDED.variations,
  images = EXCLUDED.images,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  delivery_price = EXCLUDED.delivery_price,
  video_url = EXCLUDED.video_url;

INSERT INTO fishing.products (id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url) VALUES 
('f20adf71-92c7-4267-bb68-7c1fcbb53a6c', 
 'Fishing Float', 
 'High-visibility bite indicator float bobber for freshwater and lake fishing.', 
 150.00, 'physical', '[]', '{https://supabase.buildstart.io/storage/v1/object/public/biz-5543a79b-21f1-4091-905b-025d39acd0c8/products/65d4ac30-882e-43d1-80af-34c07a97011b.png}', true, '2026-11-09 09:57:52.834858+00', '2026-11-09 09:57:52.834858+00', '5543a79b-21f1-4091-905b-025d39acd0c8', 0, NULL) 
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  price = EXCLUDED.price,
  product_type = EXCLUDED.product_type,
  variations = EXCLUDED.variations,
  images = EXCLUDED.images,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  delivery_price = EXCLUDED.delivery_price,
  video_url = EXCLUDED.video_url;

-- 3. Insert FAQs into fishing.faqs
INSERT INTO fishing.faqs (id, question, answer, product_id, is_active, created_at, updated_at, user_id, is_tracked, media_urls) VALUES 
('9c8c239b-b8de-4c1c-8a33-21e8ffed7708', 
 'Do you provide delivery across Sri Lanka?', 
 'Yes, we offer secure All-Island Delivery to any town or district across Sri Lanka!', 
 NULL, true, '2026-11-04 14:03:34.560797+00', '2026-11-04 14:03:34.560797+00', '5543a79b-21f1-4091-905b-025d39acd0c8', false, '{}') 
ON CONFLICT (id) DO UPDATE SET
  question = EXCLUDED.question,
  answer = EXCLUDED.answer,
  product_id = EXCLUDED.product_id,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  is_tracked = EXCLUDED.is_tracked,
  media_urls = EXCLUDED.media_urls;

INSERT INTO fishing.faqs (id, question, answer, product_id, is_active, created_at, updated_at, user_id, is_tracked, media_urls) VALUES 
('1f277596-4113-4c46-8037-61eb16d4e6e5', 
 'What are the available rod heights and sizes?', 
 'Our fishing rods come in extended lengths ranging from 6ft up to 15ft depending on the model. Many models feature compact telescopic or 2-piece foldable designs (collapsed length ~42cm) making them very easy to carry on a bike or in a backpack.', 
 NULL, true, '2026-11-04 14:03:51.963354+00', '2026-11-04 14:03:51.963354+00', '5543a79b-21f1-4091-905b-025d39acd0c8', false, '{}') 
ON CONFLICT (id) DO UPDATE SET
  question = EXCLUDED.question,
  answer = EXCLUDED.answer,
  product_id = EXCLUDED.product_id,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  is_tracked = EXCLUDED.is_tracked,
  media_urls = EXCLUDED.media_urls;

INSERT INTO fishing.faqs (id, question, answer, product_id, is_active, created_at, updated_at, user_id, is_tracked, media_urls) VALUES 
('4fa3eada-871c-4619-b56c-e3729c74fe61', 
 'Can I pay using Cash on Delivery (COD)?', 
 'Yes! We support Cash on Delivery (COD) so you can pay once the package reaches your doorstep, as well as Bank Transfer.', 
 NULL, true, '2026-11-04 14:04:05.174797+00', '2026-11-04 14:04:05.174797+00', '5543a79b-21f1-4091-905b-025d39acd0c8', false, '{}') 
ON CONFLICT (id) DO UPDATE SET
  question = EXCLUDED.question,
  answer = EXCLUDED.answer,
  product_id = EXCLUDED.product_id,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  is_tracked = EXCLUDED.is_tracked,
  media_urls = EXCLUDED.media_urls;

INSERT INTO fishing.faqs (id, question, answer, product_id, is_active, created_at, updated_at, user_id, is_tracked, media_urls) VALUES 
('5565d23f-b97e-4065-adb8-1f771d558b62', 
 'How long does delivery take?', 
 'Orders are dispatched promptly and typically delivered within 2 to 4 working days to any location in Sri Lanka.', 
 NULL, true, '2026-11-04 14:04:18.729406+00', '2026-11-04 14:04:18.729406+00', '5543a79b-21f1-4091-905b-025d39acd0c8', false, '{}') 
ON CONFLICT (id) DO UPDATE SET
  question = EXCLUDED.question,
  answer = EXCLUDED.answer,
  product_id = EXCLUDED.product_id,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  is_tracked = EXCLUDED.is_tracked,
  media_urls = EXCLUDED.media_urls;

INSERT INTO fishing.faqs (id, question, answer, product_id, is_active, created_at, updated_at, user_id, is_tracked, media_urls) VALUES 
('c51b215a-91a1-4f7e-bd60-4ac4ffcb6ed9', 
 'What other fishing equipment do you have? Do you sell cast nets (Wisi Del)?', 
 'We specialize in complete fishing packages (combo kits), rods, spinning/baitcasting reels, braided/monofilament lines, lures, frogs, and hooks. Please contact us directly regarding cast net (wisi del) availability.', 
 NULL, true, '2026-11-04 14:04:45.927914+00', '2026-11-04 14:04:45.927914+00', '5543a79b-21f1-4091-905b-025d39acd0c8', false, '{}') 
ON CONFLICT (id) DO UPDATE SET
  question = EXCLUDED.question,
  answer = EXCLUDED.answer,
  product_id = EXCLUDED.product_id,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  is_tracked = EXCLUDED.is_tracked,
  media_urls = EXCLUDED.media_urls;

-- 4. Sync to public schema
INSERT INTO public.products (id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url)
SELECT id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url
FROM fishing.products
WHERE user_id = '5543a79b-21f1-4091-905b-025d39acd0c8'
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  price = EXCLUDED.price,
  product_type = EXCLUDED.product_type,
  variations = EXCLUDED.variations,
  images = EXCLUDED.images,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  delivery_price = EXCLUDED.delivery_price,
  video_url = EXCLUDED.video_url;

INSERT INTO public.faqs (id, question, answer, product_id, is_active, created_at, updated_at, user_id, is_tracked, media_urls)
SELECT id, question, answer, product_id, is_active, created_at, updated_at, user_id, is_tracked, media_urls
FROM fishing.faqs
WHERE user_id = '5543a79b-21f1-4091-905b-025d39acd0c8'
ON CONFLICT (id) DO UPDATE SET
  question = EXCLUDED.question,
  answer = EXCLUDED.answer,
  product_id = EXCLUDED.product_id,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  is_tracked = EXCLUDED.is_tracked,
  media_urls = EXCLUDED.media_urls;

-- 5. Sync to ibbagamuwa_customization schema
INSERT INTO ibbagamuwa_customization.products (id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url)
SELECT id, name, description, price, product_type, variations, images, is_active, created_at, updated_at, user_id, delivery_price, video_url
FROM fishing.products
WHERE user_id = '5543a79b-21f1-4091-905b-025d39acd0c8'
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  price = EXCLUDED.price,
  product_type = EXCLUDED.product_type,
  variations = EXCLUDED.variations,
  images = EXCLUDED.images,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  delivery_price = EXCLUDED.delivery_price,
  video_url = EXCLUDED.video_url;

INSERT INTO ibbagamuwa_customization.faqs (id, question, answer, product_id, is_active, created_at, updated_at, user_id, is_tracked, media_urls)
SELECT id, question, answer, product_id, is_active, created_at, updated_at, user_id, is_tracked, media_urls
FROM fishing.faqs
WHERE user_id = '5543a79b-21f1-4091-905b-025d39acd0c8'
ON CONFLICT (id) DO UPDATE SET
  question = EXCLUDED.question,
  answer = EXCLUDED.answer,
  product_id = EXCLUDED.product_id,
  is_active = EXCLUDED.is_active,
  created_at = EXCLUDED.created_at,
  updated_at = EXCLUDED.updated_at,
  user_id = EXCLUDED.user_id,
  is_tracked = EXCLUDED.is_tracked,
  media_urls = EXCLUDED.media_urls;

-- 6. Ensure storage bucket for user 5543a79b-21f1-4091-905b-025d39acd0c8
INSERT INTO storage.buckets (id, name, public, file_size_limit, created_at, updated_at)
VALUES (
  'biz-5543a79b-21f1-4091-905b-025d39acd0c8',
  'biz-5543a79b-21f1-4091-905b-025d39acd0c8',
  true,
  52428800,
  now(),
  now()
) ON CONFLICT (id) DO UPDATE SET public = true;

COMMIT;

