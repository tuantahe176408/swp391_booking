package com.project.config;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Google OAuth 2.0 Configuration Constants
 * Reads credentials securely from Environment Variables, System Properties, or local oauth.properties
 * Package: com.project.config
 */
public class GoogleAuthConfig {

    private static final Logger LOGGER = Logger.getLogger(GoogleAuthConfig.class.getName());
    private static final Properties PROPS = new Properties();

    static {
        // Attempt to load from local oauth.properties (untracked in Git)
        File propFile = new File("oauth.properties");
        if (propFile.exists()) {
            try (InputStream is = new FileInputStream(propFile)) {
                PROPS.load(is);
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Could not load local oauth.properties", e);
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
