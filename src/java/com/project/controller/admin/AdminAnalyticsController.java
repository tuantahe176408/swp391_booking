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
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

/**
 * Controller: Platform Analytics & Financials (UC25)
 * URL: /admin/analytics
 *
 * GET  → Load analytics dashboard.
 *        Filter params: fromDate (yyyy-MM-dd), toDate (yyyy-MM-dd),
 *                       month (1-12), year (yyyy), page (integer, default 1)
 *        Priority: fromDate+toDate > month+year > default (current month)
 *
 * POST → Export .xlsx report (param: action=export), same filter params.
 */
@WebServlet(name = "AdminAnalyticsController", urlPatterns = {"/admin/analytics"})
public class AdminAnalyticsController extends HttpServlet {

    private AdminAnalyticsDAO analyticsDAO;

    private static final double COMMISSION_RATE = 10.0;
    private static final int    PAGE_SIZE       = 10;

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

        // ── 1. Resolve filter params ──────────────────────────────────────
        String filterType    = nullIfBlank(request.getParameter("filterType"));
        String fromDateParam = nullIfBlank(request.getParameter("fromDate"));
        String toDateParam   = nullIfBlank(request.getParameter("toDate"));
        String monthParam    = nullIfBlank(request.getParameter("month"));
        String yearParam     = nullIfBlank(request.getParameter("year"));

        LocalDate today = LocalDate.now();
        PeriodRange range;

        // Normalize filterType; default to "month" on first load
        if (filterType == null) filterType = "month";

        if ("date_range".equals(filterType)) {
            // ── Mode: custom date range ──────────────────────────────────
            if (fromDateParam != null && toDateParam != null) {
                range = new PeriodRange(
                    fromDateParam, toDateParam,
                    resolveGroupBy(fromDateParam, toDateParam),
                    "Từ " + fromDateParam + " đến " + toDateParam);
            } else {
                // Incomplete params — fall back to current month
                filterType    = "month";
                range         = defaultThisMonth(today);
                fromDateParam = range.from;
                toDateParam   = range.to;
                monthParam    = String.valueOf(today.getMonthValue());
                yearParam     = String.valueOf(today.getYear());
            }

        } else if ("year".equals(filterType)) {
            // ── Mode: full year ──────────────────────────────────────────
            yearParam = nullIfBlank(request.getParameter("yearOnly")); // dedicated param for year-only mode
            if (yearParam != null) {
                try {
                    int y = Integer.parseInt(yearParam);
                    range = new PeriodRange(
                        LocalDate.of(y, 1, 1).toString(),
                        LocalDate.of(y, 12, 31).toString(),
                        "MONTH",
                        "Năm " + y);
                } catch (Exception ex) {
                    filterType = "month";
                    range      = defaultThisMonth(today);
                    monthParam = String.valueOf(today.getMonthValue());
                    yearParam  = String.valueOf(today.getYear());
                }
            } else {
                filterType = "month";
                range      = defaultThisMonth(today);
                monthParam = String.valueOf(today.getMonthValue());
                yearParam  = String.valueOf(today.getYear());
            }

        } else {
            // ── Mode: by month (default) ──────────────────────────────────
            filterType = "month";
            if (monthParam != null && yearParam != null) {
                try {
                    int m = Integer.parseInt(monthParam);
                    int y = Integer.parseInt(yearParam);
                    LocalDate start = LocalDate.of(y, m, 1);
                    LocalDate end   = start.withDayOfMonth(start.lengthOfMonth());
                    fromDateParam   = start.toString();
                    toDateParam     = end.toString();
                    range = new PeriodRange(fromDateParam, toDateParam, "DAY",
                        "Tháng " + m + "/" + y);
                } catch (Exception ex) {
                    range         = defaultThisMonth(today);
                    fromDateParam = range.from;
                    toDateParam   = range.to;
                    monthParam    = String.valueOf(today.getMonthValue());
                    yearParam     = String.valueOf(today.getYear());
                }
            } else {
                range         = defaultThisMonth(today);
                fromDateParam = range.from;
                toDateParam   = range.to;
                monthParam    = String.valueOf(today.getMonthValue());
                yearParam     = String.valueOf(today.getYear());
            }
        }

