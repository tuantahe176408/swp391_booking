package com.project.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Domain Entity: Addon (Dịch vụ bổ sung đi kèm Homestay)
 * Package: com.project.model
 */
public class Addon implements Serializable {

    private static final long serialVersionUID = 1L;

    private int addonId;
    private int homestayId;
    private String name;
    private String description;
    private BigDecimal price;
    private String unit;   // "per_night", "per_person", "per_booking"
    private boolean available;
    private Timestamp createdAt;

    public Addon() {
        this.price = BigDecimal.ZERO;
        this.unit = "per_booking";
        this.available = true;
    }

    public int getAddonId() { return addonId; }
    public void setAddonId(int addonId) { this.addonId = addonId; }

    public int getHomestayId() { return homestayId; }
    public void setHomestayId(int homestayId) { this.homestayId = homestayId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }

    public boolean isAvailable() { return available; }
    public void setAvailable(boolean available) { this.available = available; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
