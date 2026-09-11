# TÀI LIỆU MÔ TẢ CHI TIẾT USE CASES & THIẾT KẾ NỀN TẢNG
## Hệ thống Đặt phòng Homestay & Hotel Thông minh (Smart Booking Platform)
**Kiến trúc Chuẩn: Java Web JSP/Servlet MVC | Đã đồng bộ hóa 100% Tiêu chuẩn Bảo mật & Công nghệ**

---

## 1. TỔNG QUAN HỆ THỐNG & NĂNG LỰC DỰ ÁN

* **Tổng số Use Cases:** 26 Use Cases (Phân chia đồng đều cho 5 Thành viên).
* **Tổng quy đổi LOC:** 4.590 Lines of Code (Trung bình 800 – 1.000 LOC / thành viên).
* **Stack Công nghệ:** NetBeans IDE, Apache Tomcat 9.0+, Java 11/17 LTS, Servlet 4.0+, JSP/JSTL 1.2, HikariCP Connection Pool / JDBC, MySQL, HTML5/CSS3, JavaScript (AJAX/Fetch API), Chart.js, Cloudinary API, JavaMail API, Apache POI.
* **Mô hình Kiến trúc:** NetBeans Java Web MVC Architecture (Session-based Auth, Servlet Filters, PreparedStatement DAO, View JSP trong `/WEB-INF/views/`).

---

## 2. BẢNG TỔNG HỢP PHÂN CÔNG 26 USE CASES

| Mã UC | Tên Use Case | Thành viên phụ trách | Actor chính | Mức độ | LOC | Fields / Trans |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **UC01** | Register / Login / OAuth & OTP | Thành viên 1 | Customer / User | Level 4 | 150 | 10-11 fields / 5 transactions |
| **UC02** | Manage Profile & Preferences | Thành viên 1 | Customer | Level 3 | 120 | 8-9 fields / 4 transactions |
| **UC03** | Search & Advanced Filter Homestays | Thành viên 1 | Customer | Level 6 | 210 | 14-15 fields / 7 transactions |
| **UC04** | View Homestay & Room Details | Thành viên 1 | Customer | Level 5 | 180 | 12-13 fields / 6 transactions |
| **UC05** | View AI Recommendations & Smart Feed | Thành viên 1 | Customer | Level 5 | 180 | 12-13 fields / 6 transactions |
| **UC06** | Manage Wishlist & Saved Lists | Thành viên 1 | Customer | Level 3 | 120 | 8-9 fields / 4 transactions |
| **UC07** | Book Room & Add-on Selection | Thành viên 2 | Customer | Level 6 | 210 | 14-15 fields / 7 transactions |
| **UC08** | Make Payment Gateway Integration | Thành viên 2 | Customer | Level 6 | 210 | 14-15 fields / 7 transactions |
| **UC09** | Manage Customer Bookings & Refund | Thành viên 2 | Customer | Level 5 | 180 | 12-13 fields / 6 transactions |
| **UC10** | Submit Review, Rating & Media Upload | Thành viên 2 | Customer | Level 4 | 150 | 10-11 fields / 5 transactions |
| **UC11** | Apply Vouchers & Loyalty Rewards | Thành viên 2 | Customer | Level 4 | 150 | 10-11 fields / 5 transactions |
| **UC12** | Check-in / Check-out Management & OCR | Thành viên 3 | Receptionist | Level 6 | 210 | 14-15 fields / 7 transactions |
| **UC13** | Manage Walk-in & On-site Desk Booking | Thành viên 3 | Receptionist | Level 5 | 180 | 12-13 fields / 6 transactions |
| **UC14** | View Room Availability Matrix & Grid | Thành viên 3 | Receptionist | Level 5 | 180 | 12-13 fields / 6 transactions |
| **UC15** | Process On-site Payment & Surcharges | Thành viên 3 | Receptionist | Level 5 | 180 | 12-13 fields / 6 transactions |
| **UC16** | View Daily Guest List & Housekeeping | Thành viên 3 | Receptionist | Level 4 | 150 | 10-11 fields / 5 transactions |
| **UC17** | Manage Homestay & Room Listings | Thành viên 4 | Owner | Level 7 | 240 | >15 fields / >7 transactions |
| **UC18** | Manage Room Calendar & Dynamic Pricing | Thành viên 4 | Owner | Level 6 | 210 | 14-15 fields / 7 transactions |
| **UC19** | Manage Extra Add-on Services | Thành viên 4 | Owner | Level 4 | 150 | 10-11 fields / 5 transactions |
| **UC20** | View Revenue & Occupancy Analytics | Thành viên 4 | Owner | Level 5 | 180 | 12-13 fields / 6 transactions |
| **UC21** | Manage Receptionist Staff Accounts | Thành viên 4 | Owner | Level 4 | 150 | 10-11 fields / 5 transactions |
| **UC22** | Manage Users & Account Permissions | Thành viên 5 | Admin | Level 5 | 180 | 12-13 fields / 6 transactions |
| **UC23** | Approve Homestay Registration Listings | Thành viên 5 | Admin | Level 5 | 180 | 12-13 fields / 6 transactions |
| **UC24** | System Configuration & AI Monitoring | Thành viên 5 | Admin | Level 6 | 210 | 14-15 fields / 7 transactions |
| **UC25** | View Platform Analytics & Financials | Thành viên 5 | Admin | Level 5 | 180 | 12-13 fields / 6 transactions |
| **UC26** | Manage Platform Vouchers & Campaigns | Thành viên 5 | Admin | Level 5 | 180 | 12-13 fields / 6 transactions |

