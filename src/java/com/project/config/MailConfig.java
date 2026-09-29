package com.project.config;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Mail / SMTP Configuration Manager
 * Reads credentials from Classpath, System Properties, Environment Variables, or mail.properties
 * Package: com.project.config
 */
public class MailConfig {

    private static final Logger LOGGER = Logger.getLogger(MailConfig.class.getName());
    private static final Properties PROPS = new Properties();

    static {
        loadProperties();
    }

    public static synchronized void loadProperties() {
        PROPS.clear();

        String[] candidatePaths = new String[]{
            "mail.properties",
            "src/java/mail.properties",
            "build/web/WEB-INF/classes/mail.properties",
            "web/WEB-INF/mail.properties",
            "../mail.properties"
        };

        boolean configuredFileLoaded = false;
        for (String path : candidatePaths) {
            File file = new File(path);
            if (file.exists() && file.isFile()) {
                try (InputStream is = new FileInputStream(file)) {
                    Properties p = new Properties();
                    p.load(is);
                    String email = p.getProperty("mail.sender.email");
                    if (email != null && !email.contains("your_email") && !email.trim().isEmpty()) {
                        PROPS.putAll(p);
                        configuredFileLoaded = true;
                        LOGGER.log(Level.INFO, "Mail configuration loaded from active file: {0} ({1})", new Object[]{file.getAbsolutePath(), email});
                        break;
                    } else if (PROPS.isEmpty() && !p.isEmpty()) {
                        PROPS.putAll(p);
                    }
                } catch (Exception e) {
                    LOGGER.log(Level.WARNING, "Failed reading mail.properties from " + path, e);
                }
            }
        }

        if (!configuredFileLoaded) {
            try (InputStream is = MailConfig.class.getClassLoader().getResourceAsStream("mail.properties")) {
                if (is != null) {
                    Properties cpProps = new Properties();
                    cpProps.load(is);
                    String email = cpProps.getProperty("mail.sender.email");
                    if (email != null && !email.contains("your_email") && !email.trim().isEmpty()) {
                        PROPS.putAll(cpProps);
                        LOGGER.info("Mail configuration loaded from classpath (mail.properties).");
                    }
                }
            } catch (Exception ignored) {}
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

    public static String getSmtpHost() {
        return getSetting("MAIL_SMTP_HOST", "mail.smtp.host", "smtp.gmail.com");
    }

    public static int getSmtpPort() {
        try {
            return Integer.parseInt(getSetting("MAIL_SMTP_PORT", "mail.smtp.port", "587"));
        } catch (Exception e) {
            return 587;
        }
    }

    public static String getSenderEmail() {
        return getSetting("MAIL_SENDER_EMAIL", "mail.sender.email", "");
    }

    public static String getSenderPassword() {
        return getSetting("MAIL_SENDER_PASSWORD", "mail.sender.password", "");
    }

    public static String getSenderName() {
        return getSetting("MAIL_SENDER_NAME", "mail.sender.name", "Smart Booking Platform");
    }

    public static boolean isConfigured() {
        loadProperties(); // refresh in case user edited file
        String email = getSenderEmail();
        String pass = getSenderPassword();
        return email != null && !email.trim().isEmpty() && !email.contains("your_email") 
            && pass != null && !pass.trim().isEmpty() && !pass.contains("your_gmail_app_password");
    }
}
