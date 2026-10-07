-- ====================================================================================
-- contact_messages table + seed data cho admin quản lý đơn liên hệ
-- Chạy SAU schema.sql
-- ====================================================================================

CREATE TABLE IF NOT EXISTS contact_messages (
    message_id   INT AUTO_INCREMENT PRIMARY KEY,
    sender_name  VARCHAR(150) NOT NULL,
    sender_email VARCHAR(150) NOT NULL,
    sender_phone VARCHAR(20)  NULL,
    subject      VARCHAR(100) NOT NULL,
    message      TEXT         NOT NULL,
    is_resolved  BOOLEAN      NOT NULL DEFAULT FALSE COMMENT 'FALSE=Chưa xử lý, TRUE=Đã xử lý',
    resolved_by  INT          NULL COMMENT 'FK → users.user_id (admin đánh dấu)',
    resolved_at  TIMESTAMP    NULL,
    created_at   TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (resolved_by) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_contact_resolved (is_resolved),
    INDEX idx_contact_created  (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Seed data: các tin nhắn mẫu để test màn admin
INSERT INTO contact_messages (sender_name, sender_email, sender_phone, subject, message, is_resolved) VALUES
('Nguyễn Văn An',   'khanh.nguyen.customer@gmail.com', '0901111001',
 'Hỏi về chính sách hủy phòng',
 'Chào team Smart Booking, tôi muốn hỏi nếu tôi hủy đặt phòng trước 3 ngày thì có được hoàn tiền không? Booking code của tôi là BK-20261001-0001. Cảm ơn!',
 FALSE),

('Trần Hồng Linh',  'linh.tran.customer@gmail.com',  '0902222002',
 'Báo lỗi thanh toán VNPay',
 'Tôi vừa thanh toán qua VNPay nhưng tiền đã bị trừ mà booking vẫn đang ở trạng thái Chờ thanh toán. Vui lòng kiểm tra giúp tôi. Mã giao dịch: 14165857.',
 FALSE),

('Phạm Tiến Đức',   'duc.pham.customer@gmail.com',   '0904444004',
 'Yêu cầu xuất hóa đơn VAT',
 'Công ty tôi cần hóa đơn VAT cho chuyến công tác tại Đà Lạt. Booking BK-20261006-0013. Thông tin công ty: Công ty TNHH ABC, MST 0123456789. Liên hệ lại qua email này.',
 FALSE),

('Nguyễn Văn An',   'khanh.nguyen.customer@gmail.com', '0901111001',
 'Góp ý về ứng dụng',
 'Giao diện tìm kiếm rất đẹp và dễ dùng. Tuy nhiên tôi muốn đề xuất thêm tính năng so sánh 2-3 homestay cùng lúc để tiện lựa chọn hơn. Cảm ơn team đã làm ra sản phẩm tuyệt vời!',
 TRUE),

('Bùi Thị Hằng',    'hang.bui.customer@gmail.com',   '0907777007',
 'Không nhận được email xác nhận',
 'Tôi đã đặt phòng thành công và thanh toán xong nhưng không nhận được email xác nhận. Email của tôi là hang.bui.customer@gmail.com. Nhờ team gửi lại giúp tôi.',
 TRUE);
