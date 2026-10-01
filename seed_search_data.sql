-- ====================================================================================
-- SEED DATA - CHỨC NĂNG TÌM KIẾM (UC03)
-- Mô tả: Dữ liệu mẫu đa dạng, thực tế cho tính năng Search & Filter
-- Bao gồm: Users, Homestays, Room Types, Rooms, Amenities, Images, Reviews, Bookings
-- Tác giả: tuantahe176408 (UC12–UC16 scope, seed data chung)
-- Ngày: 2026-09-23
-- ====================================================================================

USE smart_booking_db;

SET FOREIGN_KEY_CHECKS = 0;

-- ====================================================================================
-- 1. USERS - Owners (7 chủ nhà thực tế ở các vùng khác nhau)
-- ====================================================================================
INSERT INTO users (email, password_hash, full_name, phone_number, avatar_url, role, auth_provider, is_active, is_email_verified) VALUES
('nguyenvana.owner@gmail.com',   '$2a$12$LQv3c1yqBWVHxkd0LlHdEOuPiXL4Z9TqBHC3Ot5OqJQ.PmZeaVM2', 'Nguyễn Văn An',    '0912345601', 'https://res.cloudinary.com/smartbooking/image/upload/v1/avatars/owner1.jpg', 'OWNER', 'LOCAL', TRUE, TRUE),
('tranminhb.owner@gmail.com',    '$2a$12$LQv3c1yqBWVHxkd0LlHdEOuPiXL4Z9TqBHC3Ot5OqJQ.PmZeaVM2', 'Trần Minh Bảo',    '0923456702', 'https://res.cloudinary.com/smartbooking/image/upload/v1/avatars/owner2.jpg', 'OWNER', 'LOCAL', TRUE, TRUE),
('lethicam.owner@gmail.com',     '$2a$12$LQv3c1yqBWVHxkd0LlHdEOuPiXL4Z9TqBHC3Ot5OqJQ.PmZeaVM2', 'Lê Thị Cẩm',      '0934567803', 'https://res.cloudinary.com/smartbooking/image/upload/v1/avatars/owner3.jpg', 'OWNER', 'LOCAL', TRUE, TRUE),
('phamquocd.owner@gmail.com',    '$2a$12$LQv3c1yqBWVHxkd0LlHdEOuPiXL4Z9TqBHC3Ot5OqJQ.PmZeaVM2', 'Phạm Quốc Dũng',  '0945678904', 'https://res.cloudinary.com/smartbooking/image/upload/v1/avatars/owner4.jpg', 'OWNER', 'LOCAL', TRUE, TRUE),
('hoangmine.owner@gmail.com',    '$2a$12$LQv3c1yqBWVHxkd0LlHdEOuPiXL4Z9TqBHC3Ot5OqJQ.PmZeaVM2', 'Hoàng Minh Em',   '0956789005', 'https://res.cloudinary.com/smartbooking/image/upload/v1/avatars/owner5.jpg', 'OWNER', 'LOCAL', TRUE, TRUE),
('vothif.owner@gmail.com',       '$2a$12$LQv3c1yqBWVHxkd0LlHdEOuPiXL4Z9TqBHC3Ot5OqJQ.PmZeaVM2', 'Võ Thị Fương',    '0967890106', 'https://res.cloudinary.com/smartbooking/image/upload/v1/avatars/owner6.jpg', 'OWNER', 'LOCAL', TRUE, TRUE),
('buivangiap.owner@gmail.com',   '$2a$12$LQv3c1yqBWVHxkd0LlHdEOuPiXL4Z9TqBHC3Ot5OqJQ.PmZeaVM2', 'Bùi Văn Giáp',   '0978901207', 'https://res.cloudinary.com/smartbooking/image/upload/v1/avatars/owner7.jpg', 'OWNER', 'LOCAL', TRUE, TRUE);

-- ====================================================================================
-- 2. USERS - Customers (8 khách hàng với sở thích đa dạng)
-- ====================================================================================
INSERT INTO users (email, password_hash, full_name, phone_number, avatar_url, role, auth_provider, is_active, is_email_verified) VALUES
('khanh.nguyen.customer@gmail.com',  '$2a$12$LQv3c1yqBWVHxkd0LlHdEOuPiXL4Z9TqBHC3Ot5OqJQ.PmZeaVM2', 'Nguyễn Tuấn Khanh',  '0901111001', 'https://res.cloudinary.com/smartbooking/image/upload/v1/avatars/cust1.jpg', 'CUSTOMER', 'LOCAL',  TRUE, TRUE),
('linh.tran.customer@gmail.com',     '$2a$12$LQv3c1yqBWVHxkd0LlHdEOuPiXL4Z9TqBHC3Ot5OqJQ.PmZeaVM2', 'Trần Hồng Linh',     '0902222002', 'https://res.cloudinary.com/smartbooking/image/upload/v1/avatars/cust2.jpg', 'CUSTOMER', 'LOCAL',  TRUE, TRUE),
('mai.le.customer@gmail.com',        NULL,                                                                 'Lê Thúy Mai',        '0903333003', 'https://res.cloudinary.com/smartbooking/image/upload/v1/avatars/cust3.jpg', 'CUSTOMER', 'GOOGLE', TRUE, TRUE),
('duc.pham.customer@gmail.com',      '$2a$12$LQv3c1yqBWVHxkd0LlHdEOuPiXL4Z9TqBHC3Ot5OqJQ.PmZeaVM2', 'Phạm Tiến Đức',      '0904444004', NULL, 'CUSTOMER', 'LOCAL',  TRUE, TRUE),
('yen.hoang.customer@gmail.com',     NULL,                                                                 'Hoàng Thu Yến',      '0905555005', 'https://res.cloudinary.com/smartbooking/image/upload/v1/avatars/cust5.jpg', 'CUSTOMER', 'GOOGLE', TRUE, TRUE),
('son.vo.customer@gmail.com',        '$2a$12$LQv3c1yqBWVHxkd0LlHdEOuPiXL4Z9TqBHC3Ot5OqJQ.PmZeaVM2', 'Võ Minh Sơn',        '0906666006', NULL, 'CUSTOMER', 'LOCAL',  TRUE, TRUE),
('hang.bui.customer@gmail.com',      '$2a$12$LQv3c1yqBWVHxkd0LlHdEOuPiXL4Z9TqBHC3Ot5OqJQ.PmZeaVM2', 'Bùi Thị Hằng',       '0907777007', 'https://res.cloudinary.com/smartbooking/image/upload/v1/avatars/cust7.jpg', 'CUSTOMER', 'LOCAL',  TRUE, TRUE),
('tung.dinh.customer@gmail.com',     '$2a$12$LQv3c1yqBWVHxkd0LlHdEOuPiXL4Z9TqBHC3Ot5OqJQ.PmZeaVM2', 'Đinh Quang Tùng',    '0908888008', NULL, 'CUSTOMER', 'LOCAL',  TRUE, FALSE);

