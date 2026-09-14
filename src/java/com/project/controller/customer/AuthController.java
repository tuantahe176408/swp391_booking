package com.project.controller.customer;

import com.project.dao.UserDAO;
import com.project.dao.UserDAOImpl;
import com.project.model.User;
import com.project.util.JSoupUtil;
import com.project.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Optional;

/**
 * Controller: Customer Authentication (Login, Register, Logout) (UC01)
 * Package: com.project.controller.customer
 */
@WebServlet(name = "AuthController", urlPatterns = {"/login", "/register", "/logout"})
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

        if ("/login".equals(path)) {
            String error = request.getParameter("error");
            if (error != null && !error.trim().isEmpty()) {
                request.setAttribute("errorMessage", error.trim());
            }
            request.setAttribute("pageTitle", "Đăng nhập - Smart Booking Platform");
            request.getRequestDispatcher("/WEB-INF/views/customer/login.jsp").forward(request, response);
        } else if ("/register".equals(path)) {
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
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = JSoupUtil.sanitizeText(request.getParameter("email"));
        String password = request.getParameter("password");

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

            if (PasswordUtil.checkPassword(password, user.getPasswordHash())) {
                HttpSession session = request.getSession(true);
                session.setAttribute("currentUser", user);

                // Redirect based on user role
                switch (user.getRole()) {
                    case ADMIN:
                        response.sendRedirect(request.getContextPath() + "/admin/users");
                        break;
                    case OWNER:
                        response.sendRedirect(request.getContextPath() + "/owner/homestays");
                        break;
                    case RECEPTIONIST:
                        response.sendRedirect(request.getContextPath() + "/reception/checkin");
                        break;
                    default:
                        response.sendRedirect(request.getContextPath() + "/home");
                        break;
                }
                return;
            }
        }

        request.setAttribute("errorMessage", "Email hoặc Mật khẩu không chính xác.");
        request.getRequestDispatcher("/WEB-INF/views/customer/login.jsp").forward(request, response);
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = JSoupUtil.sanitizeText(request.getParameter("fullName"));
        String email = JSoupUtil.sanitizeText(request.getParameter("email"));
        String phone = JSoupUtil.sanitizeText(request.getParameter("phone"));
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

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
            HttpSession session = request.getSession(true);
            session.setAttribute("currentUser", newUser);
            response.sendRedirect(request.getContextPath() + "/home?register=success");
        } else {
            request.setAttribute("errorMessage", "Đăng ký không thành công. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/WEB-INF/views/customer/login.jsp").forward(request, response);
        }
    }
}
