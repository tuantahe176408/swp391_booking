package com.project.util;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.project.model.Homestay;

import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * UC27 – Google Gemini AI utility.
 * Pattern mirrors GoogleAuthUtil.java (HttpClient) and DBContext.java (properties loading).
 */
public class GeminiAIUtil {

    private static final Logger LOGGER = Logger.getLogger(GeminiAIUtil.class.getName());

    private static final String API_KEY;
    private static final String MODEL;
    private static final boolean ENABLED;
    private static final String API_BASE = "https://generativelanguage.googleapis.com/v1beta/models/";

    private static final HttpClient HTTP_CLIENT = HttpClient.newBuilder()
            .version(HttpClient.Version.HTTP_2)
            .connectTimeout(Duration.ofSeconds(10))
            .build();

    static {
        String key   = System.getenv("GEMINI_API_KEY");
        String model = System.getenv("GEMINI_MODEL");
        String ena   = System.getenv("GEMINI_ENABLED");

        // Load properties whenever any value is still missing —
        // avoids the bug where setting GEMINI_API_KEY as an env var skips
        // gemini.model and gemini.enabled loading from application.properties.
        if (key == null || model == null || ena == null) {
            try (InputStream is = GeminiAIUtil.class.getClassLoader()
                    .getResourceAsStream("application.properties")) {
                if (is != null) {
                    Properties p = new Properties();
                    p.load(is);
                    if (key   == null) key   = p.getProperty("gemini.api.key");
                    if (model == null) model = p.getProperty("gemini.model", "gemini-1.5-flash");
                    if (ena   == null) ena   = p.getProperty("gemini.enabled", "false");
                }
            } catch (IOException ignored) {}
        }

        API_KEY = key;
        MODEL   = (model != null && !model.isBlank()) ? model : "gemini-3.5-flash-lite";
        ENABLED = "true".equalsIgnoreCase(ena);
    }

    /** @return true when Gemini is configured, enabled, and has a real API key. */
    public static boolean isEnabled() {
        return ENABLED
            && API_KEY != null
            && !API_KEY.isBlank()
            && !API_KEY.startsWith("YOUR_");
    }

    // ── System prompt ──────────────────────────────────────────────────────────
    private static final String SYSTEM_PROMPT =
        "Bạn là trợ lý du lịch ảo của Smart Booking Platform - nền tảng đặt phòng "
      + "Homestay & Hotel hàng đầu Việt Nam. Giúp khách hàng tìm homestay phù hợp, "
      + "trả lời câu hỏi về đặt phòng, chính sách hủy và các thắc mắc về dịch vụ. "
      + "Trả lời ngắn gọn, thân thiện bằng tiếng Việt. Tối đa 3 câu mỗi lần.";

    /**
     * Sends a message to Gemini and returns the reply text.
     *
     * @param userMessage New user message (required).
     * @param history     Prior turns – each Map must have "role" ("user"/"model") and "text".
     *                    Pass null or empty for a fresh conversation.
     * @return AI reply text, or null on any failure.
     */
    public static String chat(String userMessage, List<Map<String, String>> history) {
        if (!isEnabled() || userMessage == null || userMessage.isBlank()) return null;
        try {
            JsonObject body = new JsonObject();

            // System instruction
            JsonObject sysInst  = new JsonObject();
            JsonArray  sysParts = new JsonArray();
            JsonObject sysPart  = new JsonObject();
            sysPart.addProperty("text", SYSTEM_PROMPT);
            sysParts.add(sysPart);
            sysInst.add("parts", sysParts);
            body.add("systemInstruction", sysInst);

            // Contents (history + new user message)
            JsonArray contents = new JsonArray();
            if (history != null) {
                for (Map<String, String> turn : history) {
                    JsonObject msg   = new JsonObject();
                    JsonArray  parts = new JsonArray();
                    JsonObject part  = new JsonObject();
                    part.addProperty("text", turn.get("text"));
                    parts.add(part);
                    msg.addProperty("role", turn.get("role"));
                    msg.add("parts", parts);
                    contents.add(msg);
                }
            }
            JsonObject newMsg   = new JsonObject();
            JsonArray  newParts = new JsonArray();
            JsonObject newPart  = new JsonObject();
            newPart.addProperty("text", userMessage);
            newParts.add(newPart);
            newMsg.addProperty("role", "user");
            newMsg.add("parts", newParts);
            contents.add(newMsg);
            body.add("contents", contents);

            // Generation config
            JsonObject genConf = new JsonObject();
            genConf.addProperty("maxOutputTokens", 512);
            genConf.addProperty("temperature", 0.7);
            body.add("generationConfig", genConf);

            String url = API_BASE + MODEL + ":generateContent?key=" + API_KEY;
            HttpRequest req = HttpRequest.newBuilder()
                    .uri(URI.create(url))
                    .header("Content-Type", "application/json")
                    .header("Accept", "application/json")
                    .timeout(Duration.ofSeconds(10))
                    .POST(HttpRequest.BodyPublishers.ofString(body.toString()))
                    .build();

            HttpResponse<String> resp = HTTP_CLIENT.send(req, HttpResponse.BodyHandlers.ofString());

            if (resp.statusCode() == 200) {
                return JsonParser.parseString(resp.body())
                        .getAsJsonObject()
                        .getAsJsonArray("candidates").get(0)
                        .getAsJsonObject().getAsJsonObject("content")
                        .getAsJsonArray("parts").get(0)
                        .getAsJsonObject().get("text").getAsString();
            }
            LOGGER.log(Level.WARNING, "Gemini chat API status {0}: {1}",
                    new Object[]{resp.statusCode(), resp.body()});
        } catch (IOException | InterruptedException e) {
            LOGGER.log(Level.SEVERE, "Gemini chat exception", e);
            Thread.currentThread().interrupt();
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Gemini response parse error", e);
        }
        return null;
    }

