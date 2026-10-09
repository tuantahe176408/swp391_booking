
-- ====================================================================================
-- SEED DATA - 150 HOMESTAY THỰC TẾ VIỆT NAM (UC03, UC04, UC17, UC23)
-- Mô tả: 150 homestay trải rộng 15 tỉnh thành du lịch nổi tiếng, 10 properties/thành phố
-- Các thành phố: Đà Lạt, Hội An, Phú Quốc, Hà Nội, Nha Trang, Sa Pa, Đà Nẵng, Huế,
--               Mũi Né, Hà Giang, Ninh Bình, Quy Nhơn, Hạ Long, Bảo Lộc, Vũng Tàu
-- Phân khúc: Budget → Luxury, mỗi thành phố đa dạng phong cách
-- Chạy sau: schema.sql + seed_search_data.sql
-- ====================================================================================

USE smart_booking_db;
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- MySQL 8 / 9 compatibility: disable strict mode and ONLY_FULL_GROUP_BY for this session
SET SESSION sql_mode = 'NO_ENGINE_SUBSTITUTION';

-- ====================================================================================
-- PHẦN 1: OWNERS MỚI (10 chủ nhà, phân bổ quản lý 15 tỉnh thành)
-- Password: Abc@12345 (BCrypt $2a$12$...)
-- ====================================================================================
INSERT IGNORE INTO users (email, password_hash, full_name, phone_number, role, auth_provider, is_active, is_email_verified) VALUES
('maihuong.owner@gmail.com',    '$2a$12$LQv3c1yqBWVHxkd0LlHdEOuPiXL4Z9TqBHC3Ot5OqJQ.PmZeaVM2', 'Mai Thị Hương',     '0911000101', 'OWNER','LOCAL',TRUE,TRUE),
('truclinh.owner@gmail.com',    '$2a$12$LQv3c1yqBWVHxkd0LlHdEOuPiXL4Z9TqBHC3Ot5OqJQ.PmZeaVM2', 'Trần Trúc Linh',    '0911000202', 'OWNER','LOCAL',TRUE,TRUE),
('anhduc.owner@gmail.com',      '$2a$12$LQv3c1yqBWVHxkd0LlHdEOuPiXL4Z9TqBHC3Ot5OqJQ.PmZeaVM2', 'Nguyễn Anh Đức',   '0911000303', 'OWNER','LOCAL',TRUE,TRUE),
('thanhphuong.owner@gmail.com', '$2a$12$LQv3c1yqBWVHxkd0LlHdEOuPiXL4Z9TqBHC3Ot5OqJQ.PmZeaVM2', 'Phạm Thanh Phương', '0911000404', 'OWNER','LOCAL',TRUE,TRUE),
('minhtuan.owner@gmail.com',    '$2a$12$LQv3c1yqBWVHxkd0LlHdEOuPiXL4Z9TqBHC3Ot5OqJQ.PmZeaVM2', 'Lê Minh Tuấn',     '0911000505', 'OWNER','LOCAL',TRUE,TRUE),
('hongnga.owner@gmail.com',     '$2a$12$LQv3c1yqBWVHxkd0LlHdEOuPiXL4Z9TqBHC3Ot5OqJQ.PmZeaVM2', 'Vũ Hồng Nga',      '0911000606', 'OWNER','LOCAL',TRUE,TRUE),
('quocbao.owner@gmail.com',     '$2a$12$LQv3c1yqBWVHxkd0LlHdEOuPiXL4Z9TqBHC3Ot5OqJQ.PmZeaVM2', 'Trịnh Quốc Bảo',   '0911000707', 'OWNER','LOCAL',TRUE,TRUE),
('lanchi.owner@gmail.com',      '$2a$12$LQv3c1yqBWVHxkd0LlHdEOuPiXL4Z9TqBHC3Ot5OqJQ.PmZeaVM2', 'Đinh Lan Chi',     '0911000808', 'OWNER','LOCAL',TRUE,TRUE),
('vinhphuc.owner@gmail.com',    '$2a$12$LQv3c1yqBWVHxkd0LlHdEOuPiXL4Z9TqBHC3Ot5OqJQ.PmZeaVM2', 'Cao Vĩnh Phúc',    '0911000909', 'OWNER','LOCAL',TRUE,TRUE),
('tuankhoa.owner@gmail.com',    '$2a$12$LQv3c1yqBWVHxkd0LlHdEOuPiXL4Z9TqBHC3Ot5OqJQ.PmZeaVM2', 'Đặng Tuấn Khoa',   '0911001010', 'OWNER','LOCAL',TRUE,TRUE);

-- ====================================================================================
-- PHẦN 2A: HOMESTAYS - ĐÀ LẠT (10 properties, các địa danh thực tế)
-- Owner: maihuong.owner@gmail.com
-- ====================================================================================
INSERT INTO homestays (owner_id, name, description, address, city, district, latitude, longitude, status, checkin_time, checkout_time, rating_avg, review_count) VALUES

-- DL1: Khu vực Hồ Xuân Hương - trung tâm TP
((SELECT user_id FROM users WHERE email='maihuong.owner@gmail.com'),
 'Xuân Hương Lakeside Cottage',
 'Nhà gỗ thông 3 phòng ngủ ngay bờ Hồ Xuân Hương, đi bộ 5 phút đến chợ Đà Lạt và Trung tâm Hòa Bình. Không gian lãng mạn, mờ sương buổi sáng, hoa dã quỳ vàng mùa thu.',
 '18 Trần Quốc Toản, Phường 8', 'Đà Lạt', 'Phường 8', 11.94050, 108.43820, 'ACTIVE', '14:00:00', '12:00:00', 4.78, 63),

-- DL2: Làng hoa Thái Phiên
((SELECT user_id FROM users WHERE email='maihuong.owner@gmail.com'),
 'Thái Phiên Flower Farm Stay',
 'Farmstay giữa vườn hoa cúc và hoa hồng làng Thái Phiên nổi tiếng. Tự tay hái hoa, đạp xe giữa đồng hoa muôn màu, ăn sáng với rau củ tươi hái tại vườn.',
 '25 Thái Phiên, Phường 12', 'Đà Lạt', 'Phường 12', 11.96100, 108.44500, 'ACTIVE', '14:00:00', '11:00:00', 4.65, 41),

-- DL3: Đường Hoa Hồng - gần Valley of Love
((SELECT user_id FROM users WHERE email='maihuong.owner@gmail.com'),
 'Valley of Love Hideaway',
 'Ẩn mình gần Thung Lũng Tình Yêu, homestay concept "A-frame" bằng gỗ thông, mái dốc cao đặc trưng vùng núi. Lò sưởi củi thật, bữa sáng phô mai Đà Lạt và bánh mì nướng.',
 '12 Phù Đổng Thiên Vương, Phường 8', 'Đà Lạt', 'Phường 8', 11.96800, 108.43000, 'ACTIVE', '15:00:00', '12:00:00', 4.88, 97),

-- DL4: Đường 3 Tháng 4 - gần Hồ Than Thở
((SELECT user_id FROM users WHERE email='maihuong.owner@gmail.com'),
 'Hồ Than Thở Treehouse',
 'Nhà trên cây hiếm có tại Đà Lạt, cách Hồ Than Thở 500m. Lên xuống bằng thang gỗ chắc chắn, ngủ trên tán thông, ngắm sao khuya. Trải nghiệm thiên nhiên 100%, không TV, không internet.',
 '7 Đường 3 Tháng 4, Phường 3', 'Đà Lạt', 'Phường 3', 11.93200, 108.46500, 'ACTIVE', '14:00:00', '11:00:00', 4.72, 28),

-- DL5: Khu Đankia - Suối Vàng (ngoại ô, view hồ)
((SELECT user_id FROM users WHERE email='maihuong.owner@gmail.com'),
 'Đankia Lake Resort Đà Lạt',
 'Resort nhỏ ven hồ Đan Kia - Suối Vàng hoang sơ cách TP 12km. Bungalow gỗ thông riêng biệt view hồ, bè câu cá, kayak và trekking rừng thông bản địa. Không khí trong lành tuyệt đối.',
 'Thôn Đan Kia, Xã Lát', 'Đà Lạt', 'Lạc Dương', 12.02500, 108.38000, 'ACTIVE', '14:00:00', '12:00:00', 4.82, 55),

-- DL6: Trung tâm, gần Chợ Đà Lạt
((SELECT user_id FROM users WHERE email='maihuong.owner@gmail.com'),
 'Central Đà Lạt Boutique Hotel',
 'Khách sạn boutique 4 tầng ngay trung tâm, cách chợ Đà Lạt 200m. Phong cách Pháp thuộc - gạch đỏ, cầu thang xoắn ốc, ban công nhìn ra đường Nguyễn Thị Minh Khai. Breakfast buffet 25+ món.',
 '5 Nguyễn Thị Minh Khai, Phường 1', 'Đà Lạt', 'Phường 1', 11.94120, 108.44100, 'ACTIVE', '14:00:00', '12:00:00', 4.55, 182),

-- DL7: Cầu Đất - vùng chè lịch sử
((SELECT user_id FROM users WHERE email='maihuong.owner@gmail.com'),
 'Cầu Đất Tea Estate Homestay',
 'Ngủ giữa đồn điền chè Cầu Đất lịch sử 100 năm tuổi - di sản thời Pháp thuộc. Tham quan nhà máy chế biến chè, hái chè thủ công, nếm thử các dòng trà oolong đặc sản.',
 'Thôn Trường Thọ, Xã Xuân Trường', 'Đà Lạt', 'Xuân Trường', 11.83000, 108.52000, 'ACTIVE', '14:00:00', '12:00:00', 4.70, 36),

-- DL8: Prenn - gần thác Prenn và hầm rượu
((SELECT user_id FROM users WHERE email='maihuong.owner@gmail.com'),
 'Prenn Waterfall Ecolodge',
 'Ecolodge nép mình sát chân thác Prenn huyền thoại, cổng vào thành phố Đà Lạt. Cảnh quan xanh mướt, tiếng nước chảy ru giấc ngủ. Tổ chức hiking, xe đạp địa hình và picnic bên thác.',
 'Đèo Prenn, Phường 3', 'Đà Lạt', 'Phường 3', 11.88000, 108.44500, 'ACTIVE', '14:00:00', '11:00:00', 4.61, 44),

-- DL9: Đường Hai Bà Trưng - khu biệt thự cũ
((SELECT user_id FROM users WHERE email='maihuong.owner@gmail.com'),
 'Villa Pháp Cổ Hai Bà Trưng',
 'Biệt thự Pháp cổ 1930 được phục dựng nguyên vẹn trên đường Hai Bà Trưng - con đường có nhiều biệt thự cổ nhất Đà Lạt. Nội thất đồ cổ Đông Dương, vườn mimosa tím rực mùa xuân.',
 '34 Hai Bà Trưng, Phường 6', 'Đà Lạt', 'Phường 6', 11.94600, 108.44700, 'ACTIVE', '15:00:00', '12:00:00', 4.90, 71),

-- DL10: Lạc Dương - gần Lang Biang
((SELECT user_id FROM users WHERE email='maihuong.owner@gmail.com'),
 'Lang Biang Mountain Lodge',
 'Lodge trên núi gần đỉnh Lang Biang hùng vĩ - nóc nhà Tây Nguyên. Ngồi uống cà phê K''Ho Sê Rê đặc sản vừa ngắm mây vờn đỉnh núi. Trekking lên đỉnh 2.167m cùng hướng dẫn người Cơ Ho bản địa.',
 'Thôn Đưng K''Nớ, Xã Đạ Chais', 'Đà Lạt', 'Lạc Dương', 12.05000, 108.43000, 'ACTIVE', '14:00:00', '12:00:00', 4.85, 49);

-- ====================================================================================
-- PHẦN 2B: HOMESTAYS - HỘI AN (10 properties)
-- Owner: truclinh.owner@gmail.com
-- ====================================================================================
INSERT INTO homestays (owner_id, name, description, address, city, district, latitude, longitude, status, checkin_time, checkout_time, rating_avg, review_count) VALUES

-- HA1: Phố cổ - đường Nguyễn Thái Học
((SELECT user_id FROM users WHERE email='truclinh.owner@gmail.com'),
 'Nguyễn Thái Học Heritage House',
 'Nhà cổ 150 năm mặt tiền đường Nguyễn Thái Học - một trong những con phố đẹp nhất phố cổ Hội An. Giếng trời truyền thống, bàn ghế gỗ mun, đèn lồng thủ công treo khắp nhà. UNESCO World Heritage living experience.',
 '49 Nguyễn Thái Học, Phường Minh An', 'Hội An', 'Minh An', 15.87500, 108.32800, 'ACTIVE', '14:00:00', '12:00:00', 4.93, 118),

-- HA2: Cẩm Thanh - làng dừa nước
((SELECT user_id FROM users WHERE email='truclinh.owner@gmail.com'),
 'Cẩm Thanh Coconut Village Stay',
 'Homestay trong làng dừa nước Cẩm Thanh - địa danh nổi tiếng với thúng chài và rừng dừa xanh mướt. Ngồi thúng chài khám phá rừng dừa, câu cá, ăn cơm gà Hội An do chủ nhà tự nấu.',
 'Thôn Vạn Lăng, Xã Cẩm Thanh', 'Hội An', 'Cẩm Thanh', 15.83500, 108.36000, 'ACTIVE', '13:00:00', '11:00:00', 4.75, 87),

-- HA3: Cửa Đại - gần biển
((SELECT user_id FROM users WHERE email='truclinh.owner@gmail.com'),
 'Cửa Đại Sunrise Bungalow',
 'Khu bungalow gần bãi biển Cửa Đại, 10 phút đạp xe ra biển. Thiết kế tropical mộc mạc với tre nứa, võng bên bể bơi. Thuê xe đạp miễn phí, đạp vào phố cổ thưởng thức Cao Lầu và bánh mì Phượng.',
 '22 Cửa Đại, Phường Cẩm An', 'Hội An', 'Cẩm An', 15.86200, 108.36800, 'ACTIVE', '14:00:00', '12:00:00', 4.62, 73),

-- HA4: An Bàng - bãi biển đẹp nhất
((SELECT user_id FROM users WHERE email='truclinh.owner@gmail.com'),
 'An Bàng Beach Villa',
 'Villa 3 phòng ngủ sát bãi An Bàng - một trong những bãi biển đẹp nhất châu Á. Bể bơi ngoài trời, sân vườn dừa, BBQ hải sản tươi mỗi tối. Chỉ 3km từ phố cổ, tận hưởng cả hai trải nghiệm.',
 '15 An Bàng, Phường Cẩm An', 'Hội An', 'Cẩm An', 15.89000, 108.36500, 'ACTIVE', '15:00:00', '12:00:00', 4.87, 62),

-- HA5: Làng rau Trà Quế
((SELECT user_id FROM users WHERE email='truclinh.owner@gmail.com'),
 'Trà Quế Herb Garden Farmstay',
 'Farmstay ngay cạnh làng rau Trà Quế 400 năm tuổi, nơi cung cấp rau thơm đặc biệt cho ẩm thực Hội An. Tự tay làm vườn, nấu ăn bằng rau hái tươi. Học làm Bánh Xèo Hội An, Mì Quảng từ đầu bếp bản địa.',
 'Làng Trà Quế, Xã Cẩm Hà', 'Hội An', 'Cẩm Hà', 15.90000, 108.33500, 'ACTIVE', '13:00:00', '11:00:00', 4.80, 55),

-- HA6: Đường Phan Bội Châu - phố cổ nhỏ
((SELECT user_id FROM users WHERE email='truclinh.owner@gmail.com'),
 'Phan Bội Châu Lantern Guesthouse',
 'Nhà khách nhỏ xinh trên phố Phan Bội Châu, gần Chùa Cầu Nhật Bản biểu tượng Hội An. Sân trong trồng bonsai và treo đèn lồng suốt năm. Sáng ăn bánh mì chấm tương vừng kiểu Hội An.',
 '11 Phan Bội Châu, Phường Minh An', 'Hội An', 'Minh An', 15.87700, 108.32600, 'ACTIVE', '14:00:00', '12:00:00', 4.68, 94),

-- HA7: Cẩm Kim - đảo làng mộc Kim Bồng
((SELECT user_id FROM users WHERE email='truclinh.owner@gmail.com'),
 'Kim Bồng Carpentry Village Homestay',
 'Ở trong nhà thợ mộc làng Kim Bồng cổ truyền trên đảo Cẩm Kim, qua sông bằng đò từ phố cổ. Học đục đẽo đồ gỗ mỹ nghệ, xem thợ lành nghề tạo ra đồ nội thất chạm khắc tinh xảo.',
 'Thôn Trung Châu, Xã Cẩm Kim', 'Hội An', 'Cẩm Kim', 15.86500, 108.31000, 'ACTIVE', '13:00:00', '11:00:00', 4.70, 33),

-- HA8: Gần rừng dừa, cao cấp hơn
((SELECT user_id FROM users WHERE email='truclinh.owner@gmail.com'),
 'Thu Bồn Riverside Luxury Villa',
 'Biệt thự cao cấp ven sông Thu Bồn, ngồi thuyền ra phố cổ chỉ 15 phút. Hồ bơi tràn bờ nhìn ra sông, dịch vụ butler riêng, bữa sáng tại phòng. Lý tưởng cho tuần trăng mật.',
 '88 Cửa Đại, Phường Cẩm Nam', 'Hội An', 'Cẩm Nam', 15.86900, 108.33200, 'ACTIVE', '15:00:00', '12:00:00', 4.94, 45),

-- HA9: Biển Rạng - ít người biết
((SELECT user_id FROM users WHERE email='truclinh.owner@gmail.com'),
 'Rạng Beach Hidden Retreat',
 'Khu nghỉ ẩn tại bãi Rạng ít khách, yên tĩnh và hoang sơ. Không gian riêng tư hoàn toàn cho gia đình hoặc nhóm nhỏ. Ngắm bình minh trên biển một mình, không tiếng ồn, không đám đông.',
 'Bãi Rạng, Xã Duy Nghĩa', 'Hội An', 'Duy Xuyên', 15.85000, 108.38500, 'ACTIVE', '14:00:00', '12:00:00', 4.76, 27),

-- HA10: Gần phố cổ, budget
((SELECT user_id FROM users WHERE email='truclinh.owner@gmail.com'),
 'Old Town Backpacker Hội An',
 'Hostel sôi động cách Chùa Cầu 300m. Giường dorm cao cấp, bể bơi ngoài trời, bar mái lá phục vụ cocktail tropical và bia Larue lạnh. Tour đạp xe và lớp nấu ăn miễn phí cho khách dorm.',
 '62 Lê Lợi, Phường Minh An', 'Hội An', 'Minh An', 15.88000, 108.33000, 'ACTIVE', '12:00:00', '10:00:00', 4.45, 156);

-- ====================================================================================
-- PHẦN 2C: HOMESTAYS - PHÚ QUỐC (10 properties)
-- Owner: anhduc.owner@gmail.com
-- ====================================================================================
INSERT INTO homestays (owner_id, name, description, address, city, district, latitude, longitude, status, checkin_time, checkout_time, rating_avg, review_count) VALUES

-- PQ1: Bãi Sao - đẹp nhất đảo
((SELECT user_id FROM users WHERE email='anhduc.owner@gmail.com'),
 'Bãi Sao Pearl Villa Phú Quốc',
 'Villa sang trọng tọa lạc ngay Bãi Sao - bãi biển đẹp nhất Phú Quốc với cát trắng mịn và nước trong xanh emerald. Hồ bơi riêng, bếp đầy đủ thiết bị, dịch vụ đầu bếp theo yêu cầu.',
 'Bãi Sao, Xã An Thới', 'Phú Quốc', 'An Thới', 10.00500, 104.00800, 'ACTIVE', '15:00:00', '12:00:00', 4.91, 83),

-- PQ2: Bãi Dài - hoang sơ phía bắc
((SELECT user_id FROM users WHERE email='anhduc.owner@gmail.com'),
 'Bãi Dài North Coast Retreat',
 'Khu nghỉ hoang sơ trên Bãi Dài phía bắc đảo, nơi chưa bị phát triển ồ ạt. 7km bãi biển riêng, rừng nguyên sinh ngay sau lưng. Lặn ngắm san hô tự nhiên, câu mực đêm cùng ngư dân địa phương.',
 'Bãi Dài, Xã Gành Dầu', 'Phú Quốc', 'Gành Dầu', 10.40000, 103.85000, 'ACTIVE', '14:00:00', '12:00:00', 4.77, 38),

-- PQ3: Dương Đông - trung tâm thị trấn
((SELECT user_id FROM users WHERE email='anhduc.owner@gmail.com'),
 'Dương Đông Night Market Guesthouse',
 'Nhà khách ngay cạnh chợ đêm Dương Đông sầm uất nhất Phú Quốc. Đi bộ đến cảng tàu An Thới, chợ Dương Đông và hàng trăm quán hải sản tươi sống. Phù hợp cho gia đình du lịch tiết kiệm.',
 '22 Trần Phú, TT. Dương Đông', 'Phú Quốc', 'Dương Đông', 10.21500, 103.96200, 'ACTIVE', '13:00:00', '11:00:00', 4.40, 112),

-- PQ4: Ông Lang - bãi vắng phía tây
((SELECT user_id FROM users WHERE email='anhduc.owner@gmail.com'),
 'Ông Lang Sunset Bungalow',
 'Bungalow gỗ bên bãi Ông Lang phía tây đảo - thiên đường ngắm hoàng hôn. Cây nhiệt đới rợp bóng, võng trên bãi cát, cocktail handmade. Hoàn hảo cho couples muốn escape đám đông.',
 'Bãi Ông Lang, Xã Cửa Dương', 'Phú Quốc', 'Cửa Dương', 10.28000, 103.91000, 'ACTIVE', '14:00:00', '12:00:00', 4.83, 67),

