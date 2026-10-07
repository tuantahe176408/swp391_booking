-- ====================================================================================
-- SEED: Analytics Data - Smart Booking Platform
-- Mục đích: Tạo dữ liệu sinh động cho admin/analytics dashboard
-- Trải dài: Tháng 5/2026 → Tháng 10/2026 (6 tháng)
-- Chạy: mysql -u root -p'root@2024' smart_booking_db < seed_analytics_data.sql
-- ====================================================================================

USE smart_booking_db;

-- ====================================================================================
-- 1. THÊM CUSTOMERS MỚI (user_id 20-29) - đăng ký rải rác 6 tháng
-- ====================================================================================
INSERT INTO users (user_id, email, password_hash, full_name, phone_number, role, auth_provider, is_active, is_email_verified, must_change_password, created_at) VALUES
(20, 'khach01@gmail.com', '$2a$10$dummyhashvalue1111111uZzXyW1234567890abcdefghijklm', 'Nguyễn Thị Mai', '0901111001', 'CUSTOMER', 'LOCAL', TRUE, TRUE, FALSE, '2026-05-03 08:10:00'),
(21, 'khach02@gmail.com', '$2a$10$dummyhashvalue2222222uZzXyW1234567890abcdefghijklm', 'Trần Văn Hùng', '0901111002', 'CUSTOMER', 'LOCAL', TRUE, TRUE, FALSE, '2026-05-10 09:22:00'),
(22, 'khach03@gmail.com', '$2a$10$dummyhashvalue3333333uZzXyW1234567890abcdefghijklm', 'Lê Thị Hoa', '0901111003', 'CUSTOMER', 'LOCAL', TRUE, TRUE, FALSE, '2026-05-18 14:05:00'),
(23, 'khach04@gmail.com', '$2a$10$dummyhashvalue4444444uZzXyW1234567890abcdefghijklm', 'Phạm Minh Khoa', '0901111004', 'CUSTOMER', 'LOCAL', TRUE, TRUE, FALSE, '2026-06-02 10:30:00'),
(24, 'khach05@gmail.com', '$2a$10$dummyhashvalue5555555uZzXyW1234567890abcdefghijklm', 'Hoàng Thị Lan', '0901111005', 'CUSTOMER', 'GOOGLE', TRUE, TRUE, FALSE, '2026-06-15 16:45:00'),
(25, 'khach06@gmail.com', '$2a$10$dummyhashvalue6666666uZzXyW1234567890abcdefghijklm', 'Vũ Đức Anh', '0901111006', 'CUSTOMER', 'LOCAL', TRUE, TRUE, FALSE, '2026-07-01 11:00:00'),
(26, 'khach07@gmail.com', '$2a$10$dummyhashvalue7777777uZzXyW1234567890abcdefghijklm', 'Đặng Thị Thu', '0901111007', 'CUSTOMER', 'GOOGLE', TRUE, TRUE, FALSE, '2026-07-20 08:55:00'),
(27, 'khach08@gmail.com', '$2a$10$dummyhashvalue8888888uZzXyW1234567890abcdefghijklm', 'Bùi Quang Nam', '0901111008', 'CUSTOMER', 'LOCAL', TRUE, TRUE, FALSE, '2026-08-05 13:20:00'),
(28, 'khach09@gmail.com', '$2a$10$dummyhashvalue9999999uZzXyW1234567890abcdefghijklm', 'Ngô Thị Bích', '0901111009', 'CUSTOMER', 'LOCAL', TRUE, TRUE, FALSE, '2026-08-22 09:10:00'),
(29, 'khach10@gmail.com', '$2a$10$dummyhashvalue0000000uZzXyW1234567890abcdefghijklm', 'Đinh Văn Long', '0901111010', 'CUSTOMER', 'LOCAL', TRUE, TRUE, FALSE, '2026-09-05 15:30:00');

-- ====================================================================================
-- 2. BOOKINGS (booking_id 38-100) - rải đều 6 tháng, đa dạng status
-- ====================================================================================

-- ---- THÁNG 5/2026 (7 bookings, mùa thấp điểm) ----
INSERT INTO bookings (booking_id, booking_code, customer_id, homestay_id, room_type_id, assigned_room_id,
  guest_name, guest_email, guest_phone,
  checkin_date, checkout_date, total_nights,
  room_price_total, addon_price_total, surcharge_total, discount_amount, final_total,
  booking_type, booking_status, created_at)
