-- ====================================================================================
-- SMART BOOKING PLATFORM - MYSQL DATABASE SCHEMA (HỆ THỐNG ĐẶT PHÒNG HOMESTAY & HOTEL)
-- Architecture: JSP/Servlet Java Web MVC
-- Compatibility: MySQL 8.0+ / MariaDB 10.3+
-- Charset: utf8mb4 (Full Vietnamese & Emoji Support)
-- Sync Status: 100% aligned with 26 Use Cases (UC01 - UC26) & AGENTS.md conventions
-- ====================================================================================

CREATE DATABASE IF NOT EXISTS smart_booking_db 
DEFAULT CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE smart_booking_db;

-- Disable foreign key checks for clean drop sequence
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS audit_logs;
DROP TABLE IF EXISTS system_configs;
DROP TABLE IF EXISTS ai_recommendation_logs;
DROP TABLE IF EXISTS review_images;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS invoices;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS surcharges;
DROP TABLE IF EXISTS booking_addons;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS wishlists;
DROP TABLE IF EXISTS addons;
DROP TABLE IF EXISTS vouchers;
DROP TABLE IF EXISTS dynamic_prices;
DROP TABLE IF EXISTS rooms;
DROP TABLE IF EXISTS room_types;
DROP TABLE IF EXISTS receptionist_staff;
DROP TABLE IF EXISTS homestay_amenities;
DROP TABLE IF EXISTS amenities;
DROP TABLE IF EXISTS homestay_images;
DROP TABLE IF EXISTS homestays;
DROP TABLE IF EXISTS user_preferences;
DROP TABLE IF EXISTS user_otps;
DROP TABLE IF EXISTS users;

SET FOREIGN_KEY_CHECKS = 1;

-- ====================================================================================
-- 1. USER & AUTHENTICATION MODULE (UC01, UC02, UC21, UC22)
-- ====================================================================================

-- Users Table: Stores Customers, Receptionists, Owners, and System Admins
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NULL COMMENT 'BCrypt hash. NULL for Google OAuth accounts',
    full_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20) NULL,
    avatar_url VARCHAR(500) NULL COMMENT 'Cloudinary URL',
    role ENUM('CUSTOMER', 'RECEPTIONIST', 'OWNER', 'ADMIN') NOT NULL DEFAULT 'CUSTOMER',
    auth_provider ENUM('LOCAL', 'GOOGLE') NOT NULL DEFAULT 'LOCAL',
    google_id VARCHAR(255) NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE COMMENT 'UC22: Admin lock/unlock flag',
    is_email_verified BOOLEAN NOT NULL DEFAULT FALSE,
    failed_login_attempts INT NOT NULL DEFAULT 0,
    lockout_until DATETIME NULL COMMENT 'Lockout account after 5 failed attempts',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_user_email (email),
    INDEX idx_user_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- User OTPs Table: Email OTP verification for Registration and Password Reset (UC01)
