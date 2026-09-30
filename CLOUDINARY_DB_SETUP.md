# Tích hợp Cloudinary & Cloud MySQL — Smart Booking Platform

## 1. Tổng quan các file đã thay đổi

| File | Loại | Mô tả |
|---|---|---|
| `src/java/application.properties` | Tạo mới | Cấu hình tập trung toàn bộ (DB, Cloudinary, Mail, OAuth) - gitignored |
| `application.properties.example` | Tạo mới | File template mẫu đẩy lên Git |
| `src/java/com/project/util/CloudinaryUtil.java` | Sửa | Nạp credentials từ application.properties |
| `src/java/com/project/config/DBContext.java` | Sửa | Hỗ trợ SSL + đọc application.properties |
| `src/java/com/project/config/MailConfig.java` | Sửa | Đọc SMTP từ application.properties |
| `src/java/com/project/config/GoogleAuthConfig.java` | Sửa | Đọc Google OAuth từ application.properties |
| `src/java/com/project/dao/HomestayDAO.java` | Sửa | + 4 methods write cho homestay_images |
| `src/java/com/project/dao/HomestayDAOImpl.java` | Sửa | Implement 4 methods: insert/delete/setPrimary/getById |
| `src/java/com/project/controller/owner/OwnerHomestayEditController.java` | Sửa | `@MultipartConfig`, upload ảnh homestay, delete/set-primary |
| `src/java/com/project/controller/customer/ProfileController.java` | Sửa | `@MultipartConfig`, upload avatar |
| `web/WEB-INF/views/owner/homestay-edit.jsp` | Sửa | Image gallery + upload form + preview JS |
| `web/WEB-INF/views/customer/profile.jsp` | Sửa | File upload + live preview + URL fallback |
| `.gitignore` | Sửa | Thêm `application.properties`, bỏ qua các file properties bảo mật |

---

## 2. Cloudinary (Ảnh)

### Thông tin tài khoản đã cấu hình
```
Cloud Name : lzicu3hd
API Key    : 756824114576659
API Secret : đã điền trong cloudinary.properties
```

### File cấu hình — `src/java/cloudinary.properties`
```properties
CLOUDINARY_CLOUD_NAME=lzicu3hd
CLOUDINARY_API_KEY=756824114576659
CLOUDINARY_API_SECRET=hIdSxfZL2A3wiXQQTPUpq_6Y-HI
```

### Luồng hoạt động
```
User chọn file  →  <input type="file" name="avatarFile">
      ↓
Servlet doPost  →  request.getPart("avatarFile")
      ↓
CloudinaryUtil.uploadImage(inputStream, filename, "avatars")
      →  POST https://api.cloudinary.com/v1_1/lzicu3hd/image/upload
      ↓
Nhận secure_url  →  lưu vào DB (users.avatar_url / homestay_images.image_url)
```

### Folders trên Cloudinary
| Folder | Dùng cho |
|---|---|
| `avatars/` | Avatar người dùng (`ProfileController`) |
| `homestays/{ownerId}/` | Ảnh homestay (`OwnerHomestayEditController`) |

### Giới hạn file
- Mỗi ảnh avatar: tối đa **5 MB**
- Mỗi ảnh homestay: tối đa **10 MB**
- Tổng 1 request homestay: tối đa **60 MB** (6 ảnh)

---

## 3. Cloud MySQL — TiDB Serverless (Khuyến nghị free)

### Tại sao TiDB Serverless?
| Tiêu chí | TiDB Serverless |
|---|---|
| Giá | **Free forever** |
| Storage | **5 GB** |
| Throughput | 50 triệu row units/tháng |
| MySQL compat | **8.0 — dùng JDBC hiện tại ngay** |
| SSL | Bắt buộc (bảo mật tốt) |
| Region | Singapore (gần VN nhất) |

### Bước 1 — Tạo cluster (5 phút)