VALUES
(38, 'BK202605001', 20, 1, 1, 1, 'Nguyễn Thị Mai', 'khach01@gmail.com', '0901111001', '2026-05-03', '2026-05-05', 2, 900000, 0, 0, 0, 900000, 'ONLINE', 'CHECKED_OUT', '2026-05-01 09:00:00'),
(39, 'BK202605002', 21, 3, 7, 13, 'Trần Văn Hùng', 'khach02@gmail.com', '0901111002', '2026-05-08', '2026-05-11', 3, 2100000, 150000, 0, 0, 2250000, 'ONLINE', 'CHECKED_OUT', '2026-05-05 10:00:00'),
(40, 'BK202605003', 9,  7, 16, NULL, 'Nguyễn Văn A', 'customer1@gmail.com', '0901234567', '2026-05-10', '2026-05-12', 2, 1900000, 0, 0, 0, 1900000, 'ONLINE', 'CHECKED_OUT', '2026-05-07 14:00:00'),
(41, 'BK202605004', 22, 9, 21, NULL, 'Lê Thị Hoa', 'khach03@gmail.com', '0901111003', '2026-05-15', '2026-05-18', 3, 5400000, 200000, 0, 100000, 5500000, 'ONLINE', 'CHECKED_OUT', '2026-05-12 08:00:00'),
(42, 'BK202605005', 10, 11, 26, NULL, 'Trần Thị B', 'customer2@gmail.com', '0907654321', '2026-05-20', '2026-05-22', 2, 1960000, 0, 0, 0, 1960000, 'ONLINE', 'CANCELLED', '2026-05-16 11:00:00'),
(43, 'BK202605006', 23, 5, 11, 18, 'Phạm Minh Khoa', 'khach04@gmail.com', '0901111004', '2026-05-22', '2026-05-25', 3, 7500000, 500000, 0, 0, 8000000, 'ONLINE', 'CHECKED_OUT', '2026-05-19 15:00:00'),
(44, 'BK202605007', 11, 13, 31, NULL, 'Lê Văn C', 'customer3@gmail.com', '0909999111', '2026-05-28', '2026-05-31', 3, 28500000, 0, 0, 500000, 28000000, 'ONLINE', 'CHECKED_OUT', '2026-05-24 09:30:00'),

-- ---- THÁNG 6/2026 (9 bookings, tăng dần) ----
(45, 'BK202606001', 24, 2, 4, 8, 'Hoàng Thị Lan', 'khach05@gmail.com', '0901111005', '2026-06-01', '2026-06-03', 2, 1300000, 0, 0, 0, 1300000, 'ONLINE', 'CHECKED_OUT', '2026-05-28 10:00:00'),
(46, 'BK202606002', 20, 7, 17, NULL, 'Nguyễn Thị Mai', 'khach01@gmail.com', '0901111001', '2026-06-05', '2026-06-07', 2, 1700000, 100000, 0, 0, 1800000, 'ONLINE', 'CHECKED_OUT', '2026-06-02 09:00:00'),
(47, 'BK202606003', 12, 9, 22, NULL, 'Phạm Thị D', 'customer4@gmail.com', '0908888222', '2026-06-08', '2026-06-10', 2, 4800000, 300000, 0, 0, 5100000, 'ONLINE', 'CHECKED_OUT', '2026-06-04 14:00:00'),
(48, 'BK202606004', 25, 1, 2, 4, 'Vũ Đức Anh', 'khach06@gmail.com', '0901111006', '2026-06-10', '2026-06-13', 3, 2250000, 0, 0, 0, 2250000, 'ONLINE', 'CHECKED_OUT', '2026-06-07 11:00:00'),
(49, 'BK202606005', 21, 3, 8, 16, 'Trần Văn Hùng', 'khach02@gmail.com', '0901111002', '2026-06-12', '2026-06-15', 3, 4800000, 0, 0, 200000, 4600000, 'ONLINE', 'CHECKED_OUT', '2026-06-09 08:00:00'),
(50, 'BK202606006', 13, 11, 27, NULL, 'Nguyễn Văn E', 'customer5@gmail.com', '0902222333', '2026-06-15', '2026-06-17', 2, 3600000, 200000, 0, 0, 3800000, 'ONLINE', 'CANCELLED', '2026-06-11 09:00:00'),
(51, 'BK202606007', 26, 5, 12, 19, 'Đặng Thị Thu', 'khach07@gmail.com', '0901111007', '2026-06-18', '2026-06-21', 3, 9600000, 500000, 0, 0, 10100000, 'ONLINE', 'CHECKED_OUT', '2026-06-14 10:00:00'),
(52, 'BK202606008', 22, 7, 16, NULL, 'Lê Thị Hoa', 'khach03@gmail.com', '0901111003', '2026-06-22', '2026-06-25', 3, 2850000, 0, 0, 0, 2850000, 'ONLINE', 'CHECKED_OUT', '2026-06-18 13:00:00'),
(53, 'BK202606009', 14, 9, 21, NULL, 'Trần Thị F', 'customer6@gmail.com', '0903333444', '2026-06-27', '2026-06-30', 3, 5400000, 300000, 0, 100000, 5600000, 'ONLINE', 'CHECKED_OUT', '2026-06-23 15:00:00'),