CREATE TABLE user_otps (
    otp_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    otp_code VARCHAR(10) NOT NULL,
    purpose ENUM('REGISTRATION', 'PASSWORD_RESET', 'LOGIN') NOT NULL,
    expires_at DATETIME NOT NULL,
    is_used BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_otp_user (user_id, otp_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- User Preferences Table: Customer travel interest tags for AI Recommendation (UC02, UC05)
CREATE TABLE user_preferences (
    preference_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    category VARCHAR(50) NOT NULL COMMENT 'e.g. BEACH, MOUNTAIN, LUXURY, BUDGET, PET_FRIENDLY',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    UNIQUE KEY uk_user_category (user_id, category)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ====================================================================================
-- 2. HOMESTAY & PROPERTY LISTING MODULE (UC03, UC04, UC17, UC21, UC23)
-- ====================================================================================

-- Homestays Table: Main homestay/hotel property records
CREATE TABLE homestays (
    homestay_id INT AUTO_INCREMENT PRIMARY KEY,
    owner_id INT NOT NULL,
    name VARCHAR(200) NOT NULL,
    description TEXT NULL,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    district VARCHAR(100) NULL,
    latitude DECIMAL(10, 8) NULL COMMENT 'Google Maps coordinate (UC03)',
    longitude DECIMAL(11, 8) NULL COMMENT 'Google Maps coordinate (UC03)',
    status ENUM('PENDING_APPROVAL', 'ACTIVE', 'REJECTED', 'INACTIVE') NOT NULL DEFAULT 'PENDING_APPROVAL',
    rejection_reason TEXT NULL COMMENT 'UC23: Reason if rejected by Admin',
    checkin_time TIME DEFAULT '14:00:00',
    checkout_time TIME DEFAULT '12:00:00',
    rating_avg DECIMAL(3, 2) NOT NULL DEFAULT 0.00,
    review_count INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES users(user_id) ON DELETE RESTRICT,
    INDEX idx_homestay_owner (owner_id),
    INDEX idx_homestay_city (city),
    INDEX idx_homestay_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Homestay Images Table: HD Photos hosted on Cloudinary (UC17)
CREATE TABLE homestay_images (
    image_id INT AUTO_INCREMENT PRIMARY KEY,
    homestay_id INT NOT NULL,
    image_url VARCHAR(500) NOT NULL,
    is_primary BOOLEAN NOT NULL DEFAULT FALSE,
    display_order INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (homestay_id) REFERENCES homestays(homestay_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Master Amenities Table
CREATE TABLE amenities (
    amenity_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    icon_class VARCHAR(50) NULL COMMENT 'FontAwesome CSS icon class',
    category VARCHAR(50) DEFAULT 'GENERAL'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Homestay Amenities Mapping Table (Many-to-Many)
CREATE TABLE homestay_amenities (
    homestay_id INT NOT NULL,
    amenity_id INT NOT NULL,
    PRIMARY KEY (homestay_id, amenity_id),
    FOREIGN KEY (homestay_id) REFERENCES homestays(homestay_id) ON DELETE CASCADE,
    FOREIGN KEY (amenity_id) REFERENCES amenities(amenity_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Receptionist Staff Assignment Table (UC21)
CREATE TABLE receptionist_staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    homestay_id INT NOT NULL,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (homestay_id) REFERENCES homestays(homestay_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ====================================================================================
-- 3. ROOM MANAGEMENT & DYNAMIC PRICING MODULE (UC04, UC14, UC16, UC18)
-- ====================================================================================

-- Room Types Table: Room categories per homestay
CREATE TABLE room_types (
    room_type_id INT AUTO_INCREMENT PRIMARY KEY,
    homestay_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT NULL,
    base_price DECIMAL(12, 2) NOT NULL,
    max_occupancy INT NOT NULL DEFAULT 2,
    bed_count INT NOT NULL DEFAULT 1,
    room_size_sqm DECIMAL(6, 2) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (homestay_id) REFERENCES homestays(homestay_id) ON DELETE CASCADE,
    INDEX idx_roomtype_homestay (homestay_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Rooms Table: Physical room units (UC14 Room Availability Grid, UC16 Housekeeping)
CREATE TABLE rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_type_id INT NOT NULL,
    room_number VARCHAR(50) NOT NULL,
    status ENUM('AVAILABLE', 'OCCUPIED', 'DIRTY', 'MAINTENANCE') NOT NULL DEFAULT 'AVAILABLE',
    housekeeping_status ENUM('CLEAN', 'NEEDS_CLEANING', 'IN_PROGRESS') NOT NULL DEFAULT 'CLEAN',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (room_type_id) REFERENCES room_types(room_type_id) ON DELETE CASCADE,
    UNIQUE KEY uk_roomtype_number (room_type_id, room_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dynamic Prices Table: Seasonal & Weekend Dynamic Pricing rules (UC18)
CREATE TABLE dynamic_prices (
    price_id INT AUTO_INCREMENT PRIMARY KEY,
    room_type_id INT NOT NULL,
    date DATE NOT NULL,
    price_multiplier DECIMAL(4, 2) DEFAULT 1.00 COMMENT 'e.g. 1.25 for +25% peak rate',
    custom_price DECIMAL(12, 2) NULL COMMENT 'Explicit override price',
    is_locked BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Lock room sales for maintenance/private event',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (room_type_id) REFERENCES room_types(room_type_id) ON DELETE CASCADE,
    UNIQUE KEY uk_roomtype_date (room_type_id, date),
    INDEX idx_dynamic_price_date (date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ====================================================================================
-- 4. VOUCHERS & ADDONS MODULE (UC11, UC19, UC26)
-- ====================================================================================

-- Vouchers Table: Platform & Homestay Vouchers (UC11, UC26)
CREATE TABLE vouchers (
    voucher_id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255) NULL,
    discount_type ENUM('PERCENTAGE', 'FIXED_AMOUNT') NOT NULL,
    discount_value DECIMAL(12, 2) NOT NULL,
    min_booking_amount DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    max_discount_amount DECIMAL(12, 2) NULL COMMENT 'Max discount cap for PERCENTAGE vouchers',
    usage_limit INT NOT NULL DEFAULT 100,
    used_count INT NOT NULL DEFAULT 0,
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_by_user_id INT NULL COMMENT 'FK to Admin/Owner who created the voucher',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by_user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_voucher_code (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Addons Table: Extra services provided by Homestay (UC19)
CREATE TABLE addons (
    addon_id INT AUTO_INCREMENT PRIMARY KEY,
    homestay_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT NULL,
    price DECIMAL(12, 2) NOT NULL,
    unit VARCHAR(50) NOT NULL DEFAULT 'per stay' COMMENT 'e.g., per day, per set, per person',
    is_available BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (homestay_id) REFERENCES homestays(homestay_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Wishlists Table: Customer saved properties (UC06)
CREATE TABLE wishlists (
    wishlist_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    homestay_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (homestay_id) REFERENCES homestays(homestay_id) ON DELETE CASCADE,
    UNIQUE KEY uk_user_wishlist (user_id, homestay_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ====================================================================================
-- 5. BOOKING, RECEPTION & TRANSACTIONS MODULE (UC07, UC08, UC09, UC12, UC13, UC15)
-- ====================================================================================

-- Bookings Table: Core reservation record (UC07, UC09, UC12, UC13)
CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_code VARCHAR(30) NOT NULL UNIQUE COMMENT 'Format: BK-YYYYMMDD-XXXX',
    customer_id INT NULL COMMENT 'FK to users. Nullable for Walk-in guest without account',
    homestay_id INT NOT NULL,
    room_type_id INT NOT NULL,
    assigned_room_id INT NULL COMMENT 'Physical room assigned at Check-in (UC12, UC13)',
    guest_name VARCHAR(100) NOT NULL,
    guest_email VARCHAR(150) NOT NULL,
    guest_phone VARCHAR(20) NOT NULL,
    guest_id_card_number VARCHAR(50) NULL COMMENT 'OCR Scanned CCCD/Passport Number (UC12)',
    guest_id_card_raw_data JSON NULL COMMENT 'Raw JSON response from OCR API',
    checkin_date DATE NOT NULL,
    checkout_date DATE NOT NULL,
    total_nights INT NOT NULL,
    room_price_total DECIMAL(12, 2) NOT NULL,
    addon_price_total DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    surcharge_total DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    voucher_id INT NULL,
    discount_amount DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    final_total DECIMAL(12, 2) NOT NULL,
    booking_type ENUM('ONLINE', 'WALK_IN') NOT NULL DEFAULT 'ONLINE',
    booking_status ENUM('PENDING', 'CONFIRMED', 'CHECKED_IN', 'CHECKED_OUT', 'CANCELLED', 'REFUNDED') NOT NULL DEFAULT 'PENDING',
    hold_expires_at DATETIME NULL COMMENT '15-minute temporary room hold during payment',
    receptionist_id INT NULL COMMENT 'Staff who handled Walk-in or Check-in',
    cancellation_reason TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (homestay_id) REFERENCES homestays(homestay_id) ON DELETE RESTRICT,
    FOREIGN KEY (room_type_id) REFERENCES room_types(room_type_id) ON DELETE RESTRICT,
    FOREIGN KEY (assigned_room_id) REFERENCES rooms(room_id) ON DELETE SET NULL,
    FOREIGN KEY (voucher_id) REFERENCES vouchers(voucher_id) ON DELETE SET NULL,
    FOREIGN KEY (receptionist_id) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_booking_code (booking_code),
    INDEX idx_booking_customer (customer_id),
    INDEX idx_booking_homestay (homestay_id),
    INDEX idx_booking_dates (checkin_date, checkout_date),
    INDEX idx_booking_status (booking_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Booking Addons Junction Table: Services attached to reservation (UC07)
CREATE TABLE booking_addons (
    booking_addon_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    addon_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price DECIMAL(12, 2) NOT NULL,
    total_price DECIMAL(12, 2) NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE,
    FOREIGN KEY (addon_id) REFERENCES addons(addon_id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Surcharges Table: Extra fees imposed on-site (UC15: Early checkin, minibar, damage)
CREATE TABLE surcharges (
    surcharge_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    description VARCHAR(255) NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    created_by_staff_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE,
    FOREIGN KEY (created_by_staff_id) REFERENCES users(user_id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Payments Table: VNPay / MoMo Gateway & On-site transactions (UC08, UC09, UC15)
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    transaction_code VARCHAR(100) NULL COMMENT 'Gateway transaction ID or receipt code',
    payment_method ENUM('VNPAY', 'MOMO', 'CASH', 'POS_CARD') NOT NULL,
    payment_type ENUM('BOOKING_DEPOSIT', 'FULL_PAYMENT', 'SURCHARGE', 'REFUND') NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    payment_status ENUM('PENDING', 'SUCCESS', 'FAILED', 'REFUNDED') NOT NULL DEFAULT 'PENDING',
    gateway_checksum VARCHAR(255) NULL COMMENT 'SHA-256 HMAC checksum verification',
    gateway_response_data JSON NULL COMMENT 'Full IPN response payload',
    paid_at DATETIME NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE RESTRICT,
    INDEX idx_payment_booking (booking_id),
    INDEX idx_payment_txn (transaction_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Invoices Table: Financial accounting & commission settlement (UC20, UC25)
CREATE TABLE invoices (
    invoice_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL UNIQUE,
    invoice_number VARCHAR(50) NOT NULL UNIQUE,
    gross_amount DECIMAL(12, 2) NOT NULL,
    platform_commission_rate DECIMAL(5, 2) NOT NULL DEFAULT 10.00 COMMENT 'Platform fee percentage (e.g., 10.00%)',
    commission_amount DECIMAL(12, 2) NOT NULL COMMENT 'Calculated platform fee',
    owner_payout_amount DECIMAL(12, 2) NOT NULL COMMENT 'Gross - Commission',
    issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE RESTRICT,
    INDEX idx_invoice_number (invoice_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ====================================================================================
-- 6. REVIEW & RATING MODULE (UC10)
-- ====================================================================================

-- Reviews Table: Post-stay feedback & ratings (UC10)
CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL UNIQUE,
    customer_id INT NOT NULL,
    homestay_id INT NOT NULL,
    rating_cleanliness INT NOT NULL DEFAULT 5,
    rating_service INT NOT NULL DEFAULT 5,
    rating_location INT NOT NULL DEFAULT 5,
    rating_value INT NOT NULL DEFAULT 5,
    rating_overall DECIMAL(3, 2) NOT NULL,
    comment TEXT NULL COMMENT 'JSoup sanitized review text',
    owner_reply TEXT NULL,
    owner_replied_at DATETIME NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (homestay_id) REFERENCES homestays(homestay_id) ON DELETE CASCADE,
    INDEX idx_review_homestay (homestay_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Review Images Table: Customer uploaded media (UC10)
CREATE TABLE review_images (
    review_image_id INT AUTO_INCREMENT PRIMARY KEY,
    review_id INT NOT NULL,
    image_url VARCHAR(500) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (review_id) REFERENCES reviews(review_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ====================================================================================
-- 7. AI RECOMMENDATIONS & SYSTEM MONITORING MODULE (UC05, UC24)
-- ====================================================================================

-- AI Recommendation Logs Table: Monitoring AI Recommendation performance (UC05, UC24)
CREATE TABLE ai_recommendation_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    homestay_id INT NOT NULL,
    reason_tag VARCHAR(100) NULL COMMENT 'e.g. Based on your preference for Beach views',
    match_score DECIMAL(5, 2) NOT NULL COMMENT 'AI score %',
    is_clicked BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (homestay_id) REFERENCES homestays(homestay_id) ON DELETE CASCADE,
    INDEX idx_ai_log_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- System Configs Table: Dynamic system settings (UC24)
CREATE TABLE system_configs (
    config_key VARCHAR(100) PRIMARY KEY,
    config_value TEXT NOT NULL,
    description VARCHAR(255) NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Audit Logs Table: Admin operations & security audit trail (UC22, UC24)
CREATE TABLE audit_logs (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NULL,
    action VARCHAR(100) NOT NULL,
    details TEXT NULL,
    ip_address VARCHAR(45) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_audit_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ====================================================================================
-- SEED DATA FOR INITIAL SETUP & TESTING
-- ====================================================================================

-- System Settings (UC24)
INSERT INTO system_configs (config_key, config_value, description) VALUES
('PLATFORM_COMMISSION_RATE', '10.00', 'Tỷ lệ hoa hồng sàn tính trên đơn đặt phòng (%)'),
('BOOKING_HOLD_MINUTES', '15', 'Thời gian tạm khóa phòng chờ thanh toán (phút)'),
('MAIL_SMTP_HOST', 'smtp.gmail.com', 'Cấu hình SMTP Host gửi OTP & Vé điện tử'),
('MAIL_SMTP_PORT', '587', 'Cấu hình SMTP Port');

-- Initial System Admin Account (Password: Admin@123 hashed with BCrypt)
INSERT INTO users (email, password_hash, full_name, phone_number, role, auth_provider, is_active, is_email_verified) VALUES
('admin@smartbooking.com', '$2a$12$E1X/zS6bBqJtV3rGj.Yn2.bX3nZ8/9y1XQ/u1hGk.9z2X3nZ8/9y1', 'System Administrator', '0901234567', 'ADMIN', 'LOCAL', TRUE, TRUE);

-- Master Amenities (UC17)
INSERT INTO amenities (name, icon_class, category) VALUES
('Free Wi-Fi', 'fa-wifi', 'GENERAL'),
('Hồ bơi ngoài trời', 'fa-swimming-pool', 'OUTDOOR'),
('Bãi đỗ xe ô tô', 'fa-car', 'GENERAL'),
('Điều hòa nhiệt độ', 'fa-snowflake', 'ROOM'),
('Máy giặt & Sấy', 'fa-soap', 'ROOM'),
('Bếp & Dụng cụ nấu ăn', 'fa-utensils', 'KITCHEN'),
('Bàn BBQ ngoài trời', 'fa-fire', 'OUTDOOR'),
('Cho phép mang thú cưng', 'fa-dog', 'POLICY');

-- Platform Voucher (UC26)
INSERT INTO vouchers (code, description, discount_type, discount_value, min_booking_amount, max_discount_amount, usage_limit, used_count, start_date, end_date, is_active) VALUES
('WELCOME2026', 'Giảm 10% tối đa 200,000đ cho đơn hàng đầu tiên', 'PERCENTAGE', 10.00, 500000.00, 200000.00, 1000, 0, '2026-01-01 00:00:00', '2026-12-31 23:59:59', TRUE);
