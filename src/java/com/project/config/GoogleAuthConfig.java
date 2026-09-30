package com.project.config;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Google OAuth 2.0 Configuration Constants
 * Reads credentials securely from Classpath, Environment Variables, System Properties, or local application.properties
 * Package: com.project.config
 */
public class GoogleAuthConfig {

    private static final Logger LOGGER = Logger.getLogger(GoogleAuthConfig.class.getName());
    private static final Properties PROPS = new Properties();

    static {
        boolean loaded = false;

        // 1. Try loading from Classpath (e.g. WEB-INF/classes/application.properties)
        try (InputStream is = GoogleAuthConfig.class.getClassLoader().getResourceAsStream("application.properties")) {
            if (is != null) {
                Properties p = new Properties();
                p.load(is);
                String clientId = p.getProperty("google.client.id");
                if (clientId != null && !clientId.contains("YOUR_GOOGLE_CLIENT_ID") && !clientId.trim().isEmpty()) {
                    PROPS.putAll(p);
                    loaded = true;
                    LOGGER.info("Google OAuth configuration loaded successfully from classpath (application.properties).");
                } else if (PROPS.isEmpty() && !p.isEmpty()) {
                    PROPS.putAll(p);
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.FINE, "Could not load application.properties from classLoader", e);
        }

        // 2. Try loading from filesystem locations
        if (!loaded) {
            String[] candidatePaths = new String[]{
                "application.properties",
                "src/java/application.properties",
                "web/WEB-INF/application.properties",
                "../application.properties"
            };

            for (String path : candidatePaths) {
                File file = new File(path);
                if (file.exists() && file.isFile()) {
                    try (InputStream is = new FileInputStream(file)) {
                        PROPS.load(is);
                        loaded = true;
                        LOGGER.log(Level.INFO, "Google OAuth configuration loaded from file: {0}", file.getAbsolutePath());
                        break;
                    } catch (Exception e) {
                        LOGGER.log(Level.WARNING, "Failed reading config from " + path, e);
                    }
                }
            }
        }
    }

    private static String getSetting(String envKey, String propKey, String defaultValue) {
        String envVal = System.getenv(envKey);
        if (envVal != null && !envVal.trim().isEmpty()) {
            return envVal.trim();
        }
        String sysProp = System.getProperty(propKey);
        if (sysProp != null && !sysProp.trim().isEmpty()) {
            return sysProp.trim();
        }
        String fileProp = PROPS.getProperty(propKey);
        if (fileProp != null && !fileProp.trim().isEmpty()) {
            return fileProp.trim();
        }
        return defaultValue;
    }

    public static final String GOOGLE_CLIENT_ID = getSetting(
            "GOOGLE_CLIENT_ID",
            "google.client.id",
            "YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com"
    );

    public static final String GOOGLE_CLIENT_SECRET = getSetting(
            "GOOGLE_CLIENT_SECRET",
            "google.client.secret",
            "YOUR_GOOGLE_CLIENT_SECRET"
    );

    public static final String GOOGLE_REDIRECT_URI = getSetting(
            "GOOGLE_REDIRECT_URI",
            "google.redirect.uri",
            "http://localhost:8080/auth/google/callback"
    );

    public static final String GOOGLE_AUTH_URL = "https://accounts.google.com/o/oauth2/v2/auth";
    public static final String GOOGLE_TOKEN_URL = "https://oauth2.googleapis.com/token";
    public static final String GOOGLE_USER_INFO_URL = "https://www.googleapis.com/oauth2/v3/userinfo";
    public static final String GOOGLE_SCOPE = "openid email profile";
}
