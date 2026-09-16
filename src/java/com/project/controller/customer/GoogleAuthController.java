package com.project.controller.customer;

import com.project.dao.UserDAO;
import com.project.dao.UserDAOImpl;
import com.project.model.GoogleAccountDTO;
import com.project.model.User;
import com.project.util.GoogleAuthUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Optional;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet Controller: Google OAuth 2.0 Authentication
 * Handles authorization redirect (/auth/google) and callback (/auth/google/callback)
 * Package: com.project.controller.customer
 */
@WebServlet(name = "GoogleAuthController", urlPatterns = {"/auth/google", "/auth/google/callback"})
public class GoogleAuthController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(GoogleAuthController.class.getName());
    private static final String STATE_SESSION_KEY = "GOOGLE_OAUTH_STATE";

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        this.userDAO = new UserDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();

        if ("/auth/google".equals(servletPath)) {
            handleGoogleAuthRedirect(request, response);
        } else if ("/auth/google/callback".equals(servletPath)) {
            handleGoogleCallback(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }

    /**
     * Initiate Google OAuth flow: Generate state token and redirect to Google consent screen
     */
    private void handleGoogleAuthRedirect(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(true);
        String state = UUID.randomUUID().toString();
        session.setAttribute(STATE_SESSION_KEY, state);

        String authUrl = GoogleAuthUtil.buildAuthUrl(state);
        response.sendRedirect(authUrl);
    }

    /**
     * Process Google OAuth Callback: Validate state, exchange code, retrieve profile, login/register user
     */
    private void handleGoogleCallback(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String error = request.getParameter("error");
        if (error != null && !error.trim().isEmpty()) {
            LOGGER.log(Level.WARNING, "Google OAuth returned error: {0}", error);
            redirectWithError(request, response, "Đăng nhập với Google không thành công hoặc đã bị hủy.");
            return;
        }

        String code = request.getParameter("code");
        String state = request.getParameter("state");
        HttpSession session = request.getSession(false);

        // Anti-CSRF verification
        if (session == null || state == null || !state.equals(session.getAttribute(STATE_SESSION_KEY))) {
            LOGGER.warning("Google OAuth State validation failed (CSRF risk or expired session).");
            redirectWithError(request, response, "Phiên đăng nhập đã hết hạn hoặc không hợp lệ. Vui lòng thử lại.");
            return;
        }
        session.removeAttribute(STATE_SESSION_KEY);

        if (code == null || code.trim().isEmpty()) {
            redirectWithError(request, response, "Mã ủy quyền từ Google không hợp lệ.");
            return;
        }

        // Exchange code for access token
        String accessToken = GoogleAuthUtil.getAccessToken(code);
        if (accessToken == null || accessToken.trim().isEmpty()) {
            redirectWithError(request, response, "Không thể kết nối với dịch vụ xác thực Google. Vui lòng thử lại sau.");
            return;
        }

        // Fetch user profile from Google
        GoogleAccountDTO googleProfile = GoogleAuthUtil.getUserInfo(accessToken);
        if (googleProfile == null || googleProfile.getEmail() == null) {
            redirectWithError(request, response, "Không thể truy xuất thông tin tài khoản Google của bạn.");
            return;
        }

        // Synchronize with database
        User user = syncGoogleUser(googleProfile);
        if (user == null) {
            redirectWithError(request, response, "Có lỗi xảy ra trong quá trình xử lý tài khoản.");
            return;
        }

        if (!user.isActive()) {
            redirectWithError(request, response, "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ quản trị viên.");
            return;
        }

        // Authentication success: renew session for security
        HttpSession oldSession = request.getSession(false);
        if (oldSession != null) {
            oldSession.invalidate();
        }
        session = request.getSession(true);
        session.setAttribute("currentUser", user);

        LOGGER.log(Level.INFO, "Google OAuth successful for user: {0} (Role: {1})",
                new Object[]{user.getEmail(), user.getRole()});

        // Redirect based on role
        redirectByRole(request, response, user);
    }

    /**
     * Finds existing user by Google ID or email, or inserts a new user
     */
    private User syncGoogleUser(GoogleAccountDTO googleProfile) {
        String googleId = googleProfile.getId();
        String email = googleProfile.getEmail().toLowerCase().trim();

        // 1. Check if user already logged in with this Google ID
        Optional<User> userByGoogleId = userDAO.findByGoogleId(googleId);
        if (userByGoogleId.isPresent()) {
            return userByGoogleId.get();
        }

        // 2. Check if user exists by email (link Google ID)
        Optional<User> userByEmail = userDAO.findByEmail(email);
        if (userByEmail.isPresent()) {
            User existingUser = userByEmail.get();
            boolean linked = userDAO.linkGoogleAccount(
                    existingUser.getUserId(),
                    googleId,
                    googleProfile.getPicture()
            );
            if (linked) {
                existingUser.setGoogleId(googleId);
                existingUser.setAuthProvider(User.AuthProvider.GOOGLE);
                existingUser.setEmailVerified(true);
                if (googleProfile.getPicture() != null && !googleProfile.getPicture().isEmpty()) {
                    existingUser.setAvatarUrl(googleProfile.getPicture());
                }
            }
            return existingUser;
        }

        // 3. Brand new user registration via Google OAuth
        User newUser = new User();
        newUser.setEmail(email);
        newUser.setPasswordHash(null);
        newUser.setFullName(googleProfile.getName() != null ? googleProfile.getName() : "Google User");
        newUser.setPhoneNumber(null);
        newUser.setAvatarUrl(googleProfile.getPicture());
        newUser.setRole(User.Role.CUSTOMER);
        newUser.setAuthProvider(User.AuthProvider.GOOGLE);
        newUser.setGoogleId(googleId);
        newUser.setActive(true);
        newUser.setEmailVerified(googleProfile.isEmailVerified());

        boolean inserted = userDAO.insertUser(newUser);
        if (inserted) {
            return newUser;
        }
        return null;
    }

    /**
     * Redirects to the appropriate portal according to role
     */
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

    private void redirectWithError(HttpServletRequest request, HttpServletResponse response, String message)
            throws IOException {
        String encoded = URLEncoder.encode(message, StandardCharsets.UTF_8);
        response.sendRedirect(request.getContextPath() + "/login?error=" + encoded);
    }
}
