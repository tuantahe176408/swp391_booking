-- ============================================================
-- seed_receptionist_test.sql
-- Tài khoản test cho actor Lễ tân (RECEPTIONIST) - UC12..UC16
-- Chạy SAU schema.sql + seed_search_data.sql
-- ============================================================
--
-- MẬT KHẨU:  Admin@123  (BCrypt hash tái sử dụng từ các account test sẵn có)
--
-- TÀI KHOẢN TẠO:
--   reception.hoian@smartbooking.vn   → Lễ tân Hội An Ancient Town Boutique (homestay_id = 3)
--   reception.dalat@smartbooking.vn   → Lễ tân Đà Lạt Pine Valley Homestay (homestay_id = 1)
-- ============================================================

-- 1) Tạo user với role RECEPTIONIST
INSERT INTO users (email, password_hash, full_name, phone_number, role, auth_provider, is_active, is_email_verified)
VALUES
    ('reception.hoian@smartbooking.vn', '$2a$12$hZH1OZp1RO3t4Bk.1Y/0tOc.9dOHW5y39WA1/F7h3UzNfZLzoxzpa',
     'Lễ Tân Hội An', '0911222333', 'RECEPTIONIST', 'LOCAL', 1, 1),
    ('reception.dalat@smartbooking.vn', '$2a$12$hZH1OZp1RO3t4Bk.1Y/0tOc.9dOHW5y39WA1/F7h3UzNfZLzoxzpa',
     'Lễ Tân Đà Lạt', '0911444555', 'RECEPTIONIST', 'LOCAL', 1, 1)
ON DUPLICATE KEY UPDATE
    password_hash = VALUES(password_hash),
    full_name     = VALUES(full_name),
    role          = VALUES(role),
    is_active     = 1,
    is_email_verified = 1;

-- 2) Gán lễ tân vào homestay (receptionist_staff)
INSERT INTO receptionist_staff (user_id, homestay_id)
SELECT u.user_id, 3 FROM users u WHERE u.email = 'reception.hoian@smartbooking.vn'
ON DUPLICATE KEY UPDATE homestay_id = VALUES(homestay_id);

INSERT INTO receptionist_staff (user_id, homestay_id)
SELECT u.user_id, 1 FROM users u WHERE u.email = 'reception.dalat@smartbooking.vn'
ON DUPLICATE KEY UPDATE homestay_id = VALUES(homestay_id);

-- ============================================================
-- FIX: Thêm CHECKED_IN booking cho phòng 103 Hội An (homestay_id=3)
-- Mục đích: Room Matrix UC13 hiển thị đúng tên khách cho phòng OCCUPIED
--
-- Phòng 103 trong seed_search_data.sql được seeded là OCCUPIED nhưng
-- không có booking CHECKED_IN → currentGuestName = null → hiện "Đang có khách"
-- ============================================================

-- Lấy room_id của phòng 103 (Phòng Cổ Điển - room_type_id=7) trong homestay 3
SET @room103_id = (
    SELECT r.room_id FROM rooms r
    JOIN room_types rt ON r.room_type_id = rt.room_type_id
    WHERE rt.homestay_id = 3 AND r.room_number = '103'
    LIMIT 1
);

-- Lấy user_id của lễ tân Hội An để gán receptionist_id
SET @lt_hoian_id = (
    SELECT user_id FROM users WHERE email = 'reception.hoian@smartbooking.vn' LIMIT 1
);

-- Lấy customer_id (dùng tài khoản customer sẵn có)
SET @cust_id = (
    SELECT user_id FROM users WHERE email = 'khanh.nguyen.customer@gmail.com' LIMIT 1
);

-- Tạo booking CHECKED_IN cho phòng 103 (checkin hôm nay, checkout sau 2 ngày)
INSERT INTO bookings (
    booking_code, customer_id, homestay_id, room_type_id, assigned_room_id,
    guest_name, guest_email, guest_phone,
    checkin_date, checkout_date, total_nights,
    room_price_total, addon_price_total, surcharge_total, discount_amount, final_total,
    booking_type, booking_status, receptionist_id
)
SELECT
    'BK-RECTEST-HC103',
    @cust_id,
    3,
    rt.room_type_id,
    @room103_id,
    'Phạm Gia Hưng',
    'khanh.nguyen.customer@gmail.com',
    '0901999888',
    CURDATE(),
    DATE_ADD(CURDATE(), INTERVAL 2 DAY),
    2,
    1600000.00, 0.00, 0.00, 0.00, 1600000.00,
    'ONLINE',
    'CHECKED_IN',
    @lt_hoian_id
FROM room_types rt
WHERE rt.homestay_id = 3 AND rt.room_type_id = 7
LIMIT 1
ON DUPLICATE KEY UPDATE
    booking_status   = 'CHECKED_IN',
    assigned_room_id = @room103_id,
    receptionist_id  = @lt_hoian_id;

-- Đảm bảo room 103 ở trạng thái OCCUPIED (phòng hiện có khách)
UPDATE rooms SET status = 'OCCUPIED'
WHERE room_id = @room103_id AND @room103_id IS NOT NULL;