---

## 3. PHÂN TÍCH KỊCH BẢN CHI TIẾT TỪNG USE CASE (UC01 - UC26)

### UC01: Register / Login / OAuth & OTP
* **Thành viên phụ trách:** Thành viên 1 (Auth & Discovery)
* **Actor:** Customer / User | **Dịch vụ phụ:** Google OAuth2 API, JavaMail API (`EmailUtil`), BCrypt (`PasswordUtil`)
* **Mô tả:** Đăng ký, đăng nhập bằng tài khoản hoặc Google OAuth2, xác minh OTP qua Email và khởi tạo Http Session bảo mật.
* **Luồng sự kiện (Main Flow):**
  1. Người dùng gửi yêu cầu tới `AuthController`. Servlet forward giao diện `/WEB-INF/views/customer/login.jsp`.
  2. Người dùng điền thông tin Đăng ký hoặc chọn Google Login.
  3. `AuthController` kiểm tra mật khẩu bằng `PasswordUtil.hashPassword()`, sinh OTP 6 số và gửi qua Email với `EmailUtil`.
  4. Khách hàng nhập OTP xác nhận. `AuthController` xác thực, gọi `UserDAOImpl.insertUser()` và gán User Model vào `HttpSession`.
  5. Điều hướng người dùng về trang chủ.
* **Luồng ngoại lệ (Exceptions):** Sai mật khẩu > 5 lần $\rightarrow$ `AuthenticationFilter` tạm khóa tài khoản 15 phút.

---

### UC02: Manage Profile & Preferences
* **Thành viên phụ trách:** Thành viên 1 (Auth & Discovery)
* **Actor:** Customer | **Dịch vụ phụ:** Cloudinary API
* **Mô tả:** Cho phép khách hàng thay đổi thông tin cá nhân, cập nhật avatar và thiết lập danh mục sở thích du lịch (đầu vào AI Recommendation).
* **Luồng sự kiện (Main Flow):**
  1. `ProfileController` nhận request `GET /customer/profile`, đọc thông tin từ Session và truy vấn `UserDAOImpl`.
  2. Forward dữ liệu hiển thị tại `/WEB-INF/views/customer/profile.jsp`.
  3. Khách hàng cập nhật họ tên, SĐT, sở thích và chọn tệp avatar mới.
  4. Servlet xử lý `POST` request multipart: Upload ảnh lên Cloudinary, lưu URL và sở thích (`User_Preferences`) vào DB.
* **Luồng ngoại lệ (Exceptions):** Tệp avatar sai định dạng hoặc kích thước > 5MB $\rightarrow$ Hiển thị thông báo lỗi trên Form.

---

