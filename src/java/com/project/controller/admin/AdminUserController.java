package com.project.controller.admin;

import com.project.dao.UserDAO;
import com.project.dao.UserDAOImpl;
import com.project.model.User;
import com.project.util.PasswordUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
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

    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null || currentUser.getRole() != User.Role.ADMIN) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Admin Privilege Required");
            return;
        }

        // Parse search & filter parameters
        String keyword = request.getParameter("keyword");
        String role    = request.getParameter("role");
        String status  = request.getParameter("status");
        String pageStr = request.getParameter("page");

        if (keyword != null && keyword.trim().isEmpty()) keyword = null;
        if (role != null && role.trim().isEmpty()) role = null;
        if (status != null && status.trim().isEmpty()) status = null;

        Boolean isActive = null;
        if ("ACTIVE".equalsIgnoreCase(status)) {
            isActive = true;
        } else if ("BANNED".equalsIgnoreCase(status)) {
            isActive = false;
        }

        int page = 1;
        if (pageStr != null) {
            try {
                page = Math.max(1, Integer.parseInt(pageStr.trim()));
            } catch (NumberFormatException ignored) {}
        }
        int offset = (page - 1) * PAGE_SIZE;

        int totalUsers = userDAO.countAll();
        List<User> userList = userDAO.searchUsers(keyword, role, isActive, offset, PAGE_SIZE);
        int totalRows = userDAO.countSearchUsers(keyword, role, isActive);
        int totalPages = (totalRows == 0) ? 1 : (int) Math.ceil((double) totalRows / PAGE_SIZE);

        request.setAttribute("userList",       userList);
        request.setAttribute("totalUsers",     totalUsers);
        request.setAttribute("totalRows",      totalRows);
        request.setAttribute("totalPages",     totalPages);
        request.setAttribute("currentPage",    page);
        request.setAttribute("pageSize",       PAGE_SIZE);

        // Retain filter state
        request.setAttribute("filterKeyword",  keyword);
        request.setAttribute("filterRole",     role);
        request.setAttribute("filterStatus",   status);

        request.setAttribute("activeTab",      "users");
        request.setAttribute("pageTitle",      "Admin - Quản lý Người dùng & Phân quyền");
        request.getRequestDispatcher("/WEB-INF/views/admin/user-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        String userIdStr = request.getParameter("userId");

        if (userIdStr != null && !userIdStr.trim().isEmpty()) {
            int userId = Integer.parseInt(userIdStr);
            if ("ban".equals(action)) {
                // UC22: Protect admin accounts from being banned
                java.util.Optional<User> targetUser = userDAO.findById(userId);
                if (targetUser.isPresent() && targetUser.get().getRole() == User.Role.ADMIN) {
                    session.setAttribute("adminErrorMessage", "Không thể khóa tài khoản Quản trị viên (ADMIN)!");
                    response.sendRedirect(request.getContextPath() + "/admin/users");
                    return;
                }
                userDAO.updateLockStatus(userId, false);
            } else if ("unban".equals(action)) {
                userDAO.updateLockStatus(userId, true);
            }
        }

        // ── Tạo người dùng mới ──────────────────────────────────────────────
        if ("create".equals(action)) {
            request.setCharacterEncoding("UTF-8");
            String fullName    = trim(request.getParameter("fullName"));
            String email       = trim(request.getParameter("email"));
            String phone       = trim(request.getParameter("phone"));
            String password    = trim(request.getParameter("password"));
            String roleParam   = trim(request.getParameter("role"));

            // Validate
            if (fullName.isEmpty() || email.isEmpty() || password.isEmpty() || roleParam.isEmpty()) {
                session.setAttribute("adminErrorMessage", "Vui lòng điền đầy đủ các trường bắt buộc.");
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }
            if (password.length() < 6) {
                session.setAttribute("adminErrorMessage", "Mật khẩu phải có ít nhất 6 ký tự.");
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }
            // Check email duplicate
            if (userDAO.findByEmail(email).isPresent()) {
                session.setAttribute("adminErrorMessage", "Email \"" + email + "\" đã tồn tại trong hệ thống.");
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }

            User.Role newRole;
            try { newRole = User.Role.valueOf(roleParam.toUpperCase()); }
            catch (IllegalArgumentException e) {
                session.setAttribute("adminErrorMessage", "Vai trò không hợp lệ: " + roleParam);
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }

            User newUser = new User();
            newUser.setFullName(fullName);
            newUser.setEmail(email);
            newUser.setPhoneNumber(phone.isEmpty() ? null : phone);
            newUser.setPasswordHash(PasswordUtil.hashPassword(password));
            newUser.setRole(newRole);
            newUser.setActive(false);          // inactive until OTP verified
            newUser.setEmailVerified(false);   // unverified until OTP
            newUser.setMustChangePassword(true); // force change after activation

            boolean ok = userDAO.insertUser(newUser);
            if (ok) {
                // Lấy userId vừa tạo để tạo OTP
                java.util.Optional<User> created = userDAO.findByEmail(email);
                if (created.isPresent()) {
                    com.project.dao.OtpDAOImpl otpDAO = new com.project.dao.OtpDAOImpl();
                    String otpCode = otpDAO.createOtp(created.get().getUserId(), "LOGIN");
                    com.project.util.EmailUtil.sendActivationOtpEmail(email, fullName, otpCode);
                }
                session.setAttribute("adminSuccessMessage",
                    "Tạo tài khoản thành công cho \"" + fullName + "\" (" + newRole.name() + "). " +
                    "Email kích hoạt đã gửi đến " + email + ".");
            } else {
                session.setAttribute("adminErrorMessage", "Tạo tài khoản thất bại. Vui lòng thử lại.");
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private String trim(String s) { return s != null ? s.trim() : ""; }
}
