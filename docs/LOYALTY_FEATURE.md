# 🏆 Loyalty Points System — Tài liệu Tính năng

> **Dự án:** Smart Booking Platform (SWP391)  
> **Phiên bản:** 1.0  
> **Author:** binhtxghe171513 (TV3)  
> **Branch gốc:** `feature/UC-LOYALTY-loyalty-program`  
> **Merge commit:** `e8c5fbe`

---

## 1. Tổng quan

Hệ thống **Loyalty Points** cho phép khách hàng tích điểm thưởng mỗi khi đặt phòng thành công, sau đó dùng điểm để giảm giá cho các đơn tiếp theo. Điểm tích lũy còn quyết định **hạng thành viên** (tier) với nhân hệ số tích điểm ngày càng cao hơn.

---

## 2. Cấu trúc Database

### 2.1 Bảng mới: `loyalty_transactions`

| Cột | Kiểu | Mô tả |
|-----|------|-------|
| `transaction_id` | INT PK | Auto increment |
| `user_id` | INT FK | Liên kết `users.user_id` |
| `booking_id` | INT FK (nullable) | Liên kết `bookings.booking_id` |
| `points` | INT | **Dương** = tích, **Âm** = dùng |
| `transaction_type` | ENUM | `EARN` / `REDEEM` / `REFUND` / `ADJUSTMENT` |
| `description` | VARCHAR(255) | Mô tả giao dịch |
| `created_at` | TIMESTAMP | Thời gian giao dịch |

### 2.2 Cột thêm vào bảng `users`

| Cột | Kiểu | Mô tả |
|-----|------|-------|
| `loyalty_points_balance` | INT DEFAULT 0 | Điểm **hiện có**, có thể tiêu |
| `loyalty_total_earned` | INT DEFAULT 0 | Tổng điểm **tích lũy cả đời** (tính tier) |
| `loyalty_tier` | ENUM | `BRONZE` / `SILVER` / `GOLD` / `PLATINUM` |

> **Tại sao tách 2 trường balance và total_earned?**  
> `balance` giảm khi tiêu điểm, còn `total_earned` **không bao giờ giảm** — đảm bảo hạng chỉ lên không xuống dù khách tiêu hết điểm.

**Migration file:** `sql/alter_loyalty.sql`

---

## 3. Hạng Thành Viên (Tier)

Dựa trên `loyalty_total_earned` (điểm tích lũy cả đời):

| Hạng | Ngưỡng điểm | Nhân hệ số tích | Icon |
|------|------------|----------------|------|
| Bronze | 0 – 999 pts | ×1.0 | 🥉 |
| Silver | 1,000 – 4,999 pts | ×1.25 | 🥈 |
| Gold | 5,000 – 14,999 pts | ×1.5 | 🥇 |
| Platinum | 15,000+ pts | ×2.0 | 💎 |

---

## 4. Quy tắc Nghiệp vụ

### 4.1 Tích điểm (EARN)

```
base_points      = floor(final_total / 10,000)
points_earned    = floor(base_points × tier_multiplier)
```

- **Trigger:** booking chuyển sang `CONFIRMED` (payment success callback)
- **Ví dụ:** đơn 500,000₫, hạng Gold → `50 × 1.5 = 75 pts`
- Sau khi tích: cập nhật cả `balance` và `total_earned`, kiểm tra và nâng tier nếu đủ ngưỡng

### 4.2 Dùng điểm (REDEEM)

```
discount (₫) = points_to_redeem × 100
```

- **Điều kiện:** `balance ≥ 100 pts`
- **Tối thiểu:** 100 pts = 10,000₫ giảm giá
- **Tối đa:** 20% giá trị subtotal (phòng + addon), không vượt quá balance
- Có thể kết hợp cùng voucher
- Điểm bị trừ **ngay khi tạo booking PENDING** (trước khi thanh toán) → tránh double-use

### 4.3 Hoàn điểm (REFUND)

Điểm đã dùng được hoàn tự động trong 2 tình huống:

| Tình huống | Nơi xử lý |
|-----------|-----------|
| Khách tự hủy đơn | `CustomerBookingController.handleCancelBooking()` |
| Đơn hết hạn thanh toán (auto-cancel) | `BookingExpiryJob.run()` — refund trước, bulk-cancel sau |

---

## 5. Luồng hoàn chỉnh

```
[1] Khách vào trang Checkout
        ↓
[2] Chọn số điểm muốn dùng (nếu balance ≥ 100)
    → JS preview discount real-time
        ↓
[3] Submit form → BookingController.doPost()
    → Tạo booking PENDING
    → discountAmount = voucherDiscount + loyaltyDiscount
    → loyaltyDAO.redeemPoints()  ← balance giảm ngay
        ↓
[4] Redirect → /payment/create
        ↓
    ┌─────────────────────────────────────────────┐
    │ Payment SUCCESS (VNPay/MoMo callback)        │
    │  → updateBookingStatus → CONFIRMED           │
    │  → loyaltyDAO.earnPoints()  ← balance tăng  │
    │  → Gửi email xác nhận                       │
    └─────────────────────────────────────────────┘
    ┌─────────────────────────────────────────────┐
    │ Khách hủy / Hết hạn thanh toán              │
    │  → loyaltyDAO.refundRedeemedPoints()        │
    │  → balance hoàn lại                         │
    └─────────────────────────────────────────────┘
```

