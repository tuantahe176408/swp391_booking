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

#### Nhóm 6: Đổi mật khẩu & Quên mật khẩu (Bình - UC02)
- [x] Đổi mật khẩu với xác thực mật khẩu cũ và mã hóa BCrypt (`PasswordUtil.java`)
- [x] **[MỚI]** Quên mật khẩu — gửi OTP qua Email (`EmailUtil.java`, `user_otps` table)
- [x] Xác thực OTP 6 số, hết hạn sau 10 phút
- [x] Đặt mật khẩu mới, hash BCrypt, update DB
- [x] Redirect về login với flash success sau khi reset thành công

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
- [x] Bảng điều khiển danh sách Homestay thuộc quyền sở hữu — **thật từ DB** (`OwnerHomestayController.java`, `homestay-form.jsp`)
- [x] Stats cards: tổng cơ sở, đang hoạt động, chờ duyệt, tổng phòng từ DB
- [x] Filter tab client-side theo status (Tất cả / Hoạt động / Chờ duyệt / Từ chối / Tạm ngừng)
- [x] Alert cảnh báo khi có cơ sở bị từ chối kèm lý do inline
- [x] Form đăng ký Homestay mới → INSERT DB → status PENDING_APPROVAL (`OwnerHomestayEditController.java`, `homestay-edit.jsp`)
- [x] Form chỉnh sửa Homestay (tên, mô tả, địa chỉ, giờ check-in/out) → UPDATE DB
- [x] Tự động reset REJECTED → PENDING_APPROVAL khi owner lưu lại
- [x] Tạm ngừng / Kích hoạt lại cơ sở (ACTIVE ↔ INACTIVE) với confirm dialog
- [x] Ẩn action Quản lý phòng & Lịch giá cho cơ sở chưa được duyệt
- [x] Flash message sau mỗi thao tác (thành công / thất bại)
- [x] Seed data: 3 homestay PENDING/REJECTED/INACTIVE cho owner nguyenvana (`seed_owner_homestays.sql`)

---

### Sheet 2: Đặt phòng, Lễ tân, Quản trị nâng cao & Thanh toán (40 Tasks)

#### Nhóm 11: Chủ Homestay - Quản lý Phòng & Lịch Giá (Khoa - UC18, UC19)
- [x] Trang Quản lý Loại phòng & Phòng vật lý — **thật từ DB** (`OwnerRoomController.java`, `rooms.jsp`)
- [x] Thêm / Sửa / Xóa loại phòng (tên, giá, sức chứa, số giường, diện tích) với ownership check
- [x] Chặn xóa loại phòng khi còn booking active
- [x] Thêm / Xóa phòng vật lý (số phòng tự động uppercase)
- [x] Room cards bắt mắt: màu header theo status, icon đặc trưng mỗi trạng thái
- [x] Đổi trạng thái phòng AVAILABLE ↔ MAINTENANCE ↔ DIRTY qua dropdown inline
- [x] Phòng OCCUPIED: khóa toàn bộ action (do booking system quản lý)
- [x] Accordion expand/collapse per room type, stopPropagation chính xác
- [x] Stats: loại phòng / trống / có khách / tổng phòng từ DB (`fn:length`)
- [x] Fix Room model & RoomDAOImpl khớp schema (bỏ homestay_id, notes không có trong DB)
- [x] Fix Room.Status enum thêm DIRTY khớp DB ENUM
- [x] Xem Lịch đặt phòng trực quan — **thật từ DB** (`OwnerCalendarController.java`, `calendar.jsp`)
- [x] Calendar render đúng offset thứ trong tuần, CSS Grid 7 cột
- [x] Homestay & Room type selector tabs pill style gradient
- [x] Day modal: 3 loại điều chỉnh (hệ số % / giá cố định / khóa phòng)
- [x] Bulk apply: chọn nhiều ngày + quick-select T7/CN, apply cho nhiều loại phòng
- [x] Prev/Next month navigation, giữ homestayId
- [x] Logic phân biệt giá thật (mult ≠ 1.0) vs giá gốc bằng `isRealPriceRule()`
- [x] Seed dynamic_prices tháng 9–10/2026 (`seed_dynamic_prices.sql`)
- [x] Model DynamicPrice + CalendarDAO/Impl (upsert, delete, bulkUpsert)

