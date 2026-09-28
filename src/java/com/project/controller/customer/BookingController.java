package com.project.controller.customer;

import com.project.dao.*;
import com.project.model.*;
import com.project.service.BookingService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Optional;

/**
 * Controller: Đặt phòng & Áp dụng Voucher (UC07)
 * Package: com.project.controller.customer
 */
@WebServlet(name = "BookingController", urlPatterns = {"/booking/checkout", "/booking/confirm"})
public class BookingController extends HttpServlet {

    private HomestayDAO homestayDAO;
    private AddonDAO addonDAO;
    private VoucherDAO voucherDAO;
    private BookingDAO bookingDAO;
    private BookingService bookingService;

    @Override
    public void init() throws ServletException {
        this.homestayDAO  = new HomestayDAOImpl();
        this.addonDAO     = new AddonDAOImpl();
        this.voucherDAO   = new VoucherDAOImpl();
        this.bookingDAO   = new BookingDAOImpl();
        this.bookingService = new BookingService();
    }

    /** GET /booking/checkout — Hiển thị trang xác nhận đặt phòng */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            String redirectUrl = "/booking/checkout";
            if (request.getQueryString() != null && !request.getQueryString().trim().isEmpty()) {
                redirectUrl += "?" + request.getQueryString();
            }
            response.sendRedirect(request.getContextPath() + "/login?redirect=" + java.net.URLEncoder.encode(redirectUrl, "UTF-8"));
            return;
        }

        String homestayIdParam  = request.getParameter("homestayId");
        String roomTypeIdParam  = request.getParameter("roomTypeId");
        String checkinParam     = request.getParameter("checkin");
        String checkoutParam    = request.getParameter("checkout");

        int homestayId = 0;
        try {
            if (homestayIdParam != null && !homestayIdParam.trim().isEmpty()) {
                homestayId = Integer.parseInt(homestayIdParam.trim());
            }
        } catch (NumberFormatException ignored) {}

        if (homestayId <= 0) {
            response.sendRedirect(request.getContextPath() + "/search");
            return;
        }

        Optional<Homestay> optHomestay = homestayDAO.getHomestayById(homestayId);
        if (!optHomestay.isPresent()) {
            response.sendRedirect(request.getContextPath() + "/search");
            return;
        }

        Homestay homestay = optHomestay.get();

        // Tìm room type cụ thể hoặc lấy room type đầu tiên
        int roomTypeId = 0;
        try {
            if (roomTypeIdParam != null && !roomTypeIdParam.trim().isEmpty()) {
                roomTypeId = Integer.parseInt(roomTypeIdParam.trim());
            }
        } catch (NumberFormatException ignored) {}

        RoomType selectedRoomType = null;
        if (homestay.getRoomTypes() != null && !homestay.getRoomTypes().isEmpty()) {
            if (roomTypeId > 0) {
                final int targetId = roomTypeId;
                selectedRoomType = homestay.getRoomTypes().stream()
                        .filter(rt -> rt.getRoomTypeId() == targetId)
                        .findFirst().orElse(null);
            }
            if (selectedRoomType == null) {
                selectedRoomType = homestay.getRoomTypes().get(0);
            }
        }

        // Parse ngày checkin / checkout an toàn không cho chọn quá khứ
        LocalDate today = LocalDate.now();
        LocalDate checkin;
        try {
            checkin = (checkinParam != null && !checkinParam.trim().isEmpty()) ? LocalDate.parse(checkinParam.trim()) : today;
        } catch (Exception e) {
            checkin = today;
        }
        if (checkin.isBefore(today)) {
            checkin = today;
        }

        LocalDate checkout;
        try {
            checkout = (checkoutParam != null && !checkoutParam.trim().isEmpty()) ? LocalDate.parse(checkoutParam.trim()) : checkin.plusDays(1);
        } catch (Exception e) {
            checkout = checkin.plusDays(1);
        }
        if (!checkout.isAfter(checkin)) {
            checkout = checkin.plusDays(1);
        }

        long totalNights = ChronoUnit.DAYS.between(checkin, checkout);
        if (totalNights <= 0) totalNights = 1;

        // Addons
        List<Addon> addons = addonDAO.getAddonsByHomestayId(homestayId);

        request.setAttribute("homestay", homestay);
        request.setAttribute("selectedRoomType", selectedRoomType);
        request.setAttribute("addons", addons);
        request.setAttribute("checkin", checkin.toString());
        request.setAttribute("checkout", checkout.toString());
        request.setAttribute("totalNights", totalNights);
        request.setAttribute("currentUser", currentUser);
        request.setAttribute("pageTitle", "Xác nhận Đặt phòng - Smart Booking Platform");

        request.getRequestDispatcher("/WEB-INF/views/customer/checkout.jsp").forward(request, response);
    }

    /** POST /booking/confirm — Lưu booking vào DB */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int homestayId   = Integer.parseInt(request.getParameter("homestayId"));
            int roomTypeId   = Integer.parseInt(request.getParameter("roomTypeId"));
            String checkin   = request.getParameter("checkin");
            String checkout  = request.getParameter("checkout");
            String voucherCode = request.getParameter("voucherCode");
            String[] addonIdParams = request.getParameterValues("addonIds");

            // Tính tổng
            LocalDate ciDate = LocalDate.parse(checkin);
            LocalDate coDate = LocalDate.parse(checkout);
            long totalNights = ChronoUnit.DAYS.between(ciDate, coDate);
            if (totalNights <= 0) totalNights = 1;

            Optional<Homestay> optH = homestayDAO.getHomestayById(homestayId);
            if (!optH.isPresent()) { response.sendRedirect(request.getContextPath() + "/search"); return; }

            RoomType rt = optH.get().getRoomTypes().stream()
                    .filter(r -> r.getRoomTypeId() == roomTypeId).findFirst().orElse(null);
            if (rt == null) { response.sendRedirect(request.getContextPath() + "/search"); return; }

            BigDecimal roomTotal = rt.getBasePrice().multiply(BigDecimal.valueOf(totalNights));

            // Addon
            BigDecimal addonTotal = BigDecimal.ZERO;
            List<Integer> addonIdList = new java.util.ArrayList<>();
            if (addonIdParams != null) {
                for (String aid : addonIdParams) {
                    int addonId = Integer.parseInt(aid);
                    addonIdList.add(addonId);
                    Optional<Addon> oa = addonDAO.getAddonById(addonId);
                    if (oa.isPresent()) addonTotal = addonTotal.add(oa.get().getPrice());
                }
            }

            // Voucher
            BigDecimal discountAmt = BigDecimal.ZERO;
            Integer vId = null;
            if (voucherCode != null && !voucherCode.trim().isEmpty()) {
                Optional<Voucher> ov = voucherDAO.findByCode(voucherCode.trim());
                if (ov.isPresent()) {
                    Voucher v = ov.get();
                    discountAmt = v.calculateDiscount(roomTotal.add(addonTotal));
                    vId = v.getVoucherId();
                }
            }

            BigDecimal finalTotal = roomTotal.add(addonTotal).subtract(discountAmt);

            // Tạo Booking
            Booking booking = new Booking();
            booking.setCustomerId(currentUser.getUserId());
            booking.setHomestayId(homestayId);
            booking.setRoomTypeId(roomTypeId);
            booking.setGuestName(currentUser.getFullName());
            booking.setGuestEmail(currentUser.getEmail());
            booking.setGuestPhone(currentUser.getPhoneNumber());
            booking.setCheckinDate(Date.valueOf(ciDate));
            booking.setCheckoutDate(Date.valueOf(coDate));
            booking.setTotalNights((int) totalNights);
            booking.setRoomPriceTotal(roomTotal);
            booking.setAddonPriceTotal(addonTotal);
            booking.setDiscountAmount(discountAmt);
            booking.setFinalTotal(finalTotal);
            booking.setVoucherId(vId);
            booking.setBookingStatus("PENDING");
            booking.setBookingType("ONLINE");

            int newBookingId = bookingService.createBooking(booking, addonIdList);

            if (newBookingId > 0) {
                if (vId != null) voucherDAO.incrementUsedCount(vId);
                // Redirect sang payment
                response.sendRedirect(request.getContextPath() + "/payment/create?bookingId=" + newBookingId);
            } else {
                request.setAttribute("errorMsg", "Đặt phòng thất bại. Phòng có thể đã hết trống. Vui lòng thử lại.");
                request.getRequestDispatcher("/WEB-INF/views/customer/checkout.jsp").forward(request, response);
            }

        } catch (Exception e) {
            request.setAttribute("errorMsg", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/customer/checkout.jsp").forward(request, response);
        }
    }
}