---

## 6. Files Triển Khai

### Files mới tạo

| File | Mô tả |
|------|-------|
| `sql/alter_loyalty.sql` | Migration: thêm cột users + tạo bảng loyalty_transactions |
| `model/LoyaltyTransaction.java` | Entity lịch sử điểm |
| `dao/LoyaltyDAO.java` | Interface + static utility methods (tính điểm, tier, max redeem) |
| `dao/LoyaltyDAOImpl.java` | JDBC implementation với lazy schema migration |
| `controller/customer/LoyaltyController.java` | Servlet `/customer/loyalty` |
| `web/WEB-INF/views/customer/loyalty.jsp` | Trang Điểm thưởng |

### Files đã chỉnh sửa

| File | Thay đổi |
|------|---------|
| `model/User.java` | Thêm 3 trường loyalty |
| `dao/UserDAOImpl.java` | Map loyalty columns (graceful fallback) |
| `dao/BookingDAO.java` | Thêm `getExpiredPendingBookingIds()` |
| `dao/BookingDAOImpl.java` | Implement `getExpiredPendingBookingIds()` |
| `controller/customer/PaymentController.java` | `earnPoints()` sau CONFIRMED (VNPay + MoMo) |
| `controller/customer/BookingController.java` | Đọc `loyaltyPointsToRedeem`, `redeemPoints()` |
| `controller/customer/CustomerBookingController.java` | `refundRedeemedPoints()` khi hủy |
| `controller/customer/ProfileController.java` | Load loyalty data vào session khi visit profile |
| `service/BookingExpiryJob.java` | Refund loyalty trước khi auto-cancel |
| `views/customer/checkout.jsp` | Section dùng điểm + loyalty discount row |
| `views/customer/profile.jsp` | Link Loyalty + tier icon trong sidebar |
| `views/common/navbar.jsp` | Tier badge + số điểm trong user dropdown |
| `web/WEB-INF/web.xml` | Bảo vệ `/customer/loyalty` bằng AuthFilter |

---

## 7. Giao diện Người dùng

### Trang `/customer/loyalty`
- **Hero card** màu gradient theo tier (đồng/bạc/vàng/tím)
- **Số điểm hiện có** (font lớn, nổi bật)
- **Progress bar** tiến độ lên hạng tiếp theo
- **Bảng lịch sử** giao dịch có phân trang (10 dòng/trang)
- **Bảng hạng thành viên** 4 ô hiển thị ngưỡng + hệ số
- **Hướng dẫn** cách tích và dùng điểm

### Trang Checkout (`/booking/checkout`)
- Section **"Điểm thưởng Loyalty"** hiển thị khi `balance ≥ 100 pts`
- Input nhập số điểm + nút Áp dụng
- Preview discount real-time (JavaScript)
- Dòng **"🌟 Điểm thưởng: −X₫"** trong Order Summary

### Navbar (user dropdown)
- Link **"Điểm thưởng"** chỉ hiện với role CUSTOMER
- Tier badge inline (🥉🥈🥇💎)
- Số điểm hiện tại

---

## 8. Hướng dẫn Deploy

```sql
-- Chạy migration trước khi deploy lần đầu
-- File: sql/alter_loyalty.sql

USE smart_booking_db;

ALTER TABLE users
    ADD COLUMN loyalty_points_balance INT NOT NULL DEFAULT 0,
    ADD COLUMN loyalty_total_earned   INT NOT NULL DEFAULT 0,
    ADD COLUMN loyalty_tier ENUM('BRONZE','SILVER','GOLD','PLATINUM') NOT NULL DEFAULT 'BRONZE';

CREATE TABLE IF NOT EXISTS loyalty_transactions ( ... );
```

> **Lưu ý:** Nếu DB đã có cột (chạy migration 2 lần) sẽ báo lỗi `Duplicate column name (1060)` — bỏ qua, không ảnh hưởng. `LoyaltyDAOImpl` lazy migration xử lý error code 1060 tự động nên app vẫn chạy bình thường.

---

## 9. Cấu hình có thể tùy chỉnh

Các hằng số nghiệp vụ nằm trong `LoyaltyDAO.java` (static methods):

| Thông số | Giá trị hiện tại | Chỉnh tại |
|----------|-----------------|-----------|
| Earn rate | 1 pt / 10,000₫ | `calculateEarnPoints()` |
| Redeem rate | 1 pt = 100₫ | `pointsToDiscount()` |
| Min redeem | 100 pts | `BookingController.doPost()` |
| Max redeem | 20% subtotal | `maxRedeemablePoints()` |
| Tier thresholds | 1K / 5K / 15K | `computeTier()` |
| Tier multipliers | 1.0 / 1.25 / 1.5 / 2.0 | `calculateEarnPoints()` |