#### Nhóm 12: Chủ Homestay - Quản lý Dịch vụ Bổ sung, Đơn đặt phòng & Nhân viên (Khoa - UC20, UC21)
- [x] Danh sách dịch vụ đi kèm (Đưa đón, Thuê xe, Ăn sáng...) (`Addon.java`, `AddonDAO.java`, `AddonDAOImpl.java`, `OwnerAddonController.java`, `addons.jsp`)
- [x] Thêm/Sửa/Xóa Dịch vụ bổ sung của Homestay (`OwnerAddonController.java`)
- [x] Quản lý tài khoản Lễ tân / Nhân viên phục vụ (`OwnerStaffController.java`, `staff-list.jsp`)
- [x] **[MỚI]** Trang Đơn đặt phòng — **thật từ DB** (`OwnerBookingController.java`, `booking-list.jsp`)
- [x] Filter theo cơ sở, trạng thái, khoảng ngày check-in với pagination
- [x] BookingDAO mở rộng: `getBookingsByOwner()` + `countBookingsByOwner()` với dynamic WHERE
- [x] **[MỚI]** Trang Doanh thu & Thống kê — KPI cards, charts (analytics.jsp)
- [x] Filter theo homestay + tháng cập nhật KPI + chart realtime (JS mock data)
- [x] Switch chart Đường/Cột, Donut kênh đặt phòng
- [x] Bảng đơn đặt phòng gần đây với link "Xem tất cả" → `/owner/bookings`

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

#### Nhóm 23: Khách hàng - Đánh giá & Xếp hạng Homestay (Sáng - UC10) ✨ **[MỚI]**
- [x] Interface, DAO, Controller đánh giá từ đầu (`ReviewDAO.java`, `ReviewDAOImpl.java`, `ReviewController.java`)
- [x] Form đánh giá 4 tiêu chí (Vệ sinh, Dịch vụ, Vị trí, Giá trị) với star widget JS-driven (`review-form.jsp`)
- [x] Tính điểm tổng thể tự động = trung bình 4 tiêu chí (làm tròn 2 chữ số thập phân)
- [x] Sanitize nội dung comment chống XSS bằng JSoup (`JSoupUtil.sanitizeText`)
- [x] INSERT review + UPDATE `rating_avg` / `review_count` trên `homestays` trong cùng 1 transaction
- [x] Guard chống duplicate: 1 booking chỉ được review 1 lần (UNIQUE constraint DB + `hasReviewed()` check)
- [x] Chỉ cho phép đánh giá booking có status `CHECKED_OUT` (validate cả GET lẫn POST)
- [x] **Edit review**: customer có thể sửa đánh giá đã gửi — `updateReview()` transaction + recalc rating_avg
- [x] Form tự detect create vs edit mode dựa theo `reviewId` (`editMode`, tiêu đề động, nút "Gửi" / "Lưu thay đổi")
- [x] Nút **⭐ Viết đánh giá** trong booking-list cho CHECKED_OUT chưa review
- [x] Nút **✏️ Sửa đánh giá** + badge **✅ Đã đánh giá** trong booking-list cho đã review
- [x] Section review đầy đủ trong booking-detail: 4 tiêu chí dạng grid, điểm tổng, comment, phản hồi owner
- [x] Nút **Sửa đánh giá** trong booking-detail (outline-primary)
- [x] Section "Đánh giá từ khách hàng" trên trang detail homestay: header tổng quan điểm + từng review card
- [x] Render half-star (⯨) chính xác bằng JSTL math (`ratingOverall mod 1 >= 0.3`)
- [x] Load-more "Xem thêm đánh giá": hiển thị 5 review đầu, bấm load thêm 5 mỗi lần, fade-in animation
- [x] web.xml: bảo vệ `/customer/review` bằng `AuthenticationFilter`
- [x] Seed data test UC10: 3 booking CHECKED_OUT chưa review (`seed_review_test.sql`)