-- ====================================================================================
-- 3. USER PREFERENCES (sở thích du lịch cho AI Recommendation)
-- ====================================================================================
INSERT INTO user_preferences (user_id, category) VALUES
((SELECT user_id FROM users WHERE email='khanh.nguyen.customer@gmail.com'), 'MOUNTAIN'),
((SELECT user_id FROM users WHERE email='khanh.nguyen.customer@gmail.com'), 'BUDGET'),
((SELECT user_id FROM users WHERE email='linh.tran.customer@gmail.com'),    'BEACH'),
((SELECT user_id FROM users WHERE email='linh.tran.customer@gmail.com'),    'LUXURY'),
((SELECT user_id FROM users WHERE email='mai.le.customer@gmail.com'),       'CULTURAL'),
((SELECT user_id FROM users WHERE email='mai.le.customer@gmail.com'),       'FOODIE'),
((SELECT user_id FROM users WHERE email='duc.pham.customer@gmail.com'),     'BEACH'),
((SELECT user_id FROM users WHERE email='duc.pham.customer@gmail.com'),     'FAMILY'),
((SELECT user_id FROM users WHERE email='yen.hoang.customer@gmail.com'),    'LUXURY'),
((SELECT user_id FROM users WHERE email='yen.hoang.customer@gmail.com'),    'SPA'),
((SELECT user_id FROM users WHERE email='son.vo.customer@gmail.com'),       'PET_FRIENDLY'),
((SELECT user_id FROM users WHERE email='son.vo.customer@gmail.com'),       'OUTDOOR'),
((SELECT user_id FROM users WHERE email='hang.bui.customer@gmail.com'),     'MOUNTAIN'),
((SELECT user_id FROM users WHERE email='hang.bui.customer@gmail.com'),     'ADVENTURE');

-- ====================================================================================
-- 4. AMENITIES (bổ sung tiện nghi thực tế - nối tiếp ID từ schema gốc)
-- ====================================================================================
INSERT INTO amenities (name, icon_class, category) VALUES
('Smart TV 55 inch',        'fa-tv',              'ROOM'),
('Bồn tắm sục Jacuzzi',     'fa-bath',            'ROOM'),
('Tủ lạnh minibar',         'fa-temperature-low', 'ROOM'),
('Két an toàn điện tử',     'fa-lock',            'ROOM'),
('Ban công view núi',        'fa-mountain',        'OUTDOOR'),
('Ban công view biển',       'fa-umbrella-beach',  'OUTDOOR'),
('Gym & Phòng tập',         'fa-dumbbell',        'FACILITY'),
('Spa & Massage',            'fa-spa',             'FACILITY'),
('Nhà hàng tại chỗ',        'fa-concierge-bell',  'FACILITY'),
('Dịch vụ lễ tân 24/7',     'fa-concierge-bell',  'SERVICE'),
('Đưa đón sân bay',         'fa-shuttle-van',     'SERVICE'),
('Không hút thuốc',          'fa-ban-smoking',     'POLICY'),
('Lò sưởi',                 'fa-fire',            'ROOM'),
('Máy nước nóng lạnh',      'fa-shower',          'ROOM'),
('Bãi biển riêng',          'fa-water',           'OUTDOOR');

-- ====================================================================================
-- 5. HOMESTAYS (15 properties đa dạng: từ budget đến luxury, 7 thành phố)
-- ====================================================================================
INSERT INTO homestays (owner_id, name, description, address, city, district, latitude, longitude, status, checkin_time, checkout_time, rating_avg, review_count) VALUES

-- ===== ĐÀ LẠT =====
((SELECT user_id FROM users WHERE email='nguyenvana.owner@gmail.com'),
 'Đà Lạt Pine Valley Homestay',
 'Homestay phong cách châu Âu nằm giữa rừng thông nguyên sinh Đà Lạt. Không gian yên tĩnh, trong lành với view đồi thông tuyệt đẹp. Thích hợp cho cặp đôi và gia đình nhỏ muốn nghỉ dưỡng xa ồn ào phố thị.',
 '123 Hoàng Diệu, Phường 10', 'Đà Lạt', 'Phường 10', 11.93610, 108.44150, 'ACTIVE', '14:00:00', '11:00:00', 4.72, 38),

((SELECT user_id FROM users WHERE email='nguyenvana.owner@gmail.com'),
 'Ana Garden Villa Đà Lạt',
 'Biệt thự vườn cao cấp với diện tích 500m², bao gồm sân vườn xanh mướt, hồ cá Koi, khu vui chơi trẻ em và BBQ ngoài trời. Chỉ cách trung tâm Đà Lạt 5 phút lái xe.',
 '45 Lê Hồng Phong, Phường 4', 'Đà Lạt', 'Phường 4', 11.94200, 108.43800, 'ACTIVE', '15:00:00', '12:00:00', 4.85, 52),

-- ===== HỘI AN =====
((SELECT user_id FROM users WHERE email='tranminhb.owner@gmail.com'),
 'Hội An Ancient Town Boutique',
 'Nhà cổ 200 năm tuổi được phục dựng công phu trong lòng phố cổ Hội An. Kiến trúc mộc mạc, trầm mặc pha lẫn nét hiện đại tinh tế. Vị trí vàng - đi bộ 2 phút ra phố đèn lồng.',
 '37 Trần Phú, Phường Minh An', 'Hội An', 'Minh An', 15.87760, 108.33040, 'ACTIVE', '14:00:00', '12:00:00', 4.91, 74),

((SELECT user_id FROM users WHERE email='tranminhb.owner@gmail.com'),
 'Riverside Retreat Hội An',
 'Khu nghỉ dưỡng ven sông Thu Bồn với 8 bungalow độc lập giữa vườn dừa xanh mát. Trải nghiệm câu cá, chèo thuyền kayak và thưởng thức hải sản tươi sống ngay tại nhà hàng nổi.',
 '88 Cửa Đại, Phường Cẩm An', 'Hội An', 'Cẩm An', 15.86800, 108.36200, 'ACTIVE', '13:00:00', '11:00:00', 4.68, 29),

-- ===== PHÚ QUỐC =====
((SELECT user_id FROM users WHERE email='lethicam.owner@gmail.com'),
 'Sunset Bay Resort Phú Quốc',
 'Resort 4 sao với hơn 20 villa hướng biển, bãi biển riêng dài 150m, hồ bơi tràn bờ infinity pool và spa cao cấp. Ngắm hoàng hôn Phú Quốc – một trong những hoàng hôn đẹp nhất thế giới ngay từ ban công phòng.',
 'Bãi Trường, Đường Trần Hưng Đạo', 'Phú Quốc', 'Dương Tơ', 10.19550, 103.96960, 'ACTIVE', '15:00:00', '12:00:00', 4.88, 147),

((SELECT user_id FROM users WHERE email='lethicam.owner@gmail.com'),
 'Phú Quốc Backpacker Haven',
 'Hostel budget dành cho giới trẻ và du khách bụi. Gần chợ đêm Phú Quốc, cách biển 10 phút đi bộ. Phòng dorm giá rẻ và phòng đôi tiện nghi. Có bar mái rơm, bể bơi nhỏ và area nấu ăn tự túc.',
 '15 Nguyễn Trung Trực, TT. Dương Đông', 'Phú Quốc', 'Dương Đông', 10.21700, 103.96800, 'ACTIVE', '13:00:00', '10:00:00', 4.22, 93),

