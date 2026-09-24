package com.project.controller.customer;

import com.project.dao.UserDAO;
import com.project.dao.UserDAOImpl;
import com.project.model.User;
import com.project.util.JSoupUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
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

        String action = request.getParameter("action");
        if ("changePassword".equals(action)) {
            handleChangePassword(request, response, currentUser);
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

    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (currentUser.getPasswordHash() == null || currentUser.getPasswordHash().trim().isEmpty()) {
            request.setAttribute("passwordError", "Tài khoản đăng nhập bằng Google không sử dụng mật khẩu hệ thống.");
        } else if (currentPassword == null || !com.project.util.PasswordUtil.checkPassword(currentPassword, currentUser.getPasswordHash())) {
            request.setAttribute("passwordError", "Mật khẩu hiện tại không chính xác.");
        } else if (newPassword == null || newPassword.length() < 6) {
            request.setAttribute("passwordError", "Mật khẩu mới phải có tối thiểu 6 ký tự.");
        } else if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("passwordError", "Xác nhận mật khẩu mới không trùng khớp.");
        } else {
            String newHash = com.project.util.PasswordUtil.hashPassword(newPassword);
            if (userDAO.updatePassword(currentUser.getUserId(), newHash)) {
                currentUser.setPasswordHash(newHash);
                request.setAttribute("passwordSuccess", "Đổi mật khẩu thành công!");
            } else {
                request.setAttribute("passwordError", "Đổi mật khẩu thất bại. Vui lòng thử lại sau.");
            }
        }

        request.setAttribute("activeTab", "profile");
        request.setAttribute("pageTitle", "Hồ sơ cá nhân - Smart Booking Platform");
        request.getRequestDispatcher("/WEB-INF/views/customer/profile.jsp").forward(request, response);
    }
}
