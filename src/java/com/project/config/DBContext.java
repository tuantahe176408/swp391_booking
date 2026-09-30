package com.project.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Database Context Connection Manager
 * Standard NetBeans JSP/Servlet MVC Architecture (SWP391)
 * Package: com.project.config
 */
public class DBContext {

    private static final Logger LOGGER = Logger.getLogger(DBContext.class.getName());

    // ── Connection Parameters ─────────────────────────────────────────────────
    // Priority: environment variable > db.properties on classpath > hardcoded default
    private static final String DB_HOST;
    private static final String DB_PORT;
    private static final String DB_NAME;
    private static final String DB_USER;
    private static final String DB_PASS;
    // SSL=true required for cloud DBs (TiDB Serverless, PlanetScale, Railway…)
    // SSL=false for local dev. Set DB_SSL=true env var when deploying to cloud.
    private static final boolean DB_SSL;

    static {
        // 1. Try env vars
        String host = System.getenv("DB_HOST");
        String port = System.getenv("DB_PORT");
        String name = System.getenv("DB_NAME");
        String user = System.getenv("DB_USER");
        String pass = System.getenv("DB_PASS");
        String ssl  = System.getenv("DB_SSL");

        // 2. Fall back to db.properties on classpath
        if (host == null || user == null) {
            try (java.io.InputStream is = DBContext.class.getClassLoader()
                    .getResourceAsStream("db.properties")) {
                if (is != null) {
                    java.util.Properties p = new java.util.Properties();
                    p.load(is);
                    if (host == null) host = p.getProperty("DB_HOST");
                    if (port == null) port = p.getProperty("DB_PORT");
                    if (name == null) name = p.getProperty("DB_NAME");
                    if (user == null) user = p.getProperty("DB_USER");
                    if (pass == null) pass = p.getProperty("DB_PASS");
                    if (ssl  == null) ssl  = p.getProperty("DB_SSL");
                }
            } catch (java.io.IOException ignored) {}
        }

        // 3. Hardcoded defaults (local dev)
        DB_HOST = (host != null && !host.isBlank()) ? host : "localhost";
        DB_PORT = (port != null && !port.isBlank()) ? port : "3306";
        DB_NAME = (name != null && !name.isBlank()) ? name : "smart_booking_db";
        DB_USER = (user != null && !user.isBlank()) ? user : "root";
        DB_PASS = (pass != null && !pass.isBlank()) ? pass : "123456";
        DB_SSL  = "true".equalsIgnoreCase(ssl);
    }

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            try {
                Class.forName("com.mysql.jdbc.Driver");
            } catch (ClassNotFoundException ex) {
                LOGGER.log(Level.SEVERE, "MySQL JDBC Driver not found in classpath!", ex);
            }
        }
    }

    /**
     * Obtains a SQL Connection using JDBC DriverManager.
     * Always close Connection objects in a try-with-resources block.
     *
     * SSL is controlled by the DB_SSL env var (or db.properties):
     *   DB_SSL=false  → local dev (default)
     *   DB_SSL=true   → cloud databases (TiDB Serverless, PlanetScale, Railway…)
     */
    public static Connection getConnection() throws SQLException {
        String sslParams = DB_SSL
                ? "useSSL=true&requireSSL=true&verifyServerCertificate=true"
                : "useSSL=false&allowPublicKeyRetrieval=true";

        String jdbcUrl = String.format(
                "jdbc:mysql://%s:%s/%s?%s&serverTimezone=Asia/Ho_Chi_Minh&useUnicode=true&characterEncoding=UTF-8",
                DB_HOST, DB_PORT, DB_NAME, sslParams);

        return DriverManager.getConnection(jdbcUrl, DB_USER, DB_PASS);
    }
}
