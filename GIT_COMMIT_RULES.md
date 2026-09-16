# Smart Booking Platform - Git Commit & Workflow Rules

Tài liệu này quy định tiêu chuẩn commit, phân công tác giả và quy trình tạo nhánh / merge dành cho dự án **Hệ thống Đặt phòng Homestay & Hotel Thông minh (Smart Booking Platform)**.

---

## 1. Phân Công Thành Viên & Scope UC

| Thành viên | Tên đăng nhập / Mã SV | Email FPT | Scope Phụ Trách (Use Cases) |
| :--- | :--- | :--- | :--- |
| **Thành viên 1** | `tuantahe176408` | `tuantahe176408@fpt.edu.vn` | **UC12 - UC16**: Reception Desk (Check-in/out OCR, Walk-in, Room Matrix, On-site Payment, Housekeeping) |
| **Thành viên 2** | `sangnvhe171435` | `sangnvhe171435@fpt.edu.vn` | **UC07 - UC11**: Booking & Payments (Booking Add-ons, Payment Gateway, Refund, Reviews, Vouchers) |
| **Thành viên 3** | `binhtxghe171513` | `binhtxghe171513@fpt.edu.vn` | **UC01 - UC06**: Auth & Discovery (Login/Register, Profile, Search, Details, AI Recommend, Wishlist) |
| **Thành viên 4** | `khoandhe173573` | `khoandhe173573@fpt.edu.vn` | **UC17 - UC21**: Owner Dashboard (Homestay/Room Listing, Calendar/Pricing, Add-ons, Analytics, Staff Accounts) |
| **Thành viên 5** | `Thanhlthe171416` | `Thanhlthe171416@fpt.edu.vn` | **UC22 - UC26**: System Admin (Users/Permissions, Homestay Approvals, System/AI Config, Platform Analytics, Campaign Vouchers) |

---

## 2. Quy Tắc Cấu Hình Git Cá Nhân

Mỗi khi môi trường làm việc được khởi tạo hoặc khi AI / cá nhân thực hiện commit, thông tin `user.name` và `user.email` phải tương ứng với người phụ trách UC đó:

```bash
git config user.name "<username>"
git config user.email "<email>"
```

---

## 3. Quy Tắc Đặt Tên Nhánh (Branch Naming)

Mỗi lần phát triển tính năng mới hoặc sửa lỗi, **bắt buộc checkout ra nhánh riêng**:
- Feature: `feature/UC<Mã_UC>-<tên-tính-năng-ngắn>` (Ví dụ: `feature/UC01-google-auth`, `feature/UC07-room-booking`, `feature/UC12-ocr-checkin`)
- Bug fix: `fix/UC<Mã_UC>-<tên-lỗi-ngắn>` (Ví dụ: `fix/UC08-vnpay-checksum`)
- Maintenance / Config: `chore/<mô-tả>` hoặc `refactor/<mô-tả>`

---

## 4. Quy Tắc Soạn Nội Dung Commit (Conventional Commits)

Cấu trúc tin nhắn commit:
```text
<type>(<scope>): <mô tả ngắn bằng tiếng Việt hoặc tiếng Anh>
```

### Prefix `<type>` quy định:
- `feat`: Thêm tính năng mới hoặc tạo giao diện/controller mới.
- `fix`: Sửa lỗi logic, sửa lỗi giao diện hoặc lỗi kết nối.
- `docs`: Cập nhật tài liệu (`usecase.md`, `README.md`, `GIT_COMMIT_RULES.md`).
- `style`: Chỉnh sửa định dạng CSS/JSP không làm thay đổi logic code.
- `refactor`: Tối ưu hóa code DAO/Service/Servlet mà không đổi chức năng.
- `chore`: Cấu hình dự án (`web.xml`, dependencies, `.gitignore`, SQL script).

### Scope `<scope>` quy định:
- Mã Use Case tương ứng: `UC01` đến `UC26`.
- Scope hệ thống chung: `config`, `common`, `filter`, `db`.

---

## 5. Quy Trình Workflow 6 Bước (Checkout ➔ Dev ➔ Merge)

Mọi thao tác commit và merge phải làm đúng theo trình tự:

1. **Pull code mới nhất từ nhánh `main` / `dev`:**
   ```bash
   git checkout main
   git pull origin main
   ```
2. **Checkout nhánh mới cho Use Case:**
   ```bash
   git checkout -b feature/UC<Mã_UC>-<tên-ngắn>
   ```
3. **Thực hiện code và Commit tại nhánh riêng:**
   ```bash
   git add .
   git commit -m "<type>(<scope>): <nội dung commit>"
   ```
4. **Merge code `main` mới nhất vào nhánh cá nhân để thử nghiệm & giải quyết conflict trước:**
   ```bash
   git fetch origin
   git merge main
   ```
5. **Checkout về `main` và Merge nhánh tính năng vào `main`:**
   ```bash
   git checkout main
   git merge feature/UC<Mã_UC>-<tên-ngắn>
   git push origin main
   ```
6. **Xóa nhánh local sau khi đã merge thành công:**
   ```bash
   git branch -d feature/UC<Mã_UC>-<tên-ngắn>
   ```