-- ---- THÁNG 7/2026 (12 bookings, cao điểm hè) ----
(54, 'BK202607001', 27, 5, 11, 20, 'Bùi Quang Nam', 'khach08@gmail.com', '0901111008', '2026-07-01', '2026-07-04', 3, 7500000, 500000, 0, 0, 8000000, 'ONLINE', 'CHECKED_OUT', '2026-06-27 09:00:00'),
(55, 'BK202607002', 23, 9, 22, NULL, 'Phạm Minh Khoa', 'khach04@gmail.com', '0901111004', '2026-07-02', '2026-07-05', 3, 7200000, 600000, 0, 200000, 7600000, 'ONLINE', 'CHECKED_OUT', '2026-06-28 10:00:00'),
(56, 'BK202607003', 24, 6, 14, NULL, 'Hoàng Thị Lan', 'khach05@gmail.com', '0901111005', '2026-07-03', '2026-07-05', 2, 300000, 0, 0, 0, 300000, 'WALK_IN', 'CHECKED_OUT', '2026-07-03 14:00:00'),
(57, 'BK202607004', 15, 1, 3, 6, 'Hoàng Văn G', 'customer7@gmail.com', '0904444555', '2026-07-05', '2026-07-08', 3, 3600000, 0, 0, 0, 3600000, 'ONLINE', 'CHECKED_OUT', '2026-07-01 08:00:00'),
(58, 'BK202607005', 25, 3, 7, 13, 'Vũ Đức Anh', 'khach06@gmail.com', '0901111006', '2026-07-07', '2026-07-10', 3, 2100000, 150000, 0, 0, 2250000, 'ONLINE', 'CHECKED_OUT', '2026-07-03 11:00:00'),
(59, 'BK202607006', 26, 11, 27, NULL, 'Đặng Thị Thu', 'khach07@gmail.com', '0901111007', '2026-07-10', '2026-07-14', 4, 7200000, 400000, 0, 0, 7600000, 'ONLINE', 'CHECKED_OUT', '2026-07-06 09:30:00'),
(60, 'BK202607007', 16, 5, 13, NULL, 'Lê Thị H', 'customer8@gmail.com', '0905555666', '2026-07-12', '2026-07-15', 3, 19500000, 1000000, 0, 500000, 20000000, 'ONLINE', 'CHECKED_OUT', '2026-07-08 10:00:00'),
(61, 'BK202607008', 28, 7, 18, NULL, 'Ngô Thị Bích', 'khach09@gmail.com', '0901111009', '2026-07-15', '2026-07-17', 2, 3600000, 0, 0, 0, 3600000, 'ONLINE', 'CHECKED_OUT', '2026-07-11 14:00:00'),
(62, 'BK202607009', 20, 9, 21, NULL, 'Nguyễn Thị Mai', 'khach01@gmail.com', '0901111001', '2026-07-18', '2026-07-21', 3, 5400000, 300000, 0, 0, 5700000, 'ONLINE', 'CHECKED_OUT', '2026-07-14 09:00:00'),
(63, 'BK202607010', 29, 2, 5, 10, 'Đinh Văn Long', 'khach10@gmail.com', '0901111010', '2026-07-20', '2026-07-23', 3, 4500000, 0, 0, 0, 4500000, 'ONLINE', 'CHECKED_OUT', '2026-07-16 11:00:00'),
(64, 'BK202607011', 21, 13, 32, NULL, 'Trần Văn Hùng', 'khach02@gmail.com', '0901111002', '2026-07-23', '2026-07-26', 3, 6600000, 500000, 0, 200000, 6900000, 'ONLINE', 'CHECKED_OUT', '2026-07-19 10:00:00'),
(65, 'BK202607012', 9,  11, 26, NULL, 'Nguyễn Văn A', 'customer1@gmail.com', '0901234567', '2026-07-27', '2026-07-30', 3, 2940000, 0, 0, 0, 2940000, 'ONLINE', 'CANCELLED', '2026-07-23 08:00:00'),

-- ---- THÁNG 8/2026 (11 bookings, vẫn cao) ----
(66, 'BK202608001', 27, 5, 12, 20, 'Bùi Quang Nam', 'khach08@gmail.com', '0901111008', '2026-08-01', '2026-08-04', 3, 9600000, 600000, 0, 0, 10200000, 'ONLINE', 'CHECKED_OUT', '2026-07-28 10:00:00'),
(67, 'BK202608002', 22, 1, 2, 4, 'Lê Thị Hoa', 'khach03@gmail.com', '0901111003', '2026-08-03', '2026-08-06', 3, 2250000, 150000, 0, 0, 2400000, 'ONLINE', 'CHECKED_OUT', '2026-07-30 09:00:00'),
(68, 'BK202608003', 10, 9, 23, NULL, 'Trần Thị B', 'customer2@gmail.com', '0907654321', '2026-08-05', '2026-08-08', 3, 11400000, 800000, 0, 300000, 11900000, 'ONLINE', 'CHECKED_OUT', '2026-08-01 11:00:00'),
(69, 'BK202608004', 28, 7, 16, NULL, 'Ngô Thị Bích', 'khach09@gmail.com', '0901111009', '2026-08-08', '2026-08-10', 2, 1900000, 0, 0, 0, 1900000, 'ONLINE', 'CHECKED_OUT', '2026-08-04 14:00:00'),
(70, 'BK202608005', 23, 3, 8, 16, 'Phạm Minh Khoa', 'khach04@gmail.com', '0901111004', '2026-08-10', '2026-08-13', 3, 4800000, 300000, 0, 0, 5100000, 'ONLINE', 'CHECKED_OUT', '2026-08-06 09:00:00'),
(71, 'BK202608006', 29, 11, 28, NULL, 'Đinh Văn Long', 'khach10@gmail.com', '0901111010', '2026-08-13', '2026-08-17', 4, 10000000, 500000, 0, 0, 10500000, 'ONLINE', 'CHECKED_OUT', '2026-08-09 10:00:00'),
(72, 'BK202608007', 15, 5, 11, 18, 'Hoàng Văn G', 'customer7@gmail.com', '0904444555', '2026-08-15', '2026-08-18', 3, 7500000, 500000, 0, 500000, 7500000, 'ONLINE', 'CHECKED_OUT', '2026-08-11 08:00:00'),
(73, 'BK202608008', 24, 9, 21, NULL, 'Hoàng Thị Lan', 'khach05@gmail.com', '0901111005', '2026-08-18', '2026-08-20', 2, 3600000, 0, 0, 0, 3600000, 'ONLINE', 'CHECKED_OUT', '2026-08-14 13:00:00'),
(74, 'BK202608009', 26, 2, 6, 12, 'Đặng Thị Thu', 'khach07@gmail.com', '0901111007', '2026-08-21', '2026-08-24', 3, 13500000, 1000000, 0, 500000, 14000000, 'ONLINE', 'CHECKED_OUT', '2026-08-17 09:30:00'),
(75, 'BK202608010', 11, 7, 17, NULL, 'Lê Văn C', 'customer3@gmail.com', '0909999111', '2026-08-25', '2026-08-27', 2, 1700000, 0, 0, 0, 1700000, 'ONLINE', 'CANCELLED', '2026-08-21 11:00:00'),
(76, 'BK202608011', 20, 13, 31, NULL, 'Nguyễn Thị Mai', 'khach01@gmail.com', '0901111001', '2026-08-28', '2026-08-31', 3, 28500000, 2000000, 0, 1000000, 29500000, 'ONLINE', 'CHECKED_OUT', '2026-08-24 10:00:00'),

