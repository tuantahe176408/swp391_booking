package com.project.util;

import org.jsoup.Jsoup;
import org.jsoup.safety.Safelist;

/**
 * Technical Helper: JSoup Anti-XSS Sanitizer for Rich Text & Reviews
 * Package: com.project.util
 */
public class JSoupUtil {

    public static String sanitizeText(String rawInput) {
        if (rawInput == null) {
            return "";
        }
        return Jsoup.clean(rawInput.trim(), Safelist.none());
    }

    public static String sanitizeBasicHtml(String rawInput) {
        if (rawInput == null) {
            return "";
        }
        return Jsoup.clean(rawInput.trim(), Safelist.basic());
    }
}
