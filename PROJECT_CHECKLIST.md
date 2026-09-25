# SMART BOOKING PLATFORM - PROJECT IMPLEMENTATION CHECKLIST

> **Dự án:** Hệ thống Đặt phòng Homestay & Hotel Thông minh (SWP391)  
> **Kiến trúc:** NetBeans Java Web Servlet/JSP (MVC Pattern), Java 17, Tomcat 10, MySQL  
> **Phân công Use Cases:** 5 Thành viên, 26 Use Cases, 83 Tasks chi tiết.

---

## 👥 Bảng Phân Công Nhân Sự (Authors & Scope)

| Thành viên | Tên sinh viên | Email Git Commit | Scope Use Cases | Vai trò / Modules |
| :--- | :--- | :--- | :--- | :--- |
| **TV 1** | tuantahe176408 | `tuantahe176408@fpt.edu.vn` | **UC12 - UC16** | Receptionist (Check-in, Matrix, Housekeeping, Walk-in) |
| **TV 2** | sangnvhe171435 | `sangnvhe171435@fpt.edu.vn` | **UC07 - UC11** | Customer (Search, Homestay Detail, Booking, Payments) |
| **TV 3** | binhtxghe171513 | `binhtxghe171513@fpt.edu.vn` | **UC01 - UC06** | Customer (Auth, Login, OAuth2, Profile, Wishlist) |
| **TV 4** | khoandhe173573 | `khoandhe173573@fpt.edu.vn` | **UC17 - UC21** | Owner (Homestay CRUD, Room Matrix, Pricing, Calendar, Add-ons) |
| **TV 5** | Thanhlthe171416 | `Thanhlthe171416@fpt.edu.vn` | **UC22 - UC26** | Admin (User Management, Approval, Vouchers, Analytics, System Config) |

---

## 📋 Chi Tiết 83 Tasks & Danh Mục File Triển Khai

### Sheet 1: Nền tảng, Xác thực, Tìm kiếm & Quản trị (43 Tasks)

#### Nhóm 1: Common Pages & Layout (Sáng - UC03)
- [x] Trang chủ, Hero banner, Featured homestays (`HomeController.java`)
- [x] Form tìm kiếm nhanh (Điểm đến, Ngày đi/về, Số khách) (`home.jsp`)
- [x] Trang Giới thiệu dự án & nền tảng (`AboutController.java`, `about.jsp`)
- [x] Trang Liên hệ & Hỗ trợ khách hàng (`ContactController.java`, `contact.jsp`)

#### Nhóm 2: Authentication - Đăng ký (Bình - UC01)
- [x] Giao diện Form đăng ký tài khoản (`login.jsp`)
- [x] Tạo tài khoản mới trong Database (`UserDAO.java`, `UserDAOImpl.java`)
- [x] Validate trường bắt buộc (Email, Phone, Mật khẩu) (`User.java`)
- [x] Kiểm tra chống trùng lặp Email đăng ký (`GoogleAccountDTO.java`)
- [x] Mã hóa mật khẩu bảo mật BCrypt (`PasswordUtil.java`)

#### Nhóm 3: Authentication - Đăng nhập & OAuth2 (Bình - UC01)
- [x] Giao diện Form đăng nhập Email & Mật khẩu (`GoogleAuthUtil.java`)
- [x] Xác thực người dùng bằng Email/Password (`AuthController.java`)
- [x] Báo lỗi khi sai thông tin đăng nhập (`EncodingFilter.java`)
- [x] Điều hướng theo Role (Admin, Owner, Receptionist, Customer) (`navbar.jsp`)
- [x] Đăng nhập bằng Google OAuth 2.0 (`GoogleAuthController.java`)
- [x] Nhận Callback Google OAuth & Đăng nhập (`oauth.properties.example`)
- [x] Đăng xuất và hủy bỏ Session an toàn (`index.jsp`)

