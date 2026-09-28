package com.project.dao;

import com.project.model.DynamicPrice;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * DAO Interface: Dynamic Pricing Calendar Operations (UC18)
 * Package: com.project.dao
 */
public interface CalendarDAO {

    /**
     * Return all DynamicPrice rules for given room types within a calendar month.
     * Map key = "roomTypeId_yyyy-MM-dd" for O(1) lookup in JSP/Controller.
     * Each DynamicPrice has effectivePrice already computed (customPrice ?? base*mult).
     *
     * @param roomTypeIds list of room_type_id belonging to the selected homestay
     * @param year        4-digit year
     * @param month       1-based month (1=Jan … 12=Dec)
     */
    Map<String, DynamicPrice> getPriceMapByRoomTypesAndMonth(
            List<Integer> roomTypeIds, int year, int month);

    /**
     * Insert or update a single dynamic price rule.
     * Uses ON DUPLICATE KEY UPDATE on (room_type_id, date).
     */
    boolean upsertDynamicPrice(DynamicPrice dp);

    /**
     * Delete a dynamic price rule — reverts that date to default base_price.
     */
    boolean deleteDynamicPrice(int roomTypeId, String date);

    /**
     * Bulk upsert: apply the same multiplier/customPrice/lock to multiple dates × room types.
     * Used by "Áp dụng quy tắc giá" bulk-apply button.
     *
     * @param roomTypeIds    room types to apply the rule to
     * @param dates          list of date strings "yyyy-MM-dd"
     * @param priceMultiplier nullable — null keeps existing or defaults to 1.00
     * @param customPrice     nullable — explicit override; null clears any override
     * @param isLocked        whether to lock the room on those dates
     */
    boolean bulkUpsert(List<Integer> roomTypeIds, List<String> dates,
                       BigDecimal priceMultiplier, BigDecimal customPrice, boolean isLocked);
}
