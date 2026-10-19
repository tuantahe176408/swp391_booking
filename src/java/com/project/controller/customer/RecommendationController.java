package com.project.controller.customer;

import com.project.dao.HomestayDAO;
import com.project.dao.HomestayDAOImpl;
import com.project.model.Homestay;
import com.project.model.User;
import com.project.util.GeminiAIUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Controller: AI Smart Feed & Recommendations (UC05)
 * Package: com.project.controller.customer
 */
@WebServlet(name = "RecommendationController", urlPatterns = {"/customer/recommendations"})
public class RecommendationController extends HttpServlet {

    private HomestayDAO homestayDAO;

    @Override
    public void init() throws ServletException {
        this.homestayDAO = new HomestayDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Homestay> recommendations = homestayDAO.getRecommendedHomestays(currentUser.getUserId(), 6);

        // ── AI Reranking (UC27) ──────────────────────────────────────────
        boolean aiReranked = false;
        if (GeminiAIUtil.isEnabled() && !recommendations.isEmpty()) {
            // Build user context from session preferences (user_preferences already queried inside DAO)
            // Use the first reasonTag as a proxy for detected preferences; guard against null (cold-start)
            String rawCtx = recommendations.get(0).getReasonTag();
            String userCtx = (rawCtx != null) ? rawCtx : "Không rõ sở thích";
            List<Homestay> aiList = GeminiAIUtil.rerankForRecommendations(recommendations, userCtx);
            if (aiList != null) {
                recommendations = aiList;
                aiReranked = true;
            }
        }
        // ── /AI Reranking ────────────────────────────────────────────────

        request.setAttribute("aiReranked", aiReranked);
        request.setAttribute("recommendations", recommendations);
        request.setAttribute("activeTab", "recommendations");
        request.setAttribute("pageTitle", "Gợi ý AI Thông minh - Smart Booking Platform");
        request.getRequestDispatcher("/WEB-INF/views/customer/recommendations.jsp").forward(request, response);
    }
}
