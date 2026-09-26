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
    private BigDecimal minOrderAmount;
    private int totalLimit;
    private int usedCount;
    private java.sql.Date expiryDate;
    private boolean active;
    private Timestamp createdAt;

    public Voucher() {
        this.discountValue = BigDecimal.ZERO;
        this.maxDiscountAmount = BigDecimal.ZERO;
        this.minOrderAmount = BigDecimal.ZERO;
        this.active = true;
        this.usedCount = 0;
    }

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

    public BigDecimal getMinOrderAmount() { return minOrderAmount; }
    public void setMinOrderAmount(BigDecimal minOrderAmount) { this.minOrderAmount = minOrderAmount; }

    public int getTotalLimit() { return totalLimit; }
    public void setTotalLimit(int totalLimit) { this.totalLimit = totalLimit; }

    public int getUsedCount() { return usedCount; }
    public void setUsedCount(int usedCount) { this.usedCount = usedCount; }

    public java.sql.Date getExpiryDate() { return expiryDate; }
    public void setExpiryDate(java.sql.Date expiryDate) { this.expiryDate = expiryDate; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

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
}
