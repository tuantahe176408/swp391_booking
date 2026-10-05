package com.project.controller.customer;

import com.project.dao.VoucherDAO;
import com.project.dao.VoucherDAOImpl;
import com.project.model.Voucher;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.Optional;

/**
 * API Endpoint: Validate & Preview Voucher Discount (UC07)
 * Package: com.project.controller.customer
 *
 * GET /api/voucher/validate?code=SUMMER2026&orderTotal=1500000
 * Returns JSON: { valid, code, discountType, discountValue, maxDiscountAmount,
 *                 minBookingAmount, discountAmount, message }
 */
@WebServlet(name = "VoucherValidateController", urlPatterns = {"/api/voucher/validate"})
public class VoucherValidateController extends HttpServlet {

    private VoucherDAO voucherDAO;

    @Override
    public void init() throws ServletException {
        this.voucherDAO = new VoucherDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control", "no-store");

        PrintWriter out = response.getWriter();

        String code = request.getParameter("code");
        String orderTotalStr = request.getParameter("orderTotal");

        // Validate params
        if (code == null || code.trim().isEmpty()) {
            out.print("{\"valid\":false,\"message\":\"Vui lòng nhập mã voucher.\"}");
            return;
        }

        BigDecimal orderTotal = BigDecimal.ZERO;
        try {
            if (orderTotalStr != null && !orderTotalStr.trim().isEmpty()) {
                orderTotal = new BigDecimal(orderTotalStr.trim());
            }
        } catch (NumberFormatException e) {
            out.print("{\"valid\":false,\"message\":\"Tổng đơn hàng không hợp lệ.\"}");
            return;
        }

        Optional<Voucher> opt = voucherDAO.findByCode(code.trim());

        if (!opt.isPresent()) {
            out.print("{\"valid\":false,\"message\":\"Mã voucher không tồn tại hoặc đã hết hạn.\"}");
            return;
        }

        Voucher v = opt.get();

        // Kiểm tra đủ lượt sử dụng
        if (v.getUsageLimit() > 0 && v.getUsedCount() >= v.getUsageLimit()) {
            out.print("{\"valid\":false,\"message\":\"Mã voucher đã hết lượt sử dụng.\"}");
            return;
        }

        // Kiểm tra đơn tối thiểu
        if (v.getMinBookingAmount() != null
                && v.getMinBookingAmount().compareTo(BigDecimal.ZERO) > 0
                && orderTotal.compareTo(v.getMinBookingAmount()) < 0) {
            String minFmt = String.format("%,.0f", v.getMinBookingAmount());
            out.print("{\"valid\":false,\"message\":\"Đơn hàng tối thiểu "
                    + minFmt + "₫ để dùng mã này.\"}");
            return;
        }

        // Tính discount
        BigDecimal discountAmount = v.calculateDiscount(orderTotal);

        // Build JSON response
        String json = "{"
                + "\"valid\":true,"
                + "\"code\":\"" + escapeJson(v.getCode()) + "\","
                + "\"description\":\"" + escapeJson(v.getDescription() != null ? v.getDescription() : "") + "\","
                + "\"discountType\":\"" + v.getDiscountType().name() + "\","
                + "\"discountValue\":" + v.getDiscountValue().toPlainString() + ","
                + "\"maxDiscountAmount\":" + (v.getMaxDiscountAmount() != null ? v.getMaxDiscountAmount().toPlainString() : "0") + ","
                + "\"minBookingAmount\":" + (v.getMinBookingAmount() != null ? v.getMinBookingAmount().toPlainString() : "0") + ","
                + "\"usedCount\":" + v.getUsedCount() + ","
                + "\"usageLimit\":" + v.getUsageLimit() + ","
                + "\"discountAmount\":" + discountAmount.toPlainString() + ","
                + "\"message\":\"Áp dụng thành công! Giảm " + formatVnd(discountAmount) + "₫.\""
                + "}";

        out.print(json);
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }

    private String formatVnd(BigDecimal amount) {
        return String.format("%,.0f", amount);
    }
}