### UC03: Search & Advanced Filter Homestays
* **Thành viên phụ trách:** Thành viên 1 (Auth & Discovery)
* **Actor:** Customer | **Dịch vụ phụ:** Google Maps API, AJAX API
* **Mô tả:** Tìm kiếm Homestay theo địa điểm, ngày lưu trú, khoảng giá, số sao và tiện ích mà không reload toàn trang.
* **Luồng sự kiện (Main Flow):**
  1. Khách hàng nhập từ khóa tìm kiếm tại trang chủ. `SearchController` thực thi query với `PreparedStatement`.
  2. Forward giao diện `/WEB-INF/views/customer/search.jsp`.
  3. Khách hàng thay đổi bộ lọc (giá, dịch vụ): Client gửi AJAX request tới `SearchApiController`.
  4. Servlet phản hồi chuỗi JSON. JavaScript render lại danh sách card Homestay và cập nhật Google Maps Marker.

---

### UC04: View Homestay & Room Details
* **Thành viên phụ trách:** Thành viên 1 (Auth & Discovery)
* **Actor:** Customer | **Dịch vụ phụ:** AI Recommendation Engine, Cloudinary
* **Mô tả:** Xem chi tiết thông tin Homestay, album ảnh HD, đánh giá thực tế, điểm AI Match Score và danh sách phòng khả dụng.
* **Luồng sự kiện (Main Flow):**
  1. Khách hàng bấm chọn Homestay. `HomestayDetailController` nhận `homestay_id`.
  2. Servlet gọi `HomestayService` truy vấn danh sách phòng trống, đánh giá và tính % AI Match Score với sở thích khách hàng.
  3. Forward dữ liệu sang `/WEB-INF/views/customer/detail.jsp`.
  4. Khách hàng chọn hạng phòng ưng ý và chọn "Đặt ngay".

---

### UC05: View AI Recommendations & Smart Feed
* **Thành viên phụ trách:** Thành viên 1 (Auth & Discovery)
* **Actor:** Customer | **Dịch vụ phụ:** AI Recommendation Module (Collaborative Filtering)
* **Mô tả:** Trang Smart Feed hiển thị danh sách Homestay gợi ý cá nhân hóa dựa trên lịch sử xem, đặt phòng và sở thích.
* **Luồng sự kiện (Main Flow):**
  1. Khách hàng chọn tab "Gợi ý thông minh". `RecommendationController` trích xuất `user_id` từ Session.
  2. Servlet gọi AI Recommendation Service lấy danh sách `homestay_id` gợi ý kèm theo `reason_tag`.
  3. Truy vấn DB chi tiết các homestay và forward sang `/WEB-INF/views/customer/recommendations.jsp`.
* **Luồng ngoại lệ (Exceptions):** Người dùng mới (Cold Start) $\rightarrow$ Hệ thống tự động truy vấn danh sách Homestay Nổi bật nhất.

---

### UC06: Manage Wishlist & Saved Lists
* **Thành viên phụ trách:** Thành viên 1 (Auth & Discovery)
* **Actor:** Customer | **Dịch vụ phụ:** AJAX API
* **Mô tả:** Thêm hoặc xóa Homestay khỏi danh sách Yêu thích cá nhân bằng thao tác 1-Click.
* **Luồng sự kiện (Main Flow):**
  1. Khách hàng bấm biểu tượng Trái tim trên Card Homestay.
  2. AJAX Request gửi dữ liệu `POST` tới `WishlistApiController`.
  3. Servlet thực thi `WishlistDAOImpl.toggleWishlist()` và trả về JSON `{status: "success", is_saved: true}`.
  4. Client cập nhật trạng thái màu biểu tượng ngay tức thì.

---

### UC07: Book Room & Add-on Selection
* **Thành viên phụ trách:** Thành viên 2 (Booking & Payments)
* **Actor:** Customer | **Dịch vụ phụ:** JavaMail API (`EmailUtil`)
* **Mô tả:** Chọn dịch vụ bổ sung, nhập thông tin liên hệ và tạo đơn đặt phòng (tạm khóa phòng 15 phút).
* **Luồng sự kiện (Main Flow):**
  1. Khách hàng nhấn "Đặt phòng". `BookingController` chuyển hướng sang `/WEB-INF/views/customer/checkout.jsp`.
  2. Khách hàng tích chọn các Dịch vụ đi kèm (Add-ons) và điền thông tin lưu trú.
  3. Khách hàng bấm "Xác nhận đặt phòng".
  4. Servlet dùng DB Transaction kiểm tra lại tính khả dụng của phòng, tạo bản ghi `Bookings` với status = `PENDING` và gọi `EmailUtil` gửi email giữ chỗ.