#### Nhóm 4: Bảo mật & Phân quyền Filter (Bình - UC02)
- [x] Chuyển hướng người dùng chưa đăng nhập (`AuthenticationFilter.java`)
- [x] Giới hạn quyền truy cập URL theo Role (`web.xml`)
- [x] Trả về HTTP 403 Forbidden khi truy cập trái phép (`footer.jsp`)
- [x] Làm sạch dữ liệu đầu vào chống XSS bằng JSoup (`JSoupUtil.java`)

#### Nhóm 5: Quản lý Thông tin cá nhân (Bình - UC02)
- [x] Hiển thị thông tin cá nhân khách hàng (`profile.jsp`)
- [x] Cập nhật Họ tên và Số điện thoại cá nhân (`ProfileController.java`)
- [x] Validate thông tin cập nhật hợp lệ (`DBContext.java`)
- [x] Làm mới dữ liệu Session sau khi cập nhật Profile (`GoogleAuthConfig.java`)

#### Nhóm 6: Đổi mật khẩu (Khoa - UC02)
- [x] Đổi mật khẩu với xác thực mật khẩu cũ và mã hóa BCrypt (`PasswordUtil.java`)

#### Nhóm 7: Admin - Quản lý Người dùng (Thành - UC22)
- [x] Danh sách người dùng (ID, Tên, Email, SĐT, Role, Status) (`AdminUserController.java`)
- [x] Badge hiển thị trạng thái phân quyền tài khoản (`user-list.jsp`)
- [x] Vô hiệu hóa tài khoản người dùng vi phạm (`sidebar-admin.jsp`)
- [x] Mở khóa tài khoản bị vô hiệu hóa (`analytics.jsp`)
- [x] Chống khóa nhầm tài khoản Quản trị viên tối cao (`approval-list.jsp`)

#### Nhóm 8: Tìm kiếm & Chi tiết Homestay (Sáng - UC03)
- [x] Tìm kiếm theo Điểm đến, Khoảng giá, Tiện ích (`HomestayDAO.java`, `HomestayDAOImpl.java`, `Homestay.java`)
- [x] Danh sách Homestay phân trang và lọc động (`SearchController.java`, `search.jsp`)
- [x] Chi tiết Homestay: Mô tả, Ảnh, Địa chỉ, Quy định (`HomestayImage.java`, `Amenity.java`, `Review.java`)
- [x] Chi tiết Phòng: Bảng giá, Sức chứa, Lịch trống trực tiếp (`RoomType.java`, `Room.java`, `RoomDAO.java`, `RoomDAOImpl.java`, `HomestayDetailController.java`, `detail.jsp`)

#### Nhóm 9: Gợi ý Thông minh & Danh sách Yêu thích (Bình - UC04, UC05)
- [x] Gợi ý Homestay theo địa điểm & hành vi (`RecommendationController.java`, `recommendations.jsp`)
- [x] Thuật toán xếp hạng gợi ý theo lượt đặt & đánh giá sao (`HomestayDAOImpl.java`)
- [x] Thêm Homestay vào Danh sách Yêu thích (`WishlistDAO.java`, `WishlistDAOImpl.java`, `WishlistController.java`)
- [x] Hiển thị danh sách Homestay đã lưu (`wishlist.jsp`)
- [x] Xóa Homestay khỏi danh sách yêu thích (`Wishlist.java`)

#### Nhóm 10: Chủ Homestay - Quản lý Danh sách Homestay (Khoa - UC17)
- [x] Bảng điều khiển danh sách Homestay thuộc quyền sở hữu (`OwnerHomestayController.java`, `owner-homestays.jsp`)
- [x] Form thêm Homestay mới (Tên, Địa chỉ, Tiện ích, Mô tả) (`homestay-form.jsp`)
- [x] Cập nhật thông tin Homestay hiện có (`OwnerHomestayController.java`)
- [x] Xóa Homestay khi không còn hoạt động (`OwnerHomestayController.java`)

---

