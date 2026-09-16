package com.project.controller.reception;

import com.project.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Controller: Daily Guest List & Housekeeping Management (UC16)
 * Package: com.project.controller.reception
 */
@WebServlet(name = "HousekeepingController", urlPatterns = {"/reception/daily-report"})
public class HousekeepingController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute("activeTab", "housekeeping");
        request.setAttribute("pageTitle", "Lễ tân - Báo cáo Tạm trú & Dọn dẹp");
        request.getRequestDispatcher("/WEB-INF/views/reception/daily-report.jsp").forward(request, response);
    }
}