* **Luồng ngoại lệ (Exceptions):** Phòng đã bị khách khác đặt trùng lịch $\rightarrow$ Rollback transaction và thông báo khách hàng chọn lại.

---

### UC08: Make Payment Gateway Integration
* **Thành viên phụ trách:** Thành viên 2 (Booking & Payments)
* **Actor:** Customer | **Dịch vụ phụ:** VNPay / MoMo Payment Gateway API
* **Mô tả:** Tích hợp Cổng thanh toán trực tuyến, xử lý URL redirect, mã hóa chữ ký SHA-256 và callback IPN ngầm.
* **Luồng sự kiện (Main Flow):**
  1. `PaymentController` sinh Checksum SHA-256 mã hóa đơn hàng và chuyển hướng người dùng sang Cổng thanh toán.
  2. Khách hàng hoàn tất thanh toán. Cổng thanh toán chuyển hướng người dùng về `PaymentReturnController` (xem kết quả).
  3. Cổng thanh toán đồng thời gửi request ngầm IPN đến `PaymentIpnController`.
  4. Servlet IPN verify chữ ký, cập nhật trạng thái Booking = `CONFIRMED` trong DB Transaction và gửi Vé điện tử qua Email.

---

### UC09: Manage Customer Bookings & Refund
* **Thành viên phụ trách:** Thành viên 2 (Booking & Payments)
* **Actor:** Customer | **Dịch vụ phụ:** Payment Refund API, JavaMail API
* **Mô tả:** Quản lý lịch sử đặt phòng, xem Vé điện tử QR Code và thực hiện Yêu cầu Hủy phòng / Hoàn tiền tự động.
* **Luồng sự kiện (Main Flow):**
  1. Khách hàng truy cập `/customer/bookings`. `CustomerBookingController` forward dữ liệu sang `/WEB-INF/views/customer/booking-list.jsp`.
  2. Khách hàng xem mã QR Code của đơn để Check-in.
  3. Nếu bấm "Hủy đơn": Servlet kiểm tra điều kiện chính sách hủy (VD: Hủy trước 3 ngày = Hoàn 100%).
  4. Servlet kích hoạt API Refund của Cổng thanh toán, cập nhật status = `CANCELLED` và gửi email thông báo hủy.

---

### UC10: Submit Review, Rating & Media Upload
* **Thành viên phụ trách:** Thành viên 2 (Booking & Payments)
* **Actor:** Customer | **Dịch vụ phụ:** Cloudinary API, JSoup Sanitizer (Chống XSS)
* **Mô tả:** Gửi nhận xét, đánh giá số sao và hình ảnh thực tế sau khi hoàn thành chuyến đi (`COMPLETED`).
* **Luồng sự kiện (Main Flow):**
  1. Khách hàng chọn đơn đã ở xong và bấm "Đánh giá".
  2. `ReviewController` forward giao diện `/WEB-INF/views/customer/review-form.jsp`.
  3. Khách hàng chấm điểm sao, tải ảnh thực tế và viết nội dung.
  4. Servlet làm sạch dữ liệu bằng JSoup Sanitizer, upload ảnh lên Cloudinary và lưu bản ghi vào DB `Reviews`.
  5. Tự động tính toán lại điểm rating trung bình của Homestay.

---

### UC11: Apply Vouchers & Loyalty Rewards
* **Thành viên phụ trách:** Thành viên 2 (Booking & Payments)
* **Actor:** Customer | **Dịch vụ phụ:** AJAX API
* **Mô tả:** Áp dụng Mã giảm giá (Voucher) hoặc Điểm thưởng cá nhân để giảm trừ chi phí đơn đặt phòng.
* **Luồng sự kiện (Main Flow):**
  1. Khách hàng nhập mã Voucher tại màn hình thanh toán.
  2. AJAX Request gửi tới `VoucherApiController`.
  3. Servlet kiểm tra điều kiện mã qua `VoucherDAOImpl` (Hạn dùng, Lượt dùng còn lại, Giá trị tối thiểu).
  4. Nếu hợp lệ, trả về JSON số tiền giảm và cập nhật lại giao diện Tổng chi phí.

