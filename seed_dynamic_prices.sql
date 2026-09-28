-- ====================================================================================
-- UC18 SEED: dynamic_prices tháng 9–10/2026
-- Owner: nguyenvana.owner@gmail.com
-- HS1: Đà Lạt Pine Valley (homestay_id=1, room_type_id 1–3)
-- HS2: Ana Garden Villa   (homestay_id=2, room_type_id 4–6)
--
-- Quy tắc:
--   • Cuối tuần (T7/CN): multiplier 1.25
--   • Ngày thường: không có row → dùng base_price mặc định
--   • Một số ngày khóa phòng (is_locked=TRUE)
--   • Một vài ngày có custom_price tuyệt đối
--
-- Chạy sau khi đã chạy schema.sql + seed_search_data.sql
-- ====================================================================================

-- ── Tháng 9/2026 ──────────────────────────────────────────────────────────────
-- Thứ 7/CN tháng 9: 5,6 | 12,13 | 19,20 | 26,27

-- HS1 – Phòng Thông Standard (rt=1, base=450k)
INSERT IGNORE INTO dynamic_prices (room_type_id, date, price_multiplier, custom_price, is_locked) VALUES
(1,'2026-09-05',1.25,NULL,FALSE),(1,'2026-09-06',1.25,NULL,FALSE),
(1,'2026-09-12',1.25,NULL,FALSE),(1,'2026-09-13',1.25,NULL,FALSE),
(1,'2026-09-19',1.25,NULL,FALSE),(1,'2026-09-20',1.25,NULL,FALSE),
(1,'2026-09-26',1.25,NULL,FALSE),(1,'2026-09-27',1.25,NULL,FALSE),
-- Khóa phòng bảo trì 11/9
(1,'2026-09-11',1.00,NULL,TRUE);

-- HS1 – Phòng Gác Lửa Deluxe (rt=2, base=750k)
INSERT IGNORE INTO dynamic_prices (room_type_id, date, price_multiplier, custom_price, is_locked) VALUES
(2,'2026-09-05',1.25,NULL,FALSE),(2,'2026-09-06',1.25,NULL,FALSE),
(2,'2026-09-12',1.25,NULL,FALSE),(2,'2026-09-13',1.25,NULL,FALSE),
(2,'2026-09-19',1.25,NULL,FALSE),(2,'2026-09-20',1.25,NULL,FALSE),
(2,'2026-09-26',1.25,NULL,FALSE),(2,'2026-09-27',1.25,NULL,FALSE);

-- HS1 – Chalet Đôi Superior (rt=3, base=1.2tr) — custom price cuối tuần
INSERT IGNORE INTO dynamic_prices (room_type_id, date, price_multiplier, custom_price, is_locked) VALUES
(3,'2026-09-05',NULL,1600000,FALSE),(3,'2026-09-06',NULL,1600000,FALSE),
(3,'2026-09-12',NULL,1600000,FALSE),(3,'2026-09-13',NULL,1600000,FALSE),
(3,'2026-09-19',NULL,1600000,FALSE),(3,'2026-09-20',NULL,1600000,FALSE),
(3,'2026-09-26',NULL,1600000,FALSE),(3,'2026-09-27',NULL,1600000,FALSE),
-- Khóa Chalet 2 ngày vệ sinh sâu
(3,'2026-09-23',1.00,NULL,TRUE),(3,'2026-09-24',1.00,NULL,TRUE);

-- HS2 – Garden View Room (rt=4, base=650k)
INSERT IGNORE INTO dynamic_prices (room_type_id, date, price_multiplier, custom_price, is_locked) VALUES
(4,'2026-09-05',1.25,NULL,FALSE),(4,'2026-09-06',1.25,NULL,FALSE),
(4,'2026-09-12',1.25,NULL,FALSE),(4,'2026-09-13',1.25,NULL,FALSE),
(4,'2026-09-19',1.25,NULL,FALSE),(4,'2026-09-20',1.25,NULL,FALSE),
(4,'2026-09-26',1.25,NULL,FALSE),(4,'2026-09-27',1.25,NULL,FALSE);

-- HS2 – Suite Gia Đình 4P (rt=5, base=1.5tr)
INSERT IGNORE INTO dynamic_prices (room_type_id, date, price_multiplier, custom_price, is_locked) VALUES
(5,'2026-09-05',1.30,NULL,FALSE),(5,'2026-09-06',1.30,NULL,FALSE),
(5,'2026-09-12',1.30,NULL,FALSE),(5,'2026-09-13',1.30,NULL,FALSE),
(5,'2026-09-19',1.30,NULL,FALSE),(5,'2026-09-20',1.30,NULL,FALSE),
(5,'2026-09-26',1.30,NULL,FALSE),(5,'2026-09-27',1.30,NULL,FALSE);

-- HS2 – Villa Toàn Bộ (rt=6, base=4.5tr) — custom price cuối tuần
INSERT IGNORE INTO dynamic_prices (room_type_id, date, price_multiplier, custom_price, is_locked) VALUES
(6,'2026-09-05',NULL,5500000,FALSE),(6,'2026-09-06',NULL,5500000,FALSE),
(6,'2026-09-12',NULL,5500000,FALSE),(6,'2026-09-13',NULL,5500000,FALSE),
(6,'2026-09-19',NULL,5500000,FALSE),(6,'2026-09-20',NULL,5500000,FALSE),
(6,'2026-09-26',NULL,5500000,FALSE),(6,'2026-09-27',NULL,5500000,FALSE);

