package com.project.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Domain Entity: Room (Phòng vật lý cụ thể)
 * Package: com.project.model
 */
public class Room implements Serializable {

    private static final long serialVersionUID = 1L;

    public enum Status {
        AVAILABLE, OCCUPIED, DIRTY, MAINTENANCE
    }

    private int roomId;
    private int homestayId;
    private int roomTypeId;
    private String roomNumber;
    private Status status;
    private String notes;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Transient for UI
    private String roomTypeName;
    private BigDecimal basePrice;
    private String  currentGuestName;    // UC13 Room Matrix: tên khách đang ở (nếu OCCUPIED)
    private String  currentBookingCode;  // UC13 Room Matrix: mã booking hiện tại (nếu OCCUPIED)
    private Integer currentBookingId;    // UC12 Check-out: booking_id hiện tại để submit form checkout

    public Room() {
        this.status = Status.AVAILABLE;
    }

    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }

    public int getHomestayId() { return homestayId; }
    public void setHomestayId(int homestayId) { this.homestayId = homestayId; }

    public int getRoomTypeId() { return roomTypeId; }
    public void setRoomTypeId(int roomTypeId) { this.roomTypeId = roomTypeId; }

    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }

    public Status getStatus() { return status; }
    public void setStatus(Status status) { this.status = status; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public String getRoomTypeName() { return roomTypeName; }
    public void setRoomTypeName(String roomTypeName) { this.roomTypeName = roomTypeName; }

    public BigDecimal getBasePrice() { return basePrice; }
    public void setBasePrice(BigDecimal basePrice) { this.basePrice = basePrice; }

    public String getCurrentGuestName() { return currentGuestName; }
    public void setCurrentGuestName(String currentGuestName) { this.currentGuestName = currentGuestName; }

    public String getCurrentBookingCode() { return currentBookingCode; }
    public void setCurrentBookingCode(String currentBookingCode) { this.currentBookingCode = currentBookingCode; }

    public Integer getCurrentBookingId() { return currentBookingId; }
    public void setCurrentBookingId(Integer currentBookingId) { this.currentBookingId = currentBookingId; }
}
