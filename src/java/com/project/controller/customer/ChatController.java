package com.project.controller.customer;

import com.project.util.GeminiAIUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * UC27 – AI Chatbox Controller.
 * Endpoint: /chat
 * Session key "CHAT_HISTORY" stores conversation (max 20 entries).
 * Not behind AuthenticationFilter — accessible to all users (including guests).
 */
@WebServlet(name = "ChatController", urlPatterns = {"/chat"})
public class ChatController extends HttpServlet {

    /** Session attribute key for chat history. */
    private static final String SESSION_KEY = "CHAT_HISTORY";

    /** Maximum history entries (10 turns = 20 messages) before oldest are trimmed. */
    private static final int MAX_HISTORY = 20;

    /**
     * GET /chat?check=enabled → JSON {"enabled": true/false}
     * Used by chatbox.js on page load to decide whether to show the widget.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control", "no-cache");
        try (PrintWriter out = response.getWriter()) {
            out.write("{\"enabled\":" + GeminiAIUtil.isEnabled() + "}");
        }
    }

    /**
     * POST /chat
     * Params: message=&lt;String&gt; (required)
     * Returns: JSON {"reply":"...", "error":false} or {"reply":"...fallback...", "error":true}
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control", "no-cache");

        String message = request.getParameter("message");
        if (message == null || message.isBlank()) {
            response.setStatus(400);
            try (PrintWriter out = response.getWriter()) {
                out.write("{\"reply\":\"Vui lòng nhập tin nhắn.\",\"error\":true}");
            }
            return;
        }
        message = message.trim();

        // Retrieve or create history from session
        HttpSession session = request.getSession(true);
        @SuppressWarnings("unchecked")
        List<Map<String, String>> history =
                (List<Map<String, String>>) session.getAttribute(SESSION_KEY);
        if (history == null) {
            history = new ArrayList<>();
            session.setAttribute(SESSION_KEY, history);
        }

        // Trim history to max
        while (history.size() >= MAX_HISTORY) {
            history.remove(0);
        }

        String reply = GeminiAIUtil.chat(message, new ArrayList<>(history));

        if (reply != null) {
            // Persist this turn to session history
            Map<String, String> userTurn = new HashMap<>();
            userTurn.put("role", "user");
            userTurn.put("text", message);
            history.add(userTurn);

            Map<String, String> modelTurn = new HashMap<>();
            modelTurn.put("role", "model");
            modelTurn.put("text", reply);
            history.add(modelTurn);

            // Serialize reply safely — escape backslash, quote, newlines
            String safe = reply.replace("\\", "\\\\")
                               .replace("\"", "\\\"")
                               .replace("\n", "\\n")
                               .replace("\r", "");
            try (PrintWriter out = response.getWriter()) {
                out.write("{\"reply\":\"" + safe + "\",\"error\":false}");
            }
        } else {
            try (PrintWriter out = response.getWriter()) {
                out.write("{\"reply\":\"Xin lỗi, trợ lý AI tạm thời không khả dụng. Vui lòng thử lại sau.\",\"error\":true}");
            }
        }
    }
}