-- ── Tháng 10/2026 ──────────────────────────────────────────────────────────────
-- Thứ 7/CN tháng 10: 3,4 | 10,11 | 17,18 | 24,25 | 31
-- Lễ 20/10 (Phụ nữ Việt Nam) → tăng nhẹ, Halloween 31/10 → x1.5

-- HS1 – Phòng Thông Standard (rt=1)
INSERT IGNORE INTO dynamic_prices (room_type_id, date, price_multiplier, custom_price, is_locked) VALUES
(1,'2026-10-03',1.25,NULL,FALSE),(1,'2026-10-04',1.25,NULL,FALSE),
(1,'2026-10-10',1.25,NULL,FALSE),(1,'2026-10-11',1.25,NULL,FALSE),
(1,'2026-10-17',1.25,NULL,FALSE),(1,'2026-10-18',1.25,NULL,FALSE),
(1,'2026-10-20',1.15,NULL,FALSE),
(1,'2026-10-24',1.25,NULL,FALSE),(1,'2026-10-25',1.25,NULL,FALSE),
(1,'2026-10-31',1.50,NULL,FALSE);

-- HS1 – Phòng Gác Lửa Deluxe (rt=2)
INSERT IGNORE INTO dynamic_prices (room_type_id, date, price_multiplier, custom_price, is_locked) VALUES
(2,'2026-10-03',1.25,NULL,FALSE),(2,'2026-10-04',1.25,NULL,FALSE),
(2,'2026-10-10',1.25,NULL,FALSE),(2,'2026-10-11',1.25,NULL,FALSE),
(2,'2026-10-17',1.25,NULL,FALSE),(2,'2026-10-18',1.25,NULL,FALSE),
(2,'2026-10-24',1.25,NULL,FALSE),(2,'2026-10-25',1.25,NULL,FALSE),
(2,'2026-10-31',1.50,NULL,FALSE);

-- HS1 – Chalet Đôi Superior (rt=3)
INSERT IGNORE INTO dynamic_prices (room_type_id, date, price_multiplier, custom_price, is_locked) VALUES
(3,'2026-10-03',NULL,1600000,FALSE),(3,'2026-10-04',NULL,1600000,FALSE),
(3,'2026-10-10',NULL,1600000,FALSE),(3,'2026-10-11',NULL,1600000,FALSE),
(3,'2026-10-17',NULL,1600000,FALSE),(3,'2026-10-18',NULL,1600000,FALSE),
(3,'2026-10-24',NULL,1600000,FALSE),(3,'2026-10-25',NULL,1600000,FALSE),
(3,'2026-10-31',NULL,2000000,FALSE);

-- HS2 – Garden View Room (rt=4)
INSERT IGNORE INTO dynamic_prices (room_type_id, date, price_multiplier, custom_price, is_locked) VALUES
(4,'2026-10-03',1.25,NULL,FALSE),(4,'2026-10-04',1.25,NULL,FALSE),
(4,'2026-10-10',1.25,NULL,FALSE),(4,'2026-10-11',1.25,NULL,FALSE),
(4,'2026-10-17',1.25,NULL,FALSE),(4,'2026-10-18',1.25,NULL,FALSE),
(4,'2026-10-24',1.25,NULL,FALSE),(4,'2026-10-25',1.25,NULL,FALSE),
(4,'2026-10-31',1.40,NULL,FALSE);

-- HS2 – Suite Gia Đình 4P (rt=5)
INSERT IGNORE INTO dynamic_prices (room_type_id, date, price_multiplier, custom_price, is_locked) VALUES
(5,'2026-10-03',1.30,NULL,FALSE),(5,'2026-10-04',1.30,NULL,FALSE),
(5,'2026-10-10',1.30,NULL,FALSE),(5,'2026-10-11',1.30,NULL,FALSE),
(5,'2026-10-17',1.30,NULL,FALSE),(5,'2026-10-18',1.30,NULL,FALSE),
(5,'2026-10-24',1.30,NULL,FALSE),(5,'2026-10-25',1.30,NULL,FALSE),
(5,'2026-10-31',1.50,NULL,FALSE),
-- Khóa suite tuần bảo trì giữa tháng
(5,'2026-10-14',1.00,NULL,TRUE),(5,'2026-10-15',1.00,NULL,TRUE);

-- HS2 – Villa Toàn Bộ (rt=6)
INSERT IGNORE INTO dynamic_prices (room_type_id, date, price_multiplier, custom_price, is_locked) VALUES
(6,'2026-10-03',NULL,5500000,FALSE),(6,'2026-10-04',NULL,5500000,FALSE),
(6,'2026-10-10',NULL,5500000,FALSE),(6,'2026-10-11',NULL,5500000,FALSE),
(6,'2026-10-17',NULL,5500000,FALSE),(6,'2026-10-18',NULL,5500000,FALSE),
(6,'2026-10-24',NULL,5500000,FALSE),(6,'2026-10-25',NULL,5500000,FALSE),
(6,'2026-10-31',NULL,7000000,FALSE);
