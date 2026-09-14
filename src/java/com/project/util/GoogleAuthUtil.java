package com.project.util;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.project.config.GoogleAuthConfig;
import com.project.model.GoogleAccountDTO;

import java.io.IOException;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Utility helper for Google OAuth 2.0 flow
 * Standard Java 17 HttpClient & Gson JSON Parser
 * Package: com.project.util
 */
public class GoogleAuthUtil {

    private static final Logger LOGGER = Logger.getLogger(GoogleAuthUtil.class.getName());
    private static final HttpClient HTTP_CLIENT = HttpClient.newBuilder()
            .version(HttpClient.Version.HTTP_2)
            .connectTimeout(Duration.ofSeconds(10))
            .build();
    private static final Gson GSON = new Gson();

    /**
     * Build Google OAuth2 authorization URL
     *
     * @param state Anti-CSRF state token
     * @return Full redirect URL to Google OAuth consent
     */
    public static String buildAuthUrl(String state) {
        return GoogleAuthConfig.GOOGLE_AUTH_URL + "?"
                + "client_id=" + URLEncoder.encode(GoogleAuthConfig.GOOGLE_CLIENT_ID, StandardCharsets.UTF_8)
                + "&redirect_uri=" + URLEncoder.encode(GoogleAuthConfig.GOOGLE_REDIRECT_URI, StandardCharsets.UTF_8)
                + "&response_type=code"
                + "&scope=" + URLEncoder.encode(GoogleAuthConfig.GOOGLE_SCOPE, StandardCharsets.UTF_8)
                + "&state=" + URLEncoder.encode(state, StandardCharsets.UTF_8)
                + "&access_type=online"
                + "&prompt=select_account";
    }

    /**
     * Exchange authorization code for access_token
     *
     * @param code Authorization code from Google redirect
     * @return Access token string or null if exchange failed
     */
    public static String getAccessToken(String code) {
        try {
            String requestBody = "code=" + URLEncoder.encode(code, StandardCharsets.UTF_8)
                    + "&client_id=" + URLEncoder.encode(GoogleAuthConfig.GOOGLE_CLIENT_ID, StandardCharsets.UTF_8)
                    + "&client_secret=" + URLEncoder.encode(GoogleAuthConfig.GOOGLE_CLIENT_SECRET, StandardCharsets.UTF_8)
                    + "&redirect_uri=" + URLEncoder.encode(GoogleAuthConfig.GOOGLE_REDIRECT_URI, StandardCharsets.UTF_8)
                    + "&grant_type=authorization_code";

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(GoogleAuthConfig.GOOGLE_TOKEN_URL))
                    .header("Content-Type", "application/x-www-form-urlencoded")
                    .header("Accept", "application/json")
                    .timeout(Duration.ofSeconds(10))
                    .POST(HttpRequest.BodyPublishers.ofString(requestBody))
                    .build();

            HttpResponse<String> response = HTTP_CLIENT.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() == 200) {
                JsonObject jsonObject = JsonParser.parseString(response.body()).getAsJsonObject();
                if (jsonObject.has("access_token")) {
                    return jsonObject.get("access_token").getAsString();
                }
            } else {
                LOGGER.log(Level.WARNING, "Google Token exchange failed with status {0}: {1}",
                        new Object[]{response.statusCode(), response.body()});
            }
        } catch (IOException | InterruptedException e) {
            LOGGER.log(Level.SEVERE, "Exception during Google Token exchange", e);
            Thread.currentThread().interrupt();
        }
        return null;
    }

    /**
     * Fetch user profile from Google UserInfo endpoint
     *
     * @param accessToken Valid Google access token
     * @return GoogleAccountDTO or null if failed
     */
    public static GoogleAccountDTO getUserInfo(String accessToken) {
        try {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(GoogleAuthConfig.GOOGLE_USER_INFO_URL))
                    .header("Authorization", "Bearer " + accessToken)
                    .header("Accept", "application/json")
                    .timeout(Duration.ofSeconds(10))
                    .GET()
                    .build();

            HttpResponse<String> response = HTTP_CLIENT.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() == 200) {
                return GSON.fromJson(response.body(), GoogleAccountDTO.class);
            } else {
                LOGGER.log(Level.WARNING, "Google UserInfo request failed with status {0}: {1}",
                        new Object[]{response.statusCode(), response.body()});
            }
        } catch (IOException | InterruptedException e) {
            LOGGER.log(Level.SEVERE, "Exception during Google UserInfo fetch", e);
            Thread.currentThread().interrupt();
        }
        return null;
    }
}