-- ---- THÁNG 9/2026 (đã có 21 bookings, bổ sung thêm trải đều tháng) ----
-- Giữ nguyên 21 bookings hiện có, thêm 5 bookings nữa vào cuối tháng
(77, 'BK202609022', 25, 5, 13, NULL, 'Vũ Đức Anh', 'khach06@gmail.com', '0901111006', '2026-09-02', '2026-09-05', 3, 19500000, 1000000, 0, 500000, 20000000, 'ONLINE', 'CHECKED_OUT', '2026-08-29 10:00:00'),
(78, 'BK202609023', 27, 9, 22, NULL, 'Bùi Quang Nam', 'khach08@gmail.com', '0901111008', '2026-09-08', '2026-09-11', 3, 7200000, 600000, 0, 0, 7800000, 'ONLINE', 'CHECKED_OUT', '2026-09-04 09:00:00'),
(79, 'BK202609024', 16, 3, 7, 13, 'Lê Thị H', 'customer8@gmail.com', '0905555666', '2026-09-12', '2026-09-15', 3, 2100000, 0, 0, 0, 2100000, 'ONLINE', 'CHECKED_OUT', '2026-09-08 11:00:00'),
(80, 'BK202609025', 28, 11, 26, NULL, 'Ngô Thị Bích', 'khach09@gmail.com', '0901111009', '2026-09-18', '2026-09-20', 2, 1960000, 0, 0, 0, 1960000, 'ONLINE', 'CHECKED_OUT', '2026-09-14 14:00:00'),
(81, 'BK202609026', 29, 1, 3, 6, 'Đinh Văn Long', 'khach10@gmail.com', '0901111010', '2026-09-22', '2026-09-25', 3, 3600000, 200000, 0, 0, 3800000, 'ONLINE', 'CHECKED_OUT', '2026-09-18 09:00:00');

-- ====================================================================================
-- 3. PAYMENTS cho tất cả bookings CHECKED_OUT mới
-- ====================================================================================
INSERT INTO payments (booking_id, transaction_code, payment_method, payment_type, amount, payment_status, paid_at, created_at)
VALUES
-- Tháng 5
(38, 'VNP202605001', 'VNPAY', 'FULL_PAYMENT', 900000, 'SUCCESS', '2026-05-01 09:30:00', '2026-05-01 09:00:00'),
(39, 'VNP202605002', 'VNPAY', 'FULL_PAYMENT', 2250000, 'SUCCESS', '2026-05-05 10:30:00', '2026-05-05 10:00:00'),
(40, 'MOM202605003', 'MOMO', 'FULL_PAYMENT', 1900000, 'SUCCESS', '2026-05-07 14:30:00', '2026-05-07 14:00:00'),
(41, 'VNP202605004', 'VNPAY', 'FULL_PAYMENT', 5500000, 'SUCCESS', '2026-05-12 08:30:00', '2026-05-12 08:00:00'),
-- booking 42 CANCELLED - không payment SUCCESS
(43, 'VNP202605006', 'VNPAY', 'FULL_PAYMENT', 8000000, 'SUCCESS', '2026-05-19 15:30:00', '2026-05-19 15:00:00'),
(44, 'MOM202605007', 'MOMO', 'FULL_PAYMENT', 28000000, 'SUCCESS', '2026-05-24 09:45:00', '2026-05-24 09:30:00'),