---

### UC12: Check-in / Check-out Management & OCR ID Scanning
* **Thành viên phụ trách:** Thành viên 3 (Reception Desk)
* **Actor:** Receptionist | **Dịch vụ phụ:** OCR Service (Nhận dạng CCCD/Passport), Web Camera
* **Mô tả:** Xử lý thủ tục Check-in/Check-out. Trích xuất tự động thông tin từ ảnh CCCD/Passport bằng công nghệ OCR.
* **Luồng sự kiện (Main Flow):**
  1. Lễ tân truy cập `/reception/checkin`. Servlet forward giao diện `/WEB-INF/views/reception/checkin.jsp`.
  2. Lễ tân tìm đơn hàng theo Mã Booking/SĐT.
  3. Lễ tân chụp/tải ảnh CCCD khách hàng: AJAX gửi ảnh tới `OcrApiController`.
  4. OCR Service bóc tách Họ tên, Số CCCD, Ngày sinh $\rightarrow$ Trả về JSON điền tự động vào Form.
  5. Lễ tân chọn phòng thực tế và nhấn "Xác nhận Check-in".
  6. Servlet cập nhật đơn = `CHECKED_IN` và trạng thái phòng = `OCCUPIED`.

---

### UC13: Manage Walk-in & On-site Desk Booking
* **Thành viên phụ trách:** Thành viên 3 (Reception Desk)
* **Actor:** Receptionist
* **Mô tả:** Cho phép Lễ tân tạo đơn đặt phòng trực tiếp tại quầy cho Khách vãng lai (Walk-in Guests).
* **Luồng sự kiện (Main Flow):**
  1. Lễ tân mở trang `/reception/walk-in`. `WalkInController` tải danh sách các phòng còn trống.
  2. Lễ tân chọn phòng, nhập thời gian ở, thông tin khách hàng và hình thức thanh toán (Tiền mặt/POS).
  3. Lễ tân bấm "Xác nhận Đặt phòng & Check-in".
  4. Servlet khởi tạo đơn hàng mới, cập nhật trạng thái phòng = `OCCUPIED` và xuất phiếu thu.

---

### UC14: View Room Availability Matrix & Grid
* **Thành viên phụ trách:** Thành viên 3 (Reception Desk)
* **Actor:** Receptionist | **Dịch vụ phụ:** AJAX Polling
* **Mô tả:** Hiển thị Bảng ma trận trạng thái phòng thời gian thực (Trống, Đang có khách, Cần dọn dẹp, Bảo trì).
* **Luồng sự kiện (Main Flow):**
  1. Lễ tân truy cập `/reception/matrix`. `RoomMatrixController` truy vấn trạng thái phòng từ `RoomDAOImpl`.
  2. Forward sang `/WEB-INF/views/reception/room-matrix.jsp` hiển thị dạng lưới màu sắc.
  3. Lễ tân nhấp trực tiếp vào phòng để thao tác nhanh (Đổi phòng, đổi trạng thái vệ sinh).
  4. AJAX Polling tự động làm mới dữ liệu lưới phòng định kỳ.

---

### UC15: Process On-site Payment & Surcharges
* **Thành viên phụ trách:** Thành viên 3 (Reception Desk)
* **Actor:** Receptionist | **Dịch vụ phụ:** Thiết bị POS Interface
* **Mô tả:** Tính và thu các khoản phụ thu phát sinh tại chỗ (Check-in sớm, Check-out trễ, đồ uống minibar, hư hỏng đồ).
* **Luồng sự kiện (Main Flow):**
  1. Lễ tân mở chi tiết đơn đặt phòng của khách.
  2. Chọn "Thêm phụ thu", tích chọn dịch vụ/sản phẩm đã sử dụng.
  3. Hệ thống tính tự động tổng tiền phát sinh.
  4. Lễ tân chọn phương thức thu (Tiền mặt / Quẹt thẻ POS) và bấm "Xác nhận & In hóa đơn".
  5. `SurchargeController` lưu hóa đơn phụ thu vào DB.

---

