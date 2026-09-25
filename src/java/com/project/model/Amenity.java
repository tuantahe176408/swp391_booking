package com.project.model;

import java.io.Serializable;

/**
 * Domain Entity: Amenity
 * Package: com.project.model
 */
public class Amenity implements Serializable {

    private static final long serialVersionUID = 1L;

    private int amenityId;
    private String name;
    private String iconClass;
    private String category;

    public Amenity() {
    }

    public Amenity(int amenityId, String name, String iconClass, String category) {
        this.amenityId = amenityId;
        this.name = name;
        this.iconClass = iconClass;
        this.category = category;
    }

    public int getAmenityId() {
        return amenityId;
    }

    public void setAmenityId(int amenityId) {
        this.amenityId = amenityId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getIconClass() {
        return iconClass;
    }

    public void setIconClass(String iconClass) {
        this.iconClass = iconClass;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }
}