---

## 🔑 Tài Khoản Thử Nghiệm Mặc Định (Seed Test Data)

| Phân quyền (Role) | Email đăng nhập | Mật khẩu | Ghi chú |
| :--- | :--- | :--- | :--- |
| **Admin** | `admin@smartbooking.com` | `Admin@123` | Toàn quyền kiểm duyệt, phân tích, voucher |
| **Owner** | `nguyenvana.owner@gmail.com` | `Admin@123` | Đà Lạt — 2 ACTIVE + 3 test (PENDING/REJECTED/INACTIVE) |
| **Owner** | `tranminhb.owner@gmail.com` | `Admin@123` | Hội An — 2 homestay ACTIVE |
| **Owner** | `lethicam.owner@gmail.com` | `Admin@123` | Phú Quốc — 2 homestay ACTIVE |
| **Owner** | `phamquocd.owner@gmail.com` | `Admin@123` | Hà Nội — 2 homestay ACTIVE |
| **Owner** | `hoangmine.owner@gmail.com` | `Admin@123` | Nha Trang — 2 homestay ACTIVE |
| **Customer** | `khanh.nguyen.customer@gmail.com` | `Admin@123` | Có lịch sử đặt phòng |
| **Customer** | `linh.tran.customer@gmail.com` | `Admin@123` | Có lịch sử đặt phòng |
| **Customer** | `duc.pham.customer@gmail.com` | `Admin@123` | LOCAL auth |

> ⚠️ Password hash trong seed: `$2a$12$LQv3c1yqBWVHxkd0LlHdEOuPiXL4Z9TqBHC3Ot5OqJQ.PmZeaVM2` = `Admin@123`

---

## 🎨 UI/UX Owner Dashboard — Đã Triển Khai

### Layout & Common Fragments
- [x] `owner-shell` layout: dark sidebar 260px fixed + `owner-main` scrollable
- [x] `sidebar-owner.jsp`: brand, profile pill, nav groups, footer links
- [x] `owner-topbar.jsp`: breadcrumb 2 cấp, heading, notification bell, user dropdown
- [x] CSS BEM `.owner-sidebar__*`, `.owner-topbar__*`, `.owner-content`, `.owner-card`
- [x] Responsive collapse sidebar < 992px
- [x] Ẩn customer navbar & footer khi ở owner pages (`body.owner-page`)
- [x] Dropdown user hoạt động (custom JS, không dùng Bootstrap JS)

### Trang Giới thiệu (About)
- [x] Bỏ section Tech Stack & Team thành viên
- [x] Thay bằng nội dung business: cam kết, stats thật, features

### Owner Pages Status
| Trang | URL | Dữ liệu | Ghi chú |
|---|---|---|---|
| Cơ sở Homestay | `/owner/homestays` | ✅ Thật | CRUD đầy đủ |
| Chỉnh sửa Homestay | `/owner/homestays/edit` | ✅ Thật | INSERT + UPDATE |
| Quản lý Phòng | `/owner/rooms` | ✅ Thật | Room type + physical rooms |
| Lịch & Giá | `/owner/calendar` | ✅ Thật | Dynamic pricing từ DB |
| Đơn đặt phòng | `/owner/bookings` | ✅ Thật | Filter + pagination |
| Doanh thu | `/owner/analytics` | ⚠️ Mock JS | KPI + chart = mock data |
| Dịch vụ bổ sung | `/owner/addons` | ⚠️ Mock | Chưa connect DB |
| Nhân viên Lễ tân | `/owner/staffs` | ⚠️ Mock | Chưa connect DB |