-- ===== HÀ NỘI =====
((SELECT user_id FROM users WHERE email='phamquocd.owner@gmail.com'),
 'Hà Nội Old Quarter Heritage Hotel',
 'Khách sạn boutique 5 tầng tọa lạc ngay trái tim phố cổ 36 phố phường Hà Nội. Phòng nghỉ thiết kế theo phong cách Đông Dương, pha trộn nét cổ điển Pháp và truyền thống Việt. Buffet sáng phong phú với 30+ món ăn Hà Nội.',
 '16 Hàng Bạc, Quận Hoàn Kiếm', 'Hà Nội', 'Hoàn Kiếm', 21.03470, 105.85190, 'ACTIVE', '14:00:00', '12:00:00', 4.75, 211),

((SELECT user_id FROM users WHERE email='phamquocd.owner@gmail.com'),
 'West Lake Garden Homestay HN',
 'Homestay yên bình ven Hồ Tây với view hồ trực tiếp từ mọi phòng. Sân thượng tầng 5 là điểm ngắm hoàng hôn lý tưởng. Đạp xe quanh hồ, thưởng bún ốc, khám phá làng nghề truyền thống Tây Hồ.',
 '72 Xuân Diệu, Quận Tây Hồ', 'Hà Nội', 'Tây Hồ', 21.05580, 105.83200, 'ACTIVE', '14:00:00', '11:00:00', 4.55, 67),

-- ===== NHA TRANG =====
((SELECT user_id FROM users WHERE email='hoangmine.owner@gmail.com'),
 'Ocean Breeze Hotel Nha Trang',
 'Khách sạn hiện đại 4 sao sát biển Nha Trang với hồ bơi vô cực tầng 10, rooftop bar và nhà hàng hải sản. Tất cả phòng đều có view biển trực tiếp. Gần cảng Nha Trang – khởi điểm tour lặn biển Hòn Mun.',
 '28 Trần Phú, Phường Lộc Thọ', 'Nha Trang', 'Lộc Thọ', 12.23850, 109.19550, 'ACTIVE', '14:00:00', '12:00:00', 4.63, 189),

((SELECT user_id FROM users WHERE email='hoangmine.owner@gmail.com'),
 'Nha Trang Budget Stay',
 'Nhà nghỉ sạch sẽ, gần biển, phù hợp với túi tiền sinh viên và khách đi một mình. Phòng đơn, phòng đôi giá cực mềm. Chủ nhà thân thiện, hỗ trợ thuê xe máy và đặt tour giá tốt.',
 '5 Nguyễn Thiện Thuật, Phường Tân Lập', 'Nha Trang', 'Tân Lập', 12.24500, 109.19200, 'ACTIVE', '12:00:00', '10:00:00', 4.15, 55),

-- ===== SAPA =====
((SELECT user_id FROM users WHERE email='vothif.owner@gmail.com'),
 'Sapa Cloud Ridge Retreat',
 'Khu nghỉ dưỡng trên đỉnh núi với view thung lũng Mường Hoa và ruộng bậc thang tuyệt đẹp. Lò sưởi trong phòng ấm áp mùa đông. Trekking dẫn đường bởi người H''Mông bản địa. Ẩm thực đặc sản vùng cao: thắng cố, cá suối nướng, lợn bản.',
 'Thôn Séo Mý Tỷ, Xã Tả Van', 'Sa Pa', 'Tả Van', 22.32850, 103.87400, 'ACTIVE', '14:00:00', '12:00:00', 4.92, 83),

((SELECT user_id FROM users WHERE email='vothif.owner@gmail.com'),
 'Bản Làng H''Mông Homestay Sapa',
 'Trải nghiệm sống cùng gia đình người H''Mông bản địa. Ngủ trên nhà sàn truyền thống, ăn cơm niêu, học dệt vải thổ cẩm. Hướng dẫn viên là con cháu trong nhà, am hiểu văn hóa sâu sắc.',
 'Bản Cát Cát, Xã San Sả Hồ', 'Sa Pa', 'San Sả Hồ', 22.34100, 103.82500, 'ACTIVE', '15:00:00', '11:00:00', 4.80, 44),

-- ===== ĐÀ NẴNG =====
((SELECT user_id FROM users WHERE email='buivangiap.owner@gmail.com'),
 'Da Nang Beachfront Luxury Villa',
 'Biệt thự sang trọng 4 phòng ngủ ngay bờ biển Mỹ Khê – bãi biển đẹp nhất hành tinh. Hồ bơi riêng, sân vườn BBQ, bếp đầy đủ thiết bị. Phù hợp cho nhóm gia đình hoặc bạn bè 6-8 người. Thuê toàn bộ villa để trải nghiệm private.',
 '168 Võ Nguyên Giáp, Phường Mỹ An', 'Đà Nẵng', 'Ngũ Hành Sơn', 16.04790, 108.24350, 'ACTIVE', '15:00:00', '12:00:00', 4.95, 31),

((SELECT user_id FROM users WHERE email='buivangiap.owner@gmail.com'),
 'Dragon Bridge City View Hostel',
 'Hostel hiện đại nhìn ra cầu Rồng Đà Nẵng. Dorm giường tầng cao cấp với rèm che riêng và ổ cắm USB. Rooftop skybar ngắm pháo hoa cuối tuần. Thích hợp cho khách solo travel và nhóm bạn trẻ.',
 '60 Trần Hưng Đạo, Quận Hải Châu', 'Đà Nẵng', 'Hải Châu', 16.06830, 108.22380, 'ACTIVE', '13:00:00', '11:00:00', 4.40, 128),

-- Một property PENDING để test filter admin
((SELECT user_id FROM users WHERE email='buivangiap.owner@gmail.com'),
 'Da Nang Mountain View Guesthouse',
 'Nhà nghỉ nhỏ xinh view Ngũ Hành Sơn. Hiện đang chờ duyệt.',
 '22 Huyền Trân Công Chúa, Ngũ Hành Sơn', 'Đà Nẵng', 'Ngũ Hành Sơn', 16.00500, 108.25000, 'PENDING_APPROVAL', '14:00:00', '12:00:00', 0.00, 0);