### UC16: View Daily Guest List & Housekeeping Status
* **Thành viên phụ trách:** Thành viên 3 (Reception Desk)
* **Actor:** Receptionist | **Dịch vụ phụ:** Apache POI (Xuất file Excel)
* **Mô tả:** Báo cáo danh sách khách lưu trú trong ngày và phân công buồng phòng. Cho phép xuất file Excel báo cáo khai báo tạm trú.
* **Luồng sự kiện (Main Flow):**
  1. Lễ tân truy cập `/reception/daily-report`.
  2. `HousekeepingController` forward dữ liệu sang `/WEB-INF/views/reception/daily-report.jsp`.
  3. Bấm "Xuất file Excel Tạm trú": Servlet dùng **Apache POI** kết xuất danh sách khách ra file `.xlsx` cho máy khách tải xuống.
  4. Lễ tân cập nhật trạng thái dọn phòng (Clean & Ready) trực tiếp trên giao diện.

---

### UC17: Manage Homestay & Room Listings
* **Thành viên phụ trách:** Thành viên 4 (Owner Dashboard)
* **Actor:** Homestay Owner | **Dịch vụ phụ:** Cloudinary API, JSoup Sanitizer
* **Mô tả:** Quản lý thông tin Homestay, vị trí, tiện ích, cấu hình các Hạng phòng, giá niêm yết và đăng tải album ảnh HD.
* **Luồng sự kiện (Main Flow):**
  1. Chủ nhà vào trang `/owner/homestays`. Servlet forward `/WEB-INF/views/owner/homestay-form.jsp`.
  2. Chủ nhà nhập thông tin Homestay, địa chỉ, chọn tiện nghi và các Hạng phòng (Room Types).
  3. Upload bộ ảnh HD (Servlet tải trực tiếp ảnh lên Cloudinary).
  4. Chủ nhà nhấn "Lưu & Gửi phê duyệt". Servlet ghi bản ghi vào DB với trạng thái `PENDING_APPROVAL`.

---

### UC18: Manage Room Calendar & Dynamic Pricing Rules
* **Thành viên phụ trách:** Thành viên 4 (Owner Dashboard)
* **Actor:** Homestay Owner | **Dịch vụ phụ:** AJAX API
* **Mô tả:** Quản lý Lịch đặt phòng dạng Calendar, đóng/mở bán phòng và thiết lập Bảng giá linh hoạt theo ngày/mùa cao điểm.
* **Luồng sự kiện (Main Flow):**
  1. Chủ nhà mở `/owner/calendar`. `OwnerCalendarController` forward sang `/WEB-INF/views/owner/calendar.jsp` (Giao diện Lịch tháng).
  2. Chọn khoảng ngày trên lịch, điều chỉnh % tăng/giảm giá hoặc bật công tắc khóa phòng.
  3. Bấm "Cập nhật". AJAX gửi dữ liệu JSON đến `CalendarApiController`.
  4. Servlet thực thi cập nhật bảng `Dynamic_Prices` bằng `PreparedStatement` Batch.

---

### UC19: Manage Extra Add-on Services
* **Thành viên phụ trách:** Thành viên 4 (Owner Dashboard)
* **Actor:** Homestay Owner
* **Mô tả:** Cấu hình danh mục Dịch vụ bổ sung tại Homestay (Thuê xe, BBQ, ăn sáng...) kèm đơn giá và đơn vị tính.
* **Luồng sự kiện (Main Flow):**
  1. Chủ nhà truy cập `/owner/addons`. `OwnerAddonController` forward `/WEB-INF/views/owner/addons.jsp`.
  2. Bấm "Thêm dịch vụ mới", điền Tên, Mô tả, Giá tiền và Đơn vị tính.
  3. Nhấn "Lưu cấu hình". Servlet gọi `AddonDAOImpl.insertAddon()` ghi nhận vào CSDL.

---

### UC20: View Revenue & Occupancy Analytics
* **Thành viên phụ trách:** Thành viên 4 (Owner Dashboard)
* **Actor:** Homestay Owner | **Dịch vụ phụ:** Chart.js, Apache POI
* **Mô tả:** Báo cáo phân tích kinh doanh: Doanh thu, Tỷ lệ lấp đầy (Occupancy Rate %), Giá trung bình ngày (ADR) và xuất file báo cáo Excel.
* **Luồng sự kiện (Main Flow):**
  1. Chủ nhà mở `/owner/analytics`.
  2. `OwnerAnalyticsController` truy vấn tổng hợp dữ liệu từ `InvoiceDAOImpl` và `BookingDAOImpl`.
  3. Forward dữ liệu sang `/WEB-INF/views/owner/analytics.jsp`.
  4. Client dùng **Chart.js** vẽ biểu đồ tăng trưởng.
  5. Bấm "Tải file Excel": Servlet sử dụng **Apache POI** xuất báo cáo dạng file `.xlsx`.