-- Tháng 6
(45, 'VNP202606001', 'VNPAY', 'FULL_PAYMENT', 1300000, 'SUCCESS', '2026-05-28 10:30:00', '2026-05-28 10:00:00'),
(46, 'VNP202606002', 'VNPAY', 'FULL_PAYMENT', 1800000, 'SUCCESS', '2026-06-02 09:30:00', '2026-06-02 09:00:00'),
(47, 'MOM202606003', 'MOMO', 'FULL_PAYMENT', 5100000, 'SUCCESS', '2026-06-04 14:30:00', '2026-06-04 14:00:00'),
(48, 'VNP202606004', 'VNPAY', 'FULL_PAYMENT', 2250000, 'SUCCESS', '2026-06-07 11:30:00', '2026-06-07 11:00:00'),
(49, 'VNP202606005', 'VNPAY', 'FULL_PAYMENT', 4600000, 'SUCCESS', '2026-06-09 08:30:00', '2026-06-09 08:00:00'),
-- booking 50 CANCELLED
(51, 'VNP202606007', 'VNPAY', 'FULL_PAYMENT', 10100000, 'SUCCESS', '2026-06-14 10:30:00', '2026-06-14 10:00:00'),
(52, 'MOM202606008', 'MOMO', 'FULL_PAYMENT', 2850000, 'SUCCESS', '2026-06-18 13:30:00', '2026-06-18 13:00:00'),
(53, 'VNP202606009', 'VNPAY', 'FULL_PAYMENT', 5600000, 'SUCCESS', '2026-06-23 15:30:00', '2026-06-23 15:00:00'),

-- Tháng 7
(54, 'VNP202607001', 'VNPAY', 'FULL_PAYMENT', 8000000, 'SUCCESS', '2026-06-27 09:30:00', '2026-06-27 09:00:00'),
(55, 'MOM202607002', 'MOMO', 'FULL_PAYMENT', 7600000, 'SUCCESS', '2026-06-28 10:30:00', '2026-06-28 10:00:00'),
(56, 'CSH202607003', 'CASH', 'FULL_PAYMENT', 300000, 'SUCCESS', '2026-07-03 14:30:00', '2026-07-03 14:00:00'),
(57, 'VNP202607004', 'VNPAY', 'FULL_PAYMENT', 3600000, 'SUCCESS', '2026-07-01 08:30:00', '2026-07-01 08:00:00'),
(58, 'VNP202607005', 'VNPAY', 'FULL_PAYMENT', 2250000, 'SUCCESS', '2026-07-03 11:30:00', '2026-07-03 11:00:00'),
(59, 'MOM202607006', 'MOMO', 'FULL_PAYMENT', 7600000, 'SUCCESS', '2026-07-06 09:45:00', '2026-07-06 09:30:00'),
(60, 'VNP202607007', 'VNPAY', 'FULL_PAYMENT', 20000000, 'SUCCESS', '2026-07-08 10:30:00', '2026-07-08 10:00:00'),
(61, 'VNP202607008', 'VNPAY', 'FULL_PAYMENT', 3600000, 'SUCCESS', '2026-07-11 14:30:00', '2026-07-11 14:00:00'),
(62, 'MOM202607009', 'MOMO', 'FULL_PAYMENT', 5700000, 'SUCCESS', '2026-07-14 09:30:00', '2026-07-14 09:00:00'),
(63, 'VNP202607010', 'VNPAY', 'FULL_PAYMENT', 4500000, 'SUCCESS', '2026-07-16 11:30:00', '2026-07-16 11:00:00'),
(64, 'VNP202607011', 'VNPAY', 'FULL_PAYMENT', 6900000, 'SUCCESS', '2026-07-19 10:30:00', '2026-07-19 10:00:00'),
-- booking 65 CANCELLED

-- Tháng 8
(66, 'VNP202608001', 'VNPAY', 'FULL_PAYMENT', 10200000, 'SUCCESS', '2026-07-28 10:30:00', '2026-07-28 10:00:00'),
(67, 'MOM202608002', 'MOMO', 'FULL_PAYMENT', 2400000, 'SUCCESS', '2026-07-30 09:30:00', '2026-07-30 09:00:00'),
(68, 'VNP202608003', 'VNPAY', 'FULL_PAYMENT', 11900000, 'SUCCESS', '2026-08-01 11:30:00', '2026-08-01 11:00:00'),
(69, 'POS202608004', 'POS_CARD', 'FULL_PAYMENT', 1900000, 'SUCCESS', '2026-08-04 14:30:00', '2026-08-04 14:00:00'),
(70, 'VNP202608005', 'VNPAY', 'FULL_PAYMENT', 5100000, 'SUCCESS', '2026-08-06 09:30:00', '2026-08-06 09:00:00'),
(71, 'MOM202608006', 'MOMO', 'FULL_PAYMENT', 10500000, 'SUCCESS', '2026-08-09 10:30:00', '2026-08-09 10:00:00'),
(72, 'VNP202608007', 'VNPAY', 'FULL_PAYMENT', 7500000, 'SUCCESS', '2026-08-11 08:30:00', '2026-08-11 08:00:00'),
(73, 'VNP202608008', 'VNPAY', 'FULL_PAYMENT', 3600000, 'SUCCESS', '2026-08-14 13:30:00', '2026-08-14 13:00:00'),
(74, 'MOM202608009', 'MOMO', 'FULL_PAYMENT', 14000000, 'SUCCESS', '2026-08-17 09:45:00', '2026-08-17 09:30:00'),
-- booking 75 CANCELLED
(76, 'VNP202608011', 'VNPAY', 'FULL_PAYMENT', 29500000, 'SUCCESS', '2026-08-24 10:30:00', '2026-08-24 10:00:00'),