-- PQ5: Hàm Ninh - làng chài cua ghẹ
((SELECT user_id FROM users WHERE email='anhduc.owner@gmail.com'),
 'Hàm Ninh Fishing Village Homestay',
 'Sống như ngư dân làng Hàm Ninh nổi tiếng cua ghẹ Phú Quốc. Ra khơi đặt lồng cua lúc 5 giờ sáng, mang về nấu lẩu cua tươi sống. Tham quan xưởng sản xuất nước mắm Phú Quốc truyền thống.',
 'Làng Hàm Ninh, Xã Hàm Ninh', 'Phú Quốc', 'Hàm Ninh', 10.22000, 104.03000, 'ACTIVE', '13:00:00', '11:00:00', 4.68, 54),

-- PQ6: Phú Quốc United Center area
((SELECT user_id FROM users WHERE email='anhduc.owner@gmail.com'),
 'Grand Phú Quốc Ocean Resort',
 'Resort 5 sao khu vực Bãi Trường gần Phú Quốc United Center. 3 hồ bơi tầng cấp, bãi biển riêng 200m, nhà hàng hải sản fine-dining và spa Á Đông cao cấp. Đưa đón sân bay bằng xe limousine.',
 'Bãi Trường, Đường Trần Hưng Đạo', 'Phú Quốc', 'Dương Tơ', 10.18000, 103.97500, 'ACTIVE', '15:00:00', '12:00:00', 4.88, 201),

-- PQ7: Suối Tranh - nội địa
((SELECT user_id FROM users WHERE email='anhduc.owner@gmail.com'),
 'Suối Tranh Jungle Glamping',
 'Glamping trong rừng nguyên sinh gần thác Suối Tranh đẹp nhất Phú Quốc. Lều canvas cao cấp trang bị giường gỗ, điều hòa và bồn tắm thiên nhiên. Trekking rừng, waterfall spa và bữa tối giữa rừng.',
 'Đường Suối Tranh, Xã Dương Tơ', 'Phú Quốc', 'Dương Tơ', 10.21000, 103.99000, 'ACTIVE', '14:00:00', '12:00:00', 4.72, 43),

-- PQ8: An Thới - gần cáp treo Hòn Thơm
((SELECT user_id FROM users WHERE email='anhduc.owner@gmail.com'),
 'Hòn Thơm Cable Car Guesthouse',
 'Nhà khách cạnh cổng cáp treo Hòn Thơm - cáp treo vượt biển dài nhất thế giới. Đặt phòng được ưu tiên vé cáp treo sớm, leo đảo Hòn Thơm ngắm toàn cảnh quần đảo An Thới tuyệt đẹp.',
 '5 An Thới, Xã An Thới', 'Phú Quốc', 'An Thới', 10.00800, 104.01500, 'ACTIVE', '13:00:00', '11:00:00', 4.55, 78),

-- PQ9: Khu Cánh Đồng - giữa đảo
((SELECT user_id FROM users WHERE email='anhduc.owner@gmail.com'),
 'Phú Quốc Eco Farm Stay',
 'Trại hữu cơ giữa lòng đảo Phú Quốc, xa khỏi tiếng ồn biển. Nông trại trồng tiêu Phú Quốc nổi tiếng thế giới, vườn cây ăn quả nhiệt đới. Thu hoạch tiêu, nếm rượu sim Phú Quốc và mật ong rừng.',
 'Xã Cửa Dương, Huyện Phú Quốc', 'Phú Quốc', 'Cửa Dương', 10.27000, 103.95000, 'ACTIVE', '14:00:00', '12:00:00', 4.60, 31),

-- PQ10: Budget - gần chợ đêm
((SELECT user_id FROM users WHERE email='anhduc.owner@gmail.com'),
 'Phú Quốc Island Hostel',
 'Hostel hiện đại gần trung tâm Dương Đông, dễ dàng di chuyển đến các điểm tham quan. Giường dorm tiêu chuẩn quốc tế, bể bơi, free breakfast. Social area với bàn bóng bàn và góc ukulele.',
 '8 Nguyễn Trung Trực, TT. Dương Đông', 'Phú Quốc', 'Dương Đông', 10.21800, 103.96500, 'ACTIVE', '12:00:00', '10:00:00', 4.38, 143);

-- ====================================================================================
-- PHẦN 2D: HOMESTAYS - HÀ NỘI (10 properties)
-- Owner: thanhphuong.owner@gmail.com
-- ====================================================================================
INSERT INTO homestays (owner_id, name, description, address, city, district, latitude, longitude, status, checkin_time, checkout_time, rating_avg, review_count) VALUES

-- HN1: Hồ Gươm - trái tim Hà Nội
((SELECT user_id FROM users WHERE email='thanhphuong.owner@gmail.com'),
 'Hồ Gươm View Boutique',
 'Khách sạn boutique hiếm có view trực tiếp Hồ Gươm từ tầng 5 và tầng 6. Ăn sáng phở Hà Nội chính gốc ngay tầng 2 với view Tháp Rùa. Vị trí đi bộ đến Đền Ngọc Sơn, Nhà hát Lớn và 36 phố phường.',
 '28 Đinh Tiên Hoàng, Quận Hoàn Kiếm', 'Hà Nội', 'Hoàn Kiếm', 21.02850, 105.85190, 'ACTIVE', '14:00:00', '12:00:00', 4.82, 237),

-- HN2: Phố Cổ - phố Hàng Đào
((SELECT user_id FROM users WHERE email='thanhphuong.owner@gmail.com'),
 'Hàng Đào Silk Heritage Guesthouse',
 'Nhà cổ phố Hàng Đào - con phố buôn lụa tơ tằm trăm năm lịch sử. Kiến trúc nhà ống Hà Nội truyền thống, giếng trời, cột gỗ lim chạm khắc. Ngay chợ Đồng Xuân và phố đi bộ Hoàn Kiếm.',
 '15 Hàng Đào, Quận Hoàn Kiếm', 'Hà Nội', 'Hoàn Kiếm', 21.03450, 105.85010, 'ACTIVE', '14:00:00', '12:00:00', 4.76, 108),

-- HN3: Tây Hồ - phong cách bohemian
((SELECT user_id FROM users WHERE email='thanhphuong.owner@gmail.com'),
 'Tây Hồ Lakeside Bohemian Homestay',
 'Nhà bohemian trên con phố cà phê Đặng Thai Mai ven Hồ Tây. Sáng uống cà phê trứng nhìn hồ, chiều đạp xe khám phá làng Nhật Tân mùa đào, làng Nghi Tàm trồng sen và làng nghề giấy Yên Thái.',
 '45 Đặng Thai Mai, Quận Tây Hồ', 'Hà Nội', 'Tây Hồ', 21.05800, 105.83500, 'ACTIVE', '14:00:00', '12:00:00', 4.70, 89),

-- HN4: Đống Đa - gần Văn Miếu
((SELECT user_id FROM users WHERE email='thanhphuong.owner@gmail.com'),
 'Văn Miếu Scholar Guesthouse',
 'Nhà khách văn hoá gần Văn Miếu Quốc Tử Giám - trường đại học đầu tiên của Việt Nam. Phòng lấy cảm hứng từ văn nhân sĩ tử ngày xưa. Tổ chức tour buổi sáng khám phá Văn Miếu và phố sách Đinh Lễ.',
 '8 Cát Linh, Quận Đống Đa', 'Hà Nội', 'Đống Đa', 21.02700, 105.84200, 'ACTIVE', '14:00:00', '12:00:00', 4.58, 67),

-- HN5: Ba Đình - gần lăng Bác
((SELECT user_id FROM users WHERE email='thanhphuong.owner@gmail.com'),
 'Ba Đình Heritage Hotel Hà Nội',
 'Khách sạn 3 sao khu Ba Đình lịch sử, gần Lăng Chủ tịch Hồ Chí Minh, Bảo tàng Hồ Chí Minh và Chùa Một Cột. Phù hợp đoàn du lịch văn hoá - lịch sử. Hướng dẫn viên tiếng Anh theo yêu cầu.',
 '12 Hoàng Diệu, Quận Ba Đình', 'Hà Nội', 'Ba Đình', 21.04500, 105.83400, 'ACTIVE', '14:00:00', '12:00:00', 4.50, 145),

-- HN6: Hoàng Mai - gần phố ẩm thực
((SELECT user_id FROM users WHERE email='thanhphuong.owner@gmail.com'),
 'Hoàng Mai Local Experience Stay',
 'Ở cùng gia đình người Hà Nội chính gốc khu Hoàng Mai. Bữa sáng bún riêu cua, bún bò, xôi xéo thật sự do chủ nhà nấu. Khám phá chợ dân sinh, phở gia truyền và bánh cuốn Thanh Trì bản địa.',
 '33 Trương Định, Quận Hoàng Mai', 'Hà Nội', 'Hoàng Mai', 20.99800, 105.86500, 'ACTIVE', '14:00:00', '11:00:00', 4.65, 52),

-- HN7: Cầu Giấy - khu đại học
((SELECT user_id FROM users WHERE email='thanhphuong.owner@gmail.com'),
 'Cầu Giấy Smart Capsule Hostel',
 'Hostel capsule hiện đại gần các trường đại học và làng quốc tế Keangnam. Pod ngủ riêng biệt, co-working space, tủ đồ có khoá. Phù hợp digital nomad và sinh viên trao đổi quốc tế.',
 '67 Dịch Vọng Hậu, Quận Cầu Giấy', 'Hà Nội', 'Cầu Giấy', 21.03600, 105.79500, 'ACTIVE', '12:00:00', '10:00:00', 4.48, 88),

-- HN8: Long Biên - gần cầu Long Biên lịch sử
((SELECT user_id FROM users WHERE email='thanhphuong.owner@gmail.com'),
 'Long Biên Bridge View Guesthouse',
 'Nhà khách view cầu Long Biên - cây cầu thép 1902 biểu tượng kháng chiến Hà Nội. Sáng sớm chứng kiến chuyến tàu đầu tiên qua cầu và chợ đêm Long Biên họp lúc 2-4 giờ sáng đầy màu sắc.',
 '5 Hàng Đậu, Quận Hoàn Kiếm', 'Hà Nội', 'Hoàn Kiếm', 21.04100, 105.85600, 'ACTIVE', '14:00:00', '12:00:00', 4.68, 74),

-- HN9: Ninh Hiệp - gần Sóc Sơn (ngoại thành)
((SELECT user_id FROM users WHERE email='thanhphuong.owner@gmail.com'),
 'Đồng Quê Sóc Sơn Retreat',
 'Khu nghỉ ngoại thành Sóc Sơn, 45 phút từ trung tâm Hà Nội. Nhà sàn tre nứa truyền thống, vườn rau hữu cơ, ao cá, gà thả vườn. Học làm bánh chưng, giã giò thủ công theo kiểu nông thôn Bắc Bộ.',
 'Thôn Xuân Dục, Xã Phù Linh', 'Hà Nội', 'Sóc Sơn', 21.22000, 105.87000, 'ACTIVE', '14:00:00', '12:00:00', 4.73, 46),

-- HN10: Quận 1 phong cách - luxury
((SELECT user_id FROM users WHERE email='thanhphuong.owner@gmail.com'),
 'Silk Road Luxury Boutique Hà Nội',
 'Boutique hotel sang trọng phong cách Con Đường Tơ Lụa tại phố cổ Hà Nội. 12 phòng chuẩn 5 sao, butler service, restaurant ẩm thực fusion Việt-Pháp, rooftop bar với 180° panorama phố cổ.',
 '20 Hàng Trống, Quận Hoàn Kiếm', 'Hà Nội', 'Hoàn Kiếm', 21.03100, 105.84900, 'ACTIVE', '15:00:00', '12:00:00', 4.95, 91);

-- ====================================================================================
-- PHẦN 2E: HOMESTAYS - NHA TRANG (10 properties)
-- Owner: minhtuan.owner@gmail.com
-- ====================================================================================
INSERT INTO homestays (owner_id, name, description, address, city, district, latitude, longitude, status, checkin_time, checkout_time, rating_avg, review_count) VALUES

-- NT1: Bãi Dài Cam Ranh
((SELECT user_id FROM users WHERE email='minhtuan.owner@gmail.com'),
 'Cam Ranh Bay Beachfront Resort',
 'Resort cao cấp tại Bãi Dài Cam Ranh - bãi biển được xếp hạng đẹp nhất Việt Nam. Cát trắng mịn, nước biển trong xanh, hồ bơi infinitypool nhìn ra vịnh Cam Ranh hùng vĩ. Chỉ 15 phút từ sân bay Cam Ranh.',
 'Bãi Dài, Xã Cam Hải Đông', 'Nha Trang', 'Cam Lâm', 11.92000, 109.16000, 'ACTIVE', '15:00:00', '12:00:00', 4.89, 167),

-- NT2: Đảo Hòn Tre
((SELECT user_id FROM users WHERE email='minhtuan.owner@gmail.com'),
 'Hòn Tre Island Eco Bungalow',
 'Bungalow sinh thái trên đảo Hòn Tre giữa Vịnh Nha Trang. Đi tàu 15 phút từ cảng Nha Trang. Lặn biển san hô đa màu sắc, câu cá mực đêm và ngắm bình minh trên đảo hoang sơ.',
 'Đảo Hòn Tre, Vịnh Nha Trang', 'Nha Trang', 'Vĩnh Nguyên', 12.18000, 109.25000, 'ACTIVE', '14:00:00', '12:00:00', 4.78, 58),

-- NT3: Trần Phú - mặt tiền biển
((SELECT user_id FROM users WHERE email='minhtuan.owner@gmail.com'),
 'Nha Trang Beach Boulevard Hotel',
 'Khách sạn 4 sao mặt tiền đường Trần Phú - đại lộ ven biển đẹp nhất miền Trung. Tất cả phòng view biển, rooftop pool lầu 15 với panorama toàn vịnh Nha Trang. 5 phút tản bộ đến phố Tây Bùi Viện Nha Trang.',
 '48 Trần Phú, Phường Lộc Thọ', 'Nha Trang', 'Lộc Thọ', 12.24200, 109.19700, 'ACTIVE', '14:00:00', '12:00:00', 4.72, 248),

-- NT4: Ninh Vân Bay - xa hoa ẩn dật
((SELECT user_id FROM users WHERE email='minhtuan.owner@gmail.com'),
 'Ninh Vân Bay Water Villa',
 'Biệt thự trên nước tại vịnh Ninh Vân kỳ bí, chỉ tiếp cận bằng thuyền riêng. Không xe cộ, không ồn ào - chỉ tiếng sóng và gió biển. Villa riêng với bể bơi nổi ngay mặt vịnh và sân phơi nắng riêng.',
 'Vịnh Ninh Vân, Xã Ninh Vân', 'Nha Trang', 'Ninh Hoà', 12.45000, 109.26000, 'ACTIVE', '15:00:00', '12:00:00', 4.96, 72),

-- NT5: Gần tháp Bà Ponagar
((SELECT user_id FROM users WHERE email='minhtuan.owner@gmail.com'),
 'Ponagar Cham Tower Heritage Inn',
 'Nhà nghỉ văn hoá gần Tháp Bà Ponagar - đền Chăm 2.000 năm tuổi thờ Nữ thần Thiên Y Ana. Phòng nghỉ thiết kế lấy cảm hứng từ văn hoá Chăm Pa: gốm đỏ, hoa văn tháp cổ. Sáng ngắm tháp Bà trong sương.',
 '4 Hai Tháng Tư, Phường Vĩnh Phước', 'Nha Trang', 'Vĩnh Phước', 12.26200, 109.19000, 'ACTIVE', '13:00:00', '11:00:00', 4.55, 83),

-- NT6: Dốc Lết - bãi biển thứ hai
((SELECT user_id FROM users WHERE email='minhtuan.owner@gmail.com'),
 'Dốc Lết White Sand Resort',
 'Resort nghỉ dưỡng tại Dốc Lết Ninh Hoà - bãi cát trắng như bột mì, làn nước ngọc bích. Cách xa trung tâm Nha Trang 40km nên yên tĩnh, hoang sơ. Hải sản tươi sống được đánh bắt trực tiếp mỗi sáng.',
 'Bãi Dốc Lết, Xã Ninh Hải', 'Nha Trang', 'Ninh Hoà', 12.54000, 109.24000, 'ACTIVE', '14:00:00', '12:00:00', 4.68, 41),

-- NT7: Phố Tây - nightlife
((SELECT user_id FROM users WHERE email='minhtuan.owner@gmail.com'),
 'Backpacker Zone Nha Trang',
 'Hostel năng động ngay trung tâm khu Tây Bùi Viện Nha Trang. Bar rooftop, dorm party mỗi tối thứ 6, tổ chức tour pub crawl và boat party. Tủ giữ đồ, máy ATM và dịch vụ thuê xe máy ngay tại chỗ.',
 '32 Trần Quang Khải, Phường Tân Lập', 'Nha Trang', 'Tân Lập', 12.24700, 109.19300, 'ACTIVE', '12:00:00', '10:00:00', 4.35, 197),

-- NT8: Điệp Sơn - đảo cát nối đảo
((SELECT user_id FROM users WHERE email='minhtuan.owner@gmail.com'),
 'Điệp Sơn Sand Road Island Stay',
 'Duy nhất tại Việt Nam: đảo Điệp Sơn với con đường cát nổi giữa biển khi nước thuỷ triều rút, nối 3 đảo nhỏ. Ngủ tại nhà ngư dân, ăn cá hấp tươi, chụp ảnh con đường cát kỳ ảo lúc bình minh.',
 'Đảo Điệp Sơn, Xã Vạn Thạnh', 'Nha Trang', 'Vạn Ninh', 12.67000, 109.31000, 'ACTIVE', '13:00:00', '11:00:00', 4.80, 34),

-- NT9: Ba Hồ - thác nước nội địa
((SELECT user_id FROM users WHERE email='minhtuan.owner@gmail.com'),
 'Ba Hồ Waterfall Jungle Lodge',
 'Lodge thiên nhiên gần suối Ba Hồ - chuỗi thác và hồ bơi tự nhiên giữa rừng đẹp nhất Khánh Hoà. Trekking xuyên rừng, bơi hồ trong xanh dưới thác, BBQ bên suối. Xa phố, gần thiên nhiên.',
 'Thôn Phú Hữu, Xã Ninh Ích', 'Nha Trang', 'Ninh Hoà', 12.35000, 109.15000, 'ACTIVE', '14:00:00', '12:00:00', 4.74, 47),

-- NT10: Luxury trên núi
((SELECT user_id FROM users WHERE email='minhtuan.owner@gmail.com'),
 'Ana Mandara Cliff Villa Nha Trang',
 'Villa clifftop sang trọng nhìn xuống toàn bộ vịnh Nha Trang từ độ cao 150m. Hồ bơi treo trên vách núi, spa vi tảo biển độc quyền, bữa tối fine dining với chef Việt kiều được đào tạo tại Pháp.',
 'Núi Cảnh Long, Phường Vĩnh Hoà', 'Nha Trang', 'Vĩnh Hoà', 12.22500, 109.18000, 'ACTIVE', '15:00:00', '12:00:00', 4.93, 55);

SET FOREIGN_KEY_CHECKS = 1;

SET FOREIGN_KEY_CHECKS = 0;

-- ====================================================================================
-- PHẦN 2F: HOMESTAYS - SA PA (10 properties)
-- Owner: hongnga.owner@gmail.com
-- ====================================================================================
INSERT INTO homestays (owner_id, name, description, address, city, district, latitude, longitude, status, checkin_time, checkout_time, rating_avg, review_count) VALUES

-- SP1: Trung tâm thị trấn Sapa
((SELECT user_id FROM users WHERE email='hongnga.owner@gmail.com'),
 'Sapa Town Central Mountain Hotel',
 'Khách sạn 3 sao ngay trung tâm thị trấn Sapa, gần Nhà thờ Đá và chợ phiên Sapa cuối tuần. View thung lũng Mường Hoa từ phòng. Lobby lò sưởi ấm cúng, bữa sáng dim sum và phở Sapa.',
 '5 Cầu Mây, Thị trấn Sa Pa', 'Sa Pa', 'Thị trấn Sa Pa', 22.33600, 103.84400, 'ACTIVE', '14:00:00', '12:00:00', 4.65, 178),

-- SP2: Bản Cát Cát
((SELECT user_id FROM users WHERE email='hongnga.owner@gmail.com'),
 'Cát Cát H''Mông Traditional Lodge',
 'Lodge phong cách người H''Mông Đen trong bản Cát Cát cổ nhất Sapa - ngôi làng hơn 300 năm tuổi. Xem phụ nữ H''Mông dệt lanh, nhuộm chàm và thêu thổ cẩm. Tắm thác Tiên Sa ngay trong bản.',
 'Bản Cát Cát, Xã San Sả Hồ', 'Sa Pa', 'San Sả Hồ', 22.33000, 103.82200, 'ACTIVE', '13:00:00', '11:00:00', 4.84, 92),

-- SP3: Bản Lao Chải - ruộng bậc thang
((SELECT user_id FROM users WHERE email='hongnga.owner@gmail.com'),
 'Lao Chải Rice Terrace Eco Lodge',
 'Ecolodge trong bản Lao Chải người Mông trắng, chính giữa thung lũng ruộng bậc thang Mường Hoa huyền thoại. Mùa lúa chín tháng 9-10 vàng óng như tấm thảm khổng lồ. Trekking qua 5 bản làng 1 ngày.',
 'Bản Lao Chải, Xã Tả Van', 'Sa Pa', 'Tả Van', 22.30000, 103.88000, 'ACTIVE', '14:00:00', '12:00:00', 4.91, 74),

-- SP4: Bản Tả Phìn - người Dao Đỏ
((SELECT user_id FROM users WHERE email='hongnga.owner@gmail.com'),
 'Tả Phìn Red Dao Herbal Retreat',
 'Nghỉ dưỡng trong bản người Dao Đỏ Tả Phìn, nổi tiếng với thuốc tắm thảo dược bí truyền. Ngâm mình bồn gỗ thảo dược hơn 30 loại cây rừng, massage bấm huyệt người Dao. Thăm rừng hái thuốc cùng bà lang.',
 'Bản Tả Phìn, Xã Tả Phìn', 'Sa Pa', 'Tả Phìn', 22.39000, 103.86000, 'ACTIVE', '13:00:00', '11:00:00', 4.88, 83),

