package com.project.util;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Utility: Cloudinary Image Upload & Delete — Pure Java HTTP, zero extra JARs.
 * Package: com.project.util
 *
 * Free plan: 25 GB storage + 25 GB bandwidth/month — https://cloudinary.com
 *
 * Config (priority order):
 *  1. Environment variables: CLOUDINARY_CLOUD_NAME, CLOUDINARY_API_KEY, CLOUDINARY_API_SECRET
 *  2. src/java/application.properties on classpath (same keys)
 *
 * Usage:
 *   String url = CloudinaryUtil.uploadImage(part.getInputStream(), part.getSubmittedFileName(), "homestays");
 *   CloudinaryUtil.deleteImage(existingUrl);
 */
public class CloudinaryUtil {

    private static final Logger LOGGER = Logger.getLogger(CloudinaryUtil.class.getName());

    // ── Credentials (loaded once at class init) ──────────────────────────────
    public static final String CLOUD_NAME;
    public static final String API_KEY;
    private static final String API_SECRET;

    static {
        String name = System.getenv("CLOUDINARY_CLOUD_NAME");
        String key  = System.getenv("CLOUDINARY_API_KEY");
        String sec  = System.getenv("CLOUDINARY_API_SECRET");

        if (name == null || key == null || sec == null) {
            try (InputStream is = CloudinaryUtil.class.getClassLoader()
                    .getResourceAsStream("application.properties")) {
                if (is != null) {
                    Properties p = new Properties();
                    p.load(is);
                    if (name == null) name = p.getProperty("CLOUDINARY_CLOUD_NAME");
                    if (key  == null) key  = p.getProperty("CLOUDINARY_API_KEY");
                    if (sec  == null) sec  = p.getProperty("CLOUDINARY_API_SECRET");
                }
            } catch (IOException e) {
                LOGGER.log(Level.WARNING, "application.properties not found on classpath", e);
            }
        }

        CLOUD_NAME = (name != null) ? name : "";
        API_KEY    = (key  != null) ? key  : "";
        API_SECRET = (sec  != null) ? sec  : "";

        if (CLOUD_NAME.isEmpty() || API_KEY.isEmpty() || API_SECRET.isEmpty()) {
            LOGGER.warning("[CloudinaryUtil] Credentials not configured — " +
                           "set env vars or edit src/java/application.properties");
        } else {
            LOGGER.info("[CloudinaryUtil] Loaded credentials for cloud: " + CLOUD_NAME);
        }
    }

    /** Maximum accepted file size in bytes (10 MB). */
    private static final long MAX_SIZE_BYTES = 10L * 1024 * 1024;

    /** Multipart boundary token. */
    private static final String BOUNDARY = "----SBPCloudinaryBoundary" +
            Long.toHexString(System.nanoTime());
    private static final String CRLF = "\r\n";

    // =========================================================================
    // PUBLIC API
    // =========================================================================

