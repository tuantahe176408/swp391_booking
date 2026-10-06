package com.project.model;

import java.sql.Timestamp;

/**
 * DTO: Receptionist staff member with assigned homestay info.
 * Used in UC21 — Owner manages receptionist accounts.
 * Package: com.project.model
 */
public class StaffInfo {

    private int userId;
    private String fullName;
    private String email;
    private String avatarUrl;
    private boolean active;
    private boolean mustChangePassword;
    private Timestamp updatedAt;
    private Timestamp createdAt;
    private int homestayId;
    private String homestayName;

    public StaffInfo() {}

    // ── Getters / Setters ──────────────────────────────────────────────────

    public int getUserId()                    { return userId; }
    public void setUserId(int userId)         { this.userId = userId; }

    public String getFullName()               { return fullName; }
    public void setFullName(String fullName)  { this.fullName = fullName; }

    public String getEmail()                  { return email; }
    public void setEmail(String email)        { this.email = email; }

    public String getAvatarUrl()              { return avatarUrl; }
    public void setAvatarUrl(String url)      { this.avatarUrl = url; }

    public boolean isActive()                 { return active; }
    public void setActive(boolean active)     { this.active = active; }

    public boolean isMustChangePassword()                          { return mustChangePassword; }
    public void setMustChangePassword(boolean mustChangePassword)  { this.mustChangePassword = mustChangePassword; }

    public Timestamp getUpdatedAt()               { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public Timestamp getCreatedAt()               { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public int getHomestayId()                    { return homestayId; }
    public void setHomestayId(int homestayId)     { this.homestayId = homestayId; }

    public String getHomestayName()               { return homestayName; }
    public void setHomestayName(String name)      { this.homestayName = name; }

    /**
     * Convenience: derive the display status label.
     * "Hoạt động"     — active and has already changed their password
     * "Chờ kích hoạt" — active but has never logged in (must_change_password = true)
     * "Đã khoá"       — account locked by owner
     */
    public String getStatusLabel() {
        if (!active) return "Đã khoá";
        if (mustChangePassword) return "Chờ kích hoạt";
        return "Hoạt động";
    }
}
