package com.project.controller.admin;

import com.project.dao.UserDAO;
import com.project.dao.UserDAOImpl;
import com.project.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Controller: Manage Users & Account Permissions / RBAC (UC22)
 * Package: com.project.controller.admin
 */
@WebServlet(name = "AdminUserController", urlPatterns = {"/admin/users"})
public class AdminUserController extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        this.userDAO = new UserDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null || currentUser.getRole() != User.Role.ADMIN) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Admin Privilege Required");
            return;
        }

        List<User> userList = userDAO.findAll(0, 50);
        int totalUsers = userDAO.countAll();

        request.setAttribute("userList", userList);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("activeTab", "users");
        request.setAttribute("pageTitle", "Admin - Quản lý Người dùng & Phân quyền");
        request.getRequestDispatcher("/WEB-INF/views/admin/user-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String userIdStr = request.getParameter("userId");

        if (userIdStr != null && !userIdStr.trim().isEmpty()) {
            int userId = Integer.parseInt(userIdStr);
            if ("ban".equals(action)) {
                userDAO.updateLockStatus(userId, false);
            } else if ("unban".equals(action)) {
                userDAO.updateLockStatus(userId, true);
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
}