-- Tháng 9 (bookings mới thêm)
(77, 'MOM202609022', 'MOMO', 'FULL_PAYMENT', 20000000, 'SUCCESS', '2026-08-29 10:30:00', '2026-08-29 10:00:00'),
(78, 'VNP202609023', 'VNPAY', 'FULL_PAYMENT', 7800000, 'SUCCESS', '2026-09-04 09:30:00', '2026-09-04 09:00:00'),
(79, 'VNP202609024', 'VNPAY', 'FULL_PAYMENT', 2100000, 'SUCCESS', '2026-09-08 11:30:00', '2026-09-08 11:00:00'),
(80, 'MOM202609025', 'MOMO', 'FULL_PAYMENT', 1960000, 'SUCCESS', '2026-09-14 14:30:00', '2026-09-14 14:00:00'),
(81, 'VNP202609026', 'VNPAY', 'FULL_PAYMENT', 3800000, 'SUCCESS', '2026-09-18 09:30:00', '2026-09-18 09:00:00');

-- ====================================================================================
-- 4. INVOICES cho các bookings CHECKED_OUT (commission 10%)
-- ====================================================================================
INSERT INTO invoices (booking_id, invoice_number, gross_amount, platform_commission_rate, commission_amount, owner_payout_amount, issued_at)
VALUES
-- Tháng 5
(38, 'INV-2026-0001', 900000, 10.00, 90000, 810000, '2026-05-05 10:00:00'),
(39, 'INV-2026-0002', 2250000, 10.00, 225000, 2025000, '2026-05-11 12:00:00'),
(40, 'INV-2026-0003', 1900000, 10.00, 190000, 1710000, '2026-05-12 10:00:00'),
(41, 'INV-2026-0004', 5500000, 10.00, 550000, 4950000, '2026-05-18 10:00:00'),
(43, 'INV-2026-0005', 8000000, 10.00, 800000, 7200000, '2026-05-25 10:00:00'),
(44, 'INV-2026-0006', 28000000, 10.00, 2800000, 25200000, '2026-05-31 10:00:00'),
-- Tháng 6
(45, 'INV-2026-0007', 1300000, 10.00, 130000, 1170000, '2026-06-03 10:00:00'),
(46, 'INV-2026-0008', 1800000, 10.00, 180000, 1620000, '2026-06-07 10:00:00'),
(47, 'INV-2026-0009', 5100000, 10.00, 510000, 4590000, '2026-06-10 10:00:00'),
(48, 'INV-2026-0010', 2250000, 10.00, 225000, 2025000, '2026-06-13 10:00:00'),
(49, 'INV-2026-0011', 4600000, 10.00, 460000, 4140000, '2026-06-15 10:00:00'),
(51, 'INV-2026-0012', 10100000, 10.00, 1010000, 9090000, '2026-06-21 10:00:00'),
(52, 'INV-2026-0013', 2850000, 10.00, 285000, 2565000, '2026-06-25 10:00:00'),
(53, 'INV-2026-0014', 5600000, 10.00, 560000, 5040000, '2026-06-30 10:00:00'),
-- Tháng 7
(54, 'INV-2026-0015', 8000000, 10.00, 800000, 7200000, '2026-07-04 10:00:00'),
(55, 'INV-2026-0016', 7600000, 10.00, 760000, 6840000, '2026-07-05 10:00:00'),
(56, 'INV-2026-0017', 300000, 10.00, 30000, 270000, '2026-07-05 15:00:00'),
(57, 'INV-2026-0018', 3600000, 10.00, 360000, 3240000, '2026-07-08 10:00:00'),
(58, 'INV-2026-0019', 2250000, 10.00, 225000, 2025000, '2026-07-10 10:00:00'),
(59, 'INV-2026-0020', 7600000, 10.00, 760000, 6840000, '2026-07-14 10:00:00'),
(60, 'INV-2026-0021', 20000000, 10.00, 2000000, 18000000, '2026-07-15 10:00:00'),
(61, 'INV-2026-0022', 3600000, 10.00, 360000, 3240000, '2026-07-17 10:00:00'),
(62, 'INV-2026-0023', 5700000, 10.00, 570000, 5130000, '2026-07-21 10:00:00'),
(63, 'INV-2026-0024', 4500000, 10.00, 450000, 4050000, '2026-07-23 10:00:00'),
(64, 'INV-2026-0025', 6900000, 10.00, 690000, 6210000, '2026-07-26 10:00:00'),
-- Tháng 8
(66, 'INV-2026-0026', 10200000, 10.00, 1020000, 9180000, '2026-08-04 10:00:00'),
(67, 'INV-2026-0027', 2400000, 10.00, 240000, 2160000, '2026-08-06 10:00:00'),
(68, 'INV-2026-0028', 11900000, 10.00, 1190000, 10710000, '2026-08-08 10:00:00'),
(69, 'INV-2026-0029', 1900000, 10.00, 190000, 1710000, '2026-08-10 10:00:00'),
(70, 'INV-2026-0030', 5100000, 10.00, 510000, 4590000, '2026-08-13 10:00:00'),
(71, 'INV-2026-0031', 10500000, 10.00, 1050000, 9450000, '2026-08-17 10:00:00'),
(72, 'INV-2026-0032', 7500000, 10.00, 750000, 6750000, '2026-08-18 10:00:00'),
(73, 'INV-2026-0033', 3600000, 10.00, 360000, 3240000, '2026-08-20 10:00:00'),
(74, 'INV-2026-0034', 14000000, 10.00, 1400000, 12600000, '2026-08-24 10:00:00'),
(76, 'INV-2026-0035', 29500000, 10.00, 2950000, 26550000, '2026-08-31 10:00:00'),
-- Tháng 9
(77, 'INV-2026-0036', 20000000, 10.00, 2000000, 18000000, '2026-09-05 10:00:00'),
(78, 'INV-2026-0037', 7800000, 10.00, 780000, 7020000, '2026-09-11 10:00:00'),
(79, 'INV-2026-0038', 2100000, 10.00, 210000, 1890000, '2026-09-15 10:00:00'),
(80, 'INV-2026-0039', 1960000, 10.00, 196000, 1764000, '2026-09-20 10:00:00'),
(81, 'INV-2026-0040', 3800000, 10.00, 380000, 3420000, '2026-09-25 10:00:00');