    /**
     * Upload an image InputStream to Cloudinary (signed upload, runs server-side).
     *
     * @param inputStream   Binary content from {@code Part.getInputStream()}
     * @param originalName  Original filename e.g. "photo.jpg" — used for content-type
     * @param folder        Cloudinary folder e.g. "homestays", "avatars"
     * @return Secure HTTPS URL of the uploaded image, or {@code null} on failure
     */
    public static String uploadImage(InputStream inputStream, String originalName, String folder) {
        if (!isConfigured()) {
            LOGGER.warning("[CloudinaryUtil] Skipping upload — credentials not set.");
            return null;
        }
        if (inputStream == null) return null;

        try {
            byte[] fileBytes = inputStream.readAllBytes();
            if (fileBytes.length == 0) return null;
            if (fileBytes.length > MAX_SIZE_BYTES) {
                LOGGER.warning("[CloudinaryUtil] File too large (max 10 MB): " + originalName);
                return null;
            }

            String timestamp = String.valueOf(System.currentTimeMillis() / 1000L);
            String signature = signUpload(folder, timestamp);
            String safeFolder = (folder != null && !folder.isBlank()) ? folder : "uploads";

            String uploadEndpoint =
                    "https://api.cloudinary.com/v1_1/" + CLOUD_NAME + "/image/upload";

            HttpURLConnection conn = openPost(uploadEndpoint);
            conn.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + BOUNDARY);

            try (OutputStream raw = conn.getOutputStream();
                 PrintWriter pw  = new PrintWriter(
                         new OutputStreamWriter(raw, StandardCharsets.UTF_8), true)) {

                appendField(pw, "api_key",   API_KEY);
                appendField(pw, "timestamp", timestamp);
                appendField(pw, "signature", signature);
                appendField(pw, "folder",    safeFolder);

                // Binary file part
                String fname = (originalName != null && !originalName.isBlank())
                        ? originalName : "image.jpg";
                pw.append("--").append(BOUNDARY).append(CRLF);
                pw.append("Content-Disposition: form-data; name=\"file\"; filename=\"")
                  .append(fname).append("\"").append(CRLF);
                pw.append("Content-Type: ").append(mimeType(fname)).append(CRLF);
                pw.append("Content-Transfer-Encoding: binary").append(CRLF);
                pw.append(CRLF).flush();
                raw.write(fileBytes);
                raw.flush();
                pw.append(CRLF).append("--").append(BOUNDARY).append("--").append(CRLF).flush();
            }

            int status    = conn.getResponseCode();
            String body   = readStream(status < 400
                    ? conn.getInputStream() : conn.getErrorStream());
            conn.disconnect();

            if (status == 200) {
                String url = jsonField(body, "secure_url");
                LOGGER.info("[CloudinaryUtil] Uploaded: " + url);
                return url;
            }
            LOGGER.warning("[CloudinaryUtil] Upload failed [HTTP " + status + "]: " + body);

        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "[CloudinaryUtil] IOException uploading: " + originalName, e);
        }
        return null;
    }

    /**
     * Delete an image from Cloudinary by its stored URL.
     * Safe to call even if the URL is {@code null} or not a Cloudinary URL.
     *
     * @param imageUrl  The full Cloudinary HTTPS URL (as stored in DB)
     * @return {@code true} if Cloudinary confirmed deletion or image not found
     */
    public static boolean deleteImage(String imageUrl) {
        if (!isConfigured() || imageUrl == null || imageUrl.isBlank()) return false;

        String publicId = extractPublicId(imageUrl);
        if (publicId == null || publicId.isBlank()) {
            LOGGER.warning("[CloudinaryUtil] Could not extract public_id from: " + imageUrl);
            return false;
        }

        String timestamp  = String.valueOf(System.currentTimeMillis() / 1000L);
        // Signature for destroy: SHA1("public_id={id}&timestamp={ts}{secret}")
        String sigPayload = "public_id=" + publicId + "&timestamp=" + timestamp + API_SECRET;
        String signature  = sha1Hex(sigPayload);

        try {
            String body = "public_id=" + urlEncode(publicId)
                        + "&api_key="    + urlEncode(API_KEY)
                        + "&timestamp="  + timestamp
                        + "&signature="  + signature;

            String destroyEndpoint =
                    "https://api.cloudinary.com/v1_1/" + CLOUD_NAME + "/image/destroy";
            HttpURLConnection conn = openPost(destroyEndpoint);
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

            try (OutputStream out = conn.getOutputStream()) {
                out.write(body.getBytes(StandardCharsets.UTF_8));
            }

            int status    = conn.getResponseCode();
            String result = readStream(conn.getInputStream());
            conn.disconnect();

            boolean ok = status == 200 &&
                    (result.contains("\"ok\"") || result.contains("\"not found\""));
            if (!ok) LOGGER.warning("[CloudinaryUtil] Delete unexpected response: " + result);
            return status == 200;

        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "[CloudinaryUtil] IOException deleting: " + publicId, e);
        }
        return false;
    }

    /**
     * Extract Cloudinary {@code public_id} from a full URL.
     * <p>
     * Example: {@code https://res.cloudinary.com/mycloud/image/upload/v123/homestays/abc.jpg}
     * → {@code homestays/abc}
     */
    public static String extractPublicId(String url) {
        if (url == null || url.isBlank()) return null;
        try {
            int idx = url.indexOf("/upload/");
            if (idx < 0) return null;
            String after = url.substring(idx + "/upload/".length());
            // Strip optional version token vNNNNNN/
            if (after.length() > 2
                    && after.charAt(0) == 'v'
                    && Character.isDigit(after.charAt(1))) {
                int slash = after.indexOf('/');
                if (slash > 0) after = after.substring(slash + 1);
            }
            // Strip file extension
            int dot = after.lastIndexOf('.');
            if (dot > 0) after = after.substring(0, dot);
            return after;
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "[CloudinaryUtil] extractPublicId error for: " + url, e);
            return null;
        }
    }

    /** Returns {@code true} when all three credentials are non-empty. */
    public static boolean isConfigured() {
        return !CLOUD_NAME.isEmpty() && !API_KEY.isEmpty() && !API_SECRET.isEmpty();
    }

    // =========================================================================
    // PRIVATE HELPERS
    // =========================================================================

    /**
     * Compute Cloudinary signed-upload signature.
     * SHA1("folder={folder}&timestamp={ts}{api_secret}")
     */
    private static String signUpload(String folder, String timestamp) {
        String payload = "folder=" + folder + "&timestamp=" + timestamp + API_SECRET;
        return sha1Hex(payload);
    }

    /** SHA-1 hex digest — Cloudinary's default signature algorithm. */
    private static String sha1Hex(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-1");
            byte[] hash = md.digest(input.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder(40);
            for (byte b : hash) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-1 not available on this JVM", e);
        }
    }

    private static HttpURLConnection openPost(String endpoint) throws IOException {
        HttpURLConnection conn = (HttpURLConnection) new URL(endpoint).openConnection();
        conn.setDoOutput(true);
        conn.setRequestMethod("POST");
        conn.setConnectTimeout(15_000);
        conn.setReadTimeout(30_000);
        return conn;
    }

    private static void appendField(PrintWriter pw, String name, String value) {
        pw.append("--").append(BOUNDARY).append(CRLF);
        pw.append("Content-Disposition: form-data; name=\"").append(name).append("\"")
          .append(CRLF).append(CRLF).append(value).append(CRLF).flush();
    }

    private static String mimeType(String filename) {
        if (filename == null) return "application/octet-stream";
        String lc = filename.toLowerCase(Locale.ROOT);
        if (lc.endsWith(".jpg") || lc.endsWith(".jpeg")) return "image/jpeg";
        if (lc.endsWith(".png"))  return "image/png";
        if (lc.endsWith(".gif"))  return "image/gif";
        if (lc.endsWith(".webp")) return "image/webp";
        if (lc.endsWith(".bmp"))  return "image/bmp";
        return "application/octet-stream";
    }

    private static String readStream(InputStream is) {
        if (is == null) return "";
        try (BufferedReader br =
                new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) sb.append(line);
            return sb.toString();
        } catch (IOException e) {
            return "";
        }
    }

    /**
     * Minimal JSON string-field extractor — avoids Gson/Jackson dependency.
     * Only handles top-level string fields with no escape sequences.
     */
    private static String jsonField(String json, String key) {
        String search = "\"" + key + "\":\"";
        int start = json.indexOf(search);
        if (start < 0) return null;
        start += search.length();
        int end = json.indexOf("\"", start);
        return (end > start) ? json.substring(start, end) : null;
    }

    private static String urlEncode(String value) {
        try {
            return URLEncoder.encode(value, StandardCharsets.UTF_8.name());
        } catch (UnsupportedEncodingException e) {
            return value;
        }
    }
}
