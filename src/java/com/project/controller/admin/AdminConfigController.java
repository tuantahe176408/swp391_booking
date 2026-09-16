package com.project.controller.admin;

import com.project.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Controller: System Configuration & AI Monitoring (UC24)
 * Package: com.project.controller.admin
 */
@WebServlet(name = "AdminConfigController", urlPatterns = {"/admin/config"})
public class AdminConfigController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null || currentUser.getRole() != User.Role.ADMIN) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Admin Privilege Required");
            return;
        }

        request.setAttribute("activeTab", "config");
        request.setAttribute("pageTitle", "Admin - Cấu hình Hệ thống & AI");
        request.getRequestDispatcher("/WEB-INF/views/admin/config.jsp").forward(request, response);
    }
}