-- ====================================================================================
-- 5. REVIEWS đa dạng cho các bookings CHECKED_OUT
-- ====================================================================================
INSERT INTO reviews (booking_id, customer_id, homestay_id, rating_cleanliness, rating_service, rating_location, rating_value, rating_overall, comment, created_at)
VALUES
(38, 20, 1, 5, 5, 4, 5, 4.75, 'Phòng sạch sẽ, view đẹp, nhân viên thân thiện. Rất đáng tiền!', '2026-05-06 08:00:00'),
(39, 21, 3, 4, 5, 5, 4, 4.50, 'Vị trí tuyệt vời ngay trung tâm phố cổ. Sẽ quay lại lần sau.', '2026-05-12 09:00:00'),
(41, 22, 9, 5, 4, 5, 4, 4.50, 'View biển cực đẹp, giá hơi cao nhưng xứng đáng.', '2026-05-19 10:00:00'),
(43, 23, 5, 5, 5, 5, 5, 5.00, 'Trải nghiệm tuyệt vời nhất từ trước đến nay! Villa Phú Quốc này đỉnh của đỉnh.', '2026-05-26 11:00:00'),
(44, 11, 13, 4, 4, 5, 3, 4.00, 'Villa rộng rãi nhưng dịch vụ cần cải thiện thêm. Vị trí đẹp.', '2026-06-02 09:00:00'),
(45, 24, 2, 5, 5, 4, 5, 4.75, 'Homestay Đà Lạt rất ấm cúng, đặc biệt là buổi sáng sương mù.', '2026-06-04 08:00:00'),
(47, 12, 9, 4, 5, 5, 4, 4.50, 'Dịch vụ chuyên nghiệp, phòng sạch, sẽ giới thiệu cho bạn bè.', '2026-06-11 10:00:00'),
(48, 25, 1, 5, 4, 4, 5, 4.50, 'Cảm giác như ở nhà, chủ nhà rất nhiệt tình hướng dẫn.', '2026-06-14 09:00:00'),
(49, 21, 3, 5, 5, 5, 4, 4.75, 'Lần thứ 2 tôi ở đây và lần nào cũng hài lòng!', '2026-06-16 11:00:00'),
(51, 26, 5, 5, 5, 5, 5, 5.00, 'Pool access tuyệt vời, biển đẹp, staff super friendly!', '2026-06-22 08:00:00'),
(53, 14, 9, 4, 4, 5, 4, 4.25, 'Phòng ổn, giá tốt so với khu vực Nha Trang.', '2026-07-01 09:00:00'),
(54, 27, 5, 5, 5, 5, 5, 5.00, 'Ocean view phòng này không chê được gì cả. Hoàn hảo!', '2026-07-05 10:00:00'),
(55, 23, 9, 4, 5, 5, 4, 4.50, 'Balcony view biển tuyệt đẹp vào buổi sáng. Rất thư giãn.', '2026-07-06 11:00:00'),
(57, 15, 1, 5, 4, 4, 5, 4.50, 'Chalet Đà Lạt ấm áp, lò sưởi hoạt động tốt dù là tháng 7.', '2026-07-09 09:00:00'),
(58, 25, 3, 4, 5, 5, 4, 4.50, 'Phòng cổ điển Hội An rất có hồn, đèn lồng lung linh.', '2026-07-11 10:00:00'),
(59, 26, 11, 5, 5, 4, 4, 4.50, 'Valley view Sa Pa sáng sớm có mây che đỉnh núi, quá đẹp!', '2026-07-15 08:00:00'),
(60, 16, 5, 5, 5, 5, 4, 4.75, 'Beach Villa xứng tầm 5 sao. Đặc biệt bữa sáng phục vụ tận nơi.', '2026-07-16 09:00:00'),
(61, 28, 7, 4, 4, 5, 4, 4.25, 'Vị trí trung tâm Hà Nội, di chuyển rất thuận tiện.', '2026-07-18 11:00:00'),
(62, 20, 9, 5, 5, 5, 5, 5.00, 'Suite Executive đỉnh quá! Bathtub nhìn ra biển là highlight.', '2026-07-22 10:00:00'),
(63, 29, 2, 4, 4, 4, 5, 4.25, 'Suite gia đình rộng rãi, phù hợp cho gia đình có trẻ em.', '2026-07-24 09:00:00'),
(64, 21, 13, 3, 4, 5, 3, 3.75, 'View biển Đà Nẵng đẹp nhưng phòng cần cải thiện vệ sinh.', '2026-07-27 08:00:00'),
(66, 27, 5, 5, 5, 5, 5, 5.00, 'Pool Access Deluxe - Nằm cạnh hồ bơi nhìn ra biển, thần tiên!', '2026-08-05 10:00:00'),
(67, 22, 1, 5, 5, 4, 5, 4.75, 'Đà Lạt dịp hè mát mẻ, phòng Deluxe rất thoáng đãng.', '2026-08-07 09:00:00'),
(68, 10, 9, 5, 5, 5, 4, 4.75, 'Suite Executive Nha Trang - Sang trọng, dịch vụ 5 sao thực sự.', '2026-08-09 11:00:00'),
(70, 23, 3, 4, 5, 5, 4, 4.50, 'Suite Phố Cổ Hội An - Không gian tuyệt vời, nhất là đêm.', '2026-08-14 08:00:00'),
(71, 29, 11, 5, 4, 4, 5, 4.50, 'Bungalow Sa Pa view thung lũng, không khí trong lành tuyệt.', '2026-08-18 10:00:00'),
(72, 15, 5, 5, 5, 5, 5, 5.00, 'Lần thứ 3 đặt Phú Quốc, lần nào cũng hài lòng 100%.', '2026-08-19 09:00:00'),
(73, 24, 9, 4, 4, 5, 4, 4.25, 'Phòng view biển thoáng đãng, giá hợp lý cho Nha Trang.', '2026-08-21 11:00:00'),
(74, 26, 2, 5, 5, 4, 4, 4.50, 'Villa toàn bộ cho cả gia đình - không gian riêng tư hoàn toàn.', '2026-08-25 09:00:00'),
(76, 20, 13, 4, 4, 5, 3, 4.00, 'Villa 4PN Đà Nẵng rộng đủ cho cả đoàn 10 người. Giá tốt.', '2026-09-01 10:00:00'),
(77, 25, 5, 5, 5, 5, 5, 5.00, 'Beach Villa Phú Quốc lần này có upgrade phòng miễn phí, tuyệt!', '2026-09-06 09:00:00'),
(78, 27, 9, 4, 5, 5, 4, 4.50, 'Deluxe Balcony view biển buổi sáng cực kỳ thơ mộng.', '2026-09-12 11:00:00'),
(79, 16, 3, 5, 4, 5, 5, 4.75, 'Phòng Cổ Điển Hội An - Không gian vintage, ảnh check-in đẹp.', '2026-09-16 08:00:00'),
(80, 28, 11, 4, 4, 4, 4, 4.00, 'Mountain View Sa Pa - Khá ổn, phù hợp budget travel.', '2026-09-21 10:00:00'),
(81, 29, 1, 5, 5, 4, 5, 4.75, 'Chalet Đà Lạt Superior - Lò sưởi, cửa kính nhìn rừng thông.', '2026-09-26 09:00:00');

