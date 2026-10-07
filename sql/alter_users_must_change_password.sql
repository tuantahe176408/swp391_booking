-- ====================================================================================
-- SMART BOOKING PLATFORM - SQL MIGRATION SCRIPT
-- Mục đích: Bổ sung cột `must_change_password` vào bảng `users`
-- ====================================================================================

USE smart_booking_db;

-- Chạy câu lệnh này:
ALTER TABLE users 
ADD COLUMN must_change_password BOOLEAN NOT NULL DEFAULT FALSE 
COMMENT 'Bat buoc doi mat khau khi dang nhap lan dau bang mat khau tam';
