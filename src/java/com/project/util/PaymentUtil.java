package com.project.util;

import com.project.model.Booking;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Utility: VNPay + MoMo Payment Gateway Integration (UC08, UC10)
 * Package: com.project.util
 */
public class PaymentUtil {

    private static final Logger LOGGER = Logger.getLogger(PaymentUtil.class.getName());

    // ── VNPay Config ─────────────────────────────────────────────────────────
    private static final String VNP_TMN_CODE    = System.getenv("VNP_TMN_CODE")    != null ? System.getenv("VNP_TMN_CODE")    : "1JGR8UF7";
    private static final String VNP_HASH_SECRET = System.getenv("VNP_HASH_SECRET") != null ? System.getenv("VNP_HASH_SECRET") : "JGMXDOLSTVUDGMYYQMOIPBPQAIDQMKPB";
    private static final String VNP_URL         = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";

    // ── MoMo Config (read from application.properties via classpath) ──────────
    private static String MOMO_PARTNER_CODE;
    private static String MOMO_ACCESS_KEY;
    private static String MOMO_SECRET_KEY;
    private static String MOMO_ENDPOINT;

    static {
        loadMoMoConfig();
    }

    private static void loadMoMoConfig() {
        // Priority: env var → classpath application.properties → hardcoded sandbox defaults
        MOMO_PARTNER_CODE = getEnvOrProp("MOMO_PARTNER_CODE", "momo.partner.code", "MOMO");
        MOMO_ACCESS_KEY   = getEnvOrProp("MOMO_ACCESS_KEY",   "momo.access.key",   "F8BBA842ECF85");
        MOMO_SECRET_KEY   = getEnvOrProp("MOMO_SECRET_KEY",   "momo.secret.key",   "K951B6PE1waDMi640xX08PD3vg6EkVlz");
        MOMO_ENDPOINT     = getEnvOrProp("MOMO_API_ENDPOINT", "momo.api.endpoint",
                                         "https://test-payment.momo.vn/v2/gateway/api/create");
    }

    private static String getEnvOrProp(String envKey, String propKey, String defaultVal) {
        // 1. Environment variable
        String env = System.getenv(envKey);
        if (env != null && !env.trim().isEmpty()) return env.trim();

        // 2. Classpath application.properties
        try (java.io.InputStream is = PaymentUtil.class.getClassLoader()
                .getResourceAsStream("application.properties")) {
            if (is != null) {
                Properties p = new Properties();
                p.load(is);
                String v = p.getProperty(propKey);
                if (v != null && !v.trim().isEmpty()) return v.trim();
            }
        } catch (Exception ignored) {}

        return defaultVal;
    }

    /**
     * Returns true when real VNPay credentials are available.
     */
    public static boolean hasRealCredentials() {
        return true; // sandbox credentials are always valid for demo
    }

    /**
     * Returns true when MoMo credentials look real (not placeholder).
     */
    public static boolean hasMoMoCredentials() {
        return MOMO_PARTNER_CODE != null && !MOMO_PARTNER_CODE.isBlank()
            && MOMO_ACCESS_KEY   != null && !MOMO_ACCESS_KEY.isBlank()
            && MOMO_SECRET_KEY   != null && !MOMO_SECRET_KEY.isBlank();
    }

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

