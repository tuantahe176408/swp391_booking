-- ====================================================================================
-- SEED DATA - BỔ SUNG PHÒNG VẬT LÝ CHO CÁC HOMESTAY (UC03, UC14)
-- Mô tả: Thêm phòng vật lý (table: rooms) cho 7 homestay còn lại để đủ điều kiện
--       hiển thị trên màn hình tìm kiếm (available rooms > 0).
-- Tác giả: tuantahe176408 (UC12–UC16 scope)
-- Ngày: 2026-10-07
-- ====================================================================================

USE smart_booking_db;

-- 1. HS 4: Riverside Retreat Hội An
INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status)
SELECT rt.room_type_id, 'BG101', 'AVAILABLE', 'CLEAN'
FROM room_types rt WHERE rt.homestay_id = 4 AND rt.name LIKE 'Bungalow Tiêu Chuẩn%'
AND NOT EXISTS (SELECT 1 FROM rooms r WHERE r.room_type_id = rt.room_type_id AND r.room_number = 'BG101');

INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status)
SELECT rt.room_type_id, 'BG102', 'AVAILABLE', 'CLEAN'
FROM room_types rt WHERE rt.homestay_id = 4 AND rt.name LIKE 'Bungalow Tiêu Chuẩn%'
AND NOT EXISTS (SELECT 1 FROM rooms r WHERE r.room_type_id = rt.room_type_id AND r.room_number = 'BG102');

INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status)
SELECT rt.room_type_id, 'BGG01', 'AVAILABLE', 'CLEAN'
FROM room_types rt WHERE rt.homestay_id = 4 AND rt.name LIKE 'Bungalow Gia Đình%'
AND NOT EXISTS (SELECT 1 FROM rooms r WHERE r.room_type_id = rt.room_type_id AND r.room_number = 'BGG01');

INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status)
SELECT rt.room_type_id, 'BGG02', 'AVAILABLE', 'CLEAN'
FROM room_types rt WHERE rt.homestay_id = 4 AND rt.name LIKE 'Bungalow Gia Đình%'
AND NOT EXISTS (SELECT 1 FROM rooms r WHERE r.room_type_id = rt.room_type_id AND r.room_number = 'BGG02');


-- 2. HS 6: Phú Quốc Backpacker Haven
INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status)
SELECT rt.room_type_id, CONCAT('DORM-0', n.num), 'AVAILABLE', 'CLEAN'
FROM room_types rt
CROSS JOIN (SELECT 1 num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6) n
WHERE rt.homestay_id = 6 AND rt.name LIKE 'Giường Dorm%'
AND NOT EXISTS (SELECT 1 FROM rooms r WHERE r.room_type_id = rt.room_type_id AND r.room_number = CONCAT('DORM-0', n.num));

INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status)
SELECT rt.room_type_id, 'P101', 'AVAILABLE', 'CLEAN'
FROM room_types rt WHERE rt.homestay_id = 6 AND rt.name LIKE 'Phòng Đôi Budget%'
AND NOT EXISTS (SELECT 1 FROM rooms r WHERE r.room_type_id = rt.room_type_id AND r.room_number = 'P101');

INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status)
SELECT rt.room_type_id, 'P102', 'AVAILABLE', 'CLEAN'
FROM room_types rt WHERE rt.homestay_id = 6 AND rt.name LIKE 'Phòng Đôi Budget%'
AND NOT EXISTS (SELECT 1 FROM rooms r WHERE r.room_type_id = rt.room_type_id AND r.room_number = 'P102');


-- 3. HS 7: Hà Nội Old Quarter Heritage Hotel
INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status)
SELECT rt.room_type_id, 'DL101', 'AVAILABLE', 'CLEAN'
FROM room_types rt WHERE rt.homestay_id = 7 AND rt.name LIKE 'Phòng Deluxe Phố Cổ%'
AND NOT EXISTS (SELECT 1 FROM rooms r WHERE r.room_type_id = rt.room_type_id AND r.room_number = 'DL101');

INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status)
SELECT rt.room_type_id, 'DL102', 'AVAILABLE', 'CLEAN'
FROM room_types rt WHERE rt.homestay_id = 7 AND rt.name LIKE 'Phòng Deluxe Phố Cổ%'
AND NOT EXISTS (SELECT 1 FROM rooms r WHERE r.room_type_id = rt.room_type_id AND r.room_number = 'DL102');

INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status)
SELECT rt.room_type_id, 'TW201', 'AVAILABLE', 'CLEAN'
FROM room_types rt WHERE rt.homestay_id = 7 AND rt.name LIKE 'Twin Standard%'
AND NOT EXISTS (SELECT 1 FROM rooms r WHERE r.room_type_id = rt.room_type_id AND r.room_number = 'TW201');

INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status)
SELECT rt.room_type_id, 'TW202', 'AVAILABLE', 'CLEAN'
FROM room_types rt WHERE rt.homestay_id = 7 AND rt.name LIKE 'Twin Standard%'
AND NOT EXISTS (SELECT 1 FROM rooms r WHERE r.room_type_id = rt.room_type_id AND r.room_number = 'TW202');

INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status)
SELECT rt.room_type_id, 'JS301', 'AVAILABLE', 'CLEAN'
FROM room_types rt WHERE rt.homestay_id = 7 AND rt.name LIKE 'Junior Suite%'
AND NOT EXISTS (SELECT 1 FROM rooms r WHERE r.room_type_id = rt.room_type_id AND r.room_number = 'JS301');


-- 4. HS 8: West Lake Garden Homestay HN
INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status)
SELECT rt.room_type_id, 'HV101', 'AVAILABLE', 'CLEAN'
FROM room_types rt WHERE rt.homestay_id = 8 AND rt.name LIKE 'Phòng Hồ View%'
AND NOT EXISTS (SELECT 1 FROM rooms r WHERE r.room_type_id = rt.room_type_id AND r.room_number = 'HV101');

INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status)
SELECT rt.room_type_id, 'HV102', 'AVAILABLE', 'CLEAN'
FROM room_types rt WHERE rt.homestay_id = 8 AND rt.name LIKE 'Phòng Hồ View%'
AND NOT EXISTS (SELECT 1 FROM rooms r WHERE r.room_type_id = rt.room_type_id AND r.room_number = 'HV102');

INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status)
SELECT rt.room_type_id, 'GD201', 'AVAILABLE', 'CLEAN'
FROM room_types rt WHERE rt.homestay_id = 8 AND rt.name LIKE 'Phòng GĐ 2 Giường%'
AND NOT EXISTS (SELECT 1 FROM rooms r WHERE r.room_type_id = rt.room_type_id AND r.room_number = 'GD201');

INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status)
SELECT rt.room_type_id, 'GD202', 'AVAILABLE', 'CLEAN'
FROM room_types rt WHERE rt.homestay_id = 8 AND rt.name LIKE 'Phòng GĐ 2 Giường%'
AND NOT EXISTS (SELECT 1 FROM rooms r WHERE r.room_type_id = rt.room_type_id AND r.room_number = 'GD202');


-- 5. HS 10: Nha Trang Budget Stay
INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status)
SELECT rt.room_type_id, 'EC101', 'AVAILABLE', 'CLEAN'
FROM room_types rt WHERE rt.homestay_id = 10 AND rt.name LIKE 'Phòng Đơn Economy%'
AND NOT EXISTS (SELECT 1 FROM rooms r WHERE r.room_type_id = rt.room_type_id AND r.room_number = 'EC101');

INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status)
SELECT rt.room_type_id, 'EC102', 'AVAILABLE', 'CLEAN'
FROM room_types rt WHERE rt.homestay_id = 10 AND rt.name LIKE 'Phòng Đơn Economy%'
AND NOT EXISTS (SELECT 1 FROM rooms r WHERE r.room_type_id = rt.room_type_id AND r.room_number = 'EC102');

INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status)
SELECT rt.room_type_id, 'ST201', 'AVAILABLE', 'CLEAN'
FROM room_types rt WHERE rt.homestay_id = 10 AND rt.name LIKE 'Phòng Đôi Standard%'
AND NOT EXISTS (SELECT 1 FROM rooms r WHERE r.room_type_id = rt.room_type_id AND r.room_number = 'ST201');

INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status)
SELECT rt.room_type_id, 'ST202', 'AVAILABLE', 'CLEAN'
FROM room_types rt WHERE rt.homestay_id = 10 AND rt.name LIKE 'Phòng Đôi Standard%'
AND NOT EXISTS (SELECT 1 FROM rooms r WHERE r.room_type_id = rt.room_type_id AND r.room_number = 'ST202');


-- 6. HS 12: Bản Làng H'Mông Homestay Sapa
INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status)
SELECT rt.room_type_id, 'NS01', 'AVAILABLE', 'CLEAN'
FROM room_types rt WHERE rt.homestay_id = 12 AND rt.name LIKE 'Nhà Sàn Truyền Thống%'
AND NOT EXISTS (SELECT 1 FROM rooms r WHERE r.room_type_id = rt.room_type_id AND r.room_number = 'NS01');

INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status)
SELECT rt.room_type_id, 'NS02', 'AVAILABLE', 'CLEAN'
FROM room_types rt WHERE rt.homestay_id = 12 AND rt.name LIKE 'Nhà Sàn Truyền Thống%'
AND NOT EXISTS (SELECT 1 FROM rooms r WHERE r.room_type_id = rt.room_type_id AND r.room_number = 'NS02');

INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status)
SELECT rt.room_type_id, 'PR01', 'AVAILABLE', 'CLEAN'
FROM room_types rt WHERE rt.homestay_id = 12 AND rt.name LIKE 'Phòng Riêng Bản Địa%'
AND NOT EXISTS (SELECT 1 FROM rooms r WHERE r.room_type_id = rt.room_type_id AND r.room_number = 'PR01');

INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status)
SELECT rt.room_type_id, 'PR02', 'AVAILABLE', 'CLEAN'
FROM room_types rt WHERE rt.homestay_id = 12 AND rt.name LIKE 'Phòng Riêng Bản Địa%'
AND NOT EXISTS (SELECT 1 FROM rooms r WHERE r.room_type_id = rt.room_type_id AND r.room_number = 'PR02');


-- 7. HS 13: Da Nang Beachfront Luxury Villa
INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status)
SELECT rt.room_type_id, 'VILLA-01', 'AVAILABLE', 'CLEAN'
FROM room_types rt WHERE rt.homestay_id = 13 AND rt.name LIKE 'Villa Toàn Bộ%'
AND NOT EXISTS (SELECT 1 FROM rooms r WHERE r.room_type_id = rt.room_type_id AND r.room_number = 'VILLA-01');

INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status)
SELECT rt.room_type_id, 'OV101', 'AVAILABLE', 'CLEAN'
FROM room_types rt WHERE rt.homestay_id = 13 AND rt.name LIKE 'Phòng Đôi Hướng Biển%'
AND NOT EXISTS (SELECT 1 FROM rooms r WHERE r.room_type_id = rt.room_type_id AND r.room_number = 'OV101');

INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status)
SELECT rt.room_type_id, 'OV102', 'AVAILABLE', 'CLEAN'
FROM room_types rt WHERE rt.homestay_id = 13 AND rt.name LIKE 'Phòng Đôi Hướng Biển%'
AND NOT EXISTS (SELECT 1 FROM rooms r WHERE r.room_type_id = rt.room_type_id AND r.room_number = 'OV102');
