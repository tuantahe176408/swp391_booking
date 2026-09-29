package com.project.controller.customer;

import com.project.dao.UserDAO;
import com.project.dao.UserDAOImpl;
import com.project.model.User;
import com.project.util.JSoupUtil;
import com.project.util.PasswordUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Optional;

/**
 * Controller: Customer Authentication (Login, Register, Logout) (UC01)
 * Package: com.project.controller.customer
 */
@WebServlet(name = "AuthController", urlPatterns = {"/login", "/register", "/logout", "/forgot-password", "/force-change-password"})
public class AuthController extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        this.userDAO = new UserDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/logout".equals(path)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        if ("/forgot-password".equals(path)) {
            request.setAttribute("pageTitle", "Quên mật khẩu - Smart Booking Platform");
            request.getRequestDispatcher("/WEB-INF/views/customer/forgot-password.jsp").forward(request, response);
            return;
        }

        if ("/force-change-password".equals(path)) {
            HttpSession session = request.getSession(false);
            User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

            if (currentUser == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            if (!currentUser.isMustChangePassword()) {
                redirectByRole(request, response, currentUser);
                return;
            }

            request.setAttribute("pageTitle", "Đổi mật khẩu lần đầu - Smart Booking Platform");
            request.getRequestDispatcher("/WEB-INF/views/customer/force-change-password.jsp").forward(request, response);
            return;
        }

        if ("/login".equals(path)) {
            String error = request.getParameter("error");
            if (error != null && !error.trim().isEmpty() && !"unauthorized".equalsIgnoreCase(error.trim())) {
                request.setAttribute("errorMessage", error.trim());
            }
            String redirect = request.getParameter("redirect");
            if (redirect != null && !redirect.trim().isEmpty()) {
                request.setAttribute("redirect", redirect.trim());
            }
            request.setAttribute("activeTab", "login");
            request.setAttribute("pageTitle", "Đăng nhập - Smart Booking Platform");
            request.getRequestDispatcher("/WEB-INF/views/customer/login.jsp").forward(request, response);
        } else if ("/register".equals(path)) {
            String redirect = request.getParameter("redirect");
            if (redirect != null && !redirect.trim().isEmpty()) {
                request.setAttribute("redirect", redirect.trim());
            }
            request.setAttribute("activeTab", "register");
            request.setAttribute("pageTitle", "Đăng ký - Smart Booking Platform");
            request.getRequestDispatcher("/WEB-INF/views/customer/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/login".equals(path)) {
            handleLogin(request, response);
        } else if ("/register".equals(path)) {
            handleRegister(request, response);
        } else if ("/forgot-password".equals(path)) {
            handleForgotPassword(request, response);
        } else if ("/force-change-password".equals(path)) {
            handleForceChangePassword(request, response);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("activeTab", "login");
        String email = JSoupUtil.sanitizeText(request.getParameter("email"));
        String password = request.getParameter("password");
        String redirect = request.getParameter("redirect");
        if (redirect != null && !redirect.trim().isEmpty()) {
            request.setAttribute("redirect", redirect.trim());
        }

        if (email.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ Email và Mật khẩu.");
            request.getRequestDispatcher("/WEB-INF/views/customer/login.jsp").forward(request, response);
            return;
        }

        Optional<User> userOpt = userDAO.findByEmail(email);

        if (userOpt.isPresent()) {
            User user = userOpt.get();
            if (!user.isActive()) {
                request.setAttribute("errorMessage", "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ Admin.");
                request.getRequestDispatcher("/WEB-INF/views/customer/login.jsp").forward(request, response);
                return;
            }

            // If account was created via Google OAuth and has no password hash set
            if (user.getPasswordHash() == null || user.getPasswordHash().trim().isEmpty()) {
                request.setAttribute("errorMessage", "Tài khoản này được đăng ký bằng Google. Vui lòng sử dụng nút Đăng nhập với Google.");
                request.getRequestDispatcher("/WEB-INF/views/customer/login.jsp").forward(request, response);
                return;
            }

            if (PasswordUtil.checkPassword(password, user.getPasswordHash())) {
                HttpSession oldSession = request.getSession(false);
                if (oldSession != null) {
                    oldSession.invalidate();
                }
                HttpSession session = request.getSession(true);
                session.setAttribute("currentUser", user);

                // If user logged in using temporary password, force change password immediately
                if (user.isMustChangePassword()) {
                    response.sendRedirect(request.getContextPath() + "/force-change-password");
                    return;
                }

                redirectAfterAuth(request, response, user, redirect);
                return;
            }
        }

        request.setAttribute("errorMessage", "Email hoặc Mật khẩu không chính xác.");
        request.getRequestDispatcher("/WEB-INF/views/customer/login.jsp").forward(request, response);
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("activeTab", "register");
        String fullName = JSoupUtil.sanitizeText(request.getParameter("fullName"));
        String email = JSoupUtil.sanitizeText(request.getParameter("email"));
        String phone = JSoupUtil.sanitizeText(request.getParameter("phone"));
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String redirect = request.getParameter("redirect");
        if (redirect != null && !redirect.trim().isEmpty()) {
            request.setAttribute("redirect", redirect.trim());
        }

        // Preserve input fields for registration form
        request.setAttribute("regFullName", fullName);
        request.setAttribute("regEmail", email);
        request.setAttribute("regPhone", phone);

        if (fullName.isEmpty() || email.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin bắt buộc.");
            request.getRequestDispatcher("/WEB-INF/views/customer/login.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu xác nhận không trùng khớp.");
            request.getRequestDispatcher("/WEB-INF/views/customer/login.jsp").forward(request, response);
            return;
        }

        if (userDAO.findByEmail(email).isPresent()) {
            request.setAttribute("errorMessage", "Email này đã được đăng ký tài khoản.");
            request.getRequestDispatcher("/WEB-INF/views/customer/login.jsp").forward(request, response);
            return;
        }

        User newUser = new User();
        newUser.setFullName(fullName);
        newUser.setEmail(email);
        newUser.setPhoneNumber(phone);
        newUser.setPasswordHash(PasswordUtil.hashPassword(password));
        newUser.setRole(User.Role.CUSTOMER);
        newUser.setAuthProvider(User.AuthProvider.LOCAL);
        newUser.setActive(true);
        newUser.setEmailVerified(true);

        if (userDAO.insertUser(newUser)) {
            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) {
                oldSession.invalidate();
            }
            HttpSession session = request.getSession(true);
            session.setAttribute("currentUser", newUser);
            redirectAfterAuth(request, response, newUser, redirect);
        } else {
            request.setAttribute("errorMessage", "Đăng ký không thành công. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/WEB-INF/views/customer/login.jsp").forward(request, response);
        }
    }

    private void redirectAfterAuth(HttpServletRequest request, HttpServletResponse response, User user, String redirect)
            throws IOException {
        if (redirect != null && !redirect.trim().isEmpty()) {
            String decodedRedirect = redirect.trim();
            try {
                decodedRedirect = java.net.URLDecoder.decode(decodedRedirect, "UTF-8");
            } catch (Exception ignored) {}

            if (decodedRedirect.startsWith("/") && !decodedRedirect.contains("/login") && !decodedRedirect.contains("/register") && !decodedRedirect.contains("/logout")) {
                boolean allowed = true;
                if (decodedRedirect.startsWith("/admin/") && user.getRole() != User.Role.ADMIN) {
                    allowed = false;
                } else if (decodedRedirect.startsWith("/owner/") && user.getRole() != User.Role.OWNER && user.getRole() != User.Role.ADMIN) {
                    allowed = false;
                } else if (decodedRedirect.startsWith("/reception/") && user.getRole() != User.Role.RECEPTIONIST && user.getRole() != User.Role.OWNER && user.getRole() != User.Role.ADMIN) {
                    allowed = false;
                }

                if (allowed) {
                    response.sendRedirect(request.getContextPath() + decodedRedirect);
                    return;
                }
            }
        }
        redirectByRole(request, response, user);
    }

    private void redirectByRole(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        String redirectUrl = request.getContextPath() + "/home";
        if (user.getRole() != null) {
            switch (user.getRole()) {
                case ADMIN:
                    redirectUrl = request.getContextPath() + "/admin/users";
                    break;
                case OWNER:
                    redirectUrl = request.getContextPath() + "/owner/homestays";
                    break;
                case RECEPTIONIST:
                    redirectUrl = request.getContextPath() + "/reception/checkin";
                    break;
                case CUSTOMER:
                default:
                    redirectUrl = request.getContextPath() + "/home";
                    break;
            }
        }
        response.sendRedirect(redirectUrl);
    }

    private void handleForgotPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = JSoupUtil.sanitizeText(request.getParameter("email"));
        request.setAttribute("email", email);

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập địa chỉ Email.");
            request.setAttribute("pageTitle", "Quên mật khẩu - Smart Booking Platform");
            request.getRequestDispatcher("/WEB-INF/views/customer/forgot-password.jsp").forward(request, response);
            return;
        }

        Optional<User> userOpt = userDAO.findByEmail(email.trim());
        if (!userOpt.isPresent()) {
            request.setAttribute("errorMessage", "Địa chỉ email không tồn tại trong hệ thống.");
            request.setAttribute("pageTitle", "Quên mật khẩu - Smart Booking Platform");
            request.getRequestDispatcher("/WEB-INF/views/customer/forgot-password.jsp").forward(request, response);
            return;
        }

        User user = userOpt.get();
        if (!user.isActive()) {
            request.setAttribute("errorMessage", "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ Quản trị viên.");
            request.setAttribute("pageTitle", "Quên mật khẩu - Smart Booking Platform");
            request.getRequestDispatcher("/WEB-INF/views/customer/forgot-password.jsp").forward(request, response);
            return;
        }

        if (user.getAuthProvider() == User.AuthProvider.GOOGLE && (user.getPasswordHash() == null || user.getPasswordHash().trim().isEmpty())) {
            request.setAttribute("errorMessage", "Tài khoản này được đăng ký bằng Google. Vui lòng sử dụng tính năng Đăng nhập với Google.");
            request.setAttribute("pageTitle", "Quên mật khẩu - Smart Booking Platform");
            request.getRequestDispatcher("/WEB-INF/views/customer/forgot-password.jsp").forward(request, response);
            return;
        }

        String tempPassword = PasswordUtil.generateRandomPassword(10);
        String newHash = PasswordUtil.hashPassword(tempPassword);

        boolean updated = userDAO.updatePassword(user.getUserId(), newHash, true);
        if (updated) {
            com.project.util.EmailUtil.sendForgotPasswordEmail(user.getEmail(), user.getFullName(), tempPassword);
            request.setAttribute("successMessage", "Mật khẩu tạm thời đã được gửi thành công đến email: " + user.getEmail() + ". Vui lòng kiểm tra hòm thư và sử dụng mật khẩu này để đăng nhập.");
            request.setAttribute("tempPasswordSent", true);
            request.setAttribute("generatedTempPassword", tempPassword);
        } else {
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tạo mật khẩu mới. Vui lòng thử lại sau.");
        }

        request.setAttribute("pageTitle", "Quên mật khẩu - Smart Booking Platform");
        request.getRequestDispatcher("/WEB-INF/views/customer/forgot-password.jsp").forward(request, response);
    }

    private void handleForceChangePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (newPassword == null || newPassword.trim().isEmpty() || confirmPassword == null || confirmPassword.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ mật khẩu mới và xác nhận mật khẩu.");
            request.setAttribute("pageTitle", "Đổi mật khẩu lần đầu - Smart Booking Platform");
            request.getRequestDispatcher("/WEB-INF/views/customer/force-change-password.jsp").forward(request, response);
            return;
        }

        if (newPassword.length() < 6) {
            request.setAttribute("errorMessage", "Mật khẩu mới phải có tối thiểu 6 ký tự.");
            request.setAttribute("pageTitle", "Đổi mật khẩu lần đầu - Smart Booking Platform");
            request.getRequestDispatcher("/WEB-INF/views/customer/force-change-password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu xác nhận không trùng khớp.");
            request.setAttribute("pageTitle", "Đổi mật khẩu lần đầu - Smart Booking Platform");
            request.getRequestDispatcher("/WEB-INF/views/customer/force-change-password.jsp").forward(request, response);
            return;
        }

        String newHash = PasswordUtil.hashPassword(newPassword);
        boolean updated = userDAO.updatePassword(currentUser.getUserId(), newHash, false);

        if (updated) {
            currentUser.setPasswordHash(newHash);
            currentUser.setMustChangePassword(false);
            session.setAttribute("currentUser", currentUser);
            redirectAfterAuth(request, response, currentUser, null);
        } else {
            request.setAttribute("errorMessage", "Đổi mật khẩu thất bại. Vui lòng thử lại sau.");
            request.setAttribute("pageTitle", "Đổi mật khẩu lần đầu - Smart Booking Platform");
            request.getRequestDispatcher("/WEB-INF/views/customer/force-change-password.jsp").forward(request, response);
        }
    }
}