---

### UC21: Manage Receptionist Staff Accounts
* **Thành viên phụ trách:** Thành viên 4 (Owner Dashboard)
* **Actor:** Homestay Owner | **Dịch vụ phụ:** JavaMail API (`EmailUtil`), BCrypt (`PasswordUtil`)
* **Mô tả:** Tạo tài khoản cho nhân viên Lễ tân, phân quyền quản lý cơ sở và gửi email kích hoạt tài khoản.
* **Luồng sự kiện (Main Flow):**
  1. Chủ nhà truy cập `/owner/staffs`. Servlet forward `/WEB-INF/views/owner/staff-list.jsp`.
  2. Bấm "Thêm Lễ tân", điền Email, Họ tên và chọn cơ sở phân công.
  3. Servlet mã hóa mật khẩu ngẫu nhiên bằng `PasswordUtil`, lưu tài khoản Role = `RECEPTIONIST` và gọi `EmailUtil` gửi thông tin đăng nhập đến email nhân viên.

---

### UC22: Manage Users & Account Permissions
* **Thành viên phụ trách:** Thành viên 5 (System Admin)
* **Actor:** Admin | **Dịch vụ phụ:** `AuthenticationFilter`
* **Mô tả:** Quản lý toàn bộ người dùng hệ thống, phân quyền (RBAC) và thực hiện Khóa / Mở khóa (Ban/Unban) tài khoản vi phạm.
* **Luồng sự kiện (Main Flow):**
  1. Admin mở `/admin/users`. `AdminUserController` truy vấn DB phân trang và forward sang `/WEB-INF/views/admin/user-list.jsp`.
  2. Admin chọn tài khoản cần xử lý và bấm "Khóa tài khoản" kèm lý do.
  3. Servlet cập nhật `IsActive = false` trong CSDL.
  4. `AuthenticationFilter` tự động chặn và vô hiệu hóa Session của người dùng bị khóa ở lần truy cập kế tiếp.

---

### UC23: Approve Homestay Registration Listings
* **Thành viên phụ trách:** Thành viên 5 (System Admin)
* **Actor:** Admin | **Dịch vụ phụ:** JavaMail API (`EmailUtil`)
* **Mô tả:** Đánh giá, phê duyệt hoặc từ chối hồ sơ đăng ký Homestay mới của Chủ nhà trước khi niêm yết lên hệ thống.
* **Luồng sự kiện (Main Flow):**
  1. Admin mở `/admin/approvals`. `AdminApprovalController` forward sang `/WEB-INF/views/admin/approval-list.jsp`.
  2. Admin kiểm tra chi tiết pháp lý, hình ảnh phòng và thông tin cơ sở.
  3. Bấm "Phê duyệt": Servlet chuyển trạng thái Homestay = `ACTIVE` và gửi Email thông báo tới Chủ nhà qua JavaMail API.
* **Luồng ngoại lệ (Exceptions):** Hồ sơ không hợp lệ $\rightarrow$ Admin chọn "Từ chối" kèm lý do, hệ thống gửi email phản hồi.

---

### UC24: System Configuration & AI Monitoring
* **Thành viên phụ trách:** Thành viên 5 (System Admin)
* **Actor:** Admin | **Dịch vụ phụ:** AI Engine Monitor, System Logs Engine
* **Mô tả:** Cấu hình tham số hệ thống (% phí hoa hồng, thời gian giữ phòng) và Giám sát chỉ số hiệu năng của mô hình AI Recommendation.
* **Luồng sự kiện (Main Flow):**
  1. Admin truy cập `/admin/config`. Servlet forward `/WEB-INF/views/admin/config.jsp`.
  2. Admin thay đổi tỷ lệ hoa hồng sàn và thông số kết nối Mail Server.
  3. Admin theo dõi độ chính xác (Precision/Latency) của AI Module và có thể kích hoạt nút "Huấn luyện lại AI (Trigger Retrain)".
  4. Bấm "Lưu cấu hình": Servlet cập nhật CSDL và ghi nhận vết thao tác tại `Audit_Logs`.