-- SP5: Ham Rong - đỉnh núi
((SELECT user_id FROM users WHERE email='hongnga.owner@gmail.com'),
 'Hàm Rồng Summit Glamping',
 'Glamping trên sườn núi Hàm Rồng huyền thoại, độ cao 1.800m, không khí trong lành tuyệt đối. Ngủ lều dome xuyên sao, sáng sớm xem mây biển bồng bềnh dưới chân. Vườn hoa đỗ quyên đỏ rực tháng 3.',
 'Đỉnh Hàm Rồng, Thị trấn Sa Pa', 'Sa Pa', 'Thị trấn Sa Pa', 22.34500, 103.83500, 'ACTIVE', '14:00:00', '12:00:00', 4.79, 51),

-- SP6: Gần ga Lào Cai - dừng đêm
((SELECT user_id FROM users WHERE email='hongnga.owner@gmail.com'),
 'Lào Cai Station Stopover Inn',
 'Nhà nghỉ tiện lợi gần ga Lào Cai dành cho khách tàu đêm từ Hà Nội. Nhận phòng từ 5 giờ sáng, giữ hành lý miễn phí, shuttle lên Sapa 1 giờ đồng hồ. Xà phòng và khăn mặt mới mỗi ngày.',
 '8 Phố Mới, Phường Lào Cai', 'Sa Pa', 'Lào Cai', 22.50800, 103.97000, 'ACTIVE', '05:00:00', '22:00:00', 4.42, 134),

-- SP7: Séo Mý Tỷ - trekking sâu
((SELECT user_id FROM users WHERE email='hongnga.owner@gmail.com'),
 'Séo Mý Tỷ Valley Deep Trek Base',
 'Điểm dừng chân dành cho trekkers chinh phục thung lũng Séo Mý Tỷ hoang dã. Nhà sàn đơn giản nhưng ấm áp, cơm canh rau rừng, thịt lợn bản. Hướng dẫn viên H''Mông am hiểu mọi ngóc ngách rừng núi.',
 'Thôn Séo Mý Tỷ, Xã Tả Van', 'Sa Pa', 'Tả Van', 22.31500, 103.90000, 'ACTIVE', '14:00:00', '12:00:00', 4.73, 38),

-- SP8: Luxury - sân thượng view thung lũng
((SELECT user_id FROM users WHERE email='hongnga.owner@gmail.com'),
 'Topas Ecolodge Style Sapa',
 'Boutique lodge 4 sao với bungalow đá granit trên đỉnh đồi 1.900m, view toàn cảnh thung lũng Mường Hoa. Hồ bơi nước nóng khoáng ngoài trời, spa đá nóng, nhà hàng set menu ẩm thực Sapa hiện đại.',
 'Núi Trống, Xã Thanh Kim', 'Sa Pa', 'Thanh Kim', 22.27000, 103.89000, 'ACTIVE', '15:00:00', '12:00:00', 4.94, 61),

-- SP9: Bản Sin Chải
((SELECT user_id FROM users WHERE email='hongnga.owner@gmail.com'),
 'Sin Chải Black H''Mông Homestay',
 'Nhà sàn H''Mông Đen truyền thống tại bản Sin Chải ít người ghé thăm, cách trung tâm 3km. Gia đình 3 thế hệ cùng đón khách, kể chuyện văn hoá bên bếp lửa, uống rượu ngô Bắc Hà và ăn thắng cố.',
 'Bản Sin Chải, Thị trấn Sa Pa', 'Sa Pa', 'Thị trấn Sa Pa', 22.34000, 103.81500, 'ACTIVE', '13:00:00', '11:00:00', 4.77, 45),

-- SP10: Budget - phố đi bộ
((SELECT user_id FROM users WHERE email='hongnga.owner@gmail.com'),
 'Sapa Fog Hostel',
 'Hostel thân thiện cạnh phố đi bộ Sapa, lò sưởi phòng khách chung, chăn lông vũ dày ấm. Miễn phí trà nóng và cháo yến mạch sáng. Tour trekking ghép nhóm giá rẻ nhất thị trấn.',
 '18 Thạch Sơn, Thị trấn Sa Pa', 'Sa Pa', 'Thị trấn Sa Pa', 22.33800, 103.84700, 'ACTIVE', '12:00:00', '10:00:00', 4.52, 221),

-- ====================================================================================
-- PHẦN 2G: HOMESTAYS - ĐÀ NẴNG (10 properties)
-- Owner: quocbao.owner@gmail.com
-- ====================================================================================

-- DN1: Mỹ Khê - bãi biển nổi tiếng nhất
((SELECT user_id FROM users WHERE email='quocbao.owner@gmail.com'),
 'Mỹ Khê Sunrise Beach Hotel',
 'Khách sạn 4 sao sát bãi Mỹ Khê - bãi biển được Forbes bình chọn đẹp nhất hành tinh. Mọi phòng ban công view biển, bể bơi infinitypool, nhà hàng hải sản & BBQ tối. 5 phút lái xe đến cầu Rồng phun lửa.',
 '120 Võ Nguyên Giáp, Quận Sơn Trà', 'Đà Nẵng', 'Sơn Trà', 16.06100, 108.24900, 'ACTIVE', '14:00:00', '12:00:00', 4.80, 315),

-- DN2: Bán đảo Sơn Trà - thiên nhiên
((SELECT user_id FROM users WHERE email='quocbao.owner@gmail.com'),
 'Sơn Trà Peninsula Wildlife Lodge',
 'Lodge sinh thái trên bán đảo Sơn Trà - khu bảo tồn voọc chà vá chân nâu quý hiếm. Ngắm voọc từ ban công vào buổi sáng, trekking rừng nguyên sinh, ngắm bình minh từ chùa Linh Ứng trên đỉnh.',
 'Đường Hoàng Sa, Sơn Trà', 'Đà Nẵng', 'Sơn Trà', 16.10000, 108.27000, 'ACTIVE', '14:00:00', '12:00:00', 4.85, 67),

-- DN3: Non Nước - Ngũ Hành Sơn
((SELECT user_id FROM users WHERE email='quocbao.owner@gmail.com'),
 'Ngũ Hành Sơn Marble Boutique',
 'Boutique hotel dưới chân núi đá cẩm thạch Ngũ Hành Sơn huyền bí. Buổi sáng leo hang động và lên đỉnh núi ngắm toàn cảnh biển Đà Nẵng và Hội An. Mua đồ mỹ nghệ đá Non Nước nổi tiếng cả nước.',
 '15 Huyền Trân Công Chúa, Quận Ngũ Hành Sơn', 'Đà Nẵng', 'Ngũ Hành Sơn', 16.00200, 108.26200, 'ACTIVE', '14:00:00', '12:00:00', 4.68, 102),

-- DN4: Trung tâm - gần cầu Rồng
((SELECT user_id FROM users WHERE email='quocbao.owner@gmail.com'),
 'Dragon Bridge City Center Apartment',
 'Căn hộ dịch vụ hiện đại view cầu Rồng và cầu Sông Hàn từ tầng cao. Bếp đầy đủ tiện nghi, máy giặt riêng - phù hợp lưu trú dài ngày. Chứng kiến cầu Rồng phun lửa và phun nước mỗi cuối tuần.',
 '35 Trần Hưng Đạo, Quận Hải Châu', 'Đà Nẵng', 'Hải Châu', 16.06900, 108.22500, 'ACTIVE', '14:00:00', '12:00:00', 4.72, 148),

-- DN5: Bà Nà Hills area
((SELECT user_id FROM users WHERE email='quocbao.owner@gmail.com'),
 'Bà Nà Hills Foothills Retreat',
 'Nghỉ dưỡng dưới chân núi Bà Nà (1.487m), 25km từ trung tâm. Khí hậu mát mẻ 20°C quanh năm. Shuttle miễn phí lên cáp treo Bà Nà - cáp treo một cabin dài nhất thế giới, lên Làng Pháp cổ tích.',
 'Xã Hoà Ninh, Huyện Hoà Vang', 'Đà Nẵng', 'Hoà Vang', 15.99000, 107.99000, 'ACTIVE', '14:00:00', '12:00:00', 4.75, 88),

-- DN6: Nam Ô - làng chài nước mắm
((SELECT user_id FROM users WHERE email='quocbao.owner@gmail.com'),
 'Nam Ô Fishing Village Homestay',
 'Ngủ tại nhà ngư dân làng Nam Ô cổ - làng chài 700 năm tuổi nổi tiếng nước mắm đặc sản. Ra khơi đánh lưới lúc 4 giờ sáng, thăm xưởng ủ mắm cá cơm truyền thống và tắm biển làng chài hoang sơ.',
 'Phường Nam Ô, Quận Liên Chiểu', 'Đà Nẵng', 'Liên Chiểu', 16.08500, 108.16500, 'ACTIVE', '13:00:00', '11:00:00', 4.70, 43),

-- DN7: Mỹ An - khu biệt thự
((SELECT user_id FROM users WHERE email='quocbao.owner@gmail.com'),
 'Mỹ An Luxury Pool Villa',
 'Biệt thự sang trọng khu Mỹ An, 5 phòng ngủ, bể bơi nước mặn 12m, sân vườn rộng rãi. Chỉ 200m ra bãi Mỹ Khê. Phù hợp nhóm gia đình 10-12 người tổ chức du lịch team building hoặc đám cưới nhỏ.',
 '77 Trần Bạch Đằng, Quận Ngũ Hành Sơn', 'Đà Nẵng', 'Ngũ Hành Sơn', 16.04500, 108.24700, 'ACTIVE', '15:00:00', '12:00:00', 4.90, 38),

-- DN8: Hải Châu - khách sạn thương nhân
((SELECT user_id FROM users WHERE email='quocbao.owner@gmail.com'),
 'Hải Châu Business Inn Đà Nẵng',
 'Khách sạn 3 sao giá trị tốt cho khách công tác. Phòng họp, dịch vụ in ấn, wifi tốc độ cao và bàn làm việc rộng. Gần chợ Hàn, trung tâm thương mại và ga Đà Nẵng. Checkout linh hoạt muộn đến 14h.',
 '22 Ông Ích Khiêm, Quận Hải Châu', 'Đà Nẵng', 'Hải Châu', 16.06400, 108.22200, 'ACTIVE', '14:00:00', '13:00:00', 4.48, 92),

-- DN9: Làng Vân - làng biệt lập
((SELECT user_id FROM users WHERE email='quocbao.owner@gmail.com'),
 'Làng Vân Isolated Beach Camp',
 'Trải nghiệm độc đáo: cắm trại tại làng Vân hoàn toàn biệt lập trên sườn núi Hải Vân, chỉ đến bằng thuyền. Bãi biển hoang sơ riêng tư, câu cá, bắt bạch tuộc đêm. Tắm biển sóng lớn tuyệt đỉnh.',
 'Làng Vân, Quận Liên Chiểu', 'Đà Nẵng', 'Liên Chiểu', 16.13000, 108.16000, 'ACTIVE', '13:00:00', '11:00:00', 4.82, 29),

-- DN10: Gần sân bay - budget transit
((SELECT user_id FROM users WHERE email='quocbao.owner@gmail.com'),
 'Airport Transit Guesthouse Đà Nẵng',
 'Nhà khách tiện lợi chỉ 3 phút lái xe từ sân bay Đà Nẵng. Nhận phòng 24/7, check-out linh hoạt, free airport transfer. Lưu trú ngắn 3-6 tiếng cho khách transit hoặc chuyến bay sớm.',
 '12 Dũng Sỹ Thanh Khê, Quận Thanh Khê', 'Đà Nẵng', 'Thanh Khê', 16.05700, 108.20500, 'ACTIVE', '00:00:00', '23:59:00', 4.38, 167),

-- ====================================================================================
-- PHẦN 2H: HOMESTAYS - HUẾ (10 properties)
-- Owner: lanchi.owner@gmail.com
-- ====================================================================================

-- HE1: Đại Nội - trung tâm hoàng thành
((SELECT user_id FROM users WHERE email='lanchi.owner@gmail.com'),
 'Hoàng Thành Heritage Boutique Huế',
 'Boutique hotel trong nhà vườn Huế truyền thống cách Đại Nội 500m. Kiến trúc mái ngói âm dương, cột sơn son thếp vàng, sân vườn trồng bông sứ và ngọc lan. Phòng lấy tên các hoàng đế triều Nguyễn.',
 '12 Đinh Tiên Hoàng, Phường Thuận Thành', 'Huế', 'Thành phố Huế', 16.47200, 107.58200, 'ACTIVE', '14:00:00', '12:00:00', 4.88, 134),

-- HE2: Dòng Hương Giang - thuyền rồng
((SELECT user_id FROM users WHERE email='lanchi.owner@gmail.com'),
 'Hương Giang Floating Boat House',
 'Ngủ trên thuyền rồng đặc trưng Huế neo đậu bên bờ sông Hương. Buổi tối xem biểu diễn ca Huế trên thuyền dưới ánh đèn lồng lung linh. Sáng ngắm Huế từ mặt sông, dọc hai bờ xanh cây cổ thụ.',
 'Bến Thuyền Tòa Khâm, Đường Lê Lợi', 'Huế', 'Thành phố Huế', 16.46500, 107.58500, 'ACTIVE', '15:00:00', '11:00:00', 4.85, 76),

-- HE3: Gần chùa Thiên Mụ
((SELECT user_id FROM users WHERE email='lanchi.owner@gmail.com'),
 'Thiên Mụ Pagoda Zen Retreat',
 'Nhà nghỉ thiền định gần Chùa Thiên Mụ huyền thoại ven sông Hương. Thức dậy lúc 5 giờ nghe chuông chùa vang, đi bộ lên tháp Phước Duyên 7 tầng đón bình minh. Ăn cơm chay do sư thầy nấu.',
 '22 Kim Long, Phường Kim Long', 'Huế', 'Thành phố Huế', 16.45800, 107.55600, 'ACTIVE', '13:00:00', '11:00:00', 4.77, 58),

-- HE4: Làng Vỹ Dạ - nhà thơ Hàn Mặc Tử
((SELECT user_id FROM users WHERE email='lanchi.owner@gmail.com'),
 'Vỹ Dạ Poet Village Garden House',
 'Nhà vườn xanh mướt làng Vỹ Dạ - làng thơ gắn liền với Hàn Mặc Tử. Không gian lãng đãng, đặc chất Huế trầm mặc. Sáng ăn bún bò Huế gia truyền ngay trong nhà, chiều uống trà sen nhìn vườn.',
 '5 Nguyễn Sinh Cung, Phường Vỹ Dạ', 'Huế', 'Thành phố Huế', 16.46000, 107.60500, 'ACTIVE', '14:00:00', '12:00:00', 4.82, 67),

-- HE5: Gần lăng Tự Đức
((SELECT user_id FROM users WHERE email='lanchi.owner@gmail.com'),
 'Lăng Tự Đức Royal Forest Ecolodge',
 'Ecolodge trong rừng thông xanh cạnh Lăng Tự Đức - công trình kiến trúc thơ nhất triều Nguyễn. Sáng sớm một mình tản bộ khám phá lăng mộ trong yên tĩnh trước giờ mở cửa đón khách đại trà.',
 'Đường Lê Ngô Cát, Phường Thủy Xuân', 'Huế', 'Thành phố Huế', 16.43700, 107.55700, 'ACTIVE', '14:00:00', '12:00:00', 4.70, 44),

-- HE6: Phú Vang - làng nghề nón lá
((SELECT user_id FROM users WHERE email='lanchi.owner@gmail.com'),
 'Làng Chuồn Nón Lá Artisan Homestay',
 'Sống cùng nghệ nhân làng Chuồn, huyện Phú Vang - làng nón lá Huế nổi tiếng nhất Việt Nam. Học làm nón bài thơ Huế từ đầu: chọn lá, chuốt lá, lên khung, khâu nón. Mặc áo dài chụp ảnh bộ ảnh nón cổ điển.',
 'Thôn Mỹ Lam, Xã Phú Hồ', 'Huế', 'Phú Vang', 16.40000, 107.73000, 'ACTIVE', '13:00:00', '11:00:00', 4.72, 39),

-- HE7: Gần Cầu Ngói Thanh Toàn
((SELECT user_id FROM users WHERE email='lanchi.owner@gmail.com'),
 'Thanh Toàn Bridge Village Homestay',
 'Nhà nông dân cạnh cầu ngói Thanh Toàn 200 năm tuổi - cây cầu ngói duy nhất còn sót lại ở miền Nam. Cánh đồng lúa trải dài, câu cá trên sông, ngồi hóng mát trên cầu ngói ngắm thuyền đi qua.',
 'Thôn Thanh Toàn, Xã Thuỷ Thanh', 'Huế', 'Hương Thuỷ', 16.41500, 107.65000, 'ACTIVE', '13:00:00', '11:00:00', 4.68, 51),

-- HE8: Luxury - resort đồi thông
((SELECT user_id FROM users WHERE email='lanchi.owner@gmail.com'),
 'Vedana Lagoon Huế Luxury Resort',
 'Resort 5 sao ẩn mình trong rừng thông ven đầm phá Tam Giang rộng lớn nhất Đông Nam Á. Bungalow trên cọc giữa đầm nước, thuyền kayak riêng, câu cá tôm đầm, tắm bùn khoáng nhiệt và spa tắm lá.',
 'Đầm phá Tam Giang, Xã Phú Lộc', 'Huế', 'Phú Lộc', 16.26000, 107.82000, 'ACTIVE', '15:00:00', '12:00:00', 4.95, 82),

-- HE9: Gần trường Đồng Khánh cũ
((SELECT user_id FROM users WHERE email='lanchi.owner@gmail.com'),
 'Đồng Khánh Colonial Guesthouse',
 'Nhà khách phong cách Pháp thuộc gần trường THPT Hai Bà Trưng (cũ là trường Đồng Khánh) lịch sử. Kiến trúc thuộc địa hoàn hảo: sàn terrazzo, cầu thang gỗ cong, cửa chớp xanh, đèn gas vintage.',
 '3 Lê Lợi, Phường Phú Hội', 'Huế', 'Thành phố Huế', 16.46800, 107.58800, 'ACTIVE', '14:00:00', '12:00:00', 4.74, 88),

-- HE10: Budget - gần ga Huế
((SELECT user_id FROM users WHERE email='lanchi.owner@gmail.com'),
 'Huế Station Budget Guesthouse',
 'Nhà nghỉ sạch gần ga Huế, phù hợp khách du lịch bụi và sinh viên. Cho thuê xe đạp khám phá làng An Hiên, làng Thanh Phước và đường Nguyễn Phúc Nguyên. Chủ nhà hướng dẫn ăn vặt Huế miễn phí.',
 '18 Bùi Thị Xuân, Phường Phú Hội', 'Huế', 'Thành phố Huế', 16.46100, 107.59800, 'ACTIVE', '12:00:00', '10:00:00', 4.48, 115),

-- ====================================================================================
-- PHẦN 2I: HOMESTAYS - MŨI NÉ / PHAN THIẾT (10 properties)
-- Owner: vinhphuc.owner@gmail.com
-- ====================================================================================

-- MN1: Đồi cát đỏ
((SELECT user_id FROM users WHERE email='vinhphuc.owner@gmail.com'),
 'Red Sand Dune Desert Lodge',
 'Lodge độc đáo sát đồi cát đỏ huyền bí Mũi Né. Lướt cát (sandboarding) trên đồi cao 30m, cưỡi xe địa hình ATV xuyên sa mạc mini Việt Nam. Hoàng hôn trên đồi cát - cảnh tượng không đâu có.',
 'Đồi Hồng, Đường Nguyễn Thông', 'Phan Thiết', 'Mũi Né', 10.95000, 108.28000, 'ACTIVE', '14:00:00', '12:00:00', 4.78, 91),

-- MN2: Bãi biển Mũi Né
((SELECT user_id FROM users WHERE email='vinhphuc.owner@gmail.com'),
 'Mũi Né Kite Surf Beach Resort',
 'Resort ven biển Mũi Né nổi tiếng gió, thiên đường của dân lướt ván diều (kitesurfing) và lướt sóng. Trường dạy kite surf tiêu chuẩn quốc tế ngay tại chỗ. Phòng nhìn ra biển với gió biển mát rượi.',
 '112 Nguyễn Đình Chiểu, Hàm Tiến', 'Phan Thiết', 'Hàm Tiến', 10.97500, 108.26500, 'ACTIVE', '14:00:00', '12:00:00', 4.72, 128),

-- MN3: Tiên Thành - suối nước
((SELECT user_id FROM users WHERE email='vinhphuc.owner@gmail.com'),
 'Fairy Stream Jungle Retreat',
 'Khu nghỉ ven Suối Tiên - con suối đỏ huyền ảo chảy qua rừng cây trắng và đồi cát đỏ. Lội bộ chân trần dọc suối nước ấm, ngắm cảnh đẹp lạ thường. Hammock rừng và bữa trưa hải sản tươi sống.',
 'Suối Tiên, Phường Mũi Né', 'Phan Thiết', 'Mũi Né', 10.94500, 108.29500, 'ACTIVE', '13:00:00', '11:00:00', 4.83, 67),

-- MN4: Phan Thiết cổ - phố ẩm thực
((SELECT user_id FROM users WHERE email='vinhphuc.owner@gmail.com'),
 'Phan Thiết Old Town Food Trail Inn',
 'Nhà nghỉ trong phố cổ Phan Thiết, gần chợ Phan Thiết và phố ẩm thực đêm nổi tiếng. Nếm bánh căn, bánh xèo Phan Thiết, bún suông và mực một nắng đặc sản. Xe đạp miễn phí khám phá phố cổ.',
 '5 Trưng Nhị, Phường Đức Thắng', 'Phan Thiết', 'Phan Thiết', 10.93500, 108.10500, 'ACTIVE', '13:00:00', '11:00:00', 4.60, 55),

-- MN5: Cao cấp - resort đẳng cấp
((SELECT user_id FROM users WHERE email='vinhphuc.owner@gmail.com'),
 'Anantara Mũi Né Style Villa',
 'Biệt thự nghỉ dưỡng 5 sao concept Anantara ven biển Mũi Né. Hồ bơi riêng 20m, butler service 24/7, spa mặt biển và nhà hàng ẩm thực Pan-Asian cao cấp. Bữa sáng kiểu Pháp trên ban công nhìn ra Biển Đông.',
 '58 Nguyễn Đình Chiểu, Hàm Tiến', 'Phan Thiết', 'Hàm Tiến', 10.97800, 108.26000, 'ACTIVE', '15:00:00', '12:00:00', 4.93, 73),

