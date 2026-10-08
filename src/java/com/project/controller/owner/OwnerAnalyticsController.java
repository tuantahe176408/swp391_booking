package com.project.controller.owner;

import com.project.dao.OwnerAnalyticsDAO;
import com.project.dao.OwnerAnalyticsDAOImpl;
import com.project.model.User;
import com.project.util.PoiReportUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * Controller: View Revenue & Occupancy Analytics (UC20)
 * URL: /owner/analytics[?period=this_month|last_3m|this_year|all_time][&homestayId=N]
 * Package: com.project.controller.owner
 *
 * GET  → Load analytics dashboard with real data from OwnerAnalyticsDAO.
 * POST → Export .xlsx report (param: action=export).
 *
 * Supported periods:
 *   this_month  — 1st of current month → today,     chart by DAY
 *   last_3m     — 3 months ago → today,              chart by MONTH
 *   this_year   — Jan 1 current year → today,        chart by MONTH  (default)
 *   all_time    — earliest data → today,              chart by MONTH
 */
@WebServlet(name = "OwnerAnalyticsController", urlPatterns = {"/owner/analytics"})
public class OwnerAnalyticsController extends HttpServlet {

    private OwnerAnalyticsDAO analyticsDAO;

    @Override
    public void init() throws ServletException {
        this.analyticsDAO = new OwnerAnalyticsDAOImpl();
    }

    // ─────────────────────────────────────────────────────────────────────────
    // GET — render analytics dashboard
    // ─────────────────────────────────────────────────────────────────────────

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = getOwner(request, response);
        if (currentUser == null) return;

        int ownerId = currentUser.getUserId();

        // ── Resolve period ────────────────────────────────────────────────
        String period = request.getParameter("period");
        if (period == null || period.isBlank()) period = "last_3m";
        PeriodRange range = resolvePeriod(period);

        // ── Resolve homestayId filter ─────────────────────────────────────
        Integer homestayId = null;
        String hsParam = request.getParameter("homestayId");
        if (hsParam != null && !hsParam.isBlank() && !hsParam.equals("0")) {
            try {
                homestayId = Integer.parseInt(hsParam);
            } catch (NumberFormatException ignored) { /* treat as "all" */ }
        }

        // ── Owner homestay list (for filter dropdown) ─────────────────────
        List<Object[]> ownerHomestays = analyticsDAO.getOwnerHomestays(ownerId);

        // ── KPI Metrics ───────────────────────────────────────────────────
        long   totalRevenue       = analyticsDAO.getTotalRevenue(ownerId, homestayId, range.from, range.to);
        int    successfulBookings = analyticsDAO.countSuccessfulBookings(ownerId, homestayId, range.from, range.to);
        int    cancelledBookings  = analyticsDAO.countCancelledBookings(ownerId, homestayId, range.from, range.to);
        int    newBookings        = analyticsDAO.countNewBookings(ownerId, homestayId, range.from, range.to);
        int    newReviews         = analyticsDAO.countNewReviews(ownerId, homestayId, range.from, range.to);
        int    checkedIn          = analyticsDAO.countCheckedIn(ownerId, homestayId, range.from, range.to);
        int    checkedOut         = analyticsDAO.countCheckedOut(ownerId, homestayId, range.from, range.to);
        long   adr                = analyticsDAO.getAverageDailyRate(ownerId, homestayId, range.from, range.to);
        double occupancyRate      = analyticsDAO.getOccupancyRate(ownerId, homestayId, range.from, range.to);

        // RevPAR = ADR × (occupancyRate / 100)
        long   revpar = Math.round(adr * occupancyRate / 100.0);

        double cancelRate = newBookings > 0
                ? Math.round(cancelledBookings * 1000.0 / newBookings) / 10.0 : 0.0;

        // ── Revenue Chart ─────────────────────────────────────────────────
        List<Object[]> chartRows = analyticsDAO.getRevenueChartData(
                ownerId, homestayId, range.from, range.to, range.groupBy);

