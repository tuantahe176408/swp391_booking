package com.project.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Domain Entity: Contact / Support Message
 * Package: com.project.model
 */
public class ContactMessage implements Serializable {

    private static final long serialVersionUID = 1L;

    private int       messageId;
    private String    senderName;
    private String    senderEmail;
    private String    senderPhone;
    private String    subject;
    private String    message;
    private boolean   resolved;       // FALSE = Chưa xử lý, TRUE = Đã xử lý
    private Integer   resolvedBy;     // FK users.user_id (nullable)
    private Timestamp resolvedAt;
    private Timestamp createdAt;

    // Transient — tên admin đánh dấu xử lý (JOIN từ users)
    private String resolvedByName;

    public ContactMessage() {}

    // ── Getters & Setters ─────────────────────────────────────────────────

    public int getMessageId()                        { return messageId; }
    public void setMessageId(int messageId)          { this.messageId = messageId; }

    public String getSenderName()                    { return senderName; }
    public void setSenderName(String senderName)     { this.senderName = senderName; }

    public String getSenderEmail()                   { return senderEmail; }
    public void setSenderEmail(String senderEmail)   { this.senderEmail = senderEmail; }

    public String getSenderPhone()                   { return senderPhone; }
    public void setSenderPhone(String senderPhone)   { this.senderPhone = senderPhone; }

    public String getSubject()                       { return subject; }
    public void setSubject(String subject)           { this.subject = subject; }

    public String getMessage()                       { return message; }
    public void setMessage(String message)           { this.message = message; }

    public boolean isResolved()                      { return resolved; }
    public void setResolved(boolean resolved)        { this.resolved = resolved; }

    public Integer getResolvedBy()                   { return resolvedBy; }
    public void setResolvedBy(Integer resolvedBy)    { this.resolvedBy = resolvedBy; }

    public Timestamp getResolvedAt()                 { return resolvedAt; }
    public void setResolvedAt(Timestamp resolvedAt)  { this.resolvedAt = resolvedAt; }

    public Timestamp getCreatedAt()                  { return createdAt; }
    public void setCreatedAt(Timestamp createdAt)    { this.createdAt = createdAt; }

    public String getResolvedByName()                        { return resolvedByName; }
    public void setResolvedByName(String resolvedByName)     { this.resolvedByName = resolvedByName; }
}
