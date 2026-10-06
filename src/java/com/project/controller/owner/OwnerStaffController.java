package com.project.controller.owner;

import com.project.dao.HomestayDAO;
import com.project.dao.HomestayDAOImpl;
import com.project.dao.StaffDAO;
import com.project.dao.StaffDAOImpl;
import com.project.dao.UserDAO;
import com.project.dao.UserDAOImpl;
import com.project.model.Homestay;
import com.project.model.StaffInfo;
import com.project.model.User;
import com.project.util.EmailUtil;
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
 * Controller: Owner — Manage Receptionist Staff Accounts (UC21)
 * URL: /owner/staffs
 * Package: com.project.controller.owner
 *
 * GET  /owner/staffs                  — display staff list with stats
 * POST /owner/staffs?action=create   — create new receptionist account
 * POST /owner/staffs?action=reset    — reset a receptionist's password
 * POST /owner/staffs?action=lock     — lock a receptionist account
 * POST /owner/staffs?action=unlock   — unlock a receptionist account
 * POST /owner/staffs?action=reassign — reassign receptionist to a different homestay
 */
@WebServlet(name = "OwnerStaffController", urlPatterns = {"/owner/staffs"})
public class OwnerStaffController extends HttpServlet {

    private UserDAO     userDAO;
    private HomestayDAO homestayDAO;
    private StaffDAO    staffDAO;

    @Override
    public void init() throws ServletException {
        this.userDAO     = new UserDAOImpl();
        this.homestayDAO = new HomestayDAOImpl();
        this.staffDAO    = new StaffDAOImpl();
    }

    // ── GET ────────────────────────────────────────────────────────────────

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = requireOwner(request, response);
        if (currentUser == null) return;

        int ownerId = currentUser.getUserId();

        List<StaffInfo> staffList   = staffDAO.getStaffByOwnerId(ownerId);
        List<Homestay>  myHomestays = homestayDAO.getHomestaysByOwnerId(ownerId);
        int countActive             = staffDAO.countActiveByOwnerId(ownerId);
        int countPending            = staffDAO.countPendingByOwnerId(ownerId);
        int countManaged            = staffDAO.countManagedHomestaysByOwnerId(ownerId);

        request.setAttribute("staffList",    staffList);
        request.setAttribute("myHomestays",  myHomestays);
        request.setAttribute("countActive",  countActive);
        request.setAttribute("countPending", countPending);
        request.setAttribute("countManaged", countManaged);

        request.setAttribute("activeTab",      "staffs");
        request.setAttribute("pageTitle",      "Chủ nhà - Quản lý Tài khoản Lễ tân");
        request.setAttribute("pageBreadcrumb", "Vận hành & Báo cáo");

