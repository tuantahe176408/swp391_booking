package com.project.controller.admin;

import com.project.dao.VoucherDAO;
import com.project.dao.VoucherDAOImpl;
import com.project.model.User;
import com.project.model.Voucher;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.List;

/**
 * Controller: Manage Platform Vouchers & Marketing Campaigns (UC26)
 * Package: com.project.controller.admin
 */
@WebServlet(name = "AdminVoucherController", urlPatterns = {"/admin/vouchers"})
public class AdminVoucherController extends HttpServlet {

    private VoucherDAO voucherDAO;

    @Override
    public void init() throws ServletException {
        this.voucherDAO = new VoucherDAOImpl();
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

        List<Voucher> voucherList = voucherDAO.getAllVouchers();
        long activeCount  = voucherList.stream().filter(Voucher::isActive).count();
        long expiredCount = voucherList.stream()
                .filter(v -> v.getEndDate() != null && v.getEndDate().getTime() < System.currentTimeMillis())
                .count();

        request.setAttribute("voucherList",   voucherList);
        request.setAttribute("totalCount",    voucherList.size());
        request.setAttribute("activeCount",   activeCount);
        request.setAttribute("expiredCount",  expiredCount);
        request.setAttribute("activeTab",     "vouchers");
        request.setAttribute("pageTitle",     "Admin - Quản lý Voucher & Chiến dịch Marketing");
        request.getRequestDispatcher("/WEB-INF/views/admin/voucher-form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null || currentUser.getRole() != User.Role.ADMIN) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Admin Privilege Required");
            return;
        }

        String action = request.getParameter("action");

