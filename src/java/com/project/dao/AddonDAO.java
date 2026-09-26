package com.project.dao;

import com.project.model.Addon;
import java.util.List;
import java.util.Optional;

/**
 * Data Access Object Interface: Addon Operations
 * Package: com.project.dao
 */
public interface AddonDAO {
    List<Addon> getAddonsByHomestayId(int homestayId);
    Optional<Addon> getAddonById(int addonId);
    int insertAddon(Addon addon);
    boolean updateAddon(Addon addon);
    boolean deleteAddon(int addonId);
}
