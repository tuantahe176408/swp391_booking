package com.project.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

/**
 * Domain Entity: Dynamic Price rule for a room type on a specific date (UC18)
 * Covers: price multiplier, explicit override price, and room lock.
 * Package: com.project.model
 */
public class DynamicPrice implements Serializable {

    private static final long serialVersionUID = 1L;

    private int     priceId;
    private int     roomTypeId;
    private Date    date;
    /** e.g. 1.25 = +25%.  Null when customPrice is set instead. */
    private BigDecimal priceMultiplier;
    /** Explicit override price in VND. Null when priceMultiplier is used. */
    private BigDecimal customPrice;
    /** TRUE = room locked (maintenance / private event) — no bookings allowed. */
    private boolean isLocked;
    private Timestamp createdAt;

    // ── Transient fields populated by JOIN in CalendarDAOImpl ─────────────────
    /** base_price from room_types — used to compute effective price in UI. */
    private BigDecimal basePrice;
    /** Computed effective price = customPrice ?? (basePrice * priceMultiplier). Set by DAO. */
    private BigDecimal effectivePrice;

    public DynamicPrice() {
        this.priceMultiplier = BigDecimal.ONE;
        this.isLocked        = false;
    }

    // ── Getters & Setters ─────────────────────────────────────────────────────

    public int getPriceId()                        { return priceId; }
    public void setPriceId(int priceId)            { this.priceId = priceId; }

    public int getRoomTypeId()                     { return roomTypeId; }
    public void setRoomTypeId(int roomTypeId)      { this.roomTypeId = roomTypeId; }

    public Date getDate()                          { return date; }
    public void setDate(Date date)                 { this.date = date; }

    public BigDecimal getPriceMultiplier()         { return priceMultiplier; }
    public void setPriceMultiplier(BigDecimal m)   { this.priceMultiplier = m; }

    public BigDecimal getCustomPrice()             { return customPrice; }
    public void setCustomPrice(BigDecimal p)       { this.customPrice = p; }

    public boolean isLocked()                      { return isLocked; }
    public void setLocked(boolean locked)          { this.isLocked = locked; }

    public Timestamp getCreatedAt()                { return createdAt; }
    public void setCreatedAt(Timestamp t)          { this.createdAt = t; }

    public BigDecimal getBasePrice()               { return basePrice; }
    public void setBasePrice(BigDecimal p)         { this.basePrice = p; }

    public BigDecimal getEffectivePrice()          { return effectivePrice; }
    public void setEffectivePrice(BigDecimal p)    { this.effectivePrice = p; }

    /**
     * Returns true if this row represents a real price change
     * (multiplier != 1.0, or customPrice set, or locked).
     * Used by JSP to decide cell styling.
     */
    public boolean isRealPriceRule() {
        if (isLocked) return true;
        if (customPrice != null && customPrice.compareTo(BigDecimal.ZERO) > 0) return true;
        if (priceMultiplier != null && priceMultiplier.compareTo(BigDecimal.ONE) != 0) return true;
        return false;
    }

    /**
     * Compute and cache effectivePrice from basePrice + rule.
     * Safe to call after basePrice is set.
     */
    public BigDecimal computeEffectivePrice() {        if (customPrice != null && customPrice.compareTo(BigDecimal.ZERO) > 0) {
            effectivePrice = customPrice;
        } else if (basePrice != null) {
            BigDecimal mult = (priceMultiplier != null) ? priceMultiplier : BigDecimal.ONE;
            effectivePrice = basePrice.multiply(mult).setScale(0, java.math.RoundingMode.HALF_UP);
        } else {
            effectivePrice = BigDecimal.ZERO;
        }
        return effectivePrice;
    }
}