        StringBuilder chartLabels  = new StringBuilder("[");
        StringBuilder chartRevenue = new StringBuilder("[");
        StringBuilder chartCounts  = new StringBuilder("[");
        for (int i = 0; i < chartRows.size(); i++) {
            Object[] row = chartRows.get(i);
            String label = formatChartLabel((String) row[0], range.groupBy);
            if (i > 0) { chartLabels.append(","); chartRevenue.append(","); chartCounts.append(","); }
            chartLabels.append("\"").append(label).append("\"");
            chartRevenue.append(row[1]);
            chartCounts.append(row[2]);
        }
        chartLabels.append("]"); chartRevenue.append("]"); chartCounts.append("]");

        // ── Booking Status Breakdown (donut) ──────────────────────────────
        List<Object[]> statusRows = analyticsDAO.getBookingStatusBreakdown(
                ownerId, homestayId, range.from, range.to);
        StringBuilder statusLabels = new StringBuilder("[");
        StringBuilder statusData   = new StringBuilder("[");
        for (int i = 0; i < statusRows.size(); i++) {
            Object[] r = statusRows.get(i);
            if (i > 0) { statusLabels.append(","); statusData.append(","); }
            statusLabels.append("\"").append(r[0]).append("\"");
            statusData.append(r[1]);
        }
        statusLabels.append("]"); statusData.append("]");

        // ── Top Homestays ─────────────────────────────────────────────────
        List<Object[]> topHsRows = analyticsDAO.getTopHomestaysByRevenue(ownerId, range.from, range.to, 10);

        // ── Recent Bookings ───────────────────────────────────────────────
        List<Object[]> recentBookings = analyticsDAO.getRecentBookings(ownerId, homestayId, 10);

        // ── Request Attributes ────────────────────────────────────────────
        request.setAttribute("period",             period);
        request.setAttribute("periodLabel",        range.label);
        request.setAttribute("fromDate",           range.from != null ? range.from : "");
        request.setAttribute("toDate",             range.to   != null ? range.to   : "");
        request.setAttribute("selectedHomestayId", homestayId != null ? homestayId : 0);
        request.setAttribute("ownerHomestays",     ownerHomestays);

        request.setAttribute("totalRevenue",       totalRevenue);
        request.setAttribute("occupancyRate",      occupancyRate);
        request.setAttribute("adr",                adr);
        request.setAttribute("revpar",             revpar);
        request.setAttribute("newBookings",        newBookings);
        request.setAttribute("successfulBookings", successfulBookings);
        request.setAttribute("cancelledBookings",  cancelledBookings);
        request.setAttribute("cancelRate",         cancelRate);
        request.setAttribute("checkedIn",          checkedIn);
        request.setAttribute("checkedOut",         checkedOut);
        request.setAttribute("newReviews",         newReviews);

        request.setAttribute("chartLabels",        chartLabels.toString());
        request.setAttribute("chartRevenue",       chartRevenue.toString());
        request.setAttribute("chartCounts",        chartCounts.toString());
        request.setAttribute("chartGroupBy",       range.groupBy);

        request.setAttribute("statusLabels",       statusLabels.toString());
        request.setAttribute("statusData",         statusData.toString());

        request.setAttribute("topHsRows",          topHsRows);
        request.setAttribute("recentBookings",     recentBookings);

        request.setAttribute("activeTab",          "analytics");
        request.setAttribute("pageTitle",          "Chủ nhà - Doanh thu & Thống kê");
        request.setAttribute("pageBreadcrumb",     "Vận hành & Báo cáo");

        request.getRequestDispatcher("/WEB-INF/views/owner/analytics.jsp").forward(request, response);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // POST — export .xlsx  (?action=export)
    // ─────────────────────────────────────────────────────────────────────────

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = getOwner(request, response);
        if (currentUser == null) return;

        int ownerId = currentUser.getUserId();

        String period = request.getParameter("period");
        if (period == null || period.isBlank()) period = "last_3m";
        PeriodRange range = resolvePeriod(period);