-- MN6: Đồi cát trắng Bàu Trắng
((SELECT user_id FROM users WHERE email='vinhphuc.owner@gmail.com'),
 'Bàu Trắng White Dune Glamping',
 'Glamping trên đồi cát trắng Bàu Trắng - đồi cát trắng tinh khiết như Sahara thu nhỏ cách Mũi Né 50km. Lều sang trọng view hồ nước giữa sa mạc. Trải nghiệm hoàn toàn khác biệt so với cát đỏ Mũi Né.',
 'Bàu Trắng, Xã Hoà Thắng', 'Phan Thiết', 'Bắc Bình', 11.10000, 108.40000, 'ACTIVE', '14:00:00', '12:00:00', 4.75, 36),

-- MN7: Gần resort 5 sao - giá tầm trung
((SELECT user_id FROM users WHERE email='vinhphuc.owner@gmail.com'),
 'Sunflower Beach Garden Homestay',
 'Homestay vườn hướng dương sát bãi biển Mũi Né, bể bơi nước mặn, thư giãn giữa 2 resort 5 sao nhưng giá chỉ bằng 1/3. Sân vườn xanh tốt, ghế tắm nắng, xe đạp và ván lướt sóng miễn phí cho khách.',
 '78 Nguyễn Đình Chiểu, Hàm Tiến', 'Phan Thiết', 'Hàm Tiến', 10.97000, 108.26800, 'ACTIVE', '14:00:00', '12:00:00', 4.66, 84),

-- MN8: Cầu cá - bãi Đá Ông Địa
((SELECT user_id FROM users WHERE email='vinhphuc.owner@gmail.com'),
 'Ông Địa Rock Beach Bungalow',
 'Bungalow mộc mạc bên bãi đá Ông Địa - nơi ngư dân Mũi Né cầu nguyện trước mỗi chuyến ra khơi. Không gian tâm linh yên tĩnh, nghe sóng đập vào đá, ngắm ngư dân đẩy thuyền thúng lúc bình minh.',
 'Bãi Ông Địa, Đường Nguyễn Đình Chiểu', 'Phan Thiết', 'Mũi Né', 10.96000, 108.28500, 'ACTIVE', '13:00:00', '11:00:00', 4.70, 42),

-- MN9: Long Sơn - vắng khách
((SELECT user_id FROM users WHERE email='vinhphuc.owner@gmail.com'),
 'Tiến Thành Unspoiled Beach Retreat',
 'Khu nghỉ yên tĩnh tại bãi Tiến Thành ít người biết, 10km từ trung tâm Phan Thiết. Bãi biển sạch, ít người, nước trong. Lướt cano, kéo dù, snorkeling và câu cá mực đêm cùng ngư dân bản địa.',
 'Bãi Tiến Thành, Xã Tiến Thành', 'Phan Thiết', 'Phan Thiết', 10.88000, 108.05000, 'ACTIVE', '14:00:00', '12:00:00', 4.62, 28),

-- MN10: Budget hostel
((SELECT user_id FROM users WHERE email='vinhphuc.owner@gmail.com'),
 'Mũi Né Backpacker Beach Hostel',
 'Hostel đặc trưng phong cách Mũi Né: sàn cát, giường dù biển, quán bar tre nứa phục vụ sinh tố và bia hơi. Tour cát và biển tự tổ chức 5 USD/người. Tủ trữ đồ ẩm và máy sấy chuyên dụng cho dân lướt ván.',
 '156 Nguyễn Đình Chiểu, Hàm Tiến', 'Phan Thiết', 'Hàm Tiến', 10.97200, 108.25800, 'ACTIVE', '12:00:00', '10:00:00', 4.40, 186),

-- ====================================================================================
-- PHẦN 2J: HOMESTAYS - HÀ GIANG (10 properties)
-- Owner: tuankhoa.owner@gmail.com
-- ====================================================================================

-- HG1: Đồng Văn - cao nguyên đá
((SELECT user_id FROM users WHERE email='tuankhoa.owner@gmail.com'),
 'Đồng Văn Karst Plateau Guesthouse',
 'Nhà khách ngay thị trấn Đồng Văn trên cao nguyên đá 1.100m - di sản địa chất toàn cầu UNESCO. Nhà cổ H''Mông với tường đá, mái ngói âm dương, view hẻm vực Tu Sản hùng vĩ từ ban công.',
 'Phố cổ Đồng Văn, Thị trấn Đồng Văn', 'Hà Giang', 'Đồng Văn', 23.27500, 105.36000, 'ACTIVE', '14:00:00', '12:00:00', 4.86, 94),

-- HG2: Mèo Vạc - hẻm Tu Sản
((SELECT user_id FROM users WHERE email='tuankhoa.owner@gmail.com'),
 'Tu Sản Canyon View Lodge',
 'Lodge duy nhất có view trực diện hẻm vực Tu Sản sâu 800m - một trong những hẻm núi đẹp nhất Đông Nam Á. Ngủ trong tiếng suối Nho Quế chảy dưới vực xa. Trekking men vách đá và chèo thuyền kayak trên sông Nho Quế xanh ngọc.',
 'Xã Pải Lủng, Huyện Mèo Vạc', 'Hà Giang', 'Mèo Vạc', 23.17000, 105.43000, 'ACTIVE', '14:00:00', '12:00:00', 4.92, 61),

-- HG3: Quản Bạ - núi Đôi
((SELECT user_id FROM users WHERE email='tuankhoa.owner@gmail.com'),
 'Cổng Trời Quản Bạ Twin Mountain Stay',
 'Homestay ngay chân "Cổng Trời" Quản Bạ với cặp núi tròn trọc đặc trưng. Đỉnh Cổng Trời 1.500m nhìn xuống thung lũng trải dài, sáng mờ mây phủ núi Đôi huyền ảo như trong truyện cổ.',
 'Thị trấn Tam Sơn, Huyện Quản Bạ', 'Hà Giang', 'Quản Bạ', 23.05000, 105.02000, 'ACTIVE', '13:00:00', '11:00:00', 4.80, 47),

-- HG4: Yên Minh - giữa đường
((SELECT user_id FROM users WHERE email='tuankhoa.owner@gmail.com'),
 'Yên Minh Pine Forest Stopover',
 'Điểm dừng chân giữa hành trình chinh phục vòng cung Hà Giang. Rừng thông Yên Minh đẹp nhất Hà Giang, đồi cỏ xanh mướt. Phòng đơn sạch sẽ, cơm canh gia đình, giặt đồ nhanh chỉ 2 tiếng.',
 'Thị trấn Yên Minh, Huyện Yên Minh', 'Hà Giang', 'Yên Minh', 23.12000, 105.15000, 'ACTIVE', '13:00:00', '11:00:00', 4.63, 88),

-- HG5: Lũng Cú - cực Bắc Tổ Quốc
((SELECT user_id FROM users WHERE email='tuankhoa.owner@gmail.com'),
 'Lũng Cú Northernmost Homestay',
 'Nhà nghỉ sát cột cờ Lũng Cú - điểm cực Bắc thiêng liêng của Tổ Quốc Việt Nam. Leo 389 bậc đá lên cột cờ cao 34m, cắm cờ đỏ sao vàng tung bay trên đỉnh. Ăn cơm lam và uống rượu ngô với người Lô Lô Hoa.',
 'Thôn Séo Lủng, Xã Lũng Cú', 'Hà Giang', 'Đồng Văn', 23.37000, 105.33000, 'ACTIVE', '13:00:00', '11:00:00', 4.88, 55),

-- HG6: Thành phố Hà Giang - cửa ngõ
((SELECT user_id FROM users WHERE email='tuankhoa.owner@gmail.com'),
 'Hà Giang City Gateway Hotel',
 'Khách sạn 3 sao tại thành phố Hà Giang - điểm xuất phát cho mọi hành trình lên cao nguyên đá. Bãi xe rộng, dịch vụ thuê xe máy Win/Honda chuyên leo đèo, tư vấn lộ trình và thời tiết free.',
 '88 Nguyễn Trãi, Thành phố Hà Giang', 'Hà Giang', 'Thành phố Hà Giang', 22.82500, 104.98000, 'ACTIVE', '14:00:00', '12:00:00', 4.58, 142),

-- HG7: Thôn Tha - nhà người Mông
((SELECT user_id FROM users WHERE email='tuankhoa.owner@gmail.com'),
 'Thôn Tha H''Mông Flower Village',
 'Sống cùng người H''Mông tại thôn Tha nổi tiếng mùa hoa tam giác mạch tháng 10-11. Cánh đồng tam giác mạch hồng tím trải rộng cả thung lũng. Học xay bột làm bánh tam giác mạch và ủ rượu thóc.',
 'Thôn Tha, Xã Phố Cáo', 'Hà Giang', 'Đồng Văn', 23.25000, 105.32000, 'ACTIVE', '13:00:00', '11:00:00', 4.90, 72),

-- HG8: Phố Bảng - chợ phiên
((SELECT user_id FROM users WHERE email='tuankhoa.owner@gmail.com'),
 'Phố Bảng Sunday Market Lodge',
 'Lodge gần chợ phiên Phố Bảng họp mỗi chủ nhật - phiên chợ vùng cao đặc sắc nhất Hà Giang. Người H''Mông, Dao, Tày, Giáy mặc trang phục truyền thống mang ngô, gà, chó xuống chợ đổi hàng.',
 'Thị trấn Phố Bảng, Huyện Đồng Văn', 'Hà Giang', 'Đồng Văn', 23.29000, 105.29000, 'ACTIVE', '13:00:00', '11:00:00', 4.75, 41),

-- HG9: Bắc Mê - hoang vu
((SELECT user_id FROM users WHERE email='tuankhoa.owner@gmail.com'),
 'Bắc Mê Riverside Wild Camp',
 'Cắm trại hoang dã ven sông Gâm tại huyện Bắc Mê ít người biết. Rừng già nguyên sinh, thác nước hoang sơ và đồng lúa bản Tày trữ tình. Dành cho phượt thủ thực thụ muốn khám phá Hà Giang chưa bị thương mại hoá.',
 'Xã Yên Phú, Huyện Bắc Mê', 'Hà Giang', 'Bắc Mê', 22.73000, 105.37000, 'ACTIVE', '14:00:00', '12:00:00', 4.69, 22),

-- HG10: Vị Xuyên - nơi chiến trận
((SELECT user_id FROM users WHERE email='tuankhoa.owner@gmail.com'),
 'Vị Xuyên Frontier History Guesthouse',
 'Nhà khách gần chiến trường Vị Xuyên - nơi ghi dấu cuộc chiến tranh biên giới 1984-1989. Tham quan nghĩa trang liệt sĩ, hang động chiến tranh và nghe kể chuyện lịch sử từ cựu chiến binh địa phương.',
 'Thị trấn Vị Xuyên, Huyện Vị Xuyên', 'Hà Giang', 'Vị Xuyên', 22.68000, 104.97000, 'ACTIVE', '14:00:00', '12:00:00', 4.62, 33);

SET FOREIGN_KEY_CHECKS = 1;

SET FOREIGN_KEY_CHECKS = 0;

-- ====================================================================================
-- PHẦN 2K: HOMESTAYS - NINH BÌNH (10 properties)
-- Owner: maihuong.owner@gmail.com (dùng chung)
-- ====================================================================================
INSERT INTO homestays (owner_id, name, description, address, city, district, latitude, longitude, status, checkin_time, checkout_time, rating_avg, review_count) VALUES

-- NB1: Tràng An - di sản UNESCO
((SELECT user_id FROM users WHERE email='maihuong.owner@gmail.com'),
 'Tràng An UNESCO Riverside Lodge',
 'Lodge ven sông Sào Khê cạnh cổng khu di sản Tràng An - vịnh Hạ Long trên cạn. Thuê thuyền rowing khám phá hang động và đền thờ cổ ngay từ bến riêng của lodge. Bữa cơm niêu đặc sản Ninh Bình.',
 'Thôn Trường Yên, Xã Trường Yên', 'Ninh Bình', 'Hoa Lư', 20.27000, 105.83000, 'ACTIVE', '14:00:00', '12:00:00', 4.88, 96),

-- NB2: Tam Cốc - gạo và hang
((SELECT user_id FROM users WHERE email='maihuong.owner@gmail.com'),
 'Tam Cốc Paddyfield Homestay',
 'Nhà sàn gỗ nhìn ra cánh đồng lúa Tam Cốc xanh mướt với núi đá sừng sững. Chèo thuyền xuyên 3 hang động (Hang Cả, Hang Hai, Hang Ba), leo đỉnh núi Mua ngắm toàn cảnh như phim trường.',
 '8 Tam Cốc, Xã Ninh Hải', 'Ninh Bình', 'Hoa Lư', 20.22500, 105.93000, 'ACTIVE', '13:00:00', '11:00:00', 4.80, 134),

-- NB3: Cố Đô Hoa Lư
((SELECT user_id FROM users WHERE email='maihuong.owner@gmail.com'),
 'Hoa Lư Ancient Capital Guesthouse',
 'Nhà khách gần Cố Đô Hoa Lư - kinh đô đầu tiên của Đại Cồ Việt thế kỷ X, thờ vua Đinh và vua Lê. Sáng thắp nhang đền vua, nghe sử quan kể chuyện dựng nước. Ẩm thực đặc sản: thịt dê núi và cơm cháy Ninh Bình.',
 '3 Trường Yên, Huyện Hoa Lư', 'Ninh Bình', 'Hoa Lư', 20.28500, 105.84500, 'ACTIVE', '14:00:00', '12:00:00', 4.72, 67),

-- NB4: Chùa Bái Đính
((SELECT user_id FROM users WHERE email='maihuong.owner@gmail.com'),
 'Bái Đính Spiritual Retreat',
 'Nhà nghỉ tâm linh gần chùa Bái Đính - ngôi chùa lớn nhất Đông Nam Á với 500 pho tượng La Hán. Ăn cơm chay Phật giáo thanh tịnh, tham dự lễ tụng kinh buổi sáng và chiều. Không khí trầm mặc, phục hồi tâm hồn.',
 'Khu du lịch Bái Đính, Xã Gia Sinh', 'Ninh Bình', 'Gia Viễn', 20.35000, 105.84000, 'ACTIVE', '14:00:00', '12:00:00', 4.75, 53),

-- NB5: Vân Long - đầm nước
((SELECT user_id FROM users WHERE email='maihuong.owner@gmail.com'),
 'Vân Long Wetland Bird Watch Lodge',
 'Lodge sinh thái ven đầm Vân Long - khu bảo tồn thiên nhiên ngập nước lớn nhất đồng bằng Bắc Bộ. Ngắm voọc mông trắng quý hiếm, chim cò diệc, rùa đầm trên thuyền buổi bình minh. Không khí trong lành tuyệt đối.',
 'Thôn Xuân Vũ, Xã Gia Vân', 'Ninh Bình', 'Gia Viễn', 20.35500, 105.73000, 'ACTIVE', '14:00:00', '12:00:00', 4.85, 44),

-- NB6: Thành phố Ninh Bình
((SELECT user_id FROM users WHERE email='truclinh.owner@gmail.com'),
 'Ninh Bình City Center Hotel',
 'Khách sạn 3 sao tiện nghi tại trung tâm thành phố Ninh Bình. Xe đạp thuê 50k/ngày, bản đồ du lịch miễn phí. Toà nhà ngay cạnh sông Vân - dòng sông cổ chảy xuyên thành phố.',
 '15 Tràng Hàn, Thành phố Ninh Bình', 'Ninh Bình', 'Thành phố Ninh Bình', 20.25200, 105.96800, 'ACTIVE', '14:00:00', '12:00:00', 4.52, 89),

-- NB7: Kênh Gà - suối nước nóng
((SELECT user_id FROM users WHERE email='truclinh.owner@gmail.com'),
 'Kênh Gà Hot Spring Riverside Resort',
 'Resort ven sông Hoàng Long gần suối nước nóng Kênh Gà tự nhiên - nhiệt độ 53°C, chứa khoáng chất chữa bệnh. Tắm suối khoáng ngoài trời, massage đá nóng và thuyền khám phá sông Hoàng Long huyền bí.',
 'Xã Gia Thịnh, Huyện Gia Viễn', 'Ninh Bình', 'Gia Viễn', 20.38000, 105.77000, 'ACTIVE', '14:00:00', '12:00:00', 4.73, 58),

-- NB8: Núi Chùa - view đẹp
((SELECT user_id FROM users WHERE email='truclinh.owner@gmail.com'),
 'Núi Chùa Panorama Ecolodge',
 'Ecolodge trên sườn núi Chùa, nơi có thể quan sát toàn cảnh cánh đồng lúa Tam Cốc - Bích Động từ trên cao. Bữa sáng tổ chức ngoài trời trên đồi, xe đạp leo núi và thiền yoga lúc bình minh.',
 'Núi Chùa, Xã Ninh Xuân', 'Ninh Bình', 'Hoa Lư', 20.22000, 105.92000, 'ACTIVE', '14:00:00', '12:00:00', 4.79, 41),

-- NB9: Cúc Phương - rừng quốc gia
((SELECT user_id FROM users WHERE email='anhduc.owner@gmail.com'),
 'Cúc Phương National Park Cabin',
 'Cabin gỗ trong rừng quốc gia Cúc Phương - khu rừng nguyên sinh lớn nhất miền Bắc. Đêm ngủ nghe tiếng chim và thú rừng. Trekking 24km qua rừng cổ thụ 1.000 năm, thăm trung tâm cứu hộ linh trưởng.',
 'Rừng Quốc Gia Cúc Phương, Huyện Nho Quan', 'Ninh Bình', 'Nho Quan', 20.35000, 105.64000, 'ACTIVE', '14:00:00', '12:00:00', 4.82, 63),

-- NB10: Budget - gần bến thuyền
((SELECT user_id FROM users WHERE email='anhduc.owner@gmail.com'),
 'Ninh Hải Budget Guesthouse',
 'Nhà nghỉ kinh tế ngay bến thuyền Tam Cốc, phù hợp du khách trong nước và khách bụi. Gần hàng ăn bún bò ngon, cho thuê xe đạp đi Bích Động 2km. Chủ nhà tặng mũ nón lá khi trả phòng.',
 '45 Ninh Hải, Xã Ninh Hải', 'Ninh Bình', 'Hoa Lư', 20.22800, 105.93500, 'ACTIVE', '12:00:00', '10:00:00', 4.45, 108),

-- ====================================================================================
-- PHẦN 2L: HOMESTAYS - QUY NHƠN (10 properties)
-- Owner: thanhphuong.owner@gmail.com (dùng chung)
-- ====================================================================================

-- QN1: Kỳ Co - vịnh đẹp
((SELECT user_id FROM users WHERE email='thanhphuong.owner@gmail.com'),
 'Kỳ Co Island Paradise Bungalow',
 'Bungalow trên vịnh Kỳ Co - được mệnh danh Maldives của Việt Nam với nước biển xanh trong như pha lê. Đi tàu 45 phút từ cảng Đề Gi, lặn ngắm san hô rực rỡ, ngắm cá heo ngoài khơi sáng sớm.',
 'Đảo Kỳ Co, Xã Nhơn Lý', 'Quy Nhơn', 'Nhơn Lý', 13.67000, 109.30000, 'ACTIVE', '14:00:00', '12:00:00', 4.90, 78),

-- QN2: Ghềnh Ráng - mộ Hàn Mặc Tử
((SELECT user_id FROM users WHERE email='thanhphuong.owner@gmail.com'),
 'Ghềnh Ráng Cliff Ocean Retreat',
 'Khu nghỉ trên ghềnh đá Ghềnh Ráng lịch sử - nơi có mộ nhà thơ Hàn Mặc Tử và view biển Quy Nhơn đẹp nhất. Sóng biển vỗ ghềnh đá âm thanh tuyệt đẹp, bầu trời đêm đầy sao không ánh đèn đô thị.',
 'Khu du lịch Ghềnh Ráng, Phường Ghềnh Ráng', 'Quy Nhơn', 'Quy Nhơn', 13.73000, 109.23000, 'ACTIVE', '14:00:00', '12:00:00', 4.82, 64),

-- QN3: Bãi biển Quy Nhơn - trung tâm
((SELECT user_id FROM users WHERE email='thanhphuong.owner@gmail.com'),
 'Quy Nhơn Central Beachfront Inn',
 'Khách sạn ven biển trung tâm Quy Nhơn, bãi biển thành phố dài 2km sạch sẽ và ít đông so với các thành phố biển khác. Ăn bún chả cá Quy Nhơn, bánh ít lá gai và chả ram tôm đất tại hàng xóm.',
 '28 An Dương Vương, Phường Hải Cảng', 'Quy Nhơn', 'Quy Nhơn', 13.77500, 109.22500, 'ACTIVE', '14:00:00', '12:00:00', 4.65, 112),

-- QN4: Hải Giang - bán đảo
((SELECT user_id FROM users WHERE email='minhtuan.owner@gmail.com'),
 'Hải Giang Peninsula Hidden Villa',
 'Biệt thự ẩn trên bán đảo Hải Giang ít người khám phá, 15km từ Quy Nhơn. Vịnh biển 3 mặt, hồ bơi infinity nhìn ra đại dương mênh mông. Hoàn toàn riêng tư cho 1 nhóm khách duy nhất mỗi lần.',
 'Bán đảo Hải Giang, Xã Nhơn Hải', 'Quy Nhơn', 'Nhơn Hải', 13.73500, 109.26000, 'ACTIVE', '15:00:00', '12:00:00', 4.95, 31),

-- QN5: Gần Tháp Đôi Chăm Pa
((SELECT user_id FROM users WHERE email='minhtuan.owner@gmail.com'),
 'Tháp Đôi Cham Heritage Boutique',
 'Boutique nhỏ gần Tháp Đôi Chăm Pa thế kỷ XII - công trình kiến trúc Chăm đẹp nhất còn lại ở Bình Định. Tường gạch nung đỏ nghìn năm không vữa. Hướng dẫn viên lịch sử Chăm Pa miễn phí cho khách lưu trú.',
 '43 Trần Hưng Đạo, Phường Đống Đa', 'Quy Nhơn', 'Quy Nhơn', 13.78200, 109.21800, 'ACTIVE', '13:00:00', '11:00:00', 4.70, 55),

