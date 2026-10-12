package com.project.dao;

import com.project.model.ContactMessage;
import java.util.List;
import java.util.Optional;

/**
 * DAO Interface: Contact Message Operations
 * Package: com.project.dao
 */
public interface ContactDAO {

    /** Lưu tin nhắn liên hệ mới từ khách hàng. */
    boolean insertMessage(ContactMessage msg);

    /**
     * Danh sách tin nhắn, filter theo resolved (null = tất cả) và keyword tìm kiếm, phân trang.
     * @param resolved null=tất cả, true=đã xử lý, false=chưa xử lý
     * @param keyword  tìm trên sender_name, sender_email, subject; null = không lọc
     */
    List<ContactMessage> getMessages(Boolean resolved, String keyword, int offset, int limit);

    /**
     * Đếm tổng tin nhắn theo filter (dùng cho pagination).
     * @param resolved null=tất cả, true=đã xử lý, false=chưa xử lý
     * @param keyword  tìm trên sender_name, sender_email, subject; null = không lọc
     */
    int countMessages(Boolean resolved, String keyword);

    /** Lấy chi tiết 1 tin nhắn. */
    Optional<ContactMessage> getMessageById(int messageId);

    /**
     * Đánh dấu xử lý / bỏ đánh dấu.
     * @param messageId ID tin nhắn
     * @param resolved  true = đã xử lý, false = chưa xử lý
     * @param adminId   ID admin thực hiện (lưu vào resolved_by)
     */
    boolean setResolved(int messageId, boolean resolved, int adminId);
}