-- ====================================================================================
-- 6. HOMESTAY IMAGES
-- ====================================================================================
INSERT INTO homestay_images (homestay_id, image_url, is_primary, display_order) VALUES
-- Đà Lạt Pine Valley (ID=1)
(1,'https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/dalat_pine_01.jpg',TRUE, 0),
(1,'https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/dalat_pine_02.jpg',FALSE,1),
(1,'https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/dalat_pine_03.jpg',FALSE,2),
-- Ana Garden Villa (ID=2)
(2,'https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/dalat_ana_01.jpg', TRUE, 0),
(2,'https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/dalat_ana_02.jpg', FALSE,1),
(2,'https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/dalat_ana_03.jpg', FALSE,2),
-- Hội An Ancient (ID=3)
(3,'https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/hoian_ancient_01.jpg',TRUE, 0),
(3,'https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/hoian_ancient_02.jpg',FALSE,1),
(3,'https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/hoian_ancient_03.jpg',FALSE,2),
-- Riverside Retreat (ID=4)
(4,'https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/hoian_river_01.jpg',TRUE, 0),
(4,'https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/hoian_river_02.jpg',FALSE,1),
-- Sunset Bay Resort (ID=5)
(5,'https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/phuquoc_sunset_01.jpg',TRUE, 0),
(5,'https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/phuquoc_sunset_02.jpg',FALSE,1),
(5,'https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/phuquoc_sunset_03.jpg',FALSE,2),
(5,'https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/phuquoc_sunset_04.jpg',FALSE,3),
-- Phú Quốc Backpacker (ID=6)
(6,'https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/phuquoc_back_01.jpg',TRUE, 0),
(6,'https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/phuquoc_back_02.jpg',FALSE,1),
-- Hà Nội Old Quarter (ID=7)
(7,'https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/hanoi_oldquarter_01.jpg',TRUE, 0),
(7,'https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/hanoi_oldquarter_02.jpg',FALSE,1),
(7,'https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/hanoi_oldquarter_03.jpg',FALSE,2),
-- West Lake Garden (ID=8)
(8,'https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/hanoi_westlake_01.jpg',TRUE, 0),
(8,'https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/hanoi_westlake_02.jpg',FALSE,1),
-- Ocean Breeze Nha Trang (ID=9)
(9,'https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/nhatrang_ocean_01.jpg',TRUE, 0),
(9,'https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/nhatrang_ocean_02.jpg',FALSE,1),
(9,'https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/nhatrang_ocean_03.jpg',FALSE,2),
-- Nha Trang Budget (ID=10)
(10,'https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/nhatrang_budget_01.jpg',TRUE, 0),
(10,'https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/nhatrang_budget_02.jpg',FALSE,1),
-- Sapa Cloud Ridge (ID=11)
(11,'https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/sapa_cloud_01.jpg',TRUE, 0),
(11,'https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/sapa_cloud_02.jpg',FALSE,1),
(11,'https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/sapa_cloud_03.jpg',FALSE,2),
-- Bản Làng H'Mông (ID=12)
(12,'https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/sapa_hmong_01.jpg',TRUE, 0),
(12,'https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/sapa_hmong_02.jpg',FALSE,1),
-- Da Nang Beachfront Villa (ID=13)
(13,'https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/danang_villa_01.jpg',TRUE, 0),
(13,'https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/danang_villa_02.jpg',FALSE,1),
(13,'https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/danang_villa_03.jpg',FALSE,2),
-- Dragon Bridge Hostel (ID=14)
(14,'https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/danang_hostel_01.jpg',TRUE, 0),
(14,'https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/danang_hostel_02.jpg',FALSE,1);

-- ====================================================================================
-- 7. HOMESTAY AMENITIES
-- IDs schema gốc: 1=WiFi, 2=Hồ bơi, 3=Đỗ xe, 4=ĐH, 5=Máy giặt, 6=Bếp, 7=BBQ, 8=Pet
-- IDs mới thêm:   9=TV, 10=Jacuzzi, 11=Minibar, 12=Két, 13=Ban công núi, 14=Ban công biển
--                 15=Gym, 16=Spa, 17=Nhà hàng, 18=Lễ tân 24/7, 19=Đưa đón, 20=No smoke
--                 21=Lò sưởi, 22=Nước nóng, 23=Bãi biển riêng
-- ====================================================================================
INSERT INTO homestay_amenities VALUES
-- Đà Lạt Pine Valley (núi, cặp đôi, lò sưởi)
(1,1),(1,3),(1,4),(1,6),(1,9),(1,13),(1,21),(1,22),
-- Ana Garden Villa (gia đình, villa sang)
(2,1),(2,2),(2,3),(2,4),(2,5),(2,6),(2,7),(2,9),(2,11),(2,13),(2,21),(2,22),
-- Hội An Ancient Town (văn hóa, không hút thuốc)
(3,1),(3,4),(3,9),(3,11),(3,12),(3,18),(3,20),
-- Riverside Retreat (thiên nhiên, pet-friendly, BBQ)
(4,1),(4,2),(4,3),(4,6),(4,7),(4,8),
-- Sunset Bay Resort (5 sao, biển riêng, spa, gym)
(5,1),(5,2),(5,3),(5,4),(5,9),(5,10),(5,11),(5,12),(5,14),(5,15),(5,16),(5,17),(5,18),(5,19),(5,23),
-- Phú Quốc Backpacker (budget, pool nhỏ)
(6,1),(6,2),(6,4),(6,6),(6,20),
-- Hà Nội Old Quarter (đô thị, nhà hàng, lễ tân)
(7,1),(7,3),(7,4),(7,9),(7,11),(7,12),(7,17),(7,18),(7,20),
-- West Lake Garden (gia đình, bếp, ban công)
(8,1),(8,3),(8,4),(8,5),(8,6),(8,9),(8,20),
-- Ocean Breeze Nha Trang (resort biển, gym, spa)
(9,1),(9,2),(9,3),(9,4),(9,9),(9,11),(9,14),(9,15),(9,16),(9,17),(9,18),(9,20),
-- Nha Trang Budget (minimal, sạch)
(10,1),(10,4),(10,22),(10,20),
-- Sapa Cloud Ridge (núi, lò sưởi, spa nhỏ)
(11,1),(11,3),(11,4),(11,6),(11,9),(11,13),(11,16),(11,21),(11,22),
-- Bản Làng H'Mông (bản địa, bếp truyền thống, lò sưởi)
(12,1),(12,6),(12,8),(12,21),(12,22),
-- Da Nang Beachfront Villa (private, pool, BBQ, view biển)
(13,1),(13,2),(13,3),(13,4),(13,5),(13,6),(13,7),(13,9),(13,11),(13,14),(13,20),
-- Dragon Bridge Hostel (urban, budget, view thành phố)
(14,1),(14,4),(14,9),(14,20);

