package com.project.controller.owner;

import com.project.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Controller: View Revenue & Occupancy Analytics (UC20)
 * Package: com.project.controller.owner
 */
@WebServlet(name = "OwnerAnalyticsController", urlPatterns = {"/owner/analytics"})
public class OwnerAnalyticsController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute("activeTab", "analytics");
        request.setAttribute("pageTitle", "Chủ nhà - Báo cáo Doanh thu & Chart.js");
        request.getRequestDispatcher("/WEB-INF/views/owner/analytics.jsp").forward(request, response);
    }
}