### Sheet 2: Đặt phòng, Lễ tân, Quản trị nâng cao & Thanh toán (40 Tasks)

#### Nhóm 11: Chủ Homestay - Quản lý Phòng & Lịch Giá (Khoa - UC18, UC19)
- [x] Danh sách các phòng thuộc Homestay (`Room.java`)
- [x] Thêm loại phòng mới và thiết lập giá cơ bản (`RoomType.java`)
- [x] Cập nhật trạng thái phòng (Trống, Đang ở, Bảo trì) (`RoomDAOImpl.java`)
- [x] Xóa phòng khỏi hệ thống (`RoomDAOImpl.java`)
- [x] Xem Lịch đặt phòng trực quan (`OwnerCalendarController.java`, `calendar.jsp`)
- [x] Cập nhật giá phòng linh hoạt theo mùa/cuối tuần (`OwnerCalendarController.java`)

#### Nhóm 12: Chủ Homestay - Quản lý Dịch vụ Bổ sung & Nhân viên (Khoa - UC20, UC21)
- [x] Danh sách dịch vụ đi kèm (Đưa đón, Thuê xe, Ăn sáng...) (`Addon.java`, `AddonDAO.java`, `AddonDAOImpl.java`, `OwnerAddonController.java`, `addons.jsp`)
- [x] Thêm/Sửa/Xóa Dịch vụ bổ sung của Homestay (`OwnerAddonController.java`)
- [x] Quản lý tài khoản Lễ tân / Nhân viên phục vụ (`OwnerStaffController.java`, `staff-list.jsp`)

#### Nhóm 13: Lễ tân - Check-in & Quản lý Phòng (Tuấn - UC12, UC13)
- [x] Tìm kiếm đơn đặt phòng theo Mã Booking hoặc SĐT khách (`ReceptionCheckinController.java`, `checkin.jsp`)
- [x] Xác nhận Check-in và bàn giao chìa khóa phòng (`ReceptionCheckinController.java`)
- [x] Ma trận phòng trực quan (Room Matrix) thời gian thực (`RoomMatrixController.java`, `room-matrix.jsp`)
- [x] Đổi phòng nhanh cho khách khi có yêu cầu (`RoomMatrixController.java`)

#### Nhóm 14: Lễ tân - Buồng phòng & Khách vãng lai (Tuấn - UC14, UC15)
- [x] Cập nhật trạng thái dọn dẹp vệ sinh phòng (`HousekeepingController.java`, `housekeeping.jsp`)
- [x] Đánh dấu phòng sẵn sàng đón khách mới (`HousekeepingController.java`)
- [x] Đặt phòng trực tiếp cho khách vãng lai (Walk-in) (`WalkInController.java`, `walk-in.jsp`)

#### Nhóm 15: Admin - Duyệt Homestay & Mã Giảm Giá (Thành - UC23, UC24)
- [x] Danh sách Homestay đang chờ duyệt đăng kiểm (`AdminApprovalController.java`, `approval-list.jsp`)
- [x] Phê duyệt hoặc Từ chối kèm lý do (`AdminApprovalController.java`)
- [x] Danh sách Mã giảm giá Voucher khuyến mãi (`Voucher.java`, `VoucherDAO.java`, `VoucherDAOImpl.java`, `AdminVoucherController.java`, `vouchers.jsp`)
- [x] Tạo Voucher mới (Mã code, % giảm, Ngày hết hạn) (`voucher-form.jsp`)
- [x] Kích hoạt / Hủy kích hoạt Voucher (`AdminVoucherController.java`)

#### Nhóm 16: Admin - Báo cáo Thống kê & Phân tích (Thành - UC25, UC26)
- [x] Thống kê tổng doanh thu, số lượt đặt phòng (`AdminAnalyticsController.java`, `analytics.jsp`)
- [x] Biểu đồ phân tích doanh thu theo thời gian (`analytics.jsp`)
- [x] Quản lý cấu hình tham số hệ thống (`AdminConfigController.java`, `config.jsp`)