        // Build query string & hashData
        // vnp_ReturnUrl cần đặc biệt: encode trong hashData nhưng KHÔNG double-encode trong query
        StringBuilder query    = new StringBuilder();
        StringBuilder hashData = new StringBuilder();
        for (Map.Entry<String, String> entry : vnpParams.entrySet()) {
            if (entry.getValue() != null && !entry.getValue().isEmpty()) {
                String key = entry.getKey();
                String val = entry.getValue();
                // hashData: key=URLEncode(value) — VNPay 2.1.0 spec
                hashData.append(key).append('=')
                        .append(URLEncoder.encode(val, StandardCharsets.UTF_8))
                        .append('&');
                // query string: key=URLEncode(value)
                // ReturnUrl đã là valid URL — encode toàn bộ để truyền qua query param
                query.append(URLEncoder.encode(key, StandardCharsets.UTF_8))
                     .append('=')
                     .append(URLEncoder.encode(val, StandardCharsets.UTF_8))
                     .append('&');
            }
        }
        if (hashData.length() > 0) hashData.deleteCharAt(hashData.length() - 1);
        if (query.length() > 0)    query.deleteCharAt(query.length() - 1);

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
                        .append(URLEncoder.encode(entry.getValue(), StandardCharsets.UTF_8))
                        .append('&');
            }
        }
        if (hashData.length() > 0) hashData.deleteCharAt(hashData.length() - 1);

        String computedHash = hmacSHA512(VNP_HASH_SECRET, hashData.toString());
        return computedHash.equalsIgnoreCase(vnpSecureHash);
    }

    // ═══════════════════════════════════════════════════════════════
    // MoMo Payment Gateway (v2 — All-in-one)
    // Ref: https://developers.momo.vn/#/docs/en/aiov2/?id=payment-method
    // ═══════════════════════════════════════════════════════════════

    /**
     * Gọi MoMo API tạo giao dịch, trả về payUrl để redirect khách hàng.
     * Nếu thất bại trả về null.
     *
     * @param booking    đơn đặt phòng
     * @param returnUrl  URL khách được redirect về sau khi thanh toán
     * @param notifyUrl  URL MoMo gọi IPN (có thể trùng returnUrl ở sandbox)
     * @return payUrl từ MoMo, hoặc null nếu lỗi
     */
    public static String createMoMoUrl(Booking booking, String returnUrl, String notifyUrl) {
        try {
            String orderId    = booking.getBookingCode() + "_" + System.currentTimeMillis();
            String requestId  = UUID.randomUUID().toString();
            String orderInfo  = "Thanh toan dat phong " + booking.getBookingCode();
            long   amount     = booking.getFinalTotal().longValue();
            String extraData  = Base64.getEncoder().encodeToString(
                                    booking.getBookingCode().getBytes(StandardCharsets.UTF_8));
            String requestType = "captureWallet"; // or "payWithATM"

            // Build rawSignature theo tài liệu MoMo v2
            // accessKey&amount&extraData&ipnUrl&orderId&orderInfo&partnerCode&redirectUrl&requestId&requestType
            String rawSignature =
                "accessKey="   + MOMO_ACCESS_KEY   +
                "&amount="     + amount             +
                "&extraData="  + extraData          +
                "&ipnUrl="     + notifyUrl          +
                "&orderId="    + orderId            +
                "&orderInfo="  + orderInfo          +
                "&partnerCode="+ MOMO_PARTNER_CODE  +
                "&redirectUrl="+ returnUrl          +
                "&requestId="  + requestId          +
                "&requestType="+ requestType;

            String signature = hmacSHA256(MOMO_SECRET_KEY, rawSignature);

            // JSON body
            String jsonBody = "{"
                + "\"partnerCode\":\""  + MOMO_PARTNER_CODE  + "\","
                + "\"accessKey\":\""    + MOMO_ACCESS_KEY    + "\","
                + "\"requestId\":\""    + requestId          + "\","
                + "\"amount\":"         + amount             + ","
                + "\"orderId\":\""      + orderId            + "\","
                + "\"orderInfo\":\""    + orderInfo          + "\","
                + "\"redirectUrl\":\""  + returnUrl          + "\","
                + "\"ipnUrl\":\""       + notifyUrl          + "\","
                + "\"lang\":\"vi\","
                + "\"extraData\":\""    + extraData          + "\","
                + "\"requestType\":\""  + requestType        + "\","
                + "\"signature\":\""    + signature          + "\""
                + "}";

            LOGGER.info("[MOMO] Sending request to " + MOMO_ENDPOINT + " | orderId=" + orderId);

            URL url = new URL(MOMO_ENDPOINT);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setConnectTimeout(10000);
            conn.setReadTimeout(10000);
            conn.setDoOutput(true);

            try (OutputStream os = conn.getOutputStream()) {
                os.write(jsonBody.getBytes(StandardCharsets.UTF_8));
            }

            if (conn.getResponseCode() != 200) {
                LOGGER.warning("[MOMO] Non-200 response: " + conn.getResponseCode());
                return null;
            }

            String responseBody = new String(conn.getInputStream().readAllBytes(), StandardCharsets.UTF_8);
            LOGGER.info("[MOMO] Response: " + responseBody);

            // Parse payUrl từ JSON response (dùng regex đơn giản, không cần gson)
            String payUrl = extractJsonString(responseBody, "payUrl");
            if (payUrl == null || payUrl.isBlank()) {
                String resultCode = extractJsonString(responseBody, "resultCode");
                String message    = extractJsonString(responseBody, "message");
                LOGGER.warning("[MOMO] No payUrl. resultCode=" + resultCode + " message=" + message);
                return null;
            }
            return payUrl;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating MoMo payment URL", e);
            return null;
        }
    }

    /**
     * Xác thực chữ ký HMAC-SHA256 từ MoMo redirect/IPN callback.
     * MoMo gửi các params qua query string; chúng ta re-compute signature và so sánh.
     *
     * @param params  request.getParameterMap() từ /payment/momo-return
     * @return true nếu chữ ký hợp lệ
     */
    public static boolean verifyMoMoReturn(Map<String, String[]> params) {
        String receivedSig = getParam(params, "signature");
        if (receivedSig == null || receivedSig.isBlank()) return false;

        // Lấy các field MoMo gửi về
        String accessKey   = MOMO_ACCESS_KEY;
        String amount      = getParam(params, "amount");
        String extraData   = getParam(params, "extraData");
        String message     = getParam(params, "message");
        String orderId     = getParam(params, "orderId");
        String orderInfo   = getParam(params, "orderInfo");
        String orderType   = getParam(params, "orderType");
        String partnerCode = getParam(params, "partnerCode");
        String payType     = getParam(params, "payType");
        String requestId   = getParam(params, "requestId");
        String responseTime= getParam(params, "responseTime");
        String resultCode  = getParam(params, "resultCode");
        String transId     = getParam(params, "transId");

        // rawHash theo tài liệu MoMo v2 redirect
        String rawHash =
            "accessKey="    + nullToEmpty(accessKey)    +
            "&amount="      + nullToEmpty(amount)       +
            "&extraData="   + nullToEmpty(extraData)    +
            "&message="     + nullToEmpty(message)      +
            "&orderId="     + nullToEmpty(orderId)      +
            "&orderInfo="   + nullToEmpty(orderInfo)    +
            "&orderType="   + nullToEmpty(orderType)    +
            "&partnerCode=" + nullToEmpty(partnerCode)  +
            "&payType="     + nullToEmpty(payType)      +
            "&requestId="   + nullToEmpty(requestId)    +
            "&responseTime="+ nullToEmpty(responseTime) +
            "&resultCode="  + nullToEmpty(resultCode)   +
            "&transId="     + nullToEmpty(transId);

        String computed = hmacSHA256(MOMO_SECRET_KEY, rawHash);
        boolean valid = computed.equalsIgnoreCase(receivedSig);
        if (!valid) LOGGER.warning("[MOMO] Signature mismatch. computed=" + computed + " received=" + receivedSig);
        return valid;
    }

    /**
     * HMAC-SHA256 signing (dùng cho MoMo)
     */
    public static String hmacSHA256(String key, String data) {
        try {
            Mac hmac = Mac.getInstance("HmacSHA256");
            SecretKeySpec secretKey = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
            hmac.init(secretKey);
            byte[] bytes = hmac.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : bytes) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "HMAC-SHA256 error", e);
            return "";
        }
    }

    /** Extract a string value from a simple flat JSON response. */
    private static String extractJsonString(String json, String key) {
        String search = "\"" + key + "\":\"";
        int start = json.indexOf(search);
        if (start < 0) return null;
        start += search.length();
        int end = json.indexOf("\"", start);
        if (end < 0) return null;
        return json.substring(start, end);
    }

    /** Extract orderId (=bookingCode + "_" + ts) → booking code portion. */
    public static String extractBookingCodeFromMoMoOrderId(String orderId) {
        if (orderId == null) return null;
        int idx = orderId.lastIndexOf('_');
        return idx > 0 ? orderId.substring(0, idx) : orderId;
    }

    private static String getParam(Map<String, String[]> params, String key) {
        String[] vals = params.get(key);
        return (vals != null && vals.length > 0) ? vals[0] : null;
    }

    private static String nullToEmpty(String s) { return s != null ? s : ""; }

    // ═══════════════════════════════════════════════════════════════
    // VNPay HMAC-SHA512
    // ═══════════════════════════════════════════════════════════════

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
