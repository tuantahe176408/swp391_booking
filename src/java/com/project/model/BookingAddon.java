package com.project.model;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * Domain Entity: BookingAddon (Dịch vụ bổ sung đã chọn trong đơn đặt phòng)
 * Package: com.project.model
 */
public class BookingAddon implements Serializable {

    private static final long serialVersionUID = 1L;

    private int bookingAddonId;
    private int bookingId;
    private int addonId;
    private int quantity;
    private BigDecimal unitPrice;
    private BigDecimal subtotal;

    // Transient for UI
    private String addonName;
    private String addonUnit;

    public BookingAddon() {
        this.quantity = 1;
        this.unitPrice = BigDecimal.ZERO;
        this.subtotal = BigDecimal.ZERO;
    }

    public int getBookingAddonId() { return bookingAddonId; }
    public void setBookingAddonId(int bookingAddonId) { this.bookingAddonId = bookingAddonId; }

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public int getAddonId() { return addonId; }
    public void setAddonId(int addonId) { this.addonId = addonId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }

    public BigDecimal getSubtotal() { return subtotal; }
    public void setSubtotal(BigDecimal subtotal) { this.subtotal = subtotal; }

    public String getAddonName() { return addonName; }
    public void setAddonName(String addonName) { this.addonName = addonName; }

    public String getAddonUnit() { return addonUnit; }
    public void setAddonUnit(String addonUnit) { this.addonUnit = addonUnit; }
}
