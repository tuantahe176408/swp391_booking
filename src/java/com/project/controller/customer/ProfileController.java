package com.project.controller.customer;

import com.project.dao.UserDAO;
import com.project.dao.UserDAOImpl;
import com.project.model.User;
import com.project.util.CloudinaryUtil;
import com.project.util.JSoupUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Controller: Manage Customer Profile, Avatar Upload & Preferences (UC02)
 *
 * GET  /customer/profile — show profile form
 * POST /customer/profile — update info (+ optional avatar file upload)
 * POST /customer/profile (action=changePassword) — change password
 *
 * Avatar priority:
 *  1. If a file is uploaded → upload to Cloudinary, use returned URL
 *  2. Else if avatarUrl text field is non-empty → use that URL
 *  3. Else keep existing avatar unchanged
 *
 * Package: com.project.controller.customer
 */
@WebServlet(name = "ProfileController", urlPatterns = {"/profile", "/customer/profile"})
@MultipartConfig(
    fileSizeThreshold = 512 * 1024,       // 512 KB buffer before disk
    maxFileSize       = 5 * 1024 * 1024,  // 5 MB per avatar
    maxRequestSize    = 10 * 1024 * 1024  // 10 MB total
)
public class ProfileController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ProfileController.class.getName());
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        this.userDAO = new UserDAOImpl();
    }

    // ── GET ───────────────────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Refresh from DB to get latest data
        userDAO.findById(currentUser.getUserId())
               .ifPresent(u -> session.setAttribute("currentUser", u));

        request.setAttribute("activeTab", "profile");
        request.setAttribute("pageTitle", "Hồ sơ cá nhân - Smart Booking Platform");
        request.getRequestDispatcher("/WEB-INF/views/customer/profile.jsp")
               .forward(request, response);
    }

    // ── POST ──────────────────────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

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

        // ── Update profile info + optional avatar ─────────────────────────────
        String fullName    = JSoupUtil.sanitizeText(request.getParameter("fullName"));
        String phoneNumber = JSoupUtil.sanitizeText(request.getParameter("phoneNumber"));

        currentUser.setFullName(fullName);
        currentUser.setPhoneNumber(phoneNumber);

        // Resolve new avatar URL: file upload > URL text field > keep existing
        String newAvatarUrl = resolveAvatarUrl(request, currentUser);
        if (newAvatarUrl != null) {
            currentUser.setAvatarUrl(newAvatarUrl);
        }

        if (userDAO.updateUser(currentUser)) {
            session.setAttribute("currentUser", currentUser);
            request.setAttribute("successMessage", "Cập nhật thông tin hồ sơ thành công!");
        } else {
            request.setAttribute("errorMessage", "Cập nhật hồ sơ thất bại. Vui lòng thử lại!");
        }

        request.setAttribute("activeTab", "profile");
        request.setAttribute("pageTitle", "Hồ sơ cá nhân - Smart Booking Platform");
        request.getRequestDispatcher("/WEB-INF/views/customer/profile.jsp")
               .forward(request, response);
    }

    // =========================================================================
    // PRIVATE HELPERS
    // =========================================================================

    /**
     * Determine the new avatar URL to store.
     * Returns null if neither a file nor a non-empty URL was provided (keep existing).
     */
    private String resolveAvatarUrl(HttpServletRequest request, User currentUser) {
        // 1. Try file upload first
        try {
            Part avatarPart = request.getPart("avatarFile");
            if (avatarPart != null && avatarPart.getSize() > 0) {
                String filename = getSubmittedFilename(avatarPart);
                if (isImage(filename)) {
                    String uploaded = CloudinaryUtil.uploadImage(
                            avatarPart.getInputStream(),
                            filename,
                            "avatars"
                    );
                    if (uploaded != null) {
                        LOGGER.info("[ProfileController] Avatar uploaded: " + uploaded);
                        return uploaded;
                    }
                    LOGGER.warning("[ProfileController] Cloudinary upload failed for: " + filename);
                }
            }
        } catch (IOException | ServletException e) {
            LOGGER.log(Level.WARNING, "[ProfileController] Error reading avatar file part", e);
        }

        // 2. Try URL text field
        String urlField = JSoupUtil.sanitizeText(request.getParameter("avatarUrl"));
        if (urlField != null && !urlField.isBlank()) {
            return urlField;
        }

        // 3. Keep existing (return null = no change)
        return null;
    }

    /** Change password sub-handler (unchanged logic). */
    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response,
                                      User currentUser)
            throws ServletException, IOException {

        String currentPassword  = request.getParameter("currentPassword");
        String newPassword      = request.getParameter("newPassword");
        String confirmPassword  = request.getParameter("confirmPassword");

        if (currentUser.getPasswordHash() == null ||
                currentUser.getPasswordHash().trim().isEmpty()) {
            request.setAttribute("passwordError",
                    "Tài khoản đăng nhập bằng Google không sử dụng mật khẩu hệ thống.");

        } else if (currentPassword == null ||
                !com.project.util.PasswordUtil.checkPassword(
                        currentPassword, currentUser.getPasswordHash())) {
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
        request.getRequestDispatcher("/WEB-INF/views/customer/profile.jsp")
               .forward(request, response);
    }

    private static String getSubmittedFilename(Part part) {
        String header = part.getHeader("content-disposition");
        if (header == null) return "";
        for (String token : header.split(";")) {
            token = token.trim();
            if (token.startsWith("filename=") || token.startsWith("filename*=")) {
                String name = token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                int slash = Math.max(name.lastIndexOf('/'), name.lastIndexOf('\\'));
                return (slash >= 0) ? name.substring(slash + 1) : name;
            }
        }
        return "";
    }

    private static boolean isImage(String filename) {
        if (filename == null || filename.isBlank()) return false;
        String lc = filename.toLowerCase(java.util.Locale.ROOT);
        return lc.endsWith(".jpg") || lc.endsWith(".jpeg")
            || lc.endsWith(".png") || lc.endsWith(".gif")
            || lc.endsWith(".webp");
    }
}