        // ── 2. Pagination ─────────────────────────────────────────────────
        int page   = Math.max(1, parseIntOrDefault(request.getParameter("page"), 1));
        int offset = (page - 1) * PAGE_SIZE;

        // ── 3. KPI Metrics ────────────────────────────────────────────────
        long   totalGmv           = analyticsDAO.getTotalGmv(range.from, range.to);
        int    successfulBookings  = analyticsDAO.countSuccessfulBookings(range.from, range.to);
        int    cancelledBookings   = analyticsDAO.countCancelledBookings(range.from, range.to);
        int    totalBookingsKpi    = analyticsDAO.countTotalBookings(range.from, range.to);
        long   commissionRevenue   = Math.round(totalGmv * COMMISSION_RATE / 100.0);
        double cancelRate          = totalBookingsKpi > 0
                ? Math.round(cancelledBookings * 1000.0 / totalBookingsKpi) / 10.0 : 0.0;

        // Customer KPI
        int uniqueCustomers = analyticsDAO.countUniqueBookingCustomers(range.from, range.to);
        int newCustomers    = analyticsDAO.countNewCustomers(range.from, range.to);

        // ── 4. Platform Stats (all-time) ──────────────────────────────────
        int activeHomestays = analyticsDAO.countActiveHomestays();
        int totalOwners     = analyticsDAO.countOwners();
        int totalCustomers  = analyticsDAO.countCustomers();

        // ── 5. Main Chart: Revenue + Counts ──────────────────────────────
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

        // ── 6. Booking Status Breakdown ───────────────────────────────────
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

        // ── 7. Payment Method Breakdown ───────────────────────────────────
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

        // ── 8. Top Homestays ──────────────────────────────────────────────
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

        // ── 9. New Users (last 6 months, fixed window) ────────────────────
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

        // ── 10. Booking list (paginated) ──────────────────────────────────
        List<Object[]> bookingList  = analyticsDAO.getBookingList(range.from, range.to, offset, PAGE_SIZE);
        int   totalBookingRows      = analyticsDAO.countBookingListRows(range.from, range.to);
        int   totalPages            = (totalBookingRows == 0) ? 1
                : (int) Math.ceil((double) totalBookingRows / PAGE_SIZE);
        if (page > totalPages) page = totalPages;

        // ── 11. Available years for dropdown (2020 → next year) ─────────
        int currentYear = today.getYear();
        List<Integer> availableYears = new ArrayList<>();
        for (int y = 2020; y <= currentYear + 1; y++) availableYears.add(y);

        // ── 12. Set attributes ────────────────────────────────────────────
        request.setAttribute("filterType", filterType);
        request.setAttribute("fromDate",  fromDateParam != null ? fromDateParam : "");
        request.setAttribute("toDate",    toDateParam   != null ? toDateParam   : "");
        request.setAttribute("month",     monthParam    != null ? monthParam    : "");
        request.setAttribute("year",      yearParam     != null ? yearParam     : "");
        request.setAttribute("periodLabel",        range.label);
        request.setAttribute("currentYear",        currentYear);
        request.setAttribute("availableYears",     availableYears);

        request.setAttribute("totalGmv",           totalGmv);
        request.setAttribute("commissionRevenue",  commissionRevenue);
        request.setAttribute("commissionRate",     COMMISSION_RATE);
        request.setAttribute("successfulBookings", successfulBookings);
        request.setAttribute("cancelledBookings",  cancelledBookings);
        request.setAttribute("cancelRate",         cancelRate);
        request.setAttribute("uniqueCustomers",    uniqueCustomers);
        request.setAttribute("newCustomers",       newCustomers);

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