-- QN6: Bãi Xép - bãi vắng
((SELECT user_id FROM users WHERE email='minhtuan.owner@gmail.com'),
 'Bãi Xép Fisherman Cottage',
 'Nhà chài gỗ mộc bãi Xép - bãi biển hoang sơ trong phim "Tôi thấy hoa vàng trên cỏ xanh" (2015). Bãi biển cong như vầng trăng khuyết, rừng dương xanh ngát, ngư dân kéo lưới thủ công buổi chiều.',
 'Bãi Xép, Xã Nhơn Hải', 'Quy Nhơn', 'Nhơn Hải', 13.72000, 109.27000, 'ACTIVE', '13:00:00', '11:00:00', 4.78, 47),

-- QN7: An Nhơn - thành Bình Định cổ
((SELECT user_id FROM users WHERE email='hongnga.owner@gmail.com'),
 'Thành Bình Định Ancient Town Stay',
 'Nhà vườn trong lòng thị xã An Nhơn gần Thành Bình Định - tòa thành đất cổ xây từ thế kỷ XI. Vùng đất võ Bình Định, xem biểu diễn võ cổ truyền, học kỹ thuật căn bản Roi Bình Định từ võ sư địa phương.',
 '12 Ngô Mây, Thị xã An Nhơn', 'Quy Nhơn', 'An Nhơn', 13.88000, 109.10000, 'ACTIVE', '14:00:00', '12:00:00', 4.60, 38),

-- QN8: Cù Lao Xanh
((SELECT user_id FROM users WHERE email='hongnga.owner@gmail.com'),
 'Cù Lao Xanh Green Island Escape',
 'Đảo Cù Lao Xanh hoang sơ cách Quy Nhơn 24km, chỉ tiếp cận bằng tàu 1 lần/ngày. Bãi cát trắng không bóng người, lặn san hô đẹp nhất Bình Định, ăn hải sản nhà bè tươi sống giá bình dân.',
 'Đảo Cù Lao Xanh, Xã Nhơn Châu', 'Quy Nhơn', 'Nhơn Châu', 13.61000, 109.35000, 'ACTIVE', '14:00:00', '12:00:00', 4.83, 29),

-- QN9: Vĩnh Hội Đông - rừng
((SELECT user_id FROM users WHERE email='quocbao.owner@gmail.com'),
 'Núi Bà Bình Định Eco Retreat',
 'Nghỉ dưỡng sinh thái chân núi Bà - dãy núi thiêng vùng đất võ Bình Định. Trekking rừng nguyên sinh, thác nước trong vắt, trải nghiệm sinh hoạt cộng đồng với người Ba Na và Chăm H''Roi bản địa.',
 'Xã Tây Thuận, Huyện Tây Sơn', 'Quy Nhơn', 'Tây Sơn', 14.03000, 108.85000, 'ACTIVE', '14:00:00', '12:00:00', 4.74, 25),

-- QN10: Budget - gần trung tâm
((SELECT user_id FROM users WHERE email='quocbao.owner@gmail.com'),
 'Quy Nhơn Budget Traveler Inn',
 'Nhà nghỉ sạch sẽ, giá rẻ, ngay trung tâm Quy Nhơn. Xe máy thuê 100k/ngày tự khám phá bãi biển Hoàng Hậu, Hầm Hô và vườn rau Hưng Thịnh. Bữa sáng bánh mì + cà phê phin miễn phí.',
 '67 Diệp Văn Cương, Phường Trần Hưng Đạo', 'Quy Nhơn', 'Quy Nhơn', 13.76500, 109.22000, 'ACTIVE', '12:00:00', '10:00:00', 4.42, 97),

-- ====================================================================================
-- PHẦN 2M: HOMESTAYS - HẠ LONG (10 properties)
-- Owner: lanchi.owner@gmail.com (dùng chung)
-- ====================================================================================

-- HL1: Trên vịnh - thuyền
((SELECT user_id FROM users WHERE email='lanchi.owner@gmail.com'),
 'Ha Long Bay Luxury Cruise Cabin',
 'Cabin hạng sang trên du thuyền 5 sao neo đậu giữa Vịnh Hạ Long - di sản thiên nhiên thế giới. 2 ngày 1 đêm trên vịnh: kayak hang Luồn, tắm biển vịnh kín, ăn hải sản tươi ngay trên tàu và xem bình minh trên vịnh.',
 'Cảng Tuần Châu, Hạ Long', 'Hạ Long', 'Tuần Châu', 20.91000, 107.02000, 'ACTIVE', '12:00:00', '12:00:00', 4.92, 187),

-- HL2: Bãi Cháy - trung tâm
((SELECT user_id FROM users WHERE email='lanchi.owner@gmail.com'),
 'Bãi Cháy Vịnh Xanh Hotel',
 'Khách sạn 4 sao mặt tiền Bãi Cháy - bãi biển trung tâm thành phố Hạ Long. View Vịnh Hạ Long từ phòng, tàu đến bến Bãi Cháy mỗi giờ đi tour 1 ngày. Aquapark và khu vui chơi trẻ em ngay cạnh.',
 '30 Halong Road, Phường Bãi Cháy', 'Hạ Long', 'Bãi Cháy', 20.94500, 107.07000, 'ACTIVE', '14:00:00', '12:00:00', 4.68, 243),

-- HL3: Đảo Cát Bà
((SELECT user_id FROM users WHERE email='vinhphuc.owner@gmail.com'),
 'Cát Bà Island Jungle Trekker Base',
 'Basecamp cho trekker đảo Cát Bà - đảo lớn nhất vịnh Hạ Long với vườn quốc gia nguyên sinh. Leo núi ngắm voọc Cát Bà quý hiếm nhất thế giới, kayak hang Tối, leo vách đá limestone bên biển.',
 'Thị trấn Cát Bà, Huyện Cát Hải', 'Hạ Long', 'Cát Hải', 20.72800, 107.05000, 'ACTIVE', '13:00:00', '11:00:00', 4.80, 95),

-- HL4: Cảng Cái Rồng - Vân Đồn
((SELECT user_id FROM users WHERE email='vinhphuc.owner@gmail.com'),
 'Vân Đồn Archipelago Lodge',
 'Lodge sinh thái trên đảo Vân Đồn - quần đảo 600 hòn đảo huyền bí ít khách. Chèo SUP và kayak khám phá hang động biển, ăn sá sùng Vân Đồn nướng muối ớt - đặc sản đắt giá bậc nhất Quảng Ninh.',
 'Cảng Cái Rồng, Thị trấn Cái Rồng', 'Hạ Long', 'Vân Đồn', 21.00000, 107.48000, 'ACTIVE', '14:00:00', '12:00:00', 4.82, 52),

-- HL5: Bãi Cháy - budget
((SELECT user_id FROM users WHERE email='tuankhoa.owner@gmail.com'),
 'Hạ Long Budget Hostel',
 'Hostel tiết kiệm phổ biến nhất Hạ Long, ngay cầu Bãi Cháy. Tour vịnh 1 ngày 150k, dorm giường sắt và quạt điện tiêu chuẩn. Nhận/trả phòng sớm/muộn linh hoạt theo lịch tàu.',
 '8 Vườn Đào, Phường Bãi Cháy', 'Hạ Long', 'Bãi Cháy', 20.95200, 107.07500, 'ACTIVE', '12:00:00', '10:00:00', 4.35, 198),

-- HL6: Hòn Gai - khu phố cổ
((SELECT user_id FROM users WHERE email='tuankhoa.owner@gmail.com'),
 'Hòn Gai Colonial Quarter Inn',
 'Nhà khách trong khu phố Pháp thuộc Hòn Gai ít người ghé thăm. Kiến trúc thuộc địa nguyên vẹn, chợ Hòn Gai hải sản sáng sớm, cầu Bang Chài nhìn ra vịnh và xưởng than cũ - di sản công nghiệp.',
 '15 Lê Thánh Tông, Phường Hồng Gai', 'Hạ Long', 'Hồng Gai', 20.96800, 107.10500, 'ACTIVE', '14:00:00', '12:00:00', 4.62, 74),

-- HL7: Uông Bí - chùa Yên Tử
((SELECT user_id FROM users WHERE email='maihuong.owner@gmail.com'),
 'Yên Tử Pilgrimage Mountain Stay',
 'Nhà nghỉ hành hương chân núi Yên Tử - Đệ nhất linh sơn Phật giáo Việt Nam. Cáp treo lên chùa Đồng đỉnh cao 1.068m. Mùa xuân tháng 1-3 hàng vạn phật tử hành hương, hoa mơ, hoa đào nở rực trên núi.',
 'Phường Thượng Yên Công, Thành phố Uông Bí', 'Hạ Long', 'Uông Bí', 21.06000, 106.77000, 'ACTIVE', '05:00:00', '22:00:00', 4.70, 121),

-- HL8: Cô Tô - đảo xa
((SELECT user_id FROM users WHERE email='maihuong.owner@gmail.com'),
 'Cô Tô Remote Island Paradise',
 'Đảo Cô Tô - hòn đảo xa nhất, hoang sơ nhất của Quảng Ninh, 4 tiếng tàu cao tốc từ Vân Đồn. Bãi Hồng Vàn cát trắng dài 1km không bóng người, rạn san hô nguyên vẹn, đêm trời trong đầy sao.',
 'Đảo Cô Tô, Huyện Cô Tô', 'Hạ Long', 'Cô Tô', 20.97000, 107.77000, 'ACTIVE', '14:00:00', '12:00:00', 4.87, 43),

-- HL9: Gần Vinpearl
((SELECT user_id FROM users WHERE email='truclinh.owner@gmail.com'),
 'Tuần Châu Island Villa',
 'Villa nghỉ dưỡng trên đảo Tuần Châu - đảo du lịch nhân tạo kết nối với đất liền bằng đường cầu. Bể bơi ngoài trời nhìn thẳng ra Vịnh Hạ Long, đi bộ 10 phút đến Vinpearl resort và bãi tắm nhân tạo.',
 'Đảo Tuần Châu, Quận Hạ Long', 'Hạ Long', 'Tuần Châu', 20.90500, 107.02500, 'ACTIVE', '15:00:00', '12:00:00', 4.76, 67),

-- HL10: Móng Cái - biên giới
((SELECT user_id FROM users WHERE email='truclinh.owner@gmail.com'),
 'Móng Cái Border City Guesthouse',
 'Nhà khách gần cửa khẩu Móng Cái - Đông Hưng, điểm mua sắm hàng Trung Quốc nổi tiếng miền Bắc. Đi bộ qua cầu Ka Long sang chợ Đông Hưng mua hàng rẻ. Phòng sạch, wifi tốt, giữ hộ hàng mua.',
 '22 Trần Phú, Thành phố Móng Cái', 'Hạ Long', 'Móng Cái', 21.53000, 107.96500, 'ACTIVE', '12:00:00', '10:00:00', 4.40, 89),

-- ====================================================================================
-- PHẦN 2N: HOMESTAYS - BẢO LỘC / LÂM ĐỒNG (10 properties)
-- Owner: anhduc.owner@gmail.com (dùng chung)
-- ====================================================================================

-- BL1: Đồi chè Bảo Lộc
((SELECT user_id FROM users WHERE email='anhduc.owner@gmail.com'),
 'Bảo Lộc Tea Hill Farmstay',
 'Farmstay giữa đồi chè xanh ngát Bảo Lộc - thủ phủ chè của Việt Nam. Hái chè thủ công lúc bình minh, thăm xưởng sao chè truyền thống, nếm thử oolong Bảo Lộc, trà B''lao đặc sản. Không khí mát mẻ 20°C quanh năm.',
 'Đường Trần Phú, Phường Lộc Sơn', 'Bảo Lộc', 'Bảo Lộc', 11.55000, 107.81000, 'ACTIVE', '14:00:00', '12:00:00', 4.80, 71),

-- BL2: Thác Đambri
((SELECT user_id FROM users WHERE email='anhduc.owner@gmail.com'),
 'Đambri Waterfall Forest Ecolodge',
 'Ecolodge trong rừng thông xanh cạnh thác Đambri - thác nước cao 60m hùng vĩ nhất vùng. Đi cáp treo xuống hố xoáy thác, tắm dưới màn nước trắng xóa, BBQ bên suối buổi chiều.',
 'Khu du lịch Đambri, Phường Lộc Phú', 'Bảo Lộc', 'Bảo Lộc', 11.60000, 107.76000, 'ACTIVE', '14:00:00', '12:00:00', 4.74, 58),

-- BL3: Lâm Hà - cà phê trái cây
((SELECT user_id FROM users WHERE email='thanhphuong.owner@gmail.com'),
 'Lâm Hà Coffee & Fruit Farm Stay',
 'Farmstay trồng cà phê, sầu riêng và bơ tại Lâm Hà - vùng nông nghiệp của người Hà Nội vào Nam lập nghiệp. Hái cà phê chín đỏ, xay cà phê thủ công bằng cối đá, ăn sầu riêng Ri 6 ngay dưới vườn.',
 'Xã Nam Hà, Huyện Lâm Hà', 'Bảo Lộc', 'Lâm Hà', 11.60000, 108.10000, 'ACTIVE', '14:00:00', '12:00:00', 4.77, 44),

-- BL4: Đạ Huoai - sầu riêng
((SELECT user_id FROM users WHERE email='thanhphuong.owner@gmail.com'),
 'Đạ Huoai Durian Garden Homestay',
 'Ngủ giữa vườn sầu riêng trĩu quả Đạ Huoai - vựa sầu riêng lớn nhất tỉnh Lâm Đồng. Mùa sầu riêng tháng 6-8 ăn thoải mái tại vườn giá gốc. Xe máy thồ vào các vùng trồng Ri 6, Monthong và Musang King.',
 'Thị trấn Đạ Mri, Huyện Đạ Huoai', 'Bảo Lộc', 'Đạ Huoai', 11.47000, 107.55000, 'ACTIVE', '14:00:00', '12:00:00', 4.68, 35),

-- BL5: Trung tâm Bảo Lộc
((SELECT user_id FROM users WHERE email='minhtuan.owner@gmail.com'),
 'Bảo Lộc City Silk Road Inn',
 'Nhà nghỉ trung tâm Bảo Lộc, gần chợ dâu tằm tơ - nghề truyền thống của vùng. Tham quan xưởng dệt lụa tơ tằm, mua lụa Bảo Lộc chính hãng giá rẻ hơn tại Hội An 30%. Cà phê sáng tại vỉa hè phong cách Nam Bộ.',
 '3 Nguyễn Công Trứ, Phường 1', 'Bảo Lộc', 'Bảo Lộc', 11.54500, 107.81500, 'ACTIVE', '13:00:00', '11:00:00', 4.55, 62),

-- BL6: Đức Trọng - cao nguyên thông
((SELECT user_id FROM users WHERE email='minhtuan.owner@gmail.com'),
 'Đức Trọng Pine Plateau Retreat',
 'Nhà nghỉ giữa cao nguyên Đức Trọng - vùng nông nghiệp công nghệ cao trồng hoa lily, tulip và rau sạch. Thăm nhà kính dâu tây Nhật Bản, hoa hướng dương mùa đông và làng hoa Đà Lạt - Đức Trọng.',
 'Thị trấn Liên Nghĩa, Huyện Đức Trọng', 'Bảo Lộc', 'Đức Trọng', 11.70000, 108.22000, 'ACTIVE', '14:00:00', '12:00:00', 4.65, 48),

-- BL7: Di Linh - thác Bobla
((SELECT user_id FROM users WHERE email='hongnga.owner@gmail.com'),
 'Di Linh Highlands Coffee Lodge',
 'Lodge cà phê tại Di Linh - vùng cà phê trung nguyên cao cấp. Khám phá vườn cà phê arabica, robusta và cherry đặc sản. Cầu treo Phú Hội dài 100m bắc qua suối Đa Nhim hùng vĩ.',
 'Đường Trần Phú, Thị trấn Di Linh', 'Bảo Lộc', 'Di Linh', 11.57000, 108.08000, 'ACTIVE', '14:00:00', '12:00:00', 4.71, 41),

-- BL8: Cát Tiên - vườn quốc gia
((SELECT user_id FROM users WHERE email='hongnga.owner@gmail.com'),
 'Cát Tiên National Park Eco Camp',
 'Cắm trại sinh thái trong vườn quốc gia Cát Tiên - khu dự trữ sinh quyển UNESCO. Đêm nghe vượn hú, gặp kỳ đà, hướng dẫn viên sinh thái dẫn bird watching 5 giờ sáng. Bãi sấu Bàu Sấu hoang dã.',
 'Vườn Quốc Gia Cát Tiên, Huyện Cát Tiên', 'Bảo Lộc', 'Cát Tiên', 11.48000, 107.43000, 'ACTIVE', '14:00:00', '12:00:00', 4.85, 54),

-- BL9: Luxury - đồi chè view
((SELECT user_id FROM users WHERE email='quocbao.owner@gmail.com'),
 'Bảo Lộc Tea Horizon Luxury Villa',
 'Villa sang trọng trên đồi chè Bảo Lộc nhìn ra chân trời xanh bất tận. Hồ bơi ngoài trời giữa đồi chè, phòng kính ngủ dưới trăng sao, bữa tối set menu trà - tơ tằm độc quyền của chef Lâm Đồng.',
 'Đồi Chè Lộc An, Phường Lộc An', 'Bảo Lộc', 'Bảo Lộc', 11.56500, 107.83000, 'ACTIVE', '15:00:00', '12:00:00', 4.91, 37),

-- BL10: Budget
((SELECT user_id FROM users WHERE email='quocbao.owner@gmail.com'),
 'Bảo Lộc Traveler Budget Stay',
 'Nhà nghỉ bình dân giữa thành phố Bảo Lộc. Xe đạp miễn phí, bản đồ đồi chè và thác nước free. Bữa sáng bánh mì + trà B''Lao pha phin truyền thống. Thích hợp cho khách phượt từ TP.HCM lên.',
 '55 Nguyễn Văn Cừ, Phường Lộc Sơn', 'Bảo Lộc', 'Bảo Lộc', 11.54000, 107.82000, 'ACTIVE', '12:00:00', '10:00:00', 4.48, 83),

-- ====================================================================================
-- PHẦN 2O: HOMESTAYS - VŨNG TÀU (10 properties)
-- Owner: vinhphuc.owner@gmail.com (dùng chung)
-- ====================================================================================

-- VT1: Bãi Sau - dài nhất
((SELECT user_id FROM users WHERE email='vinhphuc.owner@gmail.com'),
 'Bãi Sau Long Beach Beachfront Resort',
 'Resort ven Bãi Sau dài 8km - bãi biển dài nhất Vũng Tàu. Hồ bơi nước mặn infinitypool, jetski, dù lượn biển và lặn biển san hô. Khu BBQ hải sản tối nổi tiếng với ghẹ xanh, tôm hùm và cá mú.',
 '158 Thùy Vân, Phường 2', 'Vũng Tàu', 'Vũng Tàu', 10.32000, 107.07000, 'ACTIVE', '14:00:00', '12:00:00', 4.75, 198),

-- VT2: Bãi Trước - trung tâm
((SELECT user_id FROM users WHERE email='vinhphuc.owner@gmail.com'),
 'Bãi Trước Front Beach Inn',
 'Khách sạn 3 sao ngay Bãi Trước Vũng Tàu - bãi biển trung tâm nhộn nhịp nhất. Đi bộ đến Chùa Thích Ca Phật Đài, tượng Chúa Kito trên đỉnh núi Tao Phùng và chợ Vũng Tàu đêm hải sản.',
 '22 Quang Trung, Phường 8', 'Vũng Tàu', 'Vũng Tàu', 10.34500, 107.08200, 'ACTIVE', '14:00:00', '12:00:00', 4.62, 167),

-- VT3: Núi Lớn - gần tượng Chúa
((SELECT user_id FROM users WHERE email='tuankhoa.owner@gmail.com'),
 'Núi Lớn Summit Pilgrim Lodge',
 'Lodge trên sườn Núi Lớn, đường đi bộ lên tượng Chúa Kito Vũng Tàu - tượng Chúa ngoài trời lớn nhất Đông Nam Á. Ngắm toàn cảnh Vũng Tàu, Thái Bình Dương và dàn giàn khoan dầu khí từ độ cao 170m.',
 'Núi Lớn, Phường 5', 'Vũng Tàu', 'Vũng Tàu', 10.34000, 107.06000, 'ACTIVE', '14:00:00', '12:00:00', 4.72, 84),

-- VT4: Long Hải
((SELECT user_id FROM users WHERE email='tuankhoa.owner@gmail.com'),
 'Long Hải Unspoiled Beach Villa',
 'Villa riêng tư tại Long Hải - bãi biển hoang sơ cách Vũng Tàu 30km. Ít khách, không resort lớn, bãi cát đen núi lửa kỳ lạ. Cầu Bàn Tay nổi tiếng và miếu Bà tín ngưỡng ngư dân Nam Bộ.',
 'Ấp Hải Lạc, Xã Long Hải', 'Vũng Tàu', 'Long Điền', 10.26000, 107.22000, 'ACTIVE', '14:00:00', '12:00:00', 4.78, 55),

-- VT5: Hồ Tràm - resort strip
((SELECT user_id FROM users WHERE email='maihuong.owner@gmail.com'),
 'Hồ Tràm Beachside Bungalow',
 'Bungalow tre nứa mộc mạc ngay Hồ Tràm - bãi biển hoang vắng nhất miền Nam Việt Nam, 120km từ TP.HCM. Không có resort lớn cạnh tranh, bãi biển cát trắng, dừa nước và gió biển vô hạn.',
 'Ấp Hồ Tràm, Xã Phước Thuận', 'Vũng Tàu', 'Xuyên Mộc', 10.48000, 107.47000, 'ACTIVE', '14:00:00', '12:00:00', 4.80, 63),

