package com.project.controller.admin;

import com.project.dao.AdminAnalyticsDAO;
import com.project.dao.AdminAnalyticsDAOImpl;
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
 * Controller: Platform Analytics & Financials (UC25)
 * URL: /admin/analytics[?period=this_month|last_3m|this_year|last_year|all_time]
 * Package: com.project.controller.admin
 *
 * GET  → Load analytics dashboard with chart data
 * POST → Export .xlsx report (param: action=export)
 *
 * Supported periods:
 *   this_month  — 1st of current month → today,    chart by DAY
 *   last_3m     — 3 months ago → today,             chart by MONTH
 *   this_year   — Jan 1 current year → today,       chart by MONTH  (default)
 *   last_year   — Jan 1 – Dec 31 of previous year,  chart by MONTH
 *   all_time    — earliest data → today,             chart by MONTH
 */
@WebServlet(name = "AdminAnalyticsController", urlPatterns = {"/admin/analytics"})
public class AdminAnalyticsController extends HttpServlet {

    private AdminAnalyticsDAO analyticsDAO;

    /** Platform commission rate used for display (deferred from SystemConfig). */
    private static final double COMMISSION_RATE = 10.0;

    @Override
    public void init() throws ServletException {
        this.analyticsDAO = new AdminAnalyticsDAOImpl();
    }

