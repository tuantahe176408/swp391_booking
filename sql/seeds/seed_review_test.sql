-- ============================================================
-- seed_review_test.sql
-- Dữ liệu test cho UC10 (Review & Rating)
-- Chạy SAU schema.sql + seed_search_data.sql
-- ============================================================
--
-- MỤC ĐÍCH:
--   Tạo các booking CHECKED_OUT chưa có review để test nút "Viết đánh giá".
--   Kết hợp với BK-20261001-0001 (Khanh đã review) → test được cả 2 state:
--     ✅ "Đã đánh giá" badge (BK01 của Khanh)
--     ⭐ "Viết đánh giá" button (BK11, BK12, BK13)
--
-- TÀI KHOẢN TEST:  (tất cả mật khẩu = Admin@123)
--   khanh.nguyen.customer@gmail.com  → BK01(reviewed) + BK11(chưa review)
--   linh.tran.customer@gmail.com     → BK12 (chưa review)
--   duc.pham.customer@gmail.com      → BK13 (chưa review)
-- ============================================================

SET FOREIGN_KEY_CHECKS = 0;

INSERT INTO bookings (
    booking_code, customer_id, homestay_id, room_type_id, assigned_room_id,
    guest_name, guest_email, guest_phone,
    checkin_date, checkout_date, total_nights,
    room_price_total, addon_price_total, surcharge_total,
    voucher_id, discount_amount, final_total,
    booking_type, booking_status
) VALUES

-- BK11: Khanh — Hội An Ancient Town — CHECKED_OUT, CHƯA REVIEW
-- → Login khanh.nguyen.customer@gmail.com/Admin@123, vào "Đơn đặt phòng"
--   → BK01 hiện badge "Đã đánh giá", BK11 hiện nút "Viết đánh giá"
(
    'BK-20261002-0011',
    (SELECT user_id FROM users WHERE email = 'khanh.nguyen.customer@gmail.com'),
    3, 8, NULL,
    'Nguyễn Tuấn Khanh', 'khanh.nguyen.customer@gmail.com', '0901111001',
    '2026-10-02', '2026-10-04', 2,
    3200000.00, 0.00, 0.00, NULL, 0.00, 3200000.00,
    'ONLINE', 'CHECKED_OUT'
),

-- BK12: Linh — Đà Lạt Pine Valley — CHECKED_OUT, CHƯA REVIEW
-- → Login linh.tran.customer@gmail.com/Admin@123
(
    'BK-20261003-0012',
    (SELECT user_id FROM users WHERE email = 'linh.tran.customer@gmail.com'),
    1, 2, NULL,
    'Trần Hồng Linh', 'linh.tran.customer@gmail.com', '0902222002',
    '2026-10-03', '2026-10-05', 2,
    1500000.00, 0.00, 0.00, NULL, 0.00, 1500000.00,
    'ONLINE', 'CHECKED_OUT'
),

-- BK13: Đức — Sapa Cloud Ridge Retreat — CHECKED_OUT, CHƯA REVIEW
-- → Login duc.pham.customer@gmail.com/Admin@123
(
    'BK-20261006-0013',
    (SELECT user_id FROM users WHERE email = 'duc.pham.customer@gmail.com'),
    11, 26, NULL,
    'Phạm Tiến Đức', 'duc.pham.customer@gmail.com', '0904444004',
    '2026-10-06', '2026-10-08', 2,
    2940000.00, 0.00, 0.00, NULL, 0.00, 2940000.00,
    'ONLINE', 'CHECKED_OUT'
);

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- KỊCH BẢN TEST GỢI Ý
-- ============================================================
-- 1. HAPPY PATH — Viết đánh giá thành công:
--    a. Đăng nhập: khanh.nguyen.customer@gmail.com / Admin@123
--    b. Vào menu "Đơn đặt phòng của tôi"
--    c. BK-20261001-0001 → hiện badge xanh "✓ Đã đánh giá"
--    d. BK-20261002-0011 → hiện nút vàng "⭐ Viết đánh giá" → click
--    e. Chấm 4 tiêu chí, nhập comment ≥ 10 ký tự → "Gửi đánh giá"
--    f. Kết quả: redirect về danh sách, toast "Cảm ơn bạn đã gửi đánh giá..."
--    g. BK-20261002-0011 đổi thành badge "✓ Đã đánh giá"
--    h. Vào trang detail homestay Hội An → rating_avg và review_count cập nhật
--
-- 2. DUPLICATE GUARD — Gửi lại review:
--    a. Vào lại URL /customer/review?bookingId=<BK01's id>
--    b. Kết quả: redirect về danh sách + thông báo lỗi "Bạn đã gửi đánh giá rồi"
--
-- 3. VALIDATION — Comment quá ngắn:
--    a. Click "Viết đánh giá" cho BK12 (Linh)
--    b. Nhập comment < 10 ký tự → click Gửi
--    c. Kết quả: form hiện lỗi, giá trị star giữ nguyên
--
-- 4. WRONG OWNER — Truy cập booking của người khác:
--    a. Đang đăng nhập là Khanh
--    b. Truy cập /customer/review?bookingId=<BK13's id> (của Đức)
--    c. Kết quả: HTTP 403 Forbidden
-- ============================================================