-- ====================================================================================
-- 6. CẬP NHẬT rating_avg và review_count cho homestays
-- ====================================================================================
UPDATE homestays h SET
  rating_avg = (
    SELECT ROUND(AVG(rating_overall), 2) FROM reviews r WHERE r.homestay_id = h.homestay_id
  ),
  review_count = (
    SELECT COUNT(*) FROM reviews r WHERE r.homestay_id = h.homestay_id
  )
WHERE homestay_id IN (1,2,3,5,7,9,11,13);

-- ====================================================================================
-- 7. USERS đăng ký mới - cập nhật created_at để phân bổ đều 6 tháng
-- ====================================================================================
UPDATE users SET created_at = '2026-05-03 08:10:00' WHERE user_id = 20;
UPDATE users SET created_at = '2026-05-10 09:22:00' WHERE user_id = 21;
UPDATE users SET created_at = '2026-05-18 14:05:00' WHERE user_id = 22;
UPDATE users SET created_at = '2026-06-02 10:30:00' WHERE user_id = 23;
UPDATE users SET created_at = '2026-06-15 16:45:00' WHERE user_id = 24;
UPDATE users SET created_at = '2026-07-01 11:00:00' WHERE user_id = 25;
UPDATE users SET created_at = '2026-07-20 08:55:00' WHERE user_id = 26;
UPDATE users SET created_at = '2026-08-05 13:20:00' WHERE user_id = 27;
UPDATE users SET created_at = '2026-08-22 09:10:00' WHERE user_id = 28;
UPDATE users SET created_at = '2026-09-05 15:30:00' WHERE user_id = 29;

-- ====================================================================================
-- KIỂM TRA NHANH
-- ====================================================================================
SELECT
  DATE_FORMAT(b.created_at, '%Y-%m') AS thang,
  COUNT(*) AS so_booking,
  SUM(CASE WHEN b.booking_status = 'CHECKED_OUT' THEN 1 ELSE 0 END) AS thanh_cong,
  SUM(CASE WHEN b.booking_status = 'CANCELLED' THEN 1 ELSE 0 END) AS huy,
  FORMAT(SUM(CASE WHEN b.booking_status = 'CHECKED_OUT' THEN b.final_total ELSE 0 END), 0) AS doanh_thu
FROM bookings b
GROUP BY thang
ORDER BY thang;

SELECT 'Tổng bookings' as label, COUNT(*) as value FROM bookings
UNION ALL SELECT 'Tổng payments SUCCESS', COUNT(*) FROM payments WHERE payment_status = 'SUCCESS'
UNION ALL SELECT 'Tổng invoices', COUNT(*) FROM invoices
UNION ALL SELECT 'Tổng reviews', COUNT(*) FROM reviews
UNION ALL SELECT 'Tổng users', COUNT(*) FROM users;