        request.setAttribute("bookingList",        bookingList);
        request.setAttribute("currentPage",        page);
        request.setAttribute("totalPages",         totalPages);
        request.setAttribute("totalBookingRows",   totalBookingRows);

        request.setAttribute("activeTab",          "analytics");

        request.getRequestDispatcher("/WEB-INF/views/admin/analytics.jsp")
               .forward(request, response);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // POST — export .xlsx
    // ─────────────────────────────────────────────────────────────────────────

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request, response)) return;

        // Resolve range from same filter params as GET
        String filterTypePost = nullIfBlank(request.getParameter("filterType"));
        String fromDateParam = nullIfBlank(request.getParameter("fromDate"));
        String toDateParam   = nullIfBlank(request.getParameter("toDate"));
        String monthParam    = nullIfBlank(request.getParameter("month"));
        String yearParam     = nullIfBlank(request.getParameter("year"));

        LocalDate today = LocalDate.now();
        PeriodRange range;

        if ("date_range".equals(filterTypePost) && fromDateParam != null && toDateParam != null) {
            range = new PeriodRange(fromDateParam, toDateParam,
                resolveGroupBy(fromDateParam, toDateParam),
                "Từ " + fromDateParam + " đến " + toDateParam);
        } else if ("year".equals(filterTypePost)) {
            String yp = nullIfBlank(request.getParameter("yearOnly"));
            if (yp == null) yp = yearParam; // fallback to year if yearOnly absent
            try {
                int y = Integer.parseInt(yp);
                range = new PeriodRange(
                    LocalDate.of(y, 1, 1).toString(),
                    LocalDate.of(y, 12, 31).toString(),
                    "MONTH",
                    "Năm " + y);
            } catch (Exception ex) {
                range = defaultThisMonth(today);
            }
        } else if (monthParam != null && yearParam != null) {
            try {
                int m = Integer.parseInt(monthParam);
                int y = Integer.parseInt(yearParam);
                LocalDate start = LocalDate.of(y, m, 1);
                range = new PeriodRange(start.toString(),
                    start.withDayOfMonth(start.lengthOfMonth()).toString(), "DAY",
                    "Tháng " + m + "/" + y);
            } catch (Exception ex) {
                range = defaultThisMonth(today);
            }
        } else {
            range = defaultThisMonth(today);
        }

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

        String today2   = today.format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String filename = "BaoCao_TaiChinh_" + today2 + ".xlsx";

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

    /** Return null when s is null or blank. */
    private static String nullIfBlank(String s) {
        return (s == null || s.isBlank()) ? null : s.trim();
    }

    private static int parseIntOrDefault(String s, int def) {
        try { return (s != null && !s.isBlank()) ? Integer.parseInt(s.trim()) : def; }
        catch (NumberFormatException e) { return def; }
    }

    /**
     * Choose groupBy based on date range length:
     *   ≤ 60 days → DAY-level chart; otherwise → MONTH-level.
     */
    private static String resolveGroupBy(String fromDate, String toDate) {
        if (fromDate == null || toDate == null) return "MONTH";
        try {
            long days = ChronoUnit.DAYS.between(
                LocalDate.parse(fromDate, DateTimeFormatter.ISO_LOCAL_DATE),
                LocalDate.parse(toDate,   DateTimeFormatter.ISO_LOCAL_DATE));
            return days <= 60 ? "DAY" : "MONTH";
        } catch (Exception e) {
            return "MONTH";
        }
    }

    private static PeriodRange defaultThisMonth(LocalDate today) {
        return new PeriodRange(
            today.withDayOfMonth(1).toString(),
            today.toString(),
            "DAY",
            "Tháng " + today.getMonthValue() + "/" + today.getYear());
    }

    /**
     * Kept for backward-compat with any old bookmarks using ?period=this_month etc.
     */
    @SuppressWarnings("unused")
    private static PeriodRange resolvePeriod(String period) {
        LocalDate today = LocalDate.now();
        switch (period) {
            case "this_month":
                return defaultThisMonth(today);
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
            default:
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
