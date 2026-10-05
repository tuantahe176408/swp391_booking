package com.project.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Domain Entity: Voucher (Mã giảm giá khuyến mãi)
 * Package: com.project.model
 */
public class Voucher implements Serializable {

    private static final long serialVersionUID = 1L;

    public enum DiscountType {
        PERCENTAGE, FIXED_AMOUNT
    }

    private int voucherId;
    private String code;
    private String description;
    private DiscountType discountType;
    private BigDecimal discountValue;
    private BigDecimal maxDiscountAmount;
    private BigDecimal minBookingAmount;   // DB: min_booking_amount
    private int usageLimit;               // DB: usage_limit
    private int usedCount;
    private Timestamp startDate;          // DB: start_date
    private Timestamp endDate;            // DB: end_date
    private boolean active;
    private Integer createdByUserId;
    private Timestamp createdAt;

    public Voucher() {
        this.discountValue = BigDecimal.ZERO;
        this.maxDiscountAmount = BigDecimal.ZERO;
        this.minBookingAmount = BigDecimal.ZERO;
        this.active = true;
        this.usedCount = 0;
        this.usageLimit = 100;
    }

    // ---- Getters / Setters ----

    public int getVoucherId() { return voucherId; }
    public void setVoucherId(int voucherId) { this.voucherId = voucherId; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public DiscountType getDiscountType() { return discountType; }
    public void setDiscountType(DiscountType discountType) { this.discountType = discountType; }

    public BigDecimal getDiscountValue() { return discountValue; }
    public void setDiscountValue(BigDecimal discountValue) { this.discountValue = discountValue; }

    public BigDecimal getMaxDiscountAmount() { return maxDiscountAmount; }
    public void setMaxDiscountAmount(BigDecimal maxDiscountAmount) { this.maxDiscountAmount = maxDiscountAmount; }

    public BigDecimal getMinBookingAmount() { return minBookingAmount; }
    public void setMinBookingAmount(BigDecimal minBookingAmount) { this.minBookingAmount = minBookingAmount; }

    public int getUsageLimit() { return usageLimit; }
    public void setUsageLimit(int usageLimit) { this.usageLimit = usageLimit; }

    public int getUsedCount() { return usedCount; }
    public void setUsedCount(int usedCount) { this.usedCount = usedCount; }

    public Timestamp getStartDate() { return startDate; }
    public void setStartDate(Timestamp startDate) { this.startDate = startDate; }

    public Timestamp getEndDate() { return endDate; }
    public void setEndDate(Timestamp endDate) { this.endDate = endDate; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public Integer getCreatedByUserId() { return createdByUserId; }
    public void setCreatedByUserId(Integer createdByUserId) { this.createdByUserId = createdByUserId; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    /**
     * Tính số tiền giảm dựa trên tổng đơn hàng
     */
    public BigDecimal calculateDiscount(BigDecimal orderTotal) {
        if (discountType == DiscountType.FIXED_AMOUNT) {
            return discountValue.min(orderTotal);
        }
        // PERCENTAGE
        BigDecimal discount = orderTotal.multiply(discountValue).divide(BigDecimal.valueOf(100), 0, java.math.RoundingMode.DOWN);
        if (maxDiscountAmount != null && maxDiscountAmount.compareTo(BigDecimal.ZERO) > 0) {
            discount = discount.min(maxDiscountAmount);
        }
        return discount;
    }

    /**
     * Kiểm tra voucher còn hiệu lực không
     */
    public boolean isValid() {
        if (!active) return false;
        long now = System.currentTimeMillis();
        if (startDate != null && startDate.getTime() > now) return false;
        if (endDate != null && endDate.getTime() < now) return false;
        if (usageLimit > 0 && usedCount >= usageLimit) return false;
        return true;
    }
}
