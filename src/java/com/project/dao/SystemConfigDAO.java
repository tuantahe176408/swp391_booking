package com.project.dao;

import java.util.Map;

/**
 * DEFERRED — UC24 System Configuration DAO
 * =========================================
 * Code này đã được implement đầy đủ nhưng TẠM HOÃN tích hợp vào luồng chính.
 * Lý do: invoice creation (nơi consume PLATFORM_COMMISSION_RATE) chưa được implement,
 * nên chưa có đủ business flow để justify kích hoạt.
 *
 * Để tái kích hoạt:
 *   1. Uncomment SystemConfigDAOImpl + AdminConfigController doPost handler
 *   2. Inject configDAO vào BookingService (đọc BOOKING_HOLD_MINUTES)
 *   3. Inject configDAO vào PaymentService khi tạo Invoice (đọc PLATFORM_COMMISSION_RATE)
 *   4. Wire config.jsp form → POST /admin/config
 *
 * Package: com.project.dao
 */
public interface SystemConfigDAO {

    String get(String key);
    String get(String key, String defaultValue);
    Map<String, String> getAll();
    boolean set(String key, String value);

    default double getCommissionRate() {
        try { return Double.parseDouble(get("PLATFORM_COMMISSION_RATE", "10.0")); }
        catch (NumberFormatException e) { return 10.0; }
    }

    default int getBookingHoldMinutes() {
        try { return Integer.parseInt(get("BOOKING_HOLD_MINUTES", "15")); }
        catch (NumberFormatException e) { return 15; }
    }
}