    // ─────────────────────────────────────────────────────────────────────────
    // GET — render analytics dashboard
    // ─────────────────────────────────────────────────────────────────────────

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request, response)) return;

        // ── Resolve period ────────────────────────────────────────────────
        String period = request.getParameter("period");
        if (period == null || period.isBlank()) period = "this_year";

        PeriodRange range = resolvePeriod(period);

        // ── KPI Metrics ───────────────────────────────────────────────────
        long   totalGmv           = analyticsDAO.getTotalGmv(range.from, range.to);
        int    successfulBookings  = analyticsDAO.countSuccessfulBookings(range.from, range.to);
        int    cancelledBookings   = analyticsDAO.countCancelledBookings(range.from, range.to);
        int    totalBookings       = analyticsDAO.countTotalBookings(range.from, range.to);
        long   commissionRevenue   = Math.round(totalGmv * COMMISSION_RATE / 100.0);
        double cancelRate          = totalBookings > 0
                ? Math.round(cancelledBookings * 1000.0 / totalBookings) / 10.0 : 0.0;

        // ── Platform Stats (all-time) ─────────────────────────────────────
        int activeHomestays = analyticsDAO.countActiveHomestays();
        int totalOwners     = analyticsDAO.countOwners();
        int totalCustomers  = analyticsDAO.countCustomers();

        // ── Main Chart: Revenue + Counts ──────────────────────────────────
        List<Object[]> chartRows = analyticsDAO.getChartData(range.from, range.to, range.groupBy);
        StringBuilder chartLabels = new StringBuilder("[");
        StringBuilder chartGmv    = new StringBuilder("[");
        StringBuilder chartCounts = new StringBuilder("[");
        for (int i = 0; i < chartRows.size(); i++) {
            Object[] row = chartRows.get(i);
            String label = formatChartLabel((String) row[0], range.groupBy);
            if (i > 0) { chartLabels.append(","); chartGmv.append(","); chartCounts.append(","); }
            chartLabels.append("\"").append(label).append("\"");
            chartGmv.append(row[1]);
            chartCounts.append(row[2]);
        }
        chartLabels.append("]"); chartGmv.append("]"); chartCounts.append("]");

        // ── Booking Status Breakdown ──────────────────────────────────────
        List<Object[]> statusRows = analyticsDAO.getBookingStatusBreakdown(range.from, range.to);
        StringBuilder statusLabels = new StringBuilder("[");
        StringBuilder statusData   = new StringBuilder("[");
        for (int i = 0; i < statusRows.size(); i++) {
            Object[] r = statusRows.get(i);
            if (i > 0) { statusLabels.append(","); statusData.append(","); }
            statusLabels.append("\"").append(r[0]).append("\"");
            statusData.append(r[1]);
        }
        statusLabels.append("]"); statusData.append("]");

        // ── Payment Method Breakdown ──────────────────────────────────────
        List<Object[]> paymentRows = analyticsDAO.getPaymentMethodBreakdown(range.from, range.to);
        StringBuilder paymentLabels = new StringBuilder("[");
        StringBuilder paymentData   = new StringBuilder("[");
        for (int i = 0; i < paymentRows.size(); i++) {
            Object[] r = paymentRows.get(i);
            if (i > 0) { paymentLabels.append(","); paymentData.append(","); }
            paymentLabels.append("\"").append(r[0]).append("\"");
            paymentData.append(r[1]);
        }
        paymentLabels.append("]"); paymentData.append("]");

        // ── Top Homestays ─────────────────────────────────────────────────
        List<Object[]> topHomestayRows = analyticsDAO.getTopHomestaysByRevenue(range.from, range.to, 6);
        StringBuilder topHsLabels  = new StringBuilder("[");
        StringBuilder topHsRevenue = new StringBuilder("[");
        StringBuilder topHsCounts  = new StringBuilder("[");
        for (int i = 0; i < topHomestayRows.size(); i++) {
            Object[] r = topHomestayRows.get(i);
            String hsName = ((String) r[0]).replace("\"", "\\\"");
            if (i > 0) { topHsLabels.append(","); topHsRevenue.append(","); topHsCounts.append(","); }
            topHsLabels.append("\"").append(hsName).append("\"");
            topHsRevenue.append(r[1]);
            topHsCounts.append(r[2]);
        }
        topHsLabels.append("]"); topHsRevenue.append("]"); topHsCounts.append("]");

        // ── New Users Per Month (fixed: last 6 months) ────────────────────
        String userFromDate = LocalDate.now().minusMonths(5).withDayOfMonth(1).toString();
        List<Object[]> newUserRows = analyticsDAO.getNewUsersPerMonth(userFromDate, null);
        StringBuilder userLabels = new StringBuilder("[");
        StringBuilder userData   = new StringBuilder("[");
        for (int i = 0; i < newUserRows.size(); i++) {
            Object[] r = newUserRows.get(i);
            String label = formatChartLabel((String) r[0], "MONTH");
            if (i > 0) { userLabels.append(","); userData.append(","); }
            userLabels.append("\"").append(label).append("\"");
            userData.append(r[1]);
        }
        userLabels.append("]"); userData.append("]");

        // ── Request Attributes ────────────────────────────────────────────
        request.setAttribute("period",             period);
        request.setAttribute("periodLabel",        range.label);
        request.setAttribute("fromDate",           range.from != null ? range.from : "");
        request.setAttribute("toDate",             range.to   != null ? range.to   : "");

        request.setAttribute("totalGmv",           totalGmv);
        request.setAttribute("commissionRevenue",  commissionRevenue);
        request.setAttribute("commissionRate",     COMMISSION_RATE);
        request.setAttribute("successfulBookings", successfulBookings);
        request.setAttribute("cancelledBookings",  cancelledBookings);
        request.setAttribute("cancelRate",         cancelRate);

        request.setAttribute("activeHomestays",    activeHomestays);
        request.setAttribute("totalOwners",        totalOwners);
        request.setAttribute("totalCustomers",     totalCustomers);

        request.setAttribute("chartLabels",        chartLabels.toString());
        request.setAttribute("chartGmv",           chartGmv.toString());
        request.setAttribute("chartCounts",        chartCounts.toString());
        request.setAttribute("chartGroupBy",       range.groupBy);

        request.setAttribute("statusLabels",       statusLabels.toString());
        request.setAttribute("statusData",         statusData.toString());
        request.setAttribute("paymentLabels",      paymentLabels.toString());
        request.setAttribute("paymentData",        paymentData.toString());

        request.setAttribute("topHsLabels",        topHsLabels.toString());
        request.setAttribute("topHsRevenue",       topHsRevenue.toString());
        request.setAttribute("topHsCounts",        topHsCounts.toString());

        request.setAttribute("userLabels",         userLabels.toString());
        request.setAttribute("userData",           userData.toString());

        request.setAttribute("activeTab",          "analytics");
        request.setAttribute("pageTitle",          "Admin - Phân tích Tài chính Toàn sàn");
        request.setAttribute("pageBreadcrumb",     "Hệ thống & Phân tích");

        request.getRequestDispatcher("/WEB-INF/views/admin/analytics.jsp")
               .forward(request, response);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // POST — export .xlsx  (?action=export&period=...)
    // ─────────────────────────────────────────────────────────────────────────

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request, response)) return;

        String period = request.getParameter("period");
        if (period == null || period.isBlank()) period = "this_year";
        PeriodRange range = resolvePeriod(period);

        // Fetch all data needed for the report
        long   totalGmv           = analyticsDAO.getTotalGmv(range.from, range.to);
        int    successfulBookings  = analyticsDAO.countSuccessfulBookings(range.from, range.to);
        int    cancelledBookings   = analyticsDAO.countCancelledBookings(range.from, range.to);
        long   commissionRevenue   = Math.round(totalGmv * COMMISSION_RATE / 100.0);
        int    activeHomestays     = analyticsDAO.countActiveHomestays();
        int    totalOwners         = analyticsDAO.countOwners();
        int    totalCustomers      = analyticsDAO.countCustomers();

        List<Object[]> chartRows   = analyticsDAO.getChartData(range.from, range.to, range.groupBy);
        List<Object[]> topHsRows   = analyticsDAO.getTopHomestaysByRevenue(range.from, range.to, 20);
        List<Object[]> paymentRows = analyticsDAO.getPaymentMethodBreakdown(range.from, range.to);

        // Build filename: BaoCao_TaiChinh_<period>_<date>.xlsx
        String today    = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String filename = "BaoCao_TaiChinh_" + period + "_" + today + ".xlsx";

        // Set response headers for download
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");

        PoiReportUtil.writeAnalyticsReport(
                response.getOutputStream(),
                range.label,
                totalGmv, commissionRevenue, COMMISSION_RATE,
                successfulBookings, cancelledBookings,
                activeHomestays, totalOwners, totalCustomers,
                chartRows, topHsRows, paymentRows
        );
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Helpers
    // ─────────────────────────────────────────────────────────────────────────

    private boolean isAdmin(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (user == null || user.getRole() != User.Role.ADMIN) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return false;
        }
        return true;
    }

    /** Resolve a period string into date bounds + groupBy + label. */
    private static PeriodRange resolvePeriod(String period) {
        LocalDate today = LocalDate.now();
        switch (period) {
            case "this_month":
                return new PeriodRange(
                        today.withDayOfMonth(1).toString(), today.toString(), "DAY",
                        "Tháng " + today.getMonthValue() + "/" + today.getYear());
            case "last_3m":
                return new PeriodRange(
                        today.minusMonths(3).withDayOfMonth(1).toString(), today.toString(), "MONTH",
                        "3 tháng qua");
            case "last_year": {
                int ly = today.getYear() - 1;
                return new PeriodRange(
                        LocalDate.of(ly, 1, 1).toString(),
                        LocalDate.of(ly, 12, 31).toString(), "MONTH",
                        "Năm " + ly);
            }
            case "all_time":
                return new PeriodRange(null, null, "MONTH", "Tất cả thời gian");
            default: // this_year
                return new PeriodRange(
                        LocalDate.of(today.getYear(), 1, 1).toString(), today.toString(), "MONTH",
                        "Năm " + today.getYear());
        }
    }

    /**
     * Convert raw DB period string to a human-readable chart label.
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

    /** Simple value object holding resolved period bounds. */
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
