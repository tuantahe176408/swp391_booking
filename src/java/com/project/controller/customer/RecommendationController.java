package com.project.controller.customer;

import com.project.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Controller: AI Smart Feed & Recommendations (UC05)
 * Package: com.project.controller.customer
 */
@WebServlet(name = "RecommendationController", urlPatterns = {"/customer/recommendations"})
public class RecommendationController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute("activeTab", "recommendations");
        request.setAttribute("pageTitle", "Gợi ý AI Thông minh - Smart Booking Platform");
        request.getRequestDispatcher("/WEB-INF/views/customer/recommendations.jsp").forward(request, response);
    }
}
