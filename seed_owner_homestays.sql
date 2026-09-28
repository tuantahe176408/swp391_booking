-- ====================================================================================
-- UC17 SEED: thêm homestay PENDING_APPROVAL, REJECTED, INACTIVE cho nguyenvana
-- Mục đích: test đầy đủ tất cả status cases trên trang /owner/homestays
-- Owner: nguyenvana.owner@gmail.com (homestay_id 1 & 2 đã có trong seed_search_data.sql)
--
-- Chạy sau khi đã chạy schema.sql + seed_search_data.sql
-- ====================================================================================

-- HS mới đăng chờ duyệt (PENDING_APPROVAL)
INSERT INTO homestays (owner_id, name, description, address, city, district, latitude, longitude,
                       status, checkin_time, checkout_time, rating_avg, review_count)
VALUES (
    (SELECT user_id FROM users WHERE email = 'nguyenvana.owner@gmail.com'),
    'Đà Lạt Misty Valley Homestay',
    'Homestay nhỏ trên đồi sương mù Đà Lạt, 3 phòng view rừng thông, yên tĩnh và thơ mộng.',
    '98 Khe Sanh, Phường 10', 'Đà Lạt', 'Phường 10',
    11.9300, 108.4550,
    'PENDING_APPROVAL', '14:00:00', '12:00:00', 0.00, 0
);

-- Room types cho homestay PENDING vừa tạo
INSERT INTO room_types (homestay_id, name, description, base_price, max_occupancy, bed_count, room_size_sqm)
VALUES (
    (SELECT homestay_id FROM homestays WHERE name = 'Đà Lạt Misty Valley Homestay' LIMIT 1),
    'Phòng Standard', 'Phòng đơn giản thoáng mát view đồi', 380000, 2, 1, 18
),
(
    (SELECT homestay_id FROM homestays WHERE name = 'Đà Lạt Misty Valley Homestay' LIMIT 1),
    'Phòng Deluxe', 'Phòng rộng hơn với ban công riêng, view thung lũng', 620000, 2, 1, 28
);

-- Rooms cho homestay PENDING
INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status)
SELECT rt.room_type_id, '101', 'AVAILABLE', 'CLEAN'
FROM room_types rt JOIN homestays h ON rt.homestay_id = h.homestay_id
WHERE h.name = 'Đà Lạt Misty Valley Homestay' AND rt.name = 'Phòng Standard' LIMIT 1;

INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status)
SELECT rt.room_type_id, '102', 'AVAILABLE', 'CLEAN'
FROM room_types rt JOIN homestays h ON rt.homestay_id = h.homestay_id
WHERE h.name = 'Đà Lạt Misty Valley Homestay' AND rt.name = 'Phòng Standard' LIMIT 1;

INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status)
SELECT rt.room_type_id, '201', 'AVAILABLE', 'CLEAN'
FROM room_types rt JOIN homestays h ON rt.homestay_id = h.homestay_id
WHERE h.name = 'Đà Lạt Misty Valley Homestay' AND rt.name = 'Phòng Deluxe' LIMIT 1;

-- HS bị từ chối (REJECTED) với lý do cụ thể
INSERT INTO homestays (owner_id, name, description, address, city, district, latitude, longitude,
                       status, rejection_reason, checkin_time, checkout_time, rating_avg, review_count)
VALUES (
    (SELECT user_id FROM users WHERE email = 'nguyenvana.owner@gmail.com'),
    'Đà Lạt Sunset Ridge Villa',
    'Biệt thự 4 phòng ngủ trên đỉnh đồi, view toàn cảnh thành phố Đà Lạt về đêm.',
    '12 Hoa Hồng, Phường 2', 'Đà Lạt', 'Phường 2',
    11.9450, 108.4380,
    'REJECTED',
    'Hình ảnh không đủ chất lượng HD (tối thiểu 5 ảnh 1920×1080). Mô tả chưa đầy đủ tiện ích. Vui lòng cập nhật và gửi lại.',
    '15:00:00', '11:00:00', 0.00, 0
);

-- HS tự tắt/tạm ngừng (INACTIVE) — owner chủ động ẩn
INSERT INTO homestays (owner_id, name, description, address, city, district, latitude, longitude,
                       status, checkin_time, checkout_time, rating_avg, review_count)
VALUES (
    (SELECT user_id FROM users WHERE email = 'nguyenvana.owner@gmail.com'),
    'Đà Lạt Rose Garden Bungalow',
    'Khu bungalow 2 căn giữa vườn hoa hồng, đang cải tạo tháng 10/2026.',
    '55 Vạn Thành, Phường 5', 'Đà Lạt', 'Phường 5',
    11.9510, 108.4620,
    'INACTIVE', '14:00:00', '12:00:00', 4.30, 11
);

-- Room type cho INACTIVE homestay (đã có lịch sử hoạt động)
INSERT INTO room_types (homestay_id, name, description, base_price, max_occupancy, bed_count, room_size_sqm)
VALUES (
    (SELECT homestay_id FROM homestays WHERE name = 'Đà Lạt Rose Garden Bungalow' LIMIT 1),
    'Bungalow Đôi', 'Bungalow riêng biệt giữa vườn hoa', 900000, 2, 1, 35
);

INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status)
SELECT rt.room_type_id, 'BG-01', 'MAINTENANCE', 'CLEAN'
FROM room_types rt JOIN homestays h ON rt.homestay_id = h.homestay_id
WHERE h.name = 'Đà Lạt Rose Garden Bungalow' LIMIT 1;

INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status)
SELECT rt.room_type_id, 'BG-02', 'MAINTENANCE', 'CLEAN'
FROM room_types rt JOIN homestays h ON rt.homestay_id = h.homestay_id
WHERE h.name = 'Đà Lạt Rose Garden Bungalow' LIMIT 1;

-- ====================================================================================
-- Kết quả sau khi chạy: owner nguyenvana có 5 homestay:
--   ID 1: Đà Lạt Pine Valley Homestay       → ACTIVE     (từ seed_search_data.sql)
--   ID 2: Ana Garden Villa Đà Lạt           → ACTIVE     (từ seed_search_data.sql)
--   ID ?: Đà Lạt Misty Valley Homestay      → PENDING_APPROVAL (3 phòng)
--   ID ?: Đà Lạt Sunset Ridge Villa         → REJECTED   (0 phòng, có rejection_reason)
--   ID ?: Đà Lạt Rose Garden Bungalow       → INACTIVE   (2 phòng, đang bảo trì)
-- ====================================================================================
