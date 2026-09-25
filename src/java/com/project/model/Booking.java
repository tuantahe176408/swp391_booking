package com.project.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

/**
 * Domain Entity: Booking (UC07, UC09, UC12, UC13)
 * Package: com.project.model
 */
public class Booking implements Serializable {

    private static final long serialVersionUID = 1L;

    public enum Status {
        PENDING, CONFIRMED, CHECKED_IN, CHECKED_OUT, CANCELLED, REFUNDED
    }

    public enum BookingType {
        ONLINE, WALK_IN
    }

    private int bookingId;
    private String bookingCode;
    private Integer customerId;
    private int homestayId;
    private int roomTypeId;
    private Integer assignedRoomId;
    private String guestName;
    private String guestEmail;
    private String guestPhone;
    private String guestIdCardNumber;
    private Date checkinDate;
    private Date checkoutDate;
    private int totalNights;
    private BigDecimal roomPriceTotal;
    private BigDecimal addonPriceTotal;
    private BigDecimal surchargeTotal;
    private Integer voucherId;
    private BigDecimal discountAmount;
    private BigDecimal finalTotal;
    private String bookingType;
    private String bookingStatus;
    private Timestamp holdExpiresAt;
    private Integer receptionistId;
    private String cancellationReason;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Transient attributes for UI presentation
    private String homestayName;
    private String homestayAddress;
    private String homestayCity;
    private String homestayImageUrl;
    private String roomTypeName;

    public Booking() {
        this.roomPriceTotal = BigDecimal.ZERO;
        this.addonPriceTotal = BigDecimal.ZERO;
        this.surchargeTotal = BigDecimal.ZERO;
        this.discountAmount = BigDecimal.ZERO;
        this.finalTotal = BigDecimal.ZERO;
        this.bookingType = "ONLINE";
        this.bookingStatus = "PENDING";
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public String getBookingCode() {
        return bookingCode;
    }

    public void setBookingCode(String bookingCode) {
        this.bookingCode = bookingCode;
    }

    public Integer getCustomerId() {
        return customerId;
    }

    public void setCustomerId(Integer customerId) {
        this.customerId = customerId;
    }

    public int getHomestayId() {
        return homestayId;
    }

    public void setHomestayId(int homestayId) {
        this.homestayId = homestayId;
    }

    public int getRoomTypeId() {
        return roomTypeId;
    }

    public void setRoomTypeId(int roomTypeId) {
        this.roomTypeId = roomTypeId;
    }

    public Integer getAssignedRoomId() {
        return assignedRoomId;
    }

    public void setAssignedRoomId(Integer assignedRoomId) {
        this.assignedRoomId = assignedRoomId;
    }

    public String getGuestName() {
        return guestName;
    }

    public void setGuestName(String guestName) {
        this.guestName = guestName;
    }

    public String getGuestEmail() {
        return guestEmail;
    }

    public void setGuestEmail(String guestEmail) {
        this.guestEmail = guestEmail;
    }

    public String getGuestPhone() {
        return guestPhone;
    }

    public void setGuestPhone(String guestPhone) {
        this.guestPhone = guestPhone;
    }

    public String getGuestIdCardNumber() {
        return guestIdCardNumber;
    }

    public void setGuestIdCardNumber(String guestIdCardNumber) {
        this.guestIdCardNumber = guestIdCardNumber;
    }

    public Date getCheckinDate() {
        return checkinDate;
    }

    public void setCheckinDate(Date checkinDate) {
        this.checkinDate = checkinDate;
    }

    public Date getCheckoutDate() {
        return checkoutDate;
    }

    public void setCheckoutDate(Date checkoutDate) {
        this.checkoutDate = checkoutDate;
    }

    public int getTotalNights() {
        return totalNights;
    }

    public void setTotalNights(int totalNights) {
        this.totalNights = totalNights;
    }

    public BigDecimal getRoomPriceTotal() {
        return roomPriceTotal;
    }

    public void setRoomPriceTotal(BigDecimal roomPriceTotal) {
        this.roomPriceTotal = roomPriceTotal;
    }

    public BigDecimal getAddonPriceTotal() {
        return addonPriceTotal;
    }

    public void setAddonPriceTotal(BigDecimal addonPriceTotal) {
        this.addonPriceTotal = addonPriceTotal;
    }

    public BigDecimal getSurchargeTotal() {
        return surchargeTotal;
    }

    public void setSurchargeTotal(BigDecimal surchargeTotal) {
        this.surchargeTotal = surchargeTotal;
    }

    public Integer getVoucherId() {
        return voucherId;
    }

    public void setVoucherId(Integer voucherId) {
        this.voucherId = voucherId;
    }

    public BigDecimal getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discountAmount = discountAmount;
    }

    public BigDecimal getFinalTotal() {
        return finalTotal;
    }

    public void setFinalTotal(BigDecimal finalTotal) {
        this.finalTotal = finalTotal;
    }

    public String getBookingType() {
        return bookingType;
    }

    public void setBookingType(String bookingType) {
        this.bookingType = bookingType;
    }

    public String getBookingStatus() {
        return bookingStatus;
    }

    public void setBookingStatus(String bookingStatus) {
        this.bookingStatus = bookingStatus;
    }

    // Alias for getBookingStatus()
    public String getStatus() {
        return bookingStatus;
    }

    public void setStatus(String status) {
        this.bookingStatus = status;
    }

    public BigDecimal getTotalAmount() {
        return finalTotal;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.finalTotal = totalAmount;
    }

    public Timestamp getHoldExpiresAt() {
        return holdExpiresAt;
    }

    public void setHoldExpiresAt(Timestamp holdExpiresAt) {
        this.holdExpiresAt = holdExpiresAt;
    }

    public Integer getReceptionistId() {
        return receptionistId;
    }

    public void setReceptionistId(Integer receptionistId) {
        this.receptionistId = receptionistId;
    }

    public String getCancellationReason() {
        return cancellationReason;
    }

    public void setCancellationReason(String cancellationReason) {
        this.cancellationReason = cancellationReason;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getHomestayName() {
        return homestayName;
    }

    public void setHomestayName(String homestayName) {
        this.homestayName = homestayName;
    }

    public String getHomestayAddress() {
        return homestayAddress;
    }

    public void setHomestayAddress(String homestayAddress) {
        this.homestayAddress = homestayAddress;
    }

    public String getHomestayCity() {
        return homestayCity;
    }

    public void setHomestayCity(String homestayCity) {
        this.homestayCity = homestayCity;
    }

    public String getHomestayImageUrl() {
        return homestayImageUrl;
    }

    public void setHomestayImageUrl(String homestayImageUrl) {
        this.homestayImageUrl = homestayImageUrl;
    }

    public String getRoomTypeName() {
        return roomTypeName;
    }

    public void setRoomTypeName(String roomTypeName) {
        this.roomTypeName = roomTypeName;
    }
}