-- ====================================================================================
-- 8. ROOM TYPES (35 loại phòng - đủ phân khúc từ 120k đến 9.5tr)
-- ====================================================================================
INSERT INTO room_types (homestay_id, name, description, base_price, max_occupancy, bed_count, room_size_sqm) VALUES
-- HS 1: Đà Lạt Pine Valley
(1,'Phòng Thông Standard',  'Phòng tiêu chuẩn view rừng thông, 1 giường đôi, ban công nhỏ',         450000,2,1,22),
(1,'Phòng Gác Lửa Deluxe',  'Phòng rộng hơn với lò sưởi mini, bàn làm việc, view thung lũng',       750000,2,1,32),
(1,'Chalet Đôi Superior',   'Chalet gỗ riêng biệt, 1 giường King, bồn tắm đứng, sân hiên',         1200000,2,1,45),
-- HS 2: Ana Garden Villa
(2,'Garden View Room',      'Nhìn ra sân vườn, 1 giường Queen, bếp nhỏ',                            650000,2,1,28),
(2,'Suite Gia Đình 4P',     '2 phòng ngủ liền kề, phù hợp gia đình 4 người',                       1500000,4,2,65),
(2,'Villa Toàn Bộ',         'Thuê nguyên villa 3 phòng ngủ, bếp, phòng khách, sân',                4500000,8,3,200),
-- HS 3: Hội An Ancient Town
(3,'Phòng Cổ Điển',        '1 giường đôi, gạch hoa văn cổ, đèn lồng trang trí',                    700000,2,1,25),
(3,'Suite Phố Cổ',          'Suite cao cấp tầng 2, view phố Trần Phú, bathtub',                    1600000,2,1,40),
-- HS 4: Riverside Retreat
(4,'Bungalow Tiêu Chuẩn',   'Bungalow 1 giường, sàn gỗ, gần sông',                                  550000,2,1,20),
(4,'Bungalow Gia Đình',     'Bungalow 2 phòng ngủ, bếp, hiên sông',                                 950000,4,2,40),
-- HS 5: Sunset Bay Resort
(5,'Ocean View Room',       'Phòng hướng biển, 1 giường King, ban công riêng',                     2500000,2,1,38),
(5,'Deluxe Pool Access',    '1 giường King + sofa, tiếp giáp hồ bơi',                              3200000,3,1,48),
(5,'Beach Villa',           'Villa sát biển, bể bơi riêng, rất lãng mạn',                         6500000,2,1,80),
-- HS 6: Phú Quốc Backpacker
(6,'Giường Dorm 6 Người',   'Giường tầng 6 chỗ, rèm che, ổ cắm USB',                                150000,1,1, 6),
(6,'Phòng Đôi Budget',      '1 giường đôi, WC riêng, quạt điện',                                    350000,2,1,15),
-- HS 7: Hà Nội Old Quarter
(7,'Phòng Deluxe Phố Cổ',  '1 giường Double, view phố cổ, điều hòa, tivi',                          950000,2,1,22),
(7,'Twin Standard',         '2 giường đơn, nội thất Indochine',                                      850000,2,2,20),
(7,'Junior Suite',          'Suite view hồ Hoàn Kiếm, phòng khách nhỏ riêng',                      1800000,2,1,42),
-- HS 8: West Lake Garden
(8,'Phòng Hồ View',         '1 giường Double nhìn Hồ Tây, ban công nhỏ',                             700000,2,1,24),
(8,'Phòng GĐ 2 Giường',     '2 giường đôi riêng, thích hợp gia đình',                              1200000,4,2,40),
-- HS 9: Ocean Breeze Nha Trang
(9,'Superior View Biển',    '1 giường King, toàn cảnh biển, minibar',                               1800000,2,1,30),
(9,'Deluxe Balcony',        '1 giường King, ban công rộng view biển, bathtub',                      2400000,2,1,38),
(9,'Suite Executive',       'Suite 2 phòng, phòng khách riêng, bồn tắm đứng',                      3800000,3,1,65),
-- HS 10: Nha Trang Budget
(10,'Phòng Đơn Economy',    '1 giường đơn, quạt, WC riêng, sạch sẽ',                                250000,1,1,12),
(10,'Phòng Đôi Standard',   '1 giường đôi, điều hòa, WC riêng',                                     380000,2,1,15),
-- HS 11: Sapa Cloud Ridge
(11,'Mountain View Room',   '1 giường Double, lò sưởi, view ruộng bậc thang',                        980000,2,1,28),
(11,'Valley View Suite',    'Suite rộng, góc nhìn toàn cảnh thung lũng, bathtub',                  1800000,2,1,50),
(11,'Bungalow Riêng Biệt',  'Bungalow gỗ riêng biệt, view đồi núi, lò sưởi',                      2500000,2,1,40),
-- HS 12: Bản Làng H'Mông
(12,'Nhà Sàn Truyền Thống', 'Ngủ trên nhà sàn, mền chăn bông địa phương',                           350000,4,2,30),
(12,'Phòng Riêng Bản Địa',  'Phòng riêng trong nhà H''Mông, gối bông lúa nếp',                     480000,2,1,18),
-- HS 13: Da Nang Beachfront Villa
(13,'Villa Toàn Bộ 4PN',    'Nguyên villa 4 phòng ngủ, bể bơi, bếp, 8 người',                     9500000,8,4,250),
(13,'Phòng Đôi Hướng Biển', '1 phòng trong villa, giường King, view biển',                         2200000,2,1,40),
-- HS 14: Dragon Bridge Hostel
(14,'Dorm 8 Giường HQ',     'Giường tầng Premium, rèm riêng, view cầu Rồng',                         120000,1,1, 5),
(14,'Phòng Đôi Hostel',     '1 giường đôi, WC riêng, view thành phố',                               380000,2,1,16);

-- ====================================================================================
-- 9. ROOMS (phòng vật lý cho từng loại)
-- ====================================================================================
-- HS 1
INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status) VALUES
(1,'101','AVAILABLE','CLEAN'),(1,'102','AVAILABLE','CLEAN'),(1,'103','OCCUPIED','NEEDS_CLEANING'),
(2,'201','AVAILABLE','CLEAN'),(2,'202','AVAILABLE','CLEAN'),
(3,'C01','AVAILABLE','CLEAN'),(3,'C02','MAINTENANCE','CLEAN');
-- HS 2
INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status) VALUES
(4,'101','AVAILABLE','CLEAN'),(4,'102','AVAILABLE','CLEAN'),
(5,'201','OCCUPIED','NEEDS_CLEANING'),(5,'202','AVAILABLE','CLEAN'),
(6,'VILLA','AVAILABLE','CLEAN');
-- HS 3
INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status) VALUES
(7,'101','AVAILABLE','CLEAN'),(7,'102','AVAILABLE','CLEAN'),(7,'103','OCCUPIED','CLEAN'),
(8,'SUITE1','AVAILABLE','CLEAN'),(8,'SUITE2','AVAILABLE','CLEAN');
-- HS 5
INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status) VALUES
(11,'OV101','AVAILABLE','CLEAN'),(11,'OV102','AVAILABLE','CLEAN'),(11,'OV103','OCCUPIED','CLEAN'),
(12,'DPA01','AVAILABLE','CLEAN'),(12,'DPA02','OCCUPIED','NEEDS_CLEANING'),
(13,'BV001','AVAILABLE','CLEAN');
-- HS 9
INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status) VALUES
(21,'801','AVAILABLE','CLEAN'),(21,'802','AVAILABLE','CLEAN'),(21,'803','OCCUPIED','CLEAN'),
(22,'901','AVAILABLE','CLEAN'),(22,'902','AVAILABLE','CLEAN'),
(23,'EX01','AVAILABLE','CLEAN');
-- HS 11
INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status) VALUES
(26,'101','AVAILABLE','CLEAN'),(26,'102','AVAILABLE','CLEAN'),
(27,'SUITE01','AVAILABLE','CLEAN'),
(28,'BG01','AVAILABLE','CLEAN'),(28,'BG02','OCCUPIED','NEEDS_CLEANING');