    /**
     * Asks Gemini to reorder a list of candidate homestays based on user preference context.
     *
     * @param candidates       Homestay list from DAO (already has matchScore/reasonTag set).
     * @param userPrefsContext Comma-separated user preference categories, e.g. "BEACH, LUXURY".
     * @return Reordered list with top item's reasonTag updated, or null on any failure.
     */
    public static List<Homestay> rerankForRecommendations(
            List<Homestay> candidates, String userPrefsContext) {
        if (!isEnabled() || candidates == null || candidates.isEmpty()) return null;
        try {
            // Build compact homestay list JSON
            JsonArray items = new JsonArray();
            for (Homestay h : candidates) {
                JsonObject item = new JsonObject();
                item.addProperty("id",     h.getHomestayId());
                item.addProperty("name",   h.getName());
                item.addProperty("city",   h.getCity());
                item.addProperty("rating", h.getRatingAvg() != null ? h.getRatingAvg().doubleValue() : 0.0);
                item.addProperty("price",  h.getMinPrice()  != null ? h.getMinPrice().longValue()    : 0L);
                items.add(item);
            }
            String prompt = "Thông tin người dùng: " + userPrefsContext + ".\n"
                + "Từ danh sách " + candidates.size() + " homestay dưới đây, hãy CHỌN và XẾP HẠNG "
                + "tối đa 6 homestay PHÙ HỢP NHẤT với người dùng này, từ cao đến thấp.\n"
                + "Trả về CHÍNH XÁC một mảng JSON các số nguyên (giá trị 'id') theo thứ tự ưu tiên, KHÔNG giải thích thêm.\n"
                + "Ví dụ kết quả hợp lệ: [3,1,5,2,4,6]\n"
                + "Dữ liệu homestay: " + items;

            String responseText = chat(prompt, null); // no history for rerank
            if (responseText == null) return null;

            // Parse returned JSON array of IDs
            String trimmed = responseText.trim();
            int start = trimmed.indexOf('[');
            int end   = trimmed.lastIndexOf(']');
            if (start < 0 || end < 0) return null;
            JsonArray arr = JsonParser.parseString(trimmed.substring(start, end + 1)).getAsJsonArray();

            // Build id → Homestay map then reorder
            Map<Integer, Homestay> byId = new LinkedHashMap<>();
            for (Homestay h : candidates) byId.put(h.getHomestayId(), h);

            List<Homestay> reranked = new ArrayList<>();
            for (JsonElement el : arr) {
                Homestay h = byId.get(el.getAsInt());
                if (h != null) reranked.add(h);
            }
            // Append any not returned by Gemini (safety)
            for (Homestay h : candidates) {
                if (!reranked.contains(h)) reranked.add(h);
            }
            // Update top result's reason tag
            if (!reranked.isEmpty()) {
                reranked.get(0).setReasonTag("✨ Lựa chọn hàng đầu của AI");
            }
            return reranked;
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Gemini rerankForRecommendations failed, using original order", e);
        }
        return null;
    }
}