        if ("create".equals(action)) {
            handleCreate(request, response, session, currentUser);
        } else if ("update".equals(action)) {
            handleUpdate(request, response, session);
        } else if ("toggle".equals(action)) {
            handleToggle(request, response, session);
        } else if ("delete".equals(action)) {
            handleDelete(request, response, session);
        } else {
            session.setAttribute("adminErrorMessage", "Hành động không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/admin/vouchers");
        }
    }

    // ---- CREATE ----
    private void handleCreate(HttpServletRequest request, HttpServletResponse response,
                              HttpSession session, User currentUser)
            throws IOException {

        try {
            String code        = request.getParameter("code");
            String description = request.getParameter("description");
            String dtype       = request.getParameter("discountType");
            String dvalue      = request.getParameter("discountValue");
            String maxDisc     = request.getParameter("maxDiscountAmount");
            String minBook     = request.getParameter("minBookingAmount");
            String usageLimStr = request.getParameter("usageLimit");
            String startStr    = request.getParameter("startDate");
            String endStr      = request.getParameter("endDate");

            if (code == null || code.trim().isEmpty()) {
                session.setAttribute("adminErrorMessage", "Mã voucher không được để trống.");
                response.sendRedirect(request.getContextPath() + "/admin/vouchers");
                return;
            }

            Voucher v = new Voucher();
            v.setCode(code.trim().toUpperCase());
            v.setDescription(description != null ? description.trim() : "");
            v.setDiscountType(Voucher.DiscountType.valueOf(dtype != null ? dtype : "PERCENTAGE"));
            v.setDiscountValue(parseBigDecimal(dvalue, BigDecimal.ZERO));
            v.setMaxDiscountAmount(parseBigDecimal(maxDisc, BigDecimal.ZERO));
            v.setMinBookingAmount(parseBigDecimal(minBook, BigDecimal.ZERO));
            v.setUsageLimit(parseIntSafe(usageLimStr, 100));
            v.setStartDate(parseTimestampStart(startStr));
            v.setEndDate(parseTimestampEnd(endStr));
            v.setActive(true);
            v.setCreatedByUserId(currentUser.getUserId());

            int newId = voucherDAO.insertVoucher(v);
            if (newId > 0) {
                session.setAttribute("adminSuccessMessage", "Tạo voucher [" + v.getCode() + "] thành công!");
            } else {
                session.setAttribute("adminErrorMessage", "Tạo voucher thất bại. Mã code có thể đã tồn tại.");
            }

        } catch (Exception e) {
            session.setAttribute("adminErrorMessage", "Lỗi tạo voucher: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/vouchers");
    }

    // ---- UPDATE (Safe Fields Only) ----
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response,
                              HttpSession session) throws IOException {
        try {
            int voucherId  = Integer.parseInt(request.getParameter("voucherId"));
            String description = request.getParameter("description");
            String endStr      = request.getParameter("endDate");
            String maxDisc     = request.getParameter("maxDiscountAmount");
            String minBook     = request.getParameter("minBookingAmount");
            String usageLimStr = request.getParameter("usageLimit");

            // Load existing voucher để giữ nguyên các immutable fields
            java.util.List<com.project.model.Voucher> all = voucherDAO.getAllVouchers();
            com.project.model.Voucher existing = all.stream()
                    .filter(v -> v.getVoucherId() == voucherId)
                    .findFirst().orElse(null);

            if (existing == null) {
                session.setAttribute("adminErrorMessage", "Không tìm thấy voucher cần cập nhật.");
                response.sendRedirect(request.getContextPath() + "/admin/vouchers");
                return;
            }

            // Chỉ cập nhật safe fields — giữ nguyên code/discountType/discountValue
            existing.setDescription(description != null ? description.trim() : existing.getDescription());
            existing.setMaxDiscountAmount(parseBigDecimal(maxDisc, existing.getMaxDiscountAmount()));
            existing.setMinBookingAmount(parseBigDecimal(minBook, existing.getMinBookingAmount()));
            existing.setUsageLimit(parseIntSafe(usageLimStr, existing.getUsageLimit()));
            if (endStr != null && !endStr.trim().isEmpty()) {
                existing.setEndDate(parseTimestampEnd(endStr));
            }

            boolean ok = voucherDAO.updateVoucher(existing);
            if (ok) {
                session.setAttribute("adminSuccessMessage",
                        "Đã cập nhật voucher [" + existing.getCode() + "] thành công!");
            } else {
                session.setAttribute("adminErrorMessage", "Cập nhật thất bại. Vui lòng thử lại.");
            }
        } catch (Exception e) {
            session.setAttribute("adminErrorMessage", "Lỗi cập nhật voucher: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/vouchers");
    }

    // ---- TOGGLE ----
    private void handleToggle(HttpServletRequest request, HttpServletResponse response,
                              HttpSession session) throws IOException {
        try {
            int voucherId   = Integer.parseInt(request.getParameter("voucherId"));
            boolean active  = "true".equals(request.getParameter("active"));
            boolean success = voucherDAO.toggleActive(voucherId, active);
            if (success) {
                session.setAttribute("adminSuccessMessage",
                        active ? "Đã kích hoạt voucher." : "Đã tắt voucher.");
            } else {
                session.setAttribute("adminErrorMessage", "Không thể cập nhật trạng thái voucher.");
            }
        } catch (Exception e) {
            session.setAttribute("adminErrorMessage", "Lỗi toggle voucher: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/vouchers");
    }

    // ---- DELETE ----
    private void handleDelete(HttpServletRequest request, HttpServletResponse response,
                              HttpSession session) throws IOException {
        try {
            int voucherId = Integer.parseInt(request.getParameter("voucherId"));
            boolean success = voucherDAO.deleteVoucher(voucherId);
            if (success) {
                session.setAttribute("adminSuccessMessage", "Đã xóa voucher thành công.");
            } else {
                session.setAttribute("adminErrorMessage", "Không thể xóa voucher (có thể đã được dùng trong booking).");
            }
        } catch (Exception e) {
            session.setAttribute("adminErrorMessage", "Lỗi xóa voucher: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/vouchers");
    }

    // ---- Helpers ----
    private BigDecimal parseBigDecimal(String s, BigDecimal defaultVal) {
        try {
            if (s == null || s.trim().isEmpty()) return defaultVal;
            return new BigDecimal(s.trim().replace(",", ""));
        } catch (NumberFormatException e) {
            return defaultVal;
        }
    }

    private int parseIntSafe(String s, int defaultVal) {
        try {
            if (s == null || s.trim().isEmpty()) return defaultVal;
            return Integer.parseInt(s.trim());
        } catch (NumberFormatException e) {
            return defaultVal;
        }
    }

    private Timestamp parseTimestampStart(String dateStr) {
        try {
            if (dateStr == null || dateStr.trim().isEmpty()) {
                return Timestamp.valueOf(LocalDateTime.now());
            }
            return Timestamp.valueOf(LocalDate.parse(dateStr).atStartOfDay());
        } catch (DateTimeParseException e) {
            return Timestamp.valueOf(LocalDateTime.now());
        }
    }

    private Timestamp parseTimestampEnd(String dateStr) {
        try {
            if (dateStr == null || dateStr.trim().isEmpty()) {
                return Timestamp.valueOf(LocalDate.now().plusYears(1).atTime(LocalTime.MAX));
            }
            return Timestamp.valueOf(LocalDate.parse(dateStr).atTime(LocalTime.MAX));
        } catch (DateTimeParseException e) {
            return Timestamp.valueOf(LocalDate.now().plusYears(1).atTime(LocalTime.MAX));
        }
    }
}