-- HS 14: Dragon Bridge Hostel (Đà Nẵng)
-- Dorm 8 Giường HQ → 8 giường (D1-D8)
INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status)
SELECT rt.room_type_id, CONCAT('D', n.num), 'AVAILABLE', 'CLEAN'
FROM room_types rt
CROSS JOIN (SELECT 1 num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
            UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8) n
WHERE rt.homestay_id = 14 AND rt.name LIKE 'Dorm%';

-- Phòng Đôi Hostel → 2 phòng (P1, P2)
INSERT INTO rooms (room_type_id, room_number, status, housekeeping_status)
SELECT rt.room_type_id, CONCAT('P', n.num), 'AVAILABLE', 'CLEAN'
FROM room_types rt
CROSS JOIN (SELECT 1 num UNION SELECT 2) n
WHERE rt.homestay_id = 14 AND rt.name LIKE 'Phòng Đôi%';

-- ====================================================================================
-- 10. DYNAMIC PRICES (giá theo mùa lễ tết tháng 10-12/2026)
-- ====================================================================================
INSERT INTO dynamic_prices (room_type_id, date, price_multiplier, custom_price) VALUES
-- Đà Lạt mùa hoa Dã Quỳ (tháng 11, weekend)
(1,'2026-11-07',1.30,NULL),(1,'2026-11-08',1.30,NULL),(1,'2026-11-14',1.30,NULL),(1,'2026-11-15',1.30,NULL),
(2,'2026-11-07',1.35,NULL),(2,'2026-11-08',1.35,NULL),
(3,'2026-11-07',1.50,NULL),(3,'2026-11-08',1.50,NULL),
-- Noel & Năm Mới Đà Lạt
(1,'2026-12-24',1.80,NULL),(1,'2026-12-25',1.80,NULL),(1,'2026-12-31',2.00,NULL),
(2,'2026-12-24',1.80,NULL),(2,'2026-12-25',1.80,NULL),(2,'2026-12-31',2.00,NULL),
(3,'2026-12-24',NULL,2500000.00),(3,'2026-12-25',NULL,2500000.00),(3,'2026-12-31',NULL,3000000.00),
-- Phú Quốc mùa khô (tháng 11-12)
(11,'2026-10-31',1.20,NULL),(11,'2026-11-01',1.20,NULL),
(11,'2026-12-24',NULL,5500000.00),(11,'2026-12-25',NULL,5500000.00),(11,'2026-12-31',NULL,7000000.00),
-- Nha Trang weekend
(21,'2026-10-03',1.25,NULL),(21,'2026-10-04',1.25,NULL),(21,'2026-10-10',1.25,NULL),(21,'2026-10-11',1.25,NULL),
-- Sapa mùa lúa vàng tháng 10
(26,'2026-10-03',1.40,NULL),(26,'2026-10-04',1.40,NULL),(26,'2026-10-10',1.40,NULL),
(26,'2026-10-11',1.40,NULL),(26,'2026-10-17',1.40,NULL),(26,'2026-10-18',1.40,NULL),
-- Đà Nẵng lễ hội pháo hoa
(33,'2026-12-31',1.60,NULL),(34,'2026-12-31',1.50,NULL);

-- ====================================================================================
-- 11. ADDONS (dịch vụ đặc sản địa phương)
-- ====================================================================================
INSERT INTO addons (homestay_id, name, description, price, unit, is_available) VALUES
(1,'Lẩu thảo mộc Đà Lạt',    'Lẩu nấm - rau rừng cho 2 người, phục vụ tận phòng 19h-21h',         280000,'per stay', TRUE),
(1,'Thuê xe đạp đôi',          'Khám phá làng hoa Thái Phiên 8h-17h',                                80000,'per day',  TRUE),
(1,'Đưa đón sân bay Liên Khương','Xe 4 chỗ đón/đưa sân bay Liên Khương',                           350000,'per trip', TRUE),
(2,'BBQ ngoài trời 4 người',   'Nguyên liệu BBQ đầy đủ: thịt, hải sản, rau củ',                    480000,'per stay', TRUE),
(2,'Thuê xe máy Yamaha',       'Xe tay ga, đầy xăng, bảo hiểm',                                     120000,'per day',  TRUE),
(3,'Tour phố cổ ban đêm',      'Hướng dẫn viên 2h đi bộ thắp đèn lồng, tiếng Anh/Việt',            250000,'per person',TRUE),
(3,'Lớp nấu ăn Hội An',        'Học nấu Cao Lầu & Mì Quảng buổi sáng',                             350000,'per person',TRUE),
(3,'Thuê áo dài chụp ảnh',     'Bộ áo dài truyền thống + phụ kiện, cả ngày',                        150000,'per set',  TRUE),
(5,'Tour lặn biển 4 đảo',      'Snorkeling + diving, bao gồm bữa trưa trên tàu',                    650000,'per person',TRUE),
(5,'Massage Spa 90 phút',      'Liệu trình thư giãn toàn thân phong cách Á Đông',                   480000,'per person',TRUE),
(5,'Bữa tối Sunset BBQ',       'Hải sản nướng trên bãi biển riêng, view hoàng hôn',                 890000,'per person',TRUE),
(9,'Tour 4 Đảo Nha Trang',     'Tàu gỗ 4 đảo, ăn trưa và lặn biển ngắn',                          450000,'per person',TRUE),
(9,'Jet Ski 30 phút',          'Trải nghiệm mô tô nước trước bãi biển khách sạn',                   300000,'per session',TRUE),
(11,'Trekking Tả Van',         'Trekking 1 ngày bản làng H''Mông, hướng dẫn bản địa',              450000,'per person',TRUE),
(11,'Bữa tối vùng cao',        'Cơm lam, thắng cố, cá suối nướng, rượu Sán Lùng',                  380000,'per person',TRUE),
(13,'Xe máy điện tự lái',      'Khám phá Đà Nẵng cả ngày',                                          150000,'per day',  TRUE),
(13,'Đầu bếp riêng tại villa', 'Đầu bếp nấu bữa tối hải sản tươi tại villa',                       900000,'per meal', TRUE);