---

### UC25: View Platform Analytics & Financials
* **Thành viên phụ trách:** Thành viên 5 (System Admin)
* **Actor:** Admin | **Dịch vụ phụ:** Chart.js, Apache POI
* **Mô tả:** Báo cáo tài chính toàn sàn (GMV), Doanh thu hoa hồng thu được, Thống kê tăng trưởng người dùng và xuất file Excel đối soát.
* **Luồng sự kiện (Main Flow):**
  1. Admin mở `/admin/analytics`. `AdminAnalyticsController` tổng hợp số liệu toàn sàn từ các DAO.
  2. Forward dữ liệu sang `/WEB-INF/views/admin/analytics.jsp`.
  3. Client dùng **Chart.js** hiển thị biểu đồ doanh thu hoa hồng và bản đồ nhiệt booking.
  4. Nhấn "Xuất báo cáo tài chính": Servlet sử dụng **Apache POI** kết xuất file Excel `.xlsx`.

---

### UC26: Manage Platform Vouchers & Campaigns
* **Thành viên phụ trách:** Thành viên 5 (System Admin)
* **Actor:** Admin | **Dịch vụ phụ:** JavaMail API (`EmailUtil`)
* **Mô tả:** Tạo và quản lý các Chiến dịch Marketing Khuyến mãi cùng Mã giảm giá (Voucher) áp dụng toàn hệ thống do Sàn tài trợ.
* **Luồng sự kiện (Main Flow):**
  1. Admin truy cập `/admin/vouchers`. Servlet forward giao diện `/WEB-INF/views/admin/voucher-form.jsp`.
  2. Bấm "Tạo Voucher mới", nhập Mã (Code), % hoặc số tiền giảm, giá trị đơn tối thiểu, số lượng phát hành và hạn dùng.
  3. Tích chọn "Gửi thông báo Email cho toàn bộ khách hàng".
  4. Nhấn "Phát hành": Servlet ghi bản ghi vào CSDL `Vouchers` và gọi `EmailUtil` gửi email chiến dịch.

---

## 4. HƯỚNG DẪN TỔ CHỨC CẤU TRÚC CODE & TIÊU CHUẨN KỸ THUẬT

### Cấu trúc Thư mục Dự án Java Web JSP/Servlet (MVC Standard)
```text
src/main/java/
├── com.project.config/        # DB Connection Pool (HikariCP), MailConfig, Constants
├── com.project.controller/    # Servlet Controllers (HttpServlet)
│   ├── admin/                 # AdminUserController, AdminApprovalController, AdminAnalyticsController...
│   ├── customer/              # AuthController, SearchController, BookingController, ProfileController...
│   ├── owner/                 # OwnerHomestayController, OwnerCalendarController, OwnerAnalyticsController...
│   └── reception/             # ReceptionController, RoomMatrixController, HousekeepingController...
├── com.project.filter/        # Servlet Filters (EncodingFilter, AuthenticationFilter, CSRFFilter)
├── com.project.service/       # Business Logic Layer (Interfaces & Impl)
├── com.project.dao/           # Data Access Layer (JDBC + PreparedStatement)
├── com.project.model/         # JavaBeans / Entities (User, Homestay, Booking, Invoice...)
└── com.project.util/          # PasswordUtil (BCrypt), EmailUtil (JavaMail), PoiReportUtil (Excel)

src/main/webapp/
├── WEB-INF/views/             # Thư mục chứa toàn bộ JSP Views (Bảo mật tuyệt đối)
│   ├── admin/                 # user-list.jsp, approval-list.jsp, analytics.jsp...
│   ├── customer/              # home.jsp, login.jsp, search.jsp, detail.jsp, checkout.jsp...
│   ├── owner/                 # homestay-form.jsp, calendar.jsp, analytics.jsp...
│   ├── reception/             # checkin.jsp, room-matrix.jsp, daily-report.jsp...
│   └── common/                # header.jsp, footer.jsp, sidebar.jsp
└── assets/                    # Public Static Resources (CSS, JS, Images, Bootstrap 5, Chart.js)