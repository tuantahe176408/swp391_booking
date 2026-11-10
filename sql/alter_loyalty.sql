-- ====================================================================================
-- LOYALTY POINTS SYSTEM — DB MIGRATION
-- Apply to: smart_booking_db
-- Compatible: MySQL 5.7+ / MySQL 8.0+
-- ====================================================================================

USE smart_booking_db;

-- 1. Add loyalty columns to users table
--    (Run once on a fresh database — columns do not exist yet)
--    If you get "Duplicate column name", the columns are already there — skip this block.
ALTER TABLE users
    ADD COLUMN loyalty_points_balance INT NOT NULL DEFAULT 0
        COMMENT 'Số điểm hiện có (có thể dùng để đổi quà)',
    ADD COLUMN loyalty_total_earned INT NOT NULL DEFAULT 0
        COMMENT 'Tổng điểm đã tích lũy (tính tier)',
    ADD COLUMN loyalty_tier
        ENUM('BRONZE','SILVER','GOLD','PLATINUM') NOT NULL DEFAULT 'BRONZE'
        COMMENT 'Hạng thành viên: BRONZE / SILVER / GOLD / PLATINUM';

-- 2. Create loyalty_transactions table
--    CREATE TABLE IF NOT EXISTS is supported on all MySQL versions.
CREATE TABLE IF NOT EXISTS loyalty_transactions (
    transaction_id  INT AUTO_INCREMENT PRIMARY KEY,
    user_id         INT NOT NULL,
    booking_id      INT NULL     COMMENT 'Liên kết đơn đặt phòng (nếu có)',
    points          INT NOT NULL COMMENT 'Dương = tích điểm, Âm = dùng điểm',
    transaction_type ENUM('EARN','REDEEM','REFUND','ADJUSTMENT') NOT NULL DEFAULT 'EARN',
    description     VARCHAR(255) NULL,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id)    REFERENCES users(user_id)    ON DELETE CASCADE,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE SET NULL,

    INDEX idx_loyalty_user    (user_id),
    INDEX idx_loyalty_booking (booking_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