-- ====================================================================================
-- 12. VOUCHERS (đa dạng loại mã giảm giá)
-- ====================================================================================
INSERT INTO vouchers (code, description, discount_type, discount_value, min_booking_amount, max_discount_amount, usage_limit, used_count, start_date, end_date, is_active, created_by_user_id) VALUES
('SALE30BEACH', 'Giảm 30% cho homestay ven biển mùa hè',             'PERCENTAGE',  30.00,1000000.00,500000.00,200, 45,'2026-09-01 00:00:00','2026-12-31 23:59:59',TRUE,(SELECT user_id FROM users WHERE email='admin@smartbooking.com')),
('DANANG200K',  'Giảm ngay 200,000đ cho đặt phòng Đà Nẵng',          'FIXED_AMOUNT',200000.00,500000.00,NULL,       100, 12,'2026-09-15 00:00:00','2026-11-30 23:59:59',TRUE,(SELECT user_id FROM users WHERE email='admin@smartbooking.com')),
('SAPA15PCT',   'Giảm 15% tour trekking Sapa mùa lúa vàng',           'PERCENTAGE',  15.00, 800000.00,300000.00, 50,  8,'2026-10-01 00:00:00','2026-10-31 23:59:59',TRUE,(SELECT user_id FROM users WHERE email='vothif.owner@gmail.com')),
('PHUQUOC2026', 'Mừng khai trương resort Phú Quốc - giảm 20%',        'PERCENTAGE',  20.00,2000000.00,800000.00,500, 78,'2026-01-01 00:00:00','2026-12-31 23:59:59',TRUE,(SELECT user_id FROM users WHERE email='lethicam.owner@gmail.com')),
('NOEL500',     'Giảm 500,000đ dịp Giáng Sinh & Năm Mới',             'FIXED_AMOUNT',500000.00,3000000.00,NULL,    80, 15,'2026-12-20 00:00:00','2027-01-03 23:59:59',TRUE,(SELECT user_id FROM users WHERE email='admin@smartbooking.com')),
('FIRSTBOOK',   'Ưu đãi đặt phòng đầu tiên - giảm 10%',               'PERCENTAGE',  10.00, 300000.00,150000.00,9999,234,'2026-01-01 00:00:00','2026-12-31 23:59:59',TRUE,(SELECT user_id FROM users WHERE email='admin@smartbooking.com'));

-- ====================================================================================
-- 13. BOOKINGS (10 đặt phòng - đủ trạng thái, nhiều homestay)
-- ====================================================================================
INSERT INTO bookings (booking_code,customer_id,homestay_id,room_type_id,assigned_room_id,guest_name,guest_email,guest_phone,checkin_date,checkout_date,total_nights,room_price_total,addon_price_total,surcharge_total,voucher_id,discount_amount,final_total,booking_type,booking_status) VALUES
-- BK01: Khanh | Đà Lạt Pine Valley | CHECKED_OUT
('BK-20261001-0001',(SELECT user_id FROM users WHERE email='khanh.nguyen.customer@gmail.com'),1,2,4,'Nguyễn Tuấn Khanh','khanh.nguyen.customer@gmail.com','0901111001','2026-10-01','2026-10-03',2,1500000.00,280000.00,0.00,NULL,0.00,1780000.00,'ONLINE','CHECKED_OUT'),
-- BK02: Linh | Sunset Bay Phú Quốc | CHECKED_IN
('BK-20261010-0002',(SELECT user_id FROM users WHERE email='linh.tran.customer@gmail.com'),5,11,11,'Trần Hồng Linh','linh.tran.customer@gmail.com','0902222002','2026-10-10','2026-10-14',4,10000000.00,1130000.00,0.00,(SELECT voucher_id FROM vouchers WHERE code='PHUQUOC2026'),1000000.00,10130000.00,'ONLINE','CHECKED_IN'),
-- BK03: Mai | Hội An Ancient Town | CONFIRMED
('BK-20261015-0003',(SELECT user_id FROM users WHERE email='mai.le.customer@gmail.com'),3,8,14,'Lê Thúy Mai','mai.le.customer@gmail.com','0903333003','2026-10-15','2026-10-17',2,3200000.00,600000.00,0.00,NULL,0.00,3800000.00,'ONLINE','CONFIRMED'),
-- BK04: Đức | Ocean Breeze Nha Trang | PENDING
('BK-20261020-0004',(SELECT user_id FROM users WHERE email='duc.pham.customer@gmail.com'),9,22,NULL,'Phạm Tiến Đức','duc.pham.customer@gmail.com','0904444004','2026-10-20','2026-10-23',3,7200000.00,750000.00,0.00,(SELECT voucher_id FROM vouchers WHERE code='FIRSTBOOK'),200000.00,7750000.00,'ONLINE','PENDING'),
-- BK05: Yến | Da Nang Beachfront Villa | CONFIRMED
('BK-20261025-0005',(SELECT user_id FROM users WHERE email='yen.hoang.customer@gmail.com'),13,34,NULL,'Hoàng Thu Yến','yen.hoang.customer@gmail.com','0905555005','2026-10-25','2026-10-28',3,6600000.00,900000.00,0.00,(SELECT voucher_id FROM vouchers WHERE code='DANANG200K'),200000.00,7300000.00,'ONLINE','CONFIRMED'),
-- BK06: Sơn | Bản Làng H'Mông Sapa | CONFIRMED
('BK-20261101-0006',(SELECT user_id FROM users WHERE email='son.vo.customer@gmail.com'),12,30,NULL,'Võ Minh Sơn','son.vo.customer@gmail.com','0906666006','2026-11-01','2026-11-03',2,960000.00,0.00,0.00,(SELECT voucher_id FROM vouchers WHERE code='SAPA15PCT'),144000.00,816000.00,'ONLINE','CONFIRMED'),
-- BK07: Hằng | Sapa Cloud Ridge | PENDING
('BK-20261107-0007',(SELECT user_id FROM users WHERE email='hang.bui.customer@gmail.com'),11,27,NULL,'Bùi Thị Hằng','hang.bui.customer@gmail.com','0907777007','2026-11-07','2026-11-09',2,3600000.00,830000.00,0.00,NULL,0.00,4430000.00,'ONLINE','PENDING'),
-- BK08: Walk-in | Nha Trang Budget | CHECKED_OUT
('BK-20261005-0008',NULL,10,25,NULL,'Trần Văn Bình','binh.walkin@gmail.com','0911111111','2026-10-05','2026-10-07',2,760000.00,0.00,0.00,NULL,0.00,760000.00,'WALK_IN','CHECKED_OUT'),
-- BK09: Khanh | Sapa Cloud Ridge | CONFIRMED (test nhiều booking 1 user)
('BK-20261107-0009',(SELECT user_id FROM users WHERE email='khanh.nguyen.customer@gmail.com'),11,26,NULL,'Nguyễn Tuấn Khanh','khanh.nguyen.customer@gmail.com','0901111001','2026-11-07','2026-11-10',3,2940000.00,450000.00,0.00,NULL,0.00,3390000.00,'ONLINE','CONFIRMED'),
-- BK10: Tùng | Phú Quốc Backpacker | CANCELLED
('BK-20261008-0010',(SELECT user_id FROM users WHERE email='tung.dinh.customer@gmail.com'),6,14,NULL,'Đinh Quang Tùng','tung.dinh.customer@gmail.com','0908888008','2026-10-08','2026-10-10',2,300000.00,0.00,0.00,NULL,0.00,300000.00,'ONLINE','CANCELLED');