        request.getRequestDispatcher("/WEB-INF/views/owner/staff-list.jsp").forward(request, response);
    }

    // ── POST ───────────────────────────────────────────────────────────────

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        User currentUser = requireOwner(request, response);
        if (currentUser == null) return;

        int ownerId = currentUser.getUserId();
        String action = trim(request.getParameter("action"));

        switch (action) {
            case "create":   handleCreate(request, response, ownerId);          break;
            case "reset":    handleReset(request, response, ownerId);            break;
            case "lock":     handleLock(request, response, ownerId, false);      break;
            case "unlock":   handleLock(request, response, ownerId, true);       break;
            case "reassign": handleReassign(request, response, ownerId);         break;
            default:
                response.sendRedirect(request.getContextPath() + "/owner/staffs");
        }
    }

    // ── Action handlers ────────────────────────────────────────────────────

    private void handleCreate(HttpServletRequest request, HttpServletResponse response, int ownerId)
            throws IOException {

        HttpSession session = request.getSession();
        String fullName      = trim(request.getParameter("fullName"));
        String email         = trim(request.getParameter("email")).toLowerCase();
        String homestayIdStr = trim(request.getParameter("homestayId"));

        if (fullName.isEmpty() || email.isEmpty() || homestayIdStr.isEmpty()) {
            session.setAttribute("flash_error", "Vui lòng điền đầy đủ: họ tên, email và cơ sở phân công.");
            response.sendRedirect(request.getContextPath() + "/owner/staffs");
            return;
        }
        if (!email.matches("^[\\w.+\\-]+@[\\w\\-]+\\.[a-zA-Z]{2,}$")) {
            session.setAttribute("flash_error", "Địa chỉ email không hợp lệ: " + email);
            response.sendRedirect(request.getContextPath() + "/owner/staffs");
            return;
        }

        int homestayId;
        try {
            homestayId = Integer.parseInt(homestayIdStr);
        } catch (NumberFormatException e) {
            session.setAttribute("flash_error", "Cơ sở không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/owner/staffs");
            return;
        }

        Homestay target = homestayDAO.getHomestayById(homestayId).orElse(null);
        if (target == null || target.getOwnerId() != ownerId) {
            session.setAttribute("flash_error", "Cơ sở không tồn tại hoặc không thuộc quyền quản lý của bạn.");
            response.sendRedirect(request.getContextPath() + "/owner/staffs");
            return;
        }

        if (userDAO.findByEmail(email).isPresent()) {
            session.setAttribute("flash_error",
                "Email \"" + email + "\" đã được sử dụng bởi một tài khoản khác trong hệ thống.");
            response.sendRedirect(request.getContextPath() + "/owner/staffs");
            return;
        }

        String rawPassword = PasswordUtil.generateRandomPassword(12);

        User newStaff = new User();
        newStaff.setFullName(fullName);
        newStaff.setEmail(email);
        newStaff.setPasswordHash(PasswordUtil.hashPassword(rawPassword));
        newStaff.setRole(User.Role.RECEPTIONIST);
        newStaff.setAuthProvider(User.AuthProvider.LOCAL);
        newStaff.setActive(true);
        newStaff.setEmailVerified(true);
        newStaff.setMustChangePassword(true);

        boolean created = userDAO.insertUser(newStaff);
        if (!created || newStaff.getUserId() == 0) {
            session.setAttribute("flash_error", "Tạo tài khoản thất bại. Vui lòng thử lại.");
            response.sendRedirect(request.getContextPath() + "/owner/staffs");
            return;
        }

        staffDAO.assignToHomestay(newStaff.getUserId(), homestayId);
        sendStaffActivationEmail(email, fullName, rawPassword, target.getName());

        session.setAttribute("flash_success",
            "Đã tạo tài khoản lễ tân cho <strong>" + escHtml(fullName) + "</strong> " +
            "và gán vào cơ sở <strong>" + escHtml(target.getName()) + "</strong>. " +
            "Email kích hoạt đã gửi đến " + escHtml(email) + ".");
        response.sendRedirect(request.getContextPath() + "/owner/staffs");
    }

    private void handleReset(HttpServletRequest request, HttpServletResponse response, int ownerId)
            throws IOException {

        HttpSession session = request.getSession();
        int userId = parseUserId(request);
        if (userId <= 0) {
            session.setAttribute("flash_error", "Nhân viên không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/owner/staffs");
            return;
        }

        if (!staffDAO.isStaffAssignedToOwner(userId, ownerId)) {
            session.setAttribute("flash_error", "Bạn không có quyền thực hiện thao tác này.");
            response.sendRedirect(request.getContextPath() + "/owner/staffs");
            return;
        }

        User staff = userDAO.findById(userId).orElse(null);
        if (staff == null) {
            session.setAttribute("flash_error", "Không tìm thấy tài khoản nhân viên.");
            response.sendRedirect(request.getContextPath() + "/owner/staffs");
            return;
        }

        String rawPassword = PasswordUtil.generateRandomPassword(12);
        userDAO.updatePassword(userId, PasswordUtil.hashPassword(rawPassword), true);
        EmailUtil.sendForgotPasswordEmail(staff.getEmail(), staff.getFullName(), rawPassword);

        session.setAttribute("flash_success",
            "Đã reset mật khẩu cho <strong>" + escHtml(staff.getFullName()) + "</strong>. " +
            "Mật khẩu tạm thời mới đã gửi đến " + escHtml(staff.getEmail()) + ".");
        response.sendRedirect(request.getContextPath() + "/owner/staffs");
    }

    private void handleLock(HttpServletRequest request, HttpServletResponse response,
                             int ownerId, boolean activate) throws IOException {

        HttpSession session = request.getSession();
        int userId = parseUserId(request);
        if (userId <= 0) {
            session.setAttribute("flash_error", "Nhân viên không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/owner/staffs");
            return;
        }

        if (!staffDAO.isStaffAssignedToOwner(userId, ownerId)) {
            session.setAttribute("flash_error", "Bạn không có quyền thực hiện thao tác này.");
            response.sendRedirect(request.getContextPath() + "/owner/staffs");
            return;
        }

        User staff = userDAO.findById(userId).orElse(null);
        if (staff == null) {
            session.setAttribute("flash_error", "Không tìm thấy tài khoản nhân viên.");
            response.sendRedirect(request.getContextPath() + "/owner/staffs");
            return;
        }

        userDAO.updateLockStatus(userId, activate);

        String verb = activate ? "Đã mở khoá" : "Đã khoá";
        session.setAttribute("flash_success",
            verb + " tài khoản của <strong>" + escHtml(staff.getFullName()) + "</strong>.");
        response.sendRedirect(request.getContextPath() + "/owner/staffs");
    }

    private void handleReassign(HttpServletRequest request, HttpServletResponse response, int ownerId)
            throws IOException {

        HttpSession session = request.getSession();
        int userId = parseUserId(request);
        String homestayIdStr = trim(request.getParameter("homestayId"));

        if (userId <= 0 || homestayIdStr.isEmpty()) {
            session.setAttribute("flash_error", "Thông tin không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/owner/staffs");
            return;
        }

        int newHomestayId;
        try {
            newHomestayId = Integer.parseInt(homestayIdStr);
        } catch (NumberFormatException e) {
            session.setAttribute("flash_error", "Cơ sở không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/owner/staffs");
            return;
        }

        if (!staffDAO.isStaffAssignedToOwner(userId, ownerId)) {
            session.setAttribute("flash_error", "Bạn không có quyền thực hiện thao tác này.");
            response.sendRedirect(request.getContextPath() + "/owner/staffs");
            return;
        }

        Homestay target = homestayDAO.getHomestayById(newHomestayId).orElse(null);
        if (target == null || target.getOwnerId() != ownerId) {
            session.setAttribute("flash_error", "Cơ sở đích không tồn tại hoặc không thuộc quyền quản lý của bạn.");
            response.sendRedirect(request.getContextPath() + "/owner/staffs");
            return;
        }

        User staff = userDAO.findById(userId).orElse(null);
        if (staff == null) {
            session.setAttribute("flash_error", "Không tìm thấy tài khoản nhân viên.");
            response.sendRedirect(request.getContextPath() + "/owner/staffs");
            return;
        }

        boolean ok = staffDAO.assignToHomestay(userId, newHomestayId);
        if (ok) {
            session.setAttribute("flash_success",
                "Đã chuyển <strong>" + escHtml(staff.getFullName()) + "</strong> sang cơ sở " +
                "<strong>" + escHtml(target.getName()) + "</strong>.");
        } else {
            session.setAttribute("flash_error", "Cập nhật cơ sở thất bại. Vui lòng thử lại.");
        }
        response.sendRedirect(request.getContextPath() + "/owner/staffs");
    }

    // ── Utilities ──────────────────────────────────────────────────────────

    private User requireOwner(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }
        if (user.getRole() != User.Role.OWNER) {
            response.sendRedirect(request.getContextPath() + "/home");
            return null;
        }
        return user;
    }

    private int parseUserId(HttpServletRequest request) {
        try {
            String s = trim(request.getParameter("userId"));
            return s.isEmpty() ? -1 : Integer.parseInt(s);
        } catch (NumberFormatException e) {
            return -1;
        }
    }

    private static String trim(String s) { return s != null ? s.trim() : ""; }

    private static String escHtml(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
    }

    private static void sendStaffActivationEmail(String email, String fullName,
                                                  String tempPassword, String homestayName) {
        String subject = "Smart Booking – Tài khoản Lễ tân của bạn đã được tạo";
        String html =
            "<!DOCTYPE html><html><head><meta charset='UTF-8'></head>" +
            "<body style='font-family:Arial,sans-serif;background:#f8fafc;padding:20px;color:#333;'>" +
            "<div style='max-width:560px;margin:0 auto;background:#fff;border-radius:12px;padding:30px;" +
                  "box-shadow:0 4px 15px rgba(0,0,0,.05);border:1px solid #e2e8f0;'>" +
              "<div style='text-align:center;margin-bottom:25px;'>" +
                "<h2 style='color:#4f46e5;margin:0;font-size:24px;'>Smart Booking Platform</h2>" +
                "<p style='color:#64748b;font-size:14px;margin-top:5px;'>Hệ thống Đặt phòng Homestay &amp; Khách sạn Thông minh</p>" +
              "</div>" +
              "<hr style='border:none;border-top:1px solid #e2e8f0;margin:20px 0;'/>" +
              "<p>Xin chào <strong>" + escapeHtml(fullName) + "</strong>,</p>" +
              "<p>Tài khoản lễ tân của bạn tại cơ sở <strong>" + escapeHtml(homestayName) + "</strong> đã được tạo.</p>" +
              "<div style='background:#f1f5f9;border-left:4px solid #4f46e5;padding:15px 20px;border-radius:6px;margin:25px 0;'>" +
                "<div style='margin-bottom:10px;'>" +
                  "<span style='font-size:13px;color:#64748b;display:block;'>Email:</span>" +
                  "<strong>" + escapeHtml(email) + "</strong>" +
                "</div>" +
                "<div>" +
                  "<span style='font-size:13px;color:#64748b;display:block;'>Mật khẩu tạm thời:</span>" +
                  "<span style='font-size:24px;font-family:monospace;font-weight:bold;letter-spacing:2px;'>" + escapeHtml(tempPassword) + "</span>" +
                "</div>" +
              "</div>" +
              "<p style='font-size:13px;color:#92400e;background:#fffbeb;border:1px solid #fef3c7;border-radius:8px;padding:10px 14px;'>" +
                "<strong>Lưu ý:</strong> Bạn sẽ được yêu cầu đổi mật khẩu ngay khi đăng nhập lần đầu.</p>" +
              "<hr style='border:none;border-top:1px solid #e2e8f0;margin:25px 0;'/>" +
              "<p style='font-size:12px;color:#94a3b8;text-align:center;'>© Smart Booking Platform</p>" +
            "</div></body></html>";
        EmailUtil.sendSmtpEmail(email, subject, html);
    }

    private static String escapeHtml(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\"", "&quot;").replace("'", "&#x27;");
    }
}
