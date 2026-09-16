package com.project.controller.customer;

import com.project.dao.UserDAO;
import com.project.dao.UserDAOImpl;
import com.project.model.User;
import com.project.util.JSoupUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Controller: Manage Customer Profile & Preferences (UC02)
 * Package: com.project.controller.customer
 */
@WebServlet(name = "ProfileController", urlPatterns = {"/customer/profile"})
public class ProfileController extends HttpServlet {

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

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        userDAO.findById(currentUser.getUserId()).ifPresent(user -> session.setAttribute("currentUser", user));

        request.setAttribute("activeTab", "profile");
        request.setAttribute("pageTitle", "Hồ sơ cá nhân - Smart Booking Platform");
        request.getRequestDispatcher("/WEB-INF/views/customer/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String fullName = JSoupUtil.sanitizeText(request.getParameter("fullName"));
        String phoneNumber = JSoupUtil.sanitizeText(request.getParameter("phoneNumber"));
        String avatarUrl = JSoupUtil.sanitizeText(request.getParameter("avatarUrl"));

        currentUser.setFullName(fullName);
        currentUser.setPhoneNumber(phoneNumber);
        if (avatarUrl != null && !avatarUrl.trim().isEmpty()) {
            currentUser.setAvatarUrl(avatarUrl);
        }

        if (userDAO.updateUser(currentUser)) {
            session.setAttribute("currentUser", currentUser);
            request.setAttribute("successMessage", "Cập nhật thông tin hồ sơ thành công!");
        } else {
            request.setAttribute("errorMessage", "Cập nhật hồ sơ thất bại. Vui lòng thử lại!");
        }

        request.setAttribute("activeTab", "profile");
        request.setAttribute("pageTitle", "Hồ sơ cá nhân - Smart Booking Platform");
        request.getRequestDispatcher("/WEB-INF/views/customer/profile.jsp").forward(request, response);
    }
}
