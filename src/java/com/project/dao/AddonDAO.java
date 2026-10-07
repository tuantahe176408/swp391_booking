package com.project.dao;

import com.project.model.Addon;
import java.util.List;
import java.util.Optional;

/**
 * Data Access Object Interface: Addon Operations
 * Package: com.project.dao
 */
public interface AddonDAO {
    /** Customer-facing: only returns is_available = TRUE for a specific homestay. */
    List<Addon> getAddonsByHomestayId(int homestayId);

    Optional<Addon> getAddonById(int addonId);

    /**
     * Owner management: returns ALL addons (active + inactive) for every
     * homestay owned by ownerId, with homestayName populated for display.
     */
    List<Addon> getAllAddonsByOwnerId(int ownerId);

    /**
     * Security check: true if addonId belongs to a homestay owned by ownerId.
     */
    boolean isAddonOwnedBy(int addonId, int ownerId);

    /**
     * Check if any active booking references this addon (blocks delete).
     * Active = not in CANCELLED / CHECKED_OUT / REFUNDED.
     */
    boolean hasActiveBookings(int addonId);

    int insertAddon(Addon addon);
    boolean updateAddon(Addon addon);
    boolean deleteAddon(int addonId);
    boolean toggleAvailable(int addonId, boolean available);
}
