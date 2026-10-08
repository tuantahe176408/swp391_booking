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