-- ====================================================================================
-- 14. PAYMENTS
-- ====================================================================================
INSERT INTO payments (booking_id,transaction_code,payment_method,payment_type,amount,payment_status,paid_at) VALUES
(1,'VNPAY20261001123456','VNPAY','FULL_PAYMENT',  1780000.00,'SUCCESS', '2026-10-01 09:15:23'),
(2,'MOMO20261010987654', 'MOMO', 'FULL_PAYMENT', 10130000.00,'SUCCESS', '2026-10-10 14:32:07'),
(3,'VNPAY20261015567890','VNPAY','BOOKING_DEPOSIT',1900000.00,'SUCCESS','2026-10-15 08:45:00'),
(4,NULL,                 'VNPAY','FULL_PAYMENT',   7750000.00,'PENDING', NULL),
(5,'MOMO20261025112233', 'MOMO', 'FULL_PAYMENT',  7300000.00,'SUCCESS', '2026-10-25 16:20:45'),
(6,'VNPAY20261101445566','VNPAY','FULL_PAYMENT',    816000.00,'SUCCESS', '2026-11-01 10:05:33'),
(7,NULL,                 'VNPAY','BOOKING_DEPOSIT',2215000.00,'PENDING', NULL),
(8,'CASH20261005-001',   'CASH', 'FULL_PAYMENT',    760000.00,'SUCCESS', '2026-10-05 11:30:00'),
(9,'VNPAY20261107778899','VNPAY','FULL_PAYMENT',   3390000.00,'SUCCESS', '2026-11-07 07:59:12'),
(10,'VNPAY20261008-REF', 'VNPAY','REFUND',          300000.00,'REFUNDED','2026-10-08 18:00:00');

-- ====================================================================================
-- 15. REVIEWS (chỉ từ CHECKED_OUT bookings)
-- ====================================================================================
-- Dùng INSERT ... SELECT để lấy customer_id từ bookings (tránh subquery NULL trong VALUES)
INSERT INTO reviews (booking_id, customer_id, homestay_id,
    rating_cleanliness, rating_service, rating_location, rating_value,
    rating_overall, comment, owner_reply, owner_replied_at)
SELECT
    b.booking_id,
    b.customer_id,
    b.homestay_id,
    5, 5, 4, 5,
    4.75,
    'Không gian cực kỳ yên tĩnh và trong lành, đúng như mô tả. Lò sưởi trong phòng ấm cúng, view rừng thông từ ban công rất thơ mộng. Chủ nhà nhiệt tình. Điểm trừ nhỏ: WiFi hơi yếu buổi tối.',
    'Cảm ơn bạn Khanh! Chúng tôi đã nâng cấp router WiFi. Hẹn gặp mùa hoa Dã Quỳ tháng 11 🌻',
    '2026-10-04 10:30:00'
FROM bookings b
WHERE b.booking_code = 'BK-20261001-0001'
  AND b.customer_id IS NOT NULL;

-- Dùng biến session để tránh subquery NULL trong VALUES
SET @khanh  = (SELECT user_id FROM users WHERE email='khanh.nguyen.customer@gmail.com');
SET @linh   = (SELECT user_id FROM users WHERE email='linh.tran.customer@gmail.com');
SET @mai    = (SELECT user_id FROM users WHERE email='mai.le.customer@gmail.com');
SET @duc    = (SELECT user_id FROM users WHERE email='duc.pham.customer@gmail.com');
SET @yen    = (SELECT user_id FROM users WHERE email='yen.hoang.customer@gmail.com');
SET @son    = (SELECT user_id FROM users WHERE email='son.vo.customer@gmail.com');
SET @hang   = (SELECT user_id FROM users WHERE email='hang.bui.customer@gmail.com');

-- ====================================================================================
-- 16. WISHLISTS
-- ====================================================================================
INSERT INTO wishlists (user_id, homestay_id) VALUES
(@khanh, 11), (@khanh, 12),
(@linh,   5), (@linh,  13),
(@mai,    3), (@mai,    4),
(@duc,    9),
(@yen,    5), (@yen,   13),
(@son,   12),
(@hang,  11), (@hang,  12);

-- ====================================================================================
-- 17. AI RECOMMENDATION LOGS (test UC05)
-- ====================================================================================
INSERT INTO ai_recommendation_logs (user_id, homestay_id, reason_tag, match_score, is_clicked) VALUES
(@khanh, 11, 'Phù hợp sở thích leo núi của bạn',      92.50, TRUE),
(@khanh, 12, 'Trải nghiệm văn hóa bản địa độc đáo',    88.30, TRUE),
(@khanh,  1, 'Đà Lạt - điểm yêu thích của bạn',        85.00, FALSE),
(@linh,   5, 'Resort biển cao cấp - đúng phong cách',   97.20, TRUE),
(@linh,  13, 'Villa biển sang trọng Đà Nẵng',           91.00, TRUE),
(@mai,    3, 'Phố cổ Hội An - văn hóa & ẩm thực',      96.80, TRUE),
(@duc,    9, 'Biển Nha Trang - phù hợp gia đình',       89.50, FALSE),
(@yen,    5, 'Spa & Luxury Resort hàng đầu',             98.10, TRUE),
(@son,   12, 'Cho phép mang thú cưng, thiên nhiên',      93.40, TRUE),
(@hang,  11, 'Núi Sapa - phù hợp người yêu trekking',   95.70, TRUE);

SET FOREIGN_KEY_CHECKS = 1;

-- ====================================================================================
-- VERIFICATION QUERIES (bỏ comment để chạy kiểm tra)
-- ====================================================================================
/*
SELECT 'users'               AS tbl, COUNT(*) AS total FROM users              UNION ALL
SELECT 'homestays',                   COUNT(*) FROM homestays                  UNION ALL
SELECT 'room_types',                  COUNT(*) FROM room_types                 UNION ALL
SELECT 'rooms',                       COUNT(*) FROM rooms                      UNION ALL
SELECT 'homestay_amenities',          COUNT(*) FROM homestay_amenities         UNION ALL
SELECT 'homestay_images',             COUNT(*) FROM homestay_images            UNION ALL
SELECT 'dynamic_prices',              COUNT(*) FROM dynamic_prices             UNION ALL
SELECT 'bookings',                    COUNT(*) FROM bookings                   UNION ALL
SELECT 'reviews',                     COUNT(*) FROM reviews                    UNION ALL
SELECT 'wishlists',                   COUNT(*) FROM wishlists                  UNION ALL
SELECT 'vouchers',                    COUNT(*) FROM vouchers;

-- Test: tìm kiếm theo city + khoảng giá + số khách
SELECT h.name, h.city, h.rating_avg, h.review_count,
       MIN(rt.base_price) AS min_price, MAX(rt.base_price) AS max_price,
       MAX(rt.max_occupancy) AS max_guests,
       hi.image_url AS thumbnail
FROM homestays h
JOIN room_types rt ON h.homestay_id = rt.homestay_id
LEFT JOIN homestay_images hi ON h.homestay_id = hi.homestay_id AND hi.is_primary = TRUE
WHERE h.status = 'ACTIVE'
  AND h.city = 'Đà Lạt'
  AND rt.base_price BETWEEN 400000 AND 2000000
  AND rt.max_occupancy >= 2
GROUP BY h.homestay_id, hi.image_url
ORDER BY h.rating_avg DESC;
*/