1. Truy cập **[tidbcloud.com](https://tidbcloud.com)** → Sign up bằng Google/GitHub
2. Click **Create Cluster** → chọn **Serverless** (free)
3. Region: **AWS / Singapore (ap-southeast-1)**
4. Đặt tên cluster: `smart-booking-db` → **Create**
5. Đợi ~30 giây để cluster khởi động

### Bước 2 — Lấy Connection String

```
Cluster → Connect → chọn tab "General"
```

Copy các thông tin:
```
Host    : gateway01.ap-southeast-1.prod.aws.tidbcloud.com
Port    : 4000
User    : <your_prefix>.root
Password: <generated_password>
```

### Bước 3 — Import Schema vào TiDB

**Cách A — MySQL CLI (nếu có mysql-client):**
```bash
mysql -h gateway01.ap-southeast-1.prod.aws.tidbcloud.com \
      -P 4000 \
      -u <user> -p \
      --ssl-mode=REQUIRED \
      smart_booking_db < schema.sql
```

**Cách B — TiDB Cloud Console:**
- Cluster → **SQL Editor** → paste nội dung `schema.sql` → Run

**Cách C — DBeaver / TablePlus / MySQL Workbench:**
- Tạo connection mới với SSL enabled
- Mở `schema.sql` → Execute All

### Bước 4 — Điền vào `src/java/db.properties`

```properties
DB_HOST=gateway01.ap-southeast-1.prod.aws.tidbcloud.com
DB_PORT=4000
DB_NAME=smart_booking_db
DB_USER=xxxxxxxx.root
DB_PASS=your_generated_password
DB_SSL=true
```

> ⚠️ `DB_SSL=true` là bắt buộc với TiDB — nếu để `false` sẽ bị từ chối kết nối.

---

## 4. So sánh tất cả dịch vụ MySQL free

| Dịch vụ | Storage | Thời hạn | SSL | Ghi chú |
|---|---|---|---|---|
| **TiDB Serverless** ⭐ | 5 GB | Vĩnh viễn | Bắt buộc | MySQL 8.0 compat, khuyến nghị |
| **PlanetScale** | 5 GB | Vĩnh viễn | Bắt buộc | Không hỗ trợ FK constraints |
| **Railway** | 1 GB | $5 credit/tháng | Optional | Hết credit = bị xóa |
| **Clever Cloud** | 256 MB | Vĩnh viễn | Optional | Quá nhỏ cho project này |
| **Freemysqlhosting** | 5 MB | Vĩnh viễn | Không | Không đủ dùng |

---

## 5. Cấu hình DBContext.java — 3 tầng ưu tiên

```
Priority 1 (cao nhất) : Environment Variables
                         DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASS, DB_SSL

Priority 2             : src/java/db.properties (vào classpath khi build)

Priority 3 (mặc định) : localhost:3306 / root / 123456 / SSL=false
```

### Local dev — không cần thay đổi gì
```properties
# db.properties (local)
DB_HOST=localhost
DB_PORT=3306
DB_NAME=smart_booking_db
DB_USER=root
DB_PASS=123456
DB_SSL=false
```

### Cloud deploy
```properties
# db.properties (cloud)
DB_HOST=gateway01.ap-southeast-1.prod.aws.tidbcloud.com
DB_PORT=4000
DB_NAME=smart_booking_db
DB_USER=xxxxxxxx.root
DB_PASS=your_password
DB_SSL=true
```

---

## 6. Checklist kiểm tra sau khi deploy

### Cloudinary
- [ ] `/customer/profile` → chọn file ảnh → Save → avatar hiển thị từ `res.cloudinary.com/lzicu3hd/...`
- [ ] `/owner/homestays/new` → điền form + chọn ảnh → Save → ảnh xuất hiện trong gallery
- [ ] `/owner/homestays/edit?id=X` → nút Xóa ảnh → ảnh biến mất khỏi Cloudinary + DB
- [ ] Ảnh đại diện (⭐) hiển thị đúng badge `Chính`

### Database
- [ ] Đăng nhập → session hoạt động bình thường
- [ ] Tìm kiếm homestay → kết quả trả về đúng
- [ ] Tạo booking → lưu thành công vào DB
- [ ] Console TiDB hiển thị số row tăng lên

---

## 7. Bảo mật — QUAN TRỌNG

> ### ⛔ TUYỆT ĐỐI KHÔNG commit `cloudinary.properties` và `db.properties` lên Git!
> Cả hai đã được thêm vào `.gitignore` — nhưng nếu đã lỡ add trước đó, phải untrack:

```bash
git rm --cached src/java/cloudinary.properties
git rm --cached src/java/db.properties
git commit -m "chore(config): untrack secret config files"
```

### Cho production server — dùng Environment Variables thay file

```bash
# Trên server (Linux/Tomcat)
export CLOUDINARY_CLOUD_NAME=lzicu3hd
export CLOUDINARY_API_KEY=756824114576659
export CLOUDINARY_API_SECRET=hIdSxfZL2A3wiXQQTPUpq_6Y-HI

export DB_HOST=gateway01.ap-southeast-1.prod.aws.tidbcloud.com
export DB_PORT=4000
export DB_NAME=smart_booking_db
export DB_USER=xxxxxxxx.root
export DB_PASS=your_password
export DB_SSL=true
```