-- VT6: Phước Hải - ngư dân
((SELECT user_id FROM users WHERE email='maihuong.owner@gmail.com'),
 'Phước Hải Fishing Village Sea Camp',
 'Cắm trại tại làng chài Phước Hải, 50km từ Vũng Tàu. Ra khơi đặt lưới tôm lúc 3 giờ sáng, mang về nấu cháo tôm ven biển. Xem ngư dân vá lưới, vợt tôm tích, phơi mực và ăn gỏi cá chình bông.',
 'Thị trấn Phước Hải, Huyện Đất Đỏ', 'Vũng Tàu', 'Đất Đỏ', 10.26500, 107.35500, 'ACTIVE', '13:00:00', '11:00:00', 4.70, 38),

-- VT7: Luxury sát biển
((SELECT user_id FROM users WHERE email='truclinh.owner@gmail.com'),
 'The Grand Vũng Tàu Ocean Villa',
 'Villa 5 sao riêng tư tại Vũng Tàu với bãi biển riêng 50m, hồ bơi nước mặn, jacuzzi sunset view và đội ngũ butler 24/7. Bữa tối hải sản fine dining do head chef từng làm tại The Intercontinental Hà Nội.',
 '78 Hoàng Hoa Thám, Phường Thắng Nhất', 'Vũng Tàu', 'Vũng Tàu', 10.36000, 107.06500, 'ACTIVE', '15:00:00', '12:00:00', 4.95, 47),

-- VT8: Gần nhà thờ cổ
((SELECT user_id FROM users WHERE email='truclinh.owner@gmail.com'),
 'Vũng Tàu Colonial Church Inn',
 'Nhà khách Pháp thuộc gần Nhà Thờ Đình Cát - nhà thờ cổ nhất Vũng Tàu xây năm 1896. Phố biển Vũng Tàu kiểu Pháp: biệt thự cũ, đường phi lao ven biển và bánh mì baguette mỗi sáng từ tiệm bánh 70 năm.',
 '5 Lê Lợi, Phường 4', 'Vũng Tàu', 'Vũng Tàu', 10.34200, 107.07800, 'ACTIVE', '14:00:00', '12:00:00', 4.65, 91),

-- VT9: Côn Đảo - hòn đảo thiêng
((SELECT user_id FROM users WHERE email='anhduc.owner@gmail.com'),
 'Côn Đảo Historic Island Guesthouse',
 'Nhà khách trên đảo Côn Đảo linh thiêng - nơi giam cầm chiến sĩ cách mạng và có nghĩa địa Hàng Dương. Thăm nhà tù Côn Đảo, lăng Cô Sáu linh thiêng và lặn biển ngắm rùa xanh quý hiếm đẻ trứng ban đêm.',
 'Thị trấn Côn Đảo, Huyện Côn Đảo', 'Vũng Tàu', 'Côn Đảo', 8.68500, 106.60000, 'ACTIVE', '14:00:00', '12:00:00', 4.88, 73),

-- VT10: Budget - Weekend getaway TP.HCM
((SELECT user_id FROM users WHERE email='anhduc.owner@gmail.com'),
 'Vũng Tàu Weekend Escape Hostel',
 'Hostel sạch sẽ, giá rẻ dành cho khách Sài Gòn thoát phố cuối tuần. Xe khách từ bến xe Miền Đông đến cổng hostel. BBQ trên sân thượng tối thứ 7, game night thứ 6 và tour biển sáng chủ nhật chỉ 200k.',
 '33 Nguyễn Thái Học, Phường 7', 'Vũng Tàu', 'Vũng Tàu', 10.33500, 107.07500, 'ACTIVE', '12:00:00', '10:00:00', 4.45, 145);

SET FOREIGN_KEY_CHECKS = 1;

-- ====================================================================================
-- PHẦN 3: HOMESTAY IMAGES
-- Dùng Cloudinary URL pattern nhất quán với seed_search_data.sql
-- Mỗi homestay: 1 ảnh primary + 2 ảnh phụ
-- ====================================================================================
SET FOREIGN_KEY_CHECKS = 0;

INSERT INTO homestay_images (homestay_id, image_url, is_primary, display_order)
SELECT h.homestay_id,
       CONCAT('https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/', h.slug, '_01.jpg'),
       TRUE, 0
FROM (
  SELECT homestay_id,
         LEFT(LOWER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
           REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(name,
           ' ','_'),'đ','d'),'Đ','d'),'ă','a'),'â','a'),'ê','e'),'ô','o'),'ơ','o'),'ư','u'),
           'á','a'),'à','a'),'ả','a'),'ã','a'),'ạ','a'),'ắ','a'),'ặ','a')), 50) AS slug
  FROM homestays
  WHERE name IN (
    'Xuân Hương Lakeside Cottage','Thái Phiên Flower Farm Stay','Valley of Love Hideaway',
    'Hồ Than Thở Treehouse','Đankia Lake Resort Đà Lạt','Central Đà Lạt Boutique Hotel',
    'Cầu Đất Tea Estate Homestay','Prenn Waterfall Ecolodge','Villa Pháp Cổ Hai Bà Trưng',
    'Lang Biang Mountain Lodge',
    'Nguyễn Thái Học Heritage House','Cẩm Thanh Coconut Village Stay','Cửa Đại Sunrise Bungalow',
    'An Bàng Beach Villa','Trà Quế Herb Garden Farmstay','Phan Bội Châu Lantern Guesthouse',
    'Kim Bồng Carpentry Village Homestay','Thu Bồn Riverside Luxury Villa',
    'Rạng Beach Hidden Retreat','Old Town Backpacker Hội An',
    'Bãi Sao Pearl Villa Phú Quốc','Bãi Dài North Coast Retreat','Dương Đông Night Market Guesthouse',
    'Ông Lang Sunset Bungalow','Hàm Ninh Fishing Village Homestay','Grand Phú Quốc Ocean Resort',
    'Suối Tranh Jungle Glamping','Hòn Thơm Cable Car Guesthouse','Phú Quốc Eco Farm Stay',
    'Phú Quốc Island Hostel',
    'Hồ Gươm View Boutique','Hàng Đào Silk Heritage Guesthouse','Tây Hồ Lakeside Bohemian Homestay',
    'Văn Miếu Scholar Guesthouse','Ba Đình Heritage Hotel Hà Nội','Hoàng Mai Local Experience Stay',
    'Cầu Giấy Smart Capsule Hostel','Long Biên Bridge View Guesthouse',
    'Đồng Quê Sóc Sơn Retreat','Silk Road Luxury Boutique Hà Nội',
    'Cam Ranh Bay Beachfront Resort','Hòn Tre Island Eco Bungalow','Nha Trang Beach Boulevard Hotel',
    'Ninh Vân Bay Water Villa','Ponagar Cham Tower Heritage Inn','Dốc Lết White Sand Resort',
    'Backpacker Zone Nha Trang','Điệp Sơn Sand Road Island Stay',
    'Ba Hồ Waterfall Jungle Lodge','Ana Mandara Cliff Villa Nha Trang',
    'Sapa Town Central Mountain Hotel','Cát Cát H''Mông Traditional Lodge',
    'Lao Chải Rice Terrace Eco Lodge','Tả Phìn Red Dao Herbal Retreat',
    'Hàm Rồng Summit Glamping','Lào Cai Station Stopover Inn',
    'Séo Mý Tỷ Valley Deep Trek Base','Topas Ecolodge Style Sapa',
    'Sin Chải Black H''Mông Homestay','Sapa Fog Hostel',
    'Mỹ Khê Sunrise Beach Hotel','Sơn Trà Peninsula Wildlife Lodge',
    'Ngũ Hành Sơn Marble Boutique','Dragon Bridge City Center Apartment',
    'Bà Nà Hills Foothills Retreat','Nam Ô Fishing Village Homestay',
    'Mỹ An Luxury Pool Villa','Hải Châu Business Inn Đà Nẵng',
    'Làng Vân Isolated Beach Camp','Airport Transit Guesthouse Đà Nẵng',
    'Hoàng Thành Heritage Boutique Huế','Hương Giang Floating Boat House',
    'Thiên Mụ Pagoda Zen Retreat','Vỹ Dạ Poet Village Garden House',
    'Lăng Tự Đức Royal Forest Ecolodge','Làng Chuồn Nón Lá Artisan Homestay',
    'Thanh Toàn Bridge Village Homestay','Vedana Lagoon Huế Luxury Resort',
    'Đồng Khánh Colonial Guesthouse','Huế Station Budget Guesthouse',
    'Red Sand Dune Desert Lodge','Mũi Né Kite Surf Beach Resort',
    'Fairy Stream Jungle Retreat','Phan Thiết Old Town Food Trail Inn',
    'Anantara Mũi Né Style Villa','Bàu Trắng White Dune Glamping',
    'Sunflower Beach Garden Homestay','Ông Địa Rock Beach Bungalow',
    'Tiến Thành Unspoiled Beach Retreat','Mũi Né Backpacker Beach Hostel',
    'Đồng Văn Karst Plateau Guesthouse','Tu Sản Canyon View Lodge',
    'Cổng Trời Quản Bạ Twin Mountain Stay','Yên Minh Pine Forest Stopover',
    'Lũng Cú Northernmost Homestay','Hà Giang City Gateway Hotel',
    'Thôn Tha H''Mông Flower Village','Phố Bảng Sunday Market Lodge',
    'Bắc Mê Riverside Wild Camp','Vị Xuyên Frontier History Guesthouse',
    'Tràng An UNESCO Riverside Lodge','Tam Cốc Paddyfield Homestay',
    'Hoa Lư Ancient Capital Guesthouse','Bái Đính Spiritual Retreat',
    'Vân Long Wetland Bird Watch Lodge','Ninh Bình City Center Hotel',
    'Kênh Gà Hot Spring Riverside Resort','Núi Chùa Panorama Ecolodge',
    'Cúc Phương National Park Cabin','Ninh Hải Budget Guesthouse',
    'Kỳ Co Island Paradise Bungalow','Ghềnh Ráng Cliff Ocean Retreat',
    'Quy Nhơn Central Beachfront Inn','Hải Giang Peninsula Hidden Villa',
    'Tháp Đôi Cham Heritage Boutique','Bãi Xép Fisherman Cottage',
    'Thành Bình Định Ancient Town Stay','Cù Lao Xanh Green Island Escape',
    'Núi Bà Bình Định Eco Retreat','Quy Nhơn Budget Traveler Inn',
    'Ha Long Bay Luxury Cruise Cabin','Bãi Cháy Vịnh Xanh Hotel',
    'Cát Bà Island Jungle Trekker Base','Vân Đồn Archipelago Lodge',
    'Hạ Long Budget Hostel','Hòn Gai Colonial Quarter Inn',
    'Yên Tử Pilgrimage Mountain Stay','Cô Tô Remote Island Paradise',
    'Tuần Châu Island Villa','Móng Cái Border City Guesthouse',
    'Bảo Lộc Tea Hill Farmstay','Đambri Waterfall Forest Ecolodge',
    'Lâm Hà Coffee & Fruit Farm Stay','Đạ Huoai Durian Garden Homestay',
    'Bảo Lộc City Silk Road Inn','Đức Trọng Pine Plateau Retreat',
    'Di Linh Highlands Coffee Lodge','Cát Tiên National Park Eco Camp',
    'Bảo Lộc Tea Horizon Luxury Villa','Bảo Lộc Traveler Budget Stay',
    'Bãi Sau Long Beach Beachfront Resort','Bãi Trước Front Beach Inn',
    'Núi Lớn Summit Pilgrim Lodge','Long Hải Unspoiled Beach Villa',
    'Hồ Tràm Beachside Bungalow','Phước Hải Fishing Village Sea Camp',
    'The Grand Vũng Tàu Ocean Villa','Vũng Tàu Colonial Church Inn',
    'Côn Đảo Historic Island Guesthouse','Vũng Tàu Weekend Escape Hostel'
  )
) h;

-- Ảnh phụ thứ 2
INSERT INTO homestay_images (homestay_id, image_url, is_primary, display_order)
SELECT h.homestay_id,
       CONCAT('https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/', h.slug, '_02.jpg'),
       FALSE, 1
FROM (
  SELECT homestay_id,
         LEFT(LOWER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
           REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(name,
           ' ','_'),'đ','d'),'Đ','d'),'ă','a'),'â','a'),'ê','e'),'ô','o'),'ơ','o'),'ư','u'),
           'á','a'),'à','a'),'ả','a'),'ã','a'),'ạ','a'),'ắ','a'),'ặ','a')), 50) AS slug
  FROM homestays
  WHERE city IN ('Đà Lạt','Hội An','Phú Quốc','Hà Nội','Nha Trang','Sa Pa','Đà Nẵng','Huế',
                 'Phan Thiết','Hà Giang','Ninh Bình','Quy Nhơn','Hạ Long','Bảo Lộc','Vũng Tàu')
    AND homestay_id NOT IN (SELECT homestay_id FROM homestays WHERE city NOT IN
                 ('Đà Lạt','Hội An','Phú Quốc','Hà Nội','Nha Trang','Sa Pa','Đà Nẵng','Huế',
                  'Phan Thiết','Hà Giang','Ninh Bình','Quy Nhơn','Hạ Long','Bảo Lộc','Vũng Tàu'))
) h;

-- Ảnh phụ thứ 3
INSERT INTO homestay_images (homestay_id, image_url, is_primary, display_order)
SELECT h.homestay_id,
       CONCAT('https://res.cloudinary.com/smartbooking/image/upload/v1/homestays/', h.slug, '_03.jpg'),
       FALSE, 2
FROM (
  SELECT homestay_id,
         LEFT(LOWER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
           REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(name,
           ' ','_'),'đ','d'),'Đ','d'),'ă','a'),'â','a'),'ê','e'),'ô','o'),'ơ','o'),'ư','u'),
           'á','a'),'à','a'),'ả','a'),'ã','a'),'ạ','a'),'ắ','a'),'ặ','a')), 50) AS slug
  FROM homestays
  WHERE city IN ('Đà Lạt','Hội An','Phú Quốc','Hà Nội','Nha Trang','Sa Pa','Đà Nẵng','Huế',
                 'Phan Thiết','Hà Giang','Ninh Bình','Quy Nhơn','Hạ Long','Bảo Lộc','Vũng Tàu')
    AND rating_avg >= 4.70
) h;

-- ====================================================================================
-- PHẦN 4: HOMESTAY AMENITIES
-- Phân nhóm theo loại hình homestay, dùng subquery theo tên
-- Amenity IDs: 1=WiFi,2=Pool,3=Parking,4=AC,5=Washer,6=Kitchen,7=BBQ,8=Pets
--              9=TV,10=Jacuzzi,11=Minibar,12=Safe,13=MtnView,14=SeaView
--              15=Gym,16=Spa,17=Restaurant,18=Reception24h,19=Shuttle,20=NoSmoke
--              21=Fireplace,22=Hotwater,23=PrivateBeach
-- ====================================================================================

-- Helper: amenities theo tên homestay
-- Đà Lạt (lò sưởi, view núi, bếp, WiFi)
INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, a.amenity_id FROM homestays h
CROSS JOIN (SELECT 1 amenity_id UNION SELECT 4 UNION SELECT 6 UNION SELECT 9
            UNION SELECT 13 UNION SELECT 21 UNION SELECT 22) a
WHERE h.city = 'Đà Lạt' AND h.status = 'ACTIVE';

-- Thêm pool cho vila/resort Đà Lạt
INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, 2 FROM homestays h
WHERE h.city = 'Đà Lạt' AND h.name IN ('Ana Garden Villa Đà Lạt','Đankia Lake Resort Đà Lạt','Central Đà Lạt Boutique Hotel');

INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, 3 FROM homestays h
WHERE h.city = 'Đà Lạt' AND h.name NOT IN ('Hồ Than Thở Treehouse','Prenn Waterfall Ecolodge');

-- Hội An (văn hoá, không hút thuốc, bếp)
INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, a.amenity_id FROM homestays h
CROSS JOIN (SELECT 1 amenity_id UNION SELECT 4 UNION SELECT 6 UNION SELECT 9 UNION SELECT 20) a
WHERE h.city = 'Hội An' AND h.status = 'ACTIVE';

INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, 2 FROM homestays h
WHERE h.city = 'Hội An' AND h.name IN ('An Bàng Beach Villa','Thu Bồn Riverside Luxury Villa','Old Town Backpacker Hội An');

INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, 23 FROM homestays h
WHERE h.city = 'Hội An' AND h.name IN ('An Bàng Beach Villa','Rạng Beach Hidden Retreat');

INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, 16 FROM homestays h
WHERE h.city = 'Hội An' AND h.name IN ('Thu Bồn Riverside Luxury Villa');

-- Phú Quốc (biển, pool, ban công biển)
INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, a.amenity_id FROM homestays h
CROSS JOIN (SELECT 1 amenity_id UNION SELECT 4 UNION SELECT 9 UNION SELECT 14 UNION SELECT 20) a
WHERE h.city = 'Phú Quốc' AND h.status = 'ACTIVE';

INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, 2 FROM homestays h
WHERE h.city = 'Phú Quốc' AND h.name IN ('Bãi Sao Pearl Villa Phú Quốc','Grand Phú Quốc Ocean Resort','Phú Quốc Island Hostel');

INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, a.amenity_id FROM homestays h
CROSS JOIN (SELECT 15 amenity_id UNION SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 23) a
WHERE h.city = 'Phú Quốc' AND h.name = 'Grand Phú Quốc Ocean Resort';

INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, a.amenity_id FROM homestays h
CROSS JOIN (SELECT 5 amenity_id UNION SELECT 6 UNION SELECT 7) a
WHERE h.city = 'Phú Quốc' AND h.name = 'Bãi Sao Pearl Villa Phú Quốc';

-- Hà Nội (đô thị, không hút thuốc, parking)
INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, a.amenity_id FROM homestays h
CROSS JOIN (SELECT 1 amenity_id UNION SELECT 4 UNION SELECT 9 UNION SELECT 20) a
WHERE h.city = 'Hà Nội' AND h.status = 'ACTIVE';

INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, 3 FROM homestays h
WHERE h.city = 'Hà Nội' AND h.name IN ('Ba Đình Heritage Hotel Hà Nội','Đồng Quê Sóc Sơn Retreat','Silk Road Luxury Boutique Hà Nội');

INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, a.amenity_id FROM homestays h
CROSS JOIN (SELECT 11 amenity_id UNION SELECT 12 UNION SELECT 16 UNION SELECT 17 UNION SELECT 18) a
WHERE h.city = 'Hà Nội' AND h.name = 'Silk Road Luxury Boutique Hà Nội';

INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, a.amenity_id FROM homestays h
CROSS JOIN (SELECT 6 amenity_id UNION SELECT 7 UNION SELECT 8) a
WHERE h.city = 'Hà Nội' AND h.name = 'Đồng Quê Sóc Sơn Retreat';

-- Nha Trang (biển, pool, gym)
INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, a.amenity_id FROM homestays h
CROSS JOIN (SELECT 1 amenity_id UNION SELECT 4 UNION SELECT 9 UNION SELECT 14 UNION SELECT 20 UNION SELECT 22) a
WHERE h.city = 'Nha Trang' AND h.status = 'ACTIVE';

INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, 2 FROM homestays h
WHERE h.city = 'Nha Trang' AND h.name IN ('Cam Ranh Bay Beachfront Resort','Nha Trang Beach Boulevard Hotel','Ana Mandara Cliff Villa Nha Trang');

INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, a.amenity_id FROM homestays h
CROSS JOIN (SELECT 15 amenity_id UNION SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 23) a
WHERE h.city = 'Nha Trang' AND h.name IN ('Ninh Vân Bay Water Villa','Ana Mandara Cliff Villa Nha Trang');

-- Sapa (lò sưởi, view núi, WiFi)
INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, a.amenity_id FROM homestays h
CROSS JOIN (SELECT 1 amenity_id UNION SELECT 4 UNION SELECT 6 UNION SELECT 13 UNION SELECT 21 UNION SELECT 22) a
WHERE h.city = 'Sa Pa' AND h.status = 'ACTIVE';

INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, a.amenity_id FROM homestays h
CROSS JOIN (SELECT 2 amenity_id UNION SELECT 16 UNION SELECT 17) a
WHERE h.city = 'Sa Pa' AND h.name = 'Topas Ecolodge Style Sapa';

-- Đà Nẵng (biển, pool, gym, shuttle)
INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, a.amenity_id FROM homestays h
CROSS JOIN (SELECT 1 amenity_id UNION SELECT 4 UNION SELECT 9 UNION SELECT 14 UNION SELECT 20) a
WHERE h.city = 'Đà Nẵng' AND h.status = 'ACTIVE';

INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, 2 FROM homestays h
WHERE h.city = 'Đà Nẵng' AND h.name IN ('Mỹ Khê Sunrise Beach Hotel','Mỹ An Luxury Pool Villa');

INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, a.amenity_id FROM homestays h
CROSS JOIN (SELECT 3 amenity_id UNION SELECT 5 UNION SELECT 7 UNION SELECT 11) a
WHERE h.city = 'Đà Nẵng' AND h.name = 'Mỹ An Luxury Pool Villa';

-- Huế (văn hoá, WiFi, không hút thuốc, bếp)
INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, a.amenity_id FROM homestays h
CROSS JOIN (SELECT 1 amenity_id UNION SELECT 4 UNION SELECT 9 UNION SELECT 20 UNION SELECT 22) a
WHERE h.city = 'Huế' AND h.status = 'ACTIVE';

INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, a.amenity_id FROM homestays h
CROSS JOIN (SELECT 2 amenity_id UNION SELECT 10 UNION SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19) a
WHERE h.city = 'Huế' AND h.name = 'Vedana Lagoon Huế Luxury Resort';

-- Mũi Né (biển, pool, view biển)
INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, a.amenity_id FROM homestays h
CROSS JOIN (SELECT 1 amenity_id UNION SELECT 4 UNION SELECT 14 UNION SELECT 20) a
WHERE h.city = 'Phan Thiết' AND h.status = 'ACTIVE';

INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, 2 FROM homestays h
WHERE h.city = 'Phan Thiết' AND h.name IN ('Mũi Né Kite Surf Beach Resort','Anantara Mũi Né Style Villa','Sunflower Beach Garden Homestay');

INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, a.amenity_id FROM homestays h
CROSS JOIN (SELECT 10 amenity_id UNION SELECT 16 UNION SELECT 17 UNION SELECT 19 UNION SELECT 23) a
WHERE h.city = 'Phan Thiết' AND h.name = 'Anantara Mũi Né Style Villa';

-- Hà Giang (WiFi, bếp, lò sưởi)
INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, a.amenity_id FROM homestays h
CROSS JOIN (SELECT 1 amenity_id UNION SELECT 6 UNION SELECT 21 UNION SELECT 22) a
WHERE h.city = 'Hà Giang' AND h.status = 'ACTIVE';

INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, a.amenity_id FROM homestays h
CROSS JOIN (SELECT 3 amenity_id UNION SELECT 4 UNION SELECT 9) a
WHERE h.city = 'Hà Giang' AND h.name = 'Hà Giang City Gateway Hotel';

-- Ninh Bình (WiFi, bếp, bãi đỗ xe)
INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, a.amenity_id FROM homestays h
CROSS JOIN (SELECT 1 amenity_id UNION SELECT 3 UNION SELECT 4 UNION SELECT 6 UNION SELECT 22) a
WHERE h.city = 'Ninh Bình' AND h.status = 'ACTIVE';

INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, 8 FROM homestays h
WHERE h.city = 'Ninh Bình' AND h.name IN ('Vân Long Wetland Bird Watch Lodge','Cúc Phương National Park Cabin');

-- Quy Nhơn (biển, WiFi, view biển)
INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, a.amenity_id FROM homestays h
CROSS JOIN (SELECT 1 amenity_id UNION SELECT 4 UNION SELECT 14 UNION SELECT 20 UNION SELECT 22) a
WHERE h.city = 'Quy Nhơn' AND h.status = 'ACTIVE';

INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, a.amenity_id FROM homestays h
CROSS JOIN (SELECT 2 amenity_id UNION SELECT 10 UNION SELECT 17 UNION SELECT 23) a
WHERE h.city = 'Quy Nhơn' AND h.name = 'Hải Giang Peninsula Hidden Villa';

-- Hạ Long (WiFi, view biển/vịnh, không hút thuốc)
INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, a.amenity_id FROM homestays h
CROSS JOIN (SELECT 1 amenity_id UNION SELECT 4 UNION SELECT 9 UNION SELECT 14 UNION SELECT 20) a
WHERE h.city = 'Hạ Long' AND h.status = 'ACTIVE';

INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, a.amenity_id FROM homestays h
CROSS JOIN (SELECT 2 amenity_id UNION SELECT 17 UNION SELECT 18 UNION SELECT 19) a
WHERE h.city = 'Hạ Long' AND h.name IN ('Ha Long Bay Luxury Cruise Cabin','Bãi Cháy Vịnh Xanh Hotel');

-- Bảo Lộc (WiFi, bếp, view núi, không hút thuốc)
INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, a.amenity_id FROM homestays h
CROSS JOIN (SELECT 1 amenity_id UNION SELECT 4 UNION SELECT 6 UNION SELECT 13 UNION SELECT 20) a
WHERE h.city = 'Bảo Lộc' AND h.status = 'ACTIVE';

INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, a.amenity_id FROM homestays h
CROSS JOIN (SELECT 2 amenity_id UNION SELECT 10 UNION SELECT 16 UNION SELECT 17) a
WHERE h.city = 'Bảo Lộc' AND h.name = 'Bảo Lộc Tea Horizon Luxury Villa';

INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, a.amenity_id FROM homestays h
CROSS JOIN (SELECT 3 amenity_id UNION SELECT 7 UNION SELECT 8) a
WHERE h.city = 'Bảo Lộc' AND h.name IN ('Cát Tiên National Park Eco Camp','Đambri Waterfall Forest Ecolodge');

-- Vũng Tàu (biển, pool, view biển, không hút thuốc)
INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, a.amenity_id FROM homestays h
CROSS JOIN (SELECT 1 amenity_id UNION SELECT 4 UNION SELECT 9 UNION SELECT 14 UNION SELECT 20 UNION SELECT 22) a
WHERE h.city = 'Vũng Tàu' AND h.status = 'ACTIVE';

INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, 2 FROM homestays h
WHERE h.city = 'Vũng Tàu' AND h.name IN ('Bãi Sau Long Beach Beachfront Resort','The Grand Vũng Tàu Ocean Villa');

INSERT IGNORE INTO homestay_amenities (homestay_id, amenity_id)
SELECT h.homestay_id, a.amenity_id FROM homestays h
CROSS JOIN (SELECT 3 amenity_id UNION SELECT 5 UNION SELECT 7 UNION SELECT 10 UNION SELECT 11 UNION SELECT 16 UNION SELECT 17 UNION SELECT 19 UNION SELECT 23) a
WHERE h.city = 'Vũng Tàu' AND h.name = 'The Grand Vũng Tàu Ocean Villa';

-- ====================================================================================
-- PHẦN 5: ROOM TYPES (1-2 loại phòng mỗi homestay)
-- ====================================================================================
INSERT IGNORE INTO room_types (homestay_id, name, description, base_price, max_occupancy, bed_count, room_size_sqm)

-- ĐÀ LẠT
SELECT homestay_id, 'Phòng Standard', 'Phòng tiêu chuẩn có ban công, view thiên nhiên', 480000, 2, 1, 22
FROM homestays WHERE name = 'Xuân Hương Lakeside Cottage'
UNION ALL
SELECT homestay_id, 'Phòng Deluxe View Hồ', 'Phòng rộng với toàn cảnh Hồ Xuân Hương', 880000, 2, 1, 35
FROM homestays WHERE name = 'Xuân Hương Lakeside Cottage'
UNION ALL
SELECT homestay_id, 'Phòng Farm Standard', 'Phòng đơn giản, view vườn hoa', 350000, 2, 1, 18
FROM homestays WHERE name = 'Thái Phiên Flower Farm Stay'
UNION ALL
SELECT homestay_id, 'Phòng Farm Family', 'Phòng gia đình 2 giường đôi, vườn hoa bao quanh', 750000, 4, 2, 36
FROM homestays WHERE name = 'Thái Phiên Flower Farm Stay'
UNION ALL
SELECT homestay_id, 'A-Frame Cabin', 'Nhà gỗ mái nhọn cổ điển, lò sưởi củi thật', 980000, 2, 1, 28
FROM homestays WHERE name = 'Valley of Love Hideaway'
UNION ALL
SELECT homestay_id, 'A-Frame Suite', 'Cabin lớn hơn, có bồn tắm gỗ, view thung lũng', 1600000, 2, 1, 40
FROM homestays WHERE name = 'Valley of Love Hideaway'
UNION ALL
SELECT homestay_id, 'Treehouse Single', 'Nhà trên cây cho 1-2 người, thang gỗ leo lên', 750000, 2, 1, 15
FROM homestays WHERE name = 'Hồ Than Thở Treehouse'
UNION ALL
SELECT homestay_id, 'Bungalow View Hồ', 'Bungalow gỗ thông tiêu chuẩn, view Hồ Đan Kia', 850000, 2, 1, 30
FROM homestays WHERE name = 'Đankia Lake Resort Đà Lạt'
UNION ALL
SELECT homestay_id, 'Bungalow Premium Hồ', 'Bungalow lớn có sân hiên riêng sát mặt hồ', 1400000, 4, 2, 50
FROM homestays WHERE name = 'Đankia Lake Resort Đà Lạt'
UNION ALL
SELECT homestay_id, 'Phòng Pháp Standard', 'Phòng khách sạn boutique kiểu Pháp, view phố', 650000, 2, 1, 22
FROM homestays WHERE name = 'Central Đà Lạt Boutique Hotel'
UNION ALL
SELECT homestay_id, 'Suite Boutique', 'Suite cao cấp, phòng khách riêng, view đường phố cổ', 1350000, 2, 1, 45
FROM homestays WHERE name = 'Central Đà Lạt Boutique Hotel'
UNION ALL
SELECT homestay_id, 'Phòng Đồn Điền', 'Phòng tiêu chuẩn giữa đồn điền chè lịch sử', 550000, 2, 1, 20
FROM homestays WHERE name = 'Cầu Đất Tea Estate Homestay'
UNION ALL
SELECT homestay_id, 'Cabin Thác', 'Cabin gỗ sát chân thác Prenn, nghe tiếng nước', 620000, 2, 1, 25
FROM homestays WHERE name = 'Prenn Waterfall Ecolodge'
UNION ALL
SELECT homestay_id, 'Suite Biệt Thự Pháp', 'Phòng trong biệt thự cổ 1930, nội thất cổ điển', 1200000, 2, 1, 40
FROM homestays WHERE name = 'Villa Pháp Cổ Hai Bà Trưng'
UNION ALL
SELECT homestay_id, 'Phòng Đôi Biệt Thự', 'Phòng trong biệt thự Pháp, chăn bông, sàn gỗ lim', 800000, 2, 1, 28
FROM homestays WHERE name = 'Villa Pháp Cổ Hai Bà Trưng'
UNION ALL
SELECT homestay_id, 'Lodge Mountain View', 'Lodge gỗ thông, view đỉnh Lang Biang', 920000, 2, 1, 32
FROM homestays WHERE name = 'Lang Biang Mountain Lodge'
UNION ALL
SELECT homestay_id, 'Family Lodge', 'Lodge gia đình 2 phòng ngủ, bếp nhỏ', 1500000, 4, 2, 55
FROM homestays WHERE name = 'Lang Biang Mountain Lodge'

-- HỘI AN
UNION ALL
SELECT homestay_id, 'Phòng Nhà Cổ', 'Phòng truyền thống nhà cổ 150 năm, giếng trời', 850000, 2, 1, 28
FROM homestays WHERE name = 'Nguyễn Thái Học Heritage House'
UNION ALL
SELECT homestay_id, 'Suite Di Sản', 'Suite tầng 2 view phố cổ Nguyễn Thái Học', 1600000, 2, 1, 48
FROM homestays WHERE name = 'Nguyễn Thái Học Heritage House'
UNION ALL
SELECT homestay_id, 'Nhà Dừa Nước', 'Phòng đơn giản trong làng dừa, giường tre nứa', 380000, 2, 1, 18
FROM homestays WHERE name = 'Cẩm Thanh Coconut Village Stay'
UNION ALL
SELECT homestay_id, 'Bungalow Bãi Biển', 'Bungalow 1 phòng gần biển Cửa Đại', 680000, 2, 1, 28
FROM homestays WHERE name = 'Cửa Đại Sunrise Bungalow'
UNION ALL
SELECT homestay_id, 'Villa An Bàng 3PN', 'Nguyên villa 3 phòng ngủ, bể bơi, sân vườn', 3800000, 6, 3, 180
FROM homestays WHERE name = 'An Bàng Beach Villa'
UNION ALL
SELECT homestay_id, 'Phòng Đôi Villa', '1 phòng trong villa, King bed, view vườn dừa', 1200000, 2, 1, 40
FROM homestays WHERE name = 'An Bàng Beach Villa'
UNION ALL
SELECT homestay_id, 'Phòng Rau Thơm', 'Phòng đơn giản view vườn rau Trà Quế', 420000, 2, 1, 20
FROM homestays WHERE name = 'Trà Quế Herb Garden Farmstay'
UNION ALL
SELECT homestay_id, 'Phòng Đèn Lồng', 'Phòng nhỏ xinh view phố cổ, đèn lồng treo', 580000, 2, 1, 18
FROM homestays WHERE name = 'Phan Bội Châu Lantern Guesthouse'
UNION ALL
SELECT homestay_id, 'Nhà Thợ Mộc', 'Phòng trong nhà thợ mộc Kim Bồng, sàn gỗ mít', 350000, 2, 1, 20
FROM homestays WHERE name = 'Kim Bồng Carpentry Village Homestay'
UNION ALL
SELECT homestay_id, 'River Villa Suite', 'Suite cao cấp view sông Thu Bồn, jacuzzi riêng', 3200000, 2, 1, 65
FROM homestays WHERE name = 'Thu Bồn Riverside Luxury Villa'
UNION ALL
SELECT homestay_id, 'Phòng Đôi Sông', 'Phòng deluxe view sông, King bed, butler service', 2100000, 2, 1, 45
FROM homestays WHERE name = 'Thu Bồn Riverside Luxury Villa'
UNION ALL
SELECT homestay_id, 'Phòng Ẩn Bãi Rạng', 'Phòng riêng tư bãi Rạng, ngủ nghe sóng biển', 750000, 2, 1, 25
FROM homestays WHERE name = 'Rạng Beach Hidden Retreat'
UNION ALL
SELECT homestay_id, 'Giường Dorm Hội An', 'Giường dorm 6 chỗ, rèm riêng, tủ khóa', 130000, 1, 1, 5
FROM homestays WHERE name = 'Old Town Backpacker Hội An'
UNION ALL
SELECT homestay_id, 'Phòng Đôi Hostel', 'Phòng đôi tư nhân, WC riêng, điều hòa', 420000, 2, 1, 16
FROM homestays WHERE name = 'Old Town Backpacker Hội An'

-- PHÚ QUỐC
UNION ALL
SELECT homestay_id, 'Villa Bãi Sao 2PN', 'Villa 2 phòng ngủ, bể bơi riêng, bếp, Bãi Sao', 4500000, 4, 2, 120
FROM homestays WHERE name = 'Bãi Sao Pearl Villa Phú Quốc'
UNION ALL
SELECT homestay_id, 'Phòng Đôi Bãi Sao', 'Phòng đôi trong villa, King bed, view biển', 1800000, 2, 1, 40
FROM homestays WHERE name = 'Bãi Sao Pearl Villa Phú Quốc'
UNION ALL
SELECT homestay_id, 'Cabin Hoang Sơ Bãi Dài', 'Cabin gỗ đơn giản, view biển Bãi Dài hoang vắng', 780000, 2, 1, 22
FROM homestays WHERE name = 'Bãi Dài North Coast Retreat'
UNION ALL
SELECT homestay_id, 'Phòng Chợ Đêm', 'Phòng đôi tiêu chuẩn, gần chợ đêm Dương Đông', 380000, 2, 1, 16
FROM homestays WHERE name = 'Dương Đông Night Market Guesthouse'
UNION ALL
SELECT homestay_id, 'Bungalow Hoàng Hôn', 'Bungalow gỗ, view hoàng hôn Bãi Ông Lang', 1200000, 2, 1, 32
FROM homestays WHERE name = 'Ông Lang Sunset Bungalow'
UNION ALL
SELECT homestay_id, 'Nhà Ngư Dân Hàm Ninh', 'Phòng đơn giản tại làng chài, ngủ với gia đình ngư dân', 320000, 2, 1, 15
FROM homestays WHERE name = 'Hàm Ninh Fishing Village Homestay'
UNION ALL
SELECT homestay_id, 'Ocean View Room Grand', 'Phòng hướng biển, King bed, minibar, 5 sao', 3500000, 2, 1, 45
FROM homestays WHERE name = 'Grand Phú Quốc Ocean Resort'
UNION ALL
SELECT homestay_id, 'Beach Villa Grand', 'Villa sát biển riêng, bể bơi vô cực, 5 sao', 8500000, 2, 1, 120
FROM homestays WHERE name = 'Grand Phú Quốc Ocean Resort'
UNION ALL
SELECT homestay_id, 'Glamping Tent Jungle', 'Lều sang trọng giữa rừng, giường gỗ, điều hòa', 1800000, 2, 1, 25
FROM homestays WHERE name = 'Suối Tranh Jungle Glamping'
UNION ALL
SELECT homestay_id, 'Phòng Cáp Treo View', 'Phòng tiêu chuẩn, gần cổng cáp treo Hòn Thơm', 480000, 2, 1, 20
FROM homestays WHERE name = 'Hòn Thơm Cable Car Guesthouse'
UNION ALL
SELECT homestay_id, 'Nhà Nông Hữu Cơ', 'Phòng trang trại, bao quanh vườn tiêu Phú Quốc', 550000, 2, 1, 22
FROM homestays WHERE name = 'Phú Quốc Eco Farm Stay'
UNION ALL
SELECT homestay_id, 'Dorm Island Hostel', 'Giường dorm 6 chỗ, bể bơi, free breakfast', 180000, 1, 1, 6
FROM homestays WHERE name = 'Phú Quốc Island Hostel'
UNION ALL
SELECT homestay_id, 'Phòng Đôi Hostel PQ', 'Phòng đôi riêng, WC riêng, điều hòa', 480000, 2, 1, 18
FROM homestays WHERE name = 'Phú Quốc Island Hostel'

-- HÀ NỘI
UNION ALL
SELECT homestay_id, 'Superior View Hồ Gươm', 'Phòng Superior tầng cao nhìn thẳng Hồ Gươm', 1500000, 2, 1, 28
FROM homestays WHERE name = 'Hồ Gươm View Boutique'
UNION ALL
SELECT homestay_id, 'Deluxe Boutique', 'Phòng Deluxe, breakfast phở gốc, view Tháp Rùa', 2200000, 2, 1, 38
FROM homestays WHERE name = 'Hồ Gươm View Boutique'
UNION ALL
SELECT homestay_id, 'Phòng Nhà Ống Hà Nội', 'Phòng truyền thống nhà ống 36 phố phường', 750000, 2, 1, 22
FROM homestays WHERE name = 'Hàng Đào Silk Heritage Guesthouse'
UNION ALL
SELECT homestay_id, 'Phòng Bohemian Hồ Tây', 'Phòng view hồ Tây, nội thất nghệ thuật', 780000, 2, 1, 25
FROM homestays WHERE name = 'Tây Hồ Lakeside Bohemian Homestay'
UNION ALL
SELECT homestay_id, 'Phòng Văn Nhân', 'Phòng phong cách thư sinh, gần Văn Miếu', 620000, 2, 1, 22
FROM homestays WHERE name = 'Văn Miếu Scholar Guesthouse'
UNION ALL
SELECT homestay_id, 'Phòng Standard Ba Đình', 'Phòng 3 sao khu lịch sử Ba Đình', 580000, 2, 1, 20
FROM homestays WHERE name = 'Ba Đình Heritage Hotel Hà Nội'
UNION ALL
SELECT homestay_id, 'Phòng Gia Đình Hoàng Mai', 'Phòng gia đình 4 người, bữa sáng truyền thống Hà Nội', 850000, 4, 2, 35
FROM homestays WHERE name = 'Hoàng Mai Local Experience Stay'
UNION ALL
SELECT homestay_id, 'Pod Capsule Standard', 'Pod ngủ riêng biệt, rèm cửa, ổ sạc USB', 280000, 1, 1, 4
FROM homestays WHERE name = 'Cầu Giấy Smart Capsule Hostel'
UNION ALL
SELECT homestay_id, 'Phòng Đôi Cầu Long Biên', 'Phòng nhỏ view cầu Long Biên lịch sử', 650000, 2, 1, 20
FROM homestays WHERE name = 'Long Biên Bridge View Guesthouse'
UNION ALL
SELECT homestay_id, 'Nhà Sàn Ngoại Thành', 'Nhà sàn tre nứa truyền thống Bắc Bộ', 680000, 4, 2, 40
FROM homestays WHERE name = 'Đồng Quê Sóc Sơn Retreat'
UNION ALL
SELECT homestay_id, 'Silk Road Suite', 'Suite cao cấp nhất, butler riêng, view phố cổ 180°', 5500000, 2, 1, 80
FROM homestays WHERE name = 'Silk Road Luxury Boutique Hà Nội'
UNION ALL
SELECT homestay_id, 'Deluxe Silk Room', 'Phòng deluxe, lụa tơ tằm Hà Đông, breakfast fusion', 2800000, 2, 1, 45
FROM homestays WHERE name = 'Silk Road Luxury Boutique Hà Nội'

-- NHA TRANG
UNION ALL
SELECT homestay_id, 'Beachfront Suite Cam Ranh', 'Suite hướng biển, King bed, bể bơi riêng', 3200000, 2, 1, 55
FROM homestays WHERE name = 'Cam Ranh Bay Beachfront Resort'
UNION ALL
SELECT homestay_id, 'Phòng Biển Cam Ranh', 'Phòng standard hướng biển Cam Ranh', 1400000, 2, 1, 30
FROM homestays WHERE name = 'Cam Ranh Bay Beachfront Resort'
UNION ALL
SELECT homestay_id, 'Bungalow Hòn Tre', 'Bungalow sinh thái trên đảo, view vịnh', 1100000, 2, 1, 28
FROM homestays WHERE name = 'Hòn Tre Island Eco Bungalow'
UNION ALL
SELECT homestay_id, 'Phòng Biển Trần Phú', 'Phòng view biển, King bed, rooftop pool access', 1600000, 2, 1, 32
FROM homestays WHERE name = 'Nha Trang Beach Boulevard Hotel'
UNION ALL
SELECT homestay_id, 'Suite Panorama NT', 'Suite tầng cao, view 180° Vịnh Nha Trang', 3800000, 2, 1, 65
FROM homestays WHERE name = 'Nha Trang Beach Boulevard Hotel'
UNION ALL
SELECT homestay_id, 'Water Villa Ninh Vân', 'Villa trên nước riêng tư, bể bơi nổi, view vịnh', 9500000, 2, 1, 110
FROM homestays WHERE name = 'Ninh Vân Bay Water Villa'
UNION ALL
SELECT homestay_id, 'Phòng Tháp Chăm', 'Phòng phong cách Chăm Pa, gần Tháp Ponagar', 450000, 2, 1, 18
FROM homestays WHERE name = 'Ponagar Cham Tower Heritage Inn'
UNION ALL
SELECT homestay_id, 'Phòng Đôi Dốc Lết', 'Phòng view biển cát trắng Dốc Lết', 750000, 2, 1, 22
FROM homestays WHERE name = 'Dốc Lết White Sand Resort'
UNION ALL
SELECT homestay_id, 'Dorm Party Zone', 'Dorm 8 chỗ, rooftop bar, pub crawl weekly', 150000, 1, 1, 5
FROM homestays WHERE name = 'Backpacker Zone Nha Trang'
UNION ALL
SELECT homestay_id, 'Nhà Ngư Dân Điệp Sơn', 'Phòng đơn sơ nhà ngư dân đảo Điệp Sơn', 280000, 2, 1, 12
FROM homestays WHERE name = 'Điệp Sơn Sand Road Island Stay'
UNION ALL
SELECT homestay_id, 'Cabin Rừng Ba Hồ', 'Cabin tự nhiên gần suối Ba Hồ', 650000, 2, 1, 20
FROM homestays WHERE name = 'Ba Hồ Waterfall Jungle Lodge'
UNION ALL
SELECT homestay_id, 'Clifftop Villa NT', 'Villa vách núi cao cấp, view Vịnh Nha Trang 270°', 7500000, 2, 1, 100
FROM homestays WHERE name = 'Ana Mandara Cliff Villa Nha Trang'
UNION ALL
SELECT homestay_id, 'Cliff Suite NT', 'Suite nhỏ hơn cùng view vịnh Nha Trang từ núi', 3500000, 2, 1, 55
FROM homestays WHERE name = 'Ana Mandara Cliff Villa Nha Trang';