        Integer homestayId = null;
        String hsParam = request.getParameter("homestayId");
        if (hsParam != null && !hsParam.isBlank() && !hsParam.equals("0")) {
            try { homestayId = Integer.parseInt(hsParam); }
            catch (NumberFormatException ignored) { }
        }

        // Collect data for Excel
        long   totalRevenue       = analyticsDAO.getTotalRevenue(ownerId, homestayId, range.from, range.to);
        long   adr                = analyticsDAO.getAverageDailyRate(ownerId, homestayId, range.from, range.to);
        double occupancyRate      = analyticsDAO.getOccupancyRate(ownerId, homestayId, range.from, range.to);
        int    successfulBookings = analyticsDAO.countSuccessfulBookings(ownerId, homestayId, range.from, range.to);
        int    cancelledBookings  = analyticsDAO.countCancelledBookings(ownerId, homestayId, range.from, range.to);

        List<Object[]> chartRows   = analyticsDAO.getRevenueChartData(ownerId, homestayId, range.from, range.to, range.groupBy);
        List<Object[]> topHsRows   = analyticsDAO.getTopHomestaysByRevenue(ownerId, range.from, range.to, 20);
        List<Object[]> statusRows  = analyticsDAO.getBookingStatusBreakdown(ownerId, homestayId, range.from, range.to);
        List<Object[]> recentRows  = analyticsDAO.getRecentBookings(ownerId, homestayId, 50);

        String today    = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String filename = "BaoCao_Owner_" + period + "_" + today + ".xlsx";

        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");

        PoiReportUtil.writeOwnerAnalyticsReport(
                response.getOutputStream(),
                currentUser.getFullName(),
                range.label,
                totalRevenue,
                adr,
                occupancyRate,
                successfulBookings,
                cancelledBookings,
                chartRows,
                topHsRows,
                statusRows,
                recentRows
        );
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Helpers
    // ─────────────────────────────────────────────────────────────────────────

    private User getOwner(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return null;
        }
        if (user.getRole() != User.Role.OWNER) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return null;
        }
        return user;
    }

    /** Resolve period string to date bounds + groupBy + label. */
    private static PeriodRange resolvePeriod(String period) {
        LocalDate today = LocalDate.now();
        switch (period) {
            case "last_3m":
                return new PeriodRange(
                        today.minusMonths(3).withDayOfMonth(1).toString(), today.toString(), "MONTH",
                        "3 tháng qua");
            case "this_year":
                return new PeriodRange(
                        LocalDate.of(today.getYear(), 1, 1).toString(), today.toString(), "MONTH",
                        "Năm " + today.getYear());
            case "all_time":
                return new PeriodRange(null, null, "MONTH", "Tất cả thời gian");
            default: // this_month
                return new PeriodRange(
                        today.withDayOfMonth(1).toString(), today.toString(), "DAY",
                        "Tháng " + today.getMonthValue() + "/" + today.getYear());
        }
    }

    /**
     * DAY  "2026-10-15" → "15/10"
     * MONTH "2026-10"   → "T10/2026"
     */
    private static String formatChartLabel(String raw, String groupBy) {
        if (raw == null) return "";
        try {
            if ("DAY".equals(groupBy)) {
                LocalDate d = LocalDate.parse(raw, DateTimeFormatter.ISO_LOCAL_DATE);
                return String.format("%02d/%02d", d.getDayOfMonth(), d.getMonthValue());
            } else {
                String[] parts = raw.split("-");
                return "T" + Integer.parseInt(parts[1]) + "/" + parts[0];
            }
        } catch (Exception e) {
            return raw;
        }
    }

    private static class PeriodRange {
        final String from;
        final String to;
        final String groupBy;
        final String label;
        PeriodRange(String from, String to, String groupBy, String label) {
            this.from    = from;
            this.to      = to;
            this.groupBy = groupBy;
            this.label   = label;
        }
    }
}
