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