-- Room types cho các thành phố còn lại (Sapa, Đà Nẵng, Huế, Mũi Né, Hà Giang, Ninh Bình, Quy Nhơn, Hạ Long, Bảo Lộc, Vũng Tàu)
INSERT INTO room_types (homestay_id, name, description, base_price, max_occupancy, bed_count, room_size_sqm)
SELECT homestay_id, 'Phòng Standard', 'Phòng tiêu chuẩn đầy đủ tiện nghi cơ bản', 480000, 2, 1, 20
FROM homestays WHERE city = 'Sa Pa' AND status = 'ACTIVE' AND name NOT IN ('Topas Ecolodge Style Sapa','Lào Cai Station Stopover Inn')
UNION ALL
SELECT homestay_id, 'Phòng Deluxe View Núi', 'Phòng deluxe, view ruộng bậc thang hoặc thung lũng', 850000, 2, 1, 32
FROM homestays WHERE city = 'Sa Pa' AND status = 'ACTIVE' AND name NOT IN ('Topas Ecolodge Style Sapa','Lào Cai Station Stopover Inn','Sapa Fog Hostel')
UNION ALL
SELECT homestay_id, 'Bungalow Granite Sapa', 'Bungalow đá granit cao cấp, hồ khoáng nóng, spa', 2800000, 2, 1, 50
FROM homestays WHERE name = 'Topas Ecolodge Style Sapa'
UNION ALL
SELECT homestay_id, 'Suite Panorama Sapa', 'Suite đỉnh đồi, toàn cảnh thung lũng Mường Hoa', 1800000, 2, 1, 45
FROM homestays WHERE name = 'Topas Ecolodge Style Sapa'
UNION ALL
SELECT homestay_id, 'Phòng Trung Chuyển', 'Phòng đơn nhận từ 5h sáng, gần ga Lào Cai', 280000, 2, 1, 14
FROM homestays WHERE name = 'Lào Cai Station Stopover Inn'
UNION ALL
SELECT homestay_id, 'Dorm Sương Mù', 'Giường dorm 4 chỗ, chăn lông vũ, lò sưởi chung', 160000, 1, 1, 5
FROM homestays WHERE name = 'Sapa Fog Hostel'
UNION ALL
-- Đà Nẵng
SELECT homestay_id, 'Phòng Standard Biển', 'Phòng view biển, điều hòa, TV, minibar', 850000, 2, 1, 28
FROM homestays WHERE city = 'Đà Nẵng' AND status = 'ACTIVE' AND name NOT IN ('Mỹ An Luxury Pool Villa','Airport Transit Guesthouse Đà Nẵng')
UNION ALL
SELECT homestay_id, 'Phòng Deluxe Biển', 'Phòng deluxe King bed, ban công view biển', 1400000, 2, 1, 38
FROM homestays WHERE city = 'Đà Nẵng' AND status = 'ACTIVE' AND name NOT IN ('Mỹ An Luxury Pool Villa','Airport Transit Guesthouse Đà Nẵng','Dragon Bridge City Center Apartment','Airport Transit Guesthouse Đà Nẵng')
UNION ALL
SELECT homestay_id, 'Villa 5PN Mỹ An', 'Toàn bộ villa 5 phòng ngủ, bể bơi, BBQ', 9500000, 12, 5, 300
FROM homestays WHERE name = 'Mỹ An Luxury Pool Villa'
UNION ALL
SELECT homestay_id, 'Phòng Đôi Villa Mỹ An', 'Phòng trong villa, giường King, view vườn', 2200000, 2, 1, 45
FROM homestays WHERE name = 'Mỹ An Luxury Pool Villa'
UNION ALL
SELECT homestay_id, 'Phòng Transit 6h', 'Phòng lưu trú ngắn 6 tiếng, gần sân bay', 320000, 2, 1, 16
FROM homestays WHERE name = 'Airport Transit Guesthouse Đà Nẵng'
UNION ALL
-- Huế
SELECT homestay_id, 'Phòng Nhà Vườn Huế', 'Phòng truyền thống nhà vườn Huế', 680000, 2, 1, 24
FROM homestays WHERE city = 'Huế' AND status = 'ACTIVE' AND name NOT IN ('Vedana Lagoon Huế Luxury Resort','Huế Station Budget Guesthouse')
UNION ALL
SELECT homestay_id, 'Suite Hoàng Triều', 'Suite cao cấp mang tên vua Nguyễn, bathtub hoa sen', 1800000, 2, 1, 55
FROM homestays WHERE city = 'Huế' AND status = 'ACTIVE' AND name NOT IN ('Vedana Lagoon Huế Luxury Resort','Huế Station Budget Guesthouse','Làng Chuồn Nón Lá Artisan Homestay','Thanh Toàn Bridge Village Homestay')
UNION ALL
SELECT homestay_id, 'Bungalow Đầm Nước', 'Bungalow trên cọc, view đầm phá Tam Giang', 3500000, 2, 1, 70
FROM homestays WHERE name = 'Vedana Lagoon Huế Luxury Resort'
UNION ALL
SELECT homestay_id, 'Phòng Budget Ga Huế', 'Phòng đơn giản, sạch sẽ, gần ga Huế', 280000, 2, 1, 14
FROM homestays WHERE name = 'Huế Station Budget Guesthouse'
UNION ALL
-- Mũi Né
SELECT homestay_id, 'Phòng Standard Biển', 'Phòng tiêu chuẩn gần biển Mũi Né', 650000, 2, 1, 22
FROM homestays WHERE city = 'Phan Thiết' AND status = 'ACTIVE' AND name NOT IN ('Anantara Mũi Né Style Villa','Bàu Trắng White Dune Glamping')
UNION ALL
SELECT homestay_id, 'Phòng Deluxe View Biển', 'Phòng deluxe, ban công view biển Mũi Né', 1100000, 2, 1, 32
FROM homestays WHERE city = 'Phan Thiết' AND status = 'ACTIVE' AND name NOT IN ('Anantara Mũi Né Style Villa','Bàu Trắng White Dune Glamping','Mũi Né Backpacker Beach Hostel','Phan Thiết Old Town Food Trail Inn')
UNION ALL
SELECT homestay_id, 'Villa Anantara Suite', 'Suite luxury mặt biển, butler 24/7', 8500000, 2, 1, 110
FROM homestays WHERE name = 'Anantara Mũi Né Style Villa'
UNION ALL
SELECT homestay_id, 'Deluxe Villa Room', 'Phòng deluxe trong khu villa Anantara', 3200000, 2, 1, 50
FROM homestays WHERE name = 'Anantara Mũi Né Style Villa'
UNION ALL
SELECT homestay_id, 'Glamping Dome Bàu Trắng', 'Lều dome sa mạc cao cấp, view hồ cát trắng', 2200000, 2, 1, 28
FROM homestays WHERE name = 'Bàu Trắng White Dune Glamping'
UNION ALL
SELECT homestay_id, 'Dorm Mũi Né Budget', 'Giường dorm 6 chỗ, gần biển kite surf', 140000, 1, 1, 5
FROM homestays WHERE name = 'Mũi Né Backpacker Beach Hostel'
UNION ALL
-- Hà Giang
SELECT homestay_id, 'Phòng Cao Nguyên Đá', 'Phòng đơn giản, mền chăn dày, lò sưởi', 380000, 2, 1, 16
FROM homestays WHERE city = 'Hà Giang' AND status = 'ACTIVE' AND name NOT IN ('Hà Giang City Gateway Hotel')
UNION ALL
SELECT homestay_id, 'Nhà Sàn H''Mông', 'Ngủ nhà sàn truyền thống, ăn cơm nếp thắng cố', 280000, 4, 2, 30
FROM homestays WHERE city = 'Hà Giang' AND status = 'ACTIVE' AND name IN ('Thôn Tha H''Mông Flower Village','Phố Bảng Sunday Market Lodge','Lũng Cú Northernmost Homestay','Cổng Trời Quản Bạ Twin Mountain Stay')
UNION ALL
SELECT homestay_id, 'Phòng Khách Sạn 3 Sao', 'Phòng khách sạn tiêu chuẩn thành phố Hà Giang', 550000, 2, 1, 22
FROM homestays WHERE name = 'Hà Giang City Gateway Hotel'
UNION ALL
SELECT homestay_id, 'Suite Cổng Trời', 'Suite view núi Đôi Quản Bạ, King bed', 980000, 2, 1, 35
FROM homestays WHERE name = 'Hà Giang City Gateway Hotel'
UNION ALL
-- Ninh Bình
SELECT homestay_id, 'Phòng Sông Sào Khê', 'Phòng tiêu chuẩn view sông Tràng An', 520000, 2, 1, 20
FROM homestays WHERE city = 'Ninh Bình' AND status = 'ACTIVE' AND name NOT IN ('Cúc Phương National Park Cabin','Ninh Hải Budget Guesthouse','Vân Long Wetland Bird Watch Lodge')
UNION ALL
SELECT homestay_id, 'Phòng Deluxe Di Sản', 'Phòng deluxe view cánh đồng lúa Tam Cốc', 950000, 2, 1, 32
FROM homestays WHERE city = 'Ninh Bình' AND status = 'ACTIVE' AND name IN ('Tràng An UNESCO Riverside Lodge','Tam Cốc Paddyfield Homestay','Hoa Lư Ancient Capital Guesthouse')
UNION ALL
SELECT homestay_id, 'Cabin Rừng Cúc Phương', 'Cabin gỗ trong rừng nguyên sinh, ngủ nghe chim', 750000, 2, 1, 25
FROM homestays WHERE name = 'Cúc Phương National Park Cabin'
UNION ALL
SELECT homestay_id, 'Phòng Budget Ninh Hải', 'Phòng nhỏ giá rẻ gần bến thuyền Tam Cốc', 260000, 2, 1, 14
FROM homestays WHERE name = 'Ninh Hải Budget Guesthouse'
UNION ALL
SELECT homestay_id, 'Phòng Đầm Vân Long', 'Phòng view đầm ngập nước, ngắm voọc trắng', 680000, 2, 1, 22
FROM homestays WHERE name = 'Vân Long Wetland Bird Watch Lodge'
UNION ALL
-- Quy Nhơn
SELECT homestay_id, 'Phòng Standard Biển QN', 'Phòng tiêu chuẩn view biển Quy Nhơn', 580000, 2, 1, 20
FROM homestays WHERE city = 'Quy Nhơn' AND status = 'ACTIVE' AND name NOT IN ('Hải Giang Peninsula Hidden Villa','Kỳ Co Island Paradise Bungalow')
UNION ALL
SELECT homestay_id, 'Phòng Deluxe View Vịnh', 'Phòng deluxe, ban công view vịnh Kỳ Co hay Hải Giang', 1100000, 2, 1, 32
FROM homestays WHERE city = 'Quy Nhơn' AND status = 'ACTIVE' AND name NOT IN ('Hải Giang Peninsula Hidden Villa','Kỳ Co Island Paradise Bungalow','Quy Nhơn Budget Traveler Inn')
UNION ALL
SELECT homestay_id, 'Private Island Villa HG', 'Villa toàn bộ bán đảo Hải Giang, riêng tư hoàn toàn', 8500000, 8, 4, 200
FROM homestays WHERE name = 'Hải Giang Peninsula Hidden Villa'
UNION ALL
SELECT homestay_id, 'Bungalow Kỳ Co', 'Bungalow đảo san hô, view vịnh xanh ngọc', 1500000, 2, 1, 30
FROM homestays WHERE name = 'Kỳ Co Island Paradise Bungalow'
UNION ALL
SELECT homestay_id, 'Phòng Budget Quy Nhơn', 'Phòng nhỏ giá rẻ, xe máy thuê 100k', 280000, 2, 1, 14
FROM homestays WHERE name = 'Quy Nhơn Budget Traveler Inn'
UNION ALL
-- Hạ Long
SELECT homestay_id, 'Cabin Du Thuyền', 'Cabin hạng sang trên du thuyền 5 sao giữa vịnh', 4500000, 2, 1, 35
FROM homestays WHERE name = 'Ha Long Bay Luxury Cruise Cabin'
UNION ALL
SELECT homestay_id, 'Phòng Standard Vịnh', 'Phòng view Vịnh Hạ Long từ khách sạn bờ', 950000, 2, 1, 28
FROM homestays WHERE city = 'Hạ Long' AND status = 'ACTIVE' AND name NOT IN ('Ha Long Bay Luxury Cruise Cabin','Hạ Long Budget Hostel','Móng Cái Border City Guesthouse')
UNION ALL
SELECT homestay_id, 'Phòng Deluxe Vịnh', 'Phòng deluxe ban công view Vịnh Hạ Long', 1600000, 2, 1, 38
FROM homestays WHERE city = 'Hạ Long' AND status = 'ACTIVE' AND name IN ('Bãi Cháy Vịnh Xanh Hotel','Tuần Châu Island Villa','Hòn Gai Colonial Quarter Inn')
UNION ALL
SELECT homestay_id, 'Dorm Hạ Long Budget', 'Giường dorm 6 chỗ, gần bến tàu vịnh', 160000, 1, 1, 5
FROM homestays WHERE name = 'Hạ Long Budget Hostel'
UNION ALL
SELECT homestay_id, 'Phòng Biên Giới', 'Phòng đơn giản sạch sẽ, gần cửa khẩu Móng Cái', 350000, 2, 1, 16
FROM homestays WHERE name = 'Móng Cái Border City Guesthouse'
UNION ALL
-- Bảo Lộc
SELECT homestay_id, 'Phòng Đồi Chè', 'Phòng tiêu chuẩn view đồi chè Bảo Lộc', 480000, 2, 1, 20
FROM homestays WHERE city = 'Bảo Lộc' AND status = 'ACTIVE' AND name NOT IN ('Bảo Lộc Tea Horizon Luxury Villa','Bảo Lộc Traveler Budget Stay')
UNION ALL
SELECT homestay_id, 'Phòng Farm Premium', 'Phòng cao cấp view nông trại, bữa sáng tại vườn', 850000, 2, 1, 32
FROM homestays WHERE city = 'Bảo Lộc' AND status = 'ACTIVE' AND name IN ('Bảo Lộc Tea Hill Farmstay','Đambri Waterfall Forest Ecolodge','Lâm Hà Coffee & Fruit Farm Stay')
UNION ALL
SELECT homestay_id, 'Glass Room Tea Horizon', 'Phòng kính ngủ dưới sao giữa đồi chè', 5500000, 2, 1, 60
FROM homestays WHERE name = 'Bảo Lộc Tea Horizon Luxury Villa'
UNION ALL
SELECT homestay_id, 'Phòng Budget Bảo Lộc', 'Phòng nhỏ xe đạp miễn phí, trà pha phin sáng', 280000, 2, 1, 14
FROM homestays WHERE name = 'Bảo Lộc Traveler Budget Stay'
UNION ALL
-- Vũng Tàu
SELECT homestay_id, 'Phòng Standard Biển VT', 'Phòng tiêu chuẩn view biển hoặc view thành phố', 680000, 2, 1, 22
FROM homestays WHERE city = 'Vũng Tàu' AND status = 'ACTIVE' AND name NOT IN ('The Grand Vũng Tàu Ocean Villa','Vũng Tàu Weekend Escape Hostel','Côn Đảo Historic Island Guesthouse')
UNION ALL
SELECT homestay_id, 'Phòng Deluxe Biển VT', 'Phòng deluxe ban công view biển Vũng Tàu', 1200000, 2, 1, 32
FROM homestays WHERE city = 'Vũng Tàu' AND status = 'ACTIVE' AND name IN ('Bãi Sau Long Beach Beachfront Resort','Bãi Trước Front Beach Inn','Long Hải Unspoiled Beach Villa')
UNION ALL
SELECT homestay_id, 'Grand Ocean Villa 5 Sao', 'Villa 5 sao toàn bộ, bãi biển riêng, butler', 12000000, 8, 4, 250
FROM homestays WHERE name = 'The Grand Vũng Tàu Ocean Villa'
UNION ALL
SELECT homestay_id, 'Dorm Weekend Escape', 'Giường dorm 6 chỗ, BBQ sân thượng thứ 7', 160000, 1, 1, 5
FROM homestays WHERE name = 'Vũng Tàu Weekend Escape Hostel'
UNION ALL
SELECT homestay_id, 'Phòng Côn Đảo Historic', 'Phòng nghỉ trên đảo Côn Đảo, gần nghĩa trang', 780000, 2, 1, 22
FROM homestays WHERE name = 'Côn Đảo Historic Island Guesthouse';

-- ====================================================================================
-- PHẦN 6: ROOMS (dùng stored logic đơn giản - 2 phòng cho mỗi room_type)
-- ====================================================================================
INSERT IGNORE INTO rooms (room_type_id, room_number, status, housekeeping_status)
SELECT room_type_id, room_number, status, housekeeping_status
FROM (
  SELECT rt.room_type_id,
         CONCAT(
           CASE WHEN rt.base_price >= 3000000 THEN 'V'
                WHEN rt.base_price >= 1000000 THEN 'D'
                ELSE 'S' END,
           LPAD(ROW_NUMBER() OVER (PARTITION BY rt.room_type_id ORDER BY rt.room_type_id), 2, '0')
         ) AS room_number,
         'AVAILABLE' AS status,
         'CLEAN' AS housekeeping_status
  FROM room_types rt
  JOIN homestays h ON rt.homestay_id = h.homestay_id
  WHERE h.city IN ('Đà Lạt','Hội An','Phú Quốc','Hà Nội','Nha Trang','Sa Pa','Đà Nẵng','Huế',
                   'Phan Thiết','Hà Giang','Ninh Bình','Quy Nhơn','Hạ Long','Bảo Lộc','Vũng Tàu')
    AND h.name NOT IN (
      'Đà Lạt Pine Valley Homestay','Ana Garden Villa Đà Lạt',
      'Hội An Ancient Town Boutique','Riverside Retreat Hội An',
      'Sunset Bay Resort Phú Quốc','Phú Quốc Backpacker Haven',
      'Hà Nội Old Quarter Heritage Hotel','West Lake Garden Homestay HN',
      'Ocean Breeze Hotel Nha Trang','Nha Trang Budget Stay',
      'Sapa Cloud Ridge Retreat','Bản Làng H''Mông Homestay Sapa',
      'Da Nang Beachfront Luxury Villa','Dragon Bridge City View Hostel',
      'Da Nang Mountain View Guesthouse',
      'Đà Lạt Misty Valley Homestay','Đà Lạt Sunset Ridge Villa','Đà Lạt Rose Garden Bungalow'
    )
) sub_rooms;

-- Thêm 1 phòng thứ 2 cho mỗi room_type (room number 02)
INSERT IGNORE INTO rooms (room_type_id, room_number, status, housekeeping_status)
SELECT rt.room_type_id,
       CONCAT(
         CASE WHEN rt.base_price >= 3000000 THEN 'V'
              WHEN rt.base_price >= 1000000 THEN 'D'
              ELSE 'S' END,
         '02'
       ),
       CASE WHEN RAND() > 0.8 THEN 'OCCUPIED' ELSE 'AVAILABLE' END,
       'CLEAN'
FROM room_types rt
JOIN homestays h ON rt.homestay_id = h.homestay_id
WHERE h.city IN ('Đà Lạt','Hội An','Phú Quốc','Hà Nội','Nha Trang','Sa Pa','Đà Nẵng','Huế',
                 'Phan Thiết','Hà Giang','Ninh Bình','Quy Nhơn','Hạ Long','Bảo Lộc','Vũng Tàu')
  AND h.name NOT IN (
    'Đà Lạt Pine Valley Homestay','Ana Garden Villa Đà Lạt',
    'Hội An Ancient Town Boutique','Riverside Retreat Hội An',
    'Sunset Bay Resort Phú Quốc','Phú Quốc Backpacker Haven',
    'Hà Nội Old Quarter Heritage Hotel','West Lake Garden Homestay HN',
    'Ocean Breeze Hotel Nha Trang','Nha Trang Budget Stay',
    'Sapa Cloud Ridge Retreat','Bản Làng H''Mông Homestay Sapa',
    'Da Nang Beachfront Luxury Villa','Dragon Bridge City View Hostel',
    'Da Nang Mountain View Guesthouse',
    'Đà Lạt Misty Valley Homestay','Đà Lạt Sunset Ridge Villa','Đà Lạt Rose Garden Bungalow'
  );

SET FOREIGN_KEY_CHECKS = 1;

-- Restore default sql_mode
SET SESSION sql_mode = DEFAULT;

-- ====================================================================================
-- VERIFICATION
-- ====================================================================================
/*
SELECT city, COUNT(*) AS total_homestays, AVG(rating_avg) AS avg_rating
FROM homestays
WHERE city IN ('Đà Lạt','Hội An','Phú Quốc','Hà Nội','Nha Trang','Sa Pa','Đà Nẵng','Huế',
               'Phan Thiết','Hà Giang','Ninh Bình','Quy Nhơn','Hạ Long','Bảo Lộc','Vũng Tàu')
GROUP BY city ORDER BY city;

SELECT COUNT(*) AS total_homestays FROM homestays;
SELECT COUNT(*) AS total_room_types FROM room_types;
SELECT COUNT(*) AS total_rooms FROM rooms;
SELECT COUNT(*) AS total_images FROM homestay_images;
SELECT COUNT(*) AS total_amenities FROM homestay_amenities;
*/