#### Nhóm 17: Khách hàng - Đặt phòng & Áp dụng Voucher (Sáng - UC07)
- [x] Giao diện Xác nhận Đặt phòng (Checkout) (`checkout.jsp`)
- [x] Chọn ngày Check-in, Check-out và Số lượng phòng (`BookingController.java`)
- [x] Chọn các Dịch vụ bổ sung đi kèm đơn đặt (`BookingAddon.java`)
- [x] Kiểm tra và Áp dụng Mã giảm giá Voucher (`VoucherDAOImpl.java`)
- [x] Tính toán Tổng tiền chính xác (`BookingService.java`)
- [x] Khóa phòng tạm thời và Lưu bản ghi Booking PENDING (`BookingDAO.java`, `BookingDAOImpl.java`, `Booking.java`)

#### Nhóm 18: Khách hàng - Quản lý Đơn đặt phòng (Sáng - UC09)
- [x] Danh sách lịch sử đặt phòng của khách hàng (`CustomerBookingController.java`, `booking-list.jsp`)
- [x] Xem chi tiết hóa đơn và trạng thái phòng (`CustomerBookingController.java`)
- [x] Hủy đơn đặt phòng theo chính sách hoàn tiền (`CustomerBookingController.java`)

#### Nhóm 19: Thanh toán Cổng trực tuyến (Sáng - UC08)
- [x] Tạo yêu cầu thanh toán VNPay / MoMo kèm SHA-512 HMAC (`PaymentController.java`, `PaymentUtil.java`)
- [x] Chuyển hướng an toàn sang Cổng thanh toán (`PaymentController.java`)

#### Nhóm 20: Xử lý Kết quả Thanh toán & IPN (Sáng - UC10)
- [x] Tiếp nhận Callback phản hồi từ Cổng thanh toán (`PaymentGatewayUtil.java`)
- [x] Xác thực chữ ký HMAC-SHA512 chống giả mạo dữ liệu (`voucher-form.jsp`)
- [x] Cập nhật trạng thái Giao dịch thành công / thất bại (`config.jsp`)
- [x] Tự động cập nhật Booking sang CONFIRMED (`daily-report.jsp`)

#### Nhóm 21: Kết quả Thanh toán & Hóa đơn Điện tử (Khoa - UC10, UC11)
- [x] Giao diện thông báo Kết quả thanh toán và Mã QR (`payment-result.jsp`)
- [x] Lịch sử các giao dịch thanh toán (`payment-history.jsp`)
- [x] Gửi Email xác nhận đặt phòng và Vé điện tử (`walk-in.jsp`, `EmailUtil.java`)

#### Nhóm 22: Kiểm thử Tự động Hệ thống (Khoa - UC26)
- [x] Test tự động luồng Đặt phòng thông suốt (`IntegrationTestController.java`)
- [x] Test tự động phát hiện xung đột trùng lặp phòng (`integration-tests.jsp`)
- [x] Test tự động chữ ký bảo mật Cổng thanh toán (`PROJECT_CHECKLIST.md`)

---

## 🔑 Tài Khoản Thử Nghiệm Mặc Định (Seed Test Data)

| Phân quyền (Role) | Email đăng nhập | Mật khẩu mặc định | Ghi chú |
| :--- | :--- | :--- | :--- |
| **Quản trị viên (ADMIN)** | `admin@smartbooking.com` | `Admin@123456` | Toàn quyền kiểm duyệt, phân tích, voucher |
| **Chủ nhà (OWNER)** | `owner@smartbooking.com` | `Owner@123456` | Quản lý Homestay, phòng, giá và lịch |
| **Lễ tân (RECEPTIONIST)** | `reception@smartbooking.com` | `Reception@123` | Check-in, Room Matrix, buồng phòng |
| **Khách hàng (CUSTOMER)** | `customer@smartbooking.com` | `Customer@123` | Tìm kiếm, đặt phòng, thanh toán trực tuyến |
