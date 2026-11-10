package com.project.controller.customer;

import com.project.dao.LoyaltyDAO;
import com.project.dao.LoyaltyDAOImpl;
import com.project.model.LoyaltyTransaction;
import com.project.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Controller: Loyalty Points Dashboard (UC-LOYALTY)
 *
 * GET /customer/loyalty — hiển thị điểm thưởng, lịch sử, tier, cách dùng điểm
 *
 * Package: com.project.controller.customer
 */
@WebServlet(name = "LoyaltyController", urlPatterns = {"/customer/loyalty"})
public class LoyaltyController extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    private LoyaltyDAO loyaltyDAO;

    @Override
    public void init() throws ServletException {
        this.loyaltyDAO = new LoyaltyDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=/customer/loyalty");
            return;
        }

        int userId = currentUser.getUserId();

        // Parse page parameter
        int page = 1;
        try {
            String p = request.getParameter("page");
            if (p != null && !p.trim().isEmpty()) page = Math.max(1, Integer.parseInt(p.trim()));
        } catch (NumberFormatException ignored) {}

        int offset = (page - 1) * PAGE_SIZE;

        // Load loyalty data
        int balance     = loyaltyDAO.getBalance(userId);
        int totalEarned = loyaltyDAO.getTotalEarned(userId);
        String tier     = loyaltyDAO.getTier(userId);
        int nextThresh  = LoyaltyDAO.nextTierThreshold(tier);

        // Progress to next tier (0–100 %)
        int progressPct = 0;
        if (nextThresh > 0) {
            // Find lower threshold
            int prevThresh = "SILVER".equals(tier) ? 1_000
                           : "GOLD".equals(tier)   ? 5_000
                           : "PLATINUM".equals(tier) ? 15_000 : 0;
            int range = nextThresh - prevThresh;
            if (range > 0) progressPct = Math.min(100, (totalEarned - prevThresh) * 100 / range);
        } else {
            progressPct = 100; // already PLATINUM
        }

        List<LoyaltyTransaction> history = loyaltyDAO.getHistory(userId, offset, PAGE_SIZE);
        int totalCount  = loyaltyDAO.countHistory(userId);
        int totalPages  = (int) Math.ceil((double) totalCount / PAGE_SIZE);

        // Update session user with fresh loyalty data
        currentUser.setLoyaltyPointsBalance(balance);
        currentUser.setLoyaltyTotalEarned(totalEarned);
        currentUser.setLoyaltyTier(tier);
        session.setAttribute("currentUser", currentUser);

        // Set attributes for JSP
        request.setAttribute("balance",      balance);
        request.setAttribute("totalEarned",  totalEarned);
        request.setAttribute("tier",         tier);
        request.setAttribute("nextThresh",   nextThresh);
        request.setAttribute("progressPct",  progressPct);
        request.setAttribute("history",      history);
        request.setAttribute("currentPage",  page);
        request.setAttribute("totalPages",   totalPages);
        request.setAttribute("activeTab",    "loyalty");
        request.setAttribute("pageTitle",    "Điểm thưởng Loyalty - Smart Booking Platform");

        request.getRequestDispatcher("/WEB-INF/views/customer/loyalty.jsp")
               .forward(request, response);
    }
}
