package com.project.util;

import com.project.model.Booking;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Utility: VNPay Payment Gateway Integration (UC08, UC10)
 * Package: com.project.util
 * Ref: https://sandbox.vnpayment.vn/apis/docs/thanh-toan-pay/pay.html
 */
public class PaymentUtil {

    private static final Logger LOGGER = Logger.getLogger(PaymentUtil.class.getName());

    // --- VNPay Config (từ application.properties hoặc environment) ---
    private static final String VNP_TMN_CODE   = System.getenv("VNP_TMN_CODE")   != null ? System.getenv("VNP_TMN_CODE")   : "SMARTBOOK";
    private static final String VNP_HASH_SECRET= System.getenv("VNP_HASH_SECRET") != null ? System.getenv("VNP_HASH_SECRET") : "SMARTBOOKINGSECRETKEY2026VNPAY";
    private static final String VNP_URL        = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
    private static final String VNP_API_URL    = "https://sandbox.vnpayment.vn/merchant_webapi/api/transaction";

    /**
     * Tạo URL thanh toán VNPay theo chuẩn SHA-512 HMAC
     */
    public static String createVnPayUrl(Booking booking, String ipAddr, String returnUrl, String bankCode) {
        Map<String, String> vnpParams = new TreeMap<>();

        String createDate = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
        String expireDate = new SimpleDateFormat("yyyyMMddHHmmss").format(
                new Date(System.currentTimeMillis() + 15 * 60 * 1000));

        // Amount: VNPay yêu cầu đơn vị VND * 100
        long amount = booking.getFinalTotal().multiply(new java.math.BigDecimal("100")).longValue();

        vnpParams.put("vnp_Version",    "2.1.0");
        vnpParams.put("vnp_Command",    "pay");
        vnpParams.put("vnp_TmnCode",    VNP_TMN_CODE);
        vnpParams.put("vnp_Amount",     String.valueOf(amount));
        vnpParams.put("vnp_CurrCode",   "VND");
        vnpParams.put("vnp_TxnRef",     booking.getBookingCode());
        vnpParams.put("vnp_OrderInfo",  "Thanh toan dat phong " + booking.getBookingCode());
        vnpParams.put("vnp_OrderType",  "250000"); // Du lịch & Khách sạn
        vnpParams.put("vnp_Locale",     "vn");
        vnpParams.put("vnp_ReturnUrl",  returnUrl);
        vnpParams.put("vnp_IpAddr",     ipAddr);
        vnpParams.put("vnp_CreateDate", createDate);
        vnpParams.put("vnp_ExpireDate", expireDate);

        if (bankCode != null && !bankCode.trim().isEmpty() && !"VNPAY".equals(bankCode)) {
            vnpParams.put("vnp_BankCode", bankCode);
        }

        // Build query string & compute HMAC-SHA512
        StringBuilder query = new StringBuilder();
        StringBuilder hashData = new StringBuilder();
        for (Map.Entry<String, String> entry : vnpParams.entrySet()) {
            if (entry.getValue() != null && !entry.getValue().isEmpty()) {
                hashData.append(entry.getKey()).append('=').append(URLEncoder.encode(entry.getValue(), StandardCharsets.US_ASCII));
                query.append(URLEncoder.encode(entry.getKey(), StandardCharsets.US_ASCII))
                     .append('=').append(URLEncoder.encode(entry.getValue(), StandardCharsets.US_ASCII));
                hashData.append('&');
                query.append('&');
            }
        }
        // Remove trailing &
        if (hashData.length() > 0) hashData.deleteCharAt(hashData.length() - 1);
        if (query.length() > 0) query.deleteCharAt(query.length() - 1);

        String secureHash = hmacSHA512(VNP_HASH_SECRET, hashData.toString());
        return VNP_URL + "?" + query + "&vnp_SecureHash=" + secureHash;
    }

    /**
     * Xác thực chữ ký HMAC-SHA512 từ VNPay callback — chống giả mạo dữ liệu
     */
    public static boolean verifyVnPayReturn(Map<String, String[]> params) {
        String vnpSecureHash = params.containsKey("vnp_SecureHash")
                ? params.get("vnp_SecureHash")[0] : "";

        Map<String, String> sortedParams = new TreeMap<>();
        for (Map.Entry<String, String[]> entry : params.entrySet()) {
            if (!entry.getKey().equals("vnp_SecureHash") && !entry.getKey().equals("vnp_SecureHashType")) {
                sortedParams.put(entry.getKey(), entry.getValue()[0]);
            }
        }

        StringBuilder hashData = new StringBuilder();
        for (Map.Entry<String, String> entry : sortedParams.entrySet()) {
            if (entry.getValue() != null && !entry.getValue().isEmpty()) {
                hashData.append(entry.getKey()).append('=')
                        .append(URLEncoder.encode(entry.getValue(), StandardCharsets.US_ASCII))
                        .append('&');
            }
        }
        if (hashData.length() > 0) hashData.deleteCharAt(hashData.length() - 1);

        String computedHash = hmacSHA512(VNP_HASH_SECRET, hashData.toString());
        return computedHash.equalsIgnoreCase(vnpSecureHash);
    }

    /**
     * HMAC-SHA512 signing
     */
    public static String hmacSHA512(String key, String data) {
        try {
            Mac hmac = Mac.getInstance("HmacSHA512");
            SecretKeySpec secretKey = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512");
            hmac.init(secretKey);
            byte[] bytes = hmac.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : bytes) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "HMAC-SHA512 error", e);
            return "";
        }
    }
}
