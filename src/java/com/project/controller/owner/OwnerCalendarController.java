package com.project.controller.owner;

import com.project.dao.CalendarDAO;
import com.project.dao.CalendarDAOImpl;
import com.project.dao.HomestayDAO;
import com.project.dao.HomestayDAOImpl;
import com.project.model.DynamicPrice;
import com.project.model.Homestay;
import com.project.model.RoomType;
import com.project.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

/**
 * Controller: Room Calendar & Dynamic Pricing (UC18)
 * GET  /owner/calendar  — render calendar view
 * POST /owner/calendar  — bulk-apply pricing rule OR single upsert/delete
 * Package: com.project.controller.owner
 */
@WebServlet(name = "OwnerCalendarController", urlPatterns = {"/owner/calendar"})
public class OwnerCalendarController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(OwnerCalendarController.class.getName());

    private final HomestayDAO homestayDAO = new HomestayDAOImpl();
    private final CalendarDAO calendarDAO = new CalendarDAOImpl();

    // ── GET: render calendar ──────────────────────────────────────────────────

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int ownerId = currentUser.getUserId();

        // ── Parse month / homestay params ────────────────────────────────────
        LocalDate today = LocalDate.now();
        int year  = today.getYear();
        int month = today.getMonthValue();

        String yearParam  = request.getParameter("year");
        String monthParam = request.getParameter("month");
        try {
            if (yearParam  != null) year  = Integer.parseInt(yearParam.trim());
            if (monthParam != null) month = Integer.parseInt(monthParam.trim());
        } catch (NumberFormatException ignored) {}

        // Clamp month 1–12
        month = Math.max(1, Math.min(12, month));

        // ── Load owner homestays ─────────────────────────────────────────────
        List<Homestay> myHomestays = homestayDAO.getHomestaysByOwnerId(ownerId);
        if (myHomestays.isEmpty()) {
            request.setAttribute("myHomestays", myHomestays);
            request.setAttribute("activeTab",  "calendar");
            request.setAttribute("pageTitle",  "Lịch & Giá phòng");
            request.setAttribute("pageBreadcrumb", "Quản lý Tài sản");
            request.getRequestDispatcher("/WEB-INF/views/owner/calendar.jsp").forward(request, response);
            return;
        }

        // ── Resolve selected homestay ────────────────────────────────────────
        int selectedHomestayId = myHomestays.get(0).getHomestayId();
        String hsParam = request.getParameter("homestayId");
        if (hsParam != null) {
            try {
                int parsed = Integer.parseInt(hsParam.trim());
                boolean owned = myHomestays.stream()
                        .anyMatch(h -> h.getHomestayId() == parsed);
                if (owned) selectedHomestayId = parsed;
            } catch (NumberFormatException ignored) {}
        }
        final int finalHomestayId = selectedHomestayId;

        // ── Load room types for selected homestay ────────────────────────────
        List<RoomType> roomTypes = homestayDAO.getRoomTypesByHomestayId(selectedHomestayId);
        List<Integer>  roomTypeIds = roomTypes.stream()
                .map(RoomType::getRoomTypeId)
                .collect(Collectors.toList());

        // ── Load dynamic price map for the month ─────────────────────────────
        Map<String, DynamicPrice> priceMap = calendarDAO
                .getPriceMapByRoomTypesAndMonth(roomTypeIds, year, month);

        // ── Build base price lookup: roomTypeId → basePrice ──────────────────
        Map<Integer, BigDecimal> basePriceMap = new LinkedHashMap<>();
        for (RoomType rt : roomTypes) {
            basePriceMap.put(rt.getRoomTypeId(), rt.getBasePrice());
        }

        // ── Build calendar days list (1 → lastDay) ───────────────────────────
        YearMonth ym = YearMonth.of(year, month);
        int daysInMonth = ym.lengthOfMonth();
        // dayOfWeek of 1st day: 1=Mon … 7=Sun (ISO)
        int firstDow = ym.atDay(1).getDayOfWeek().getValue(); // 1=Mon

        // ── Prev / Next month ────────────────────────────────────────────────
        YearMonth prev = ym.minusMonths(1);
        YearMonth next = ym.plusMonths(1);

        // ── Push to request ──────────────────────────────────────────────────
        request.setAttribute("myHomestays",        myHomestays);
        request.setAttribute("selectedHomestayId", selectedHomestayId);
        request.setAttribute("roomTypes",          roomTypes);
        request.setAttribute("basePriceMap",       basePriceMap);
        request.setAttribute("priceMap",           priceMap);
        request.setAttribute("year",               year);
        request.setAttribute("month",              month);
        request.setAttribute("daysInMonth",        daysInMonth);
        request.setAttribute("firstDow",           firstDow);   // 1=Mon offset
        request.setAttribute("prevYear",           prev.getYear());
        request.setAttribute("prevMonth",          prev.getMonthValue());
        request.setAttribute("nextYear",           next.getYear());
        request.setAttribute("nextMonth",          next.getMonthValue());

        request.setAttribute("activeTab",     "calendar");
        request.setAttribute("pageTitle",     "Lịch & Giá phòng");
        request.setAttribute("pageBreadcrumb","Quản lý Tài sản");

        request.getRequestDispatcher("/WEB-INF/views/owner/calendar.jsp")
               .forward(request, response);
    }

    // ── POST: apply pricing rule ──────────────────────────────────────────────

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

        String action = request.getParameter("action");   // "bulk" | "single" | "delete"
        String yearP  = request.getParameter("year");
        String monthP = request.getParameter("month");
        String hsP    = request.getParameter("homestayId");

        int year  = parseIntSafe(yearP,  LocalDate.now().getYear());
        int month = parseIntSafe(monthP, LocalDate.now().getMonthValue());
        int homestayId = parseIntSafe(hsP, 0);

        // Verify ownership
        List<Homestay> myHomestays = homestayDAO.getHomestaysByOwnerId(currentUser.getUserId());
        boolean owned = myHomestays.stream().anyMatch(h -> h.getHomestayId() == homestayId);
        if (!owned) {
            response.sendRedirect(request.getContextPath() + "/owner/calendar");
            return;
        }

        if ("delete".equals(action)) {
            // ── Single delete ────────────────────────────────────────────────
            int rtId   = parseIntSafe(request.getParameter("roomTypeId"), 0);
            String date = request.getParameter("date");
            if (rtId > 0 && date != null && !date.isEmpty()) {
                calendarDAO.deleteDynamicPrice(rtId, date);
            }

        } else if ("single".equals(action)) {
            // ── Single upsert ────────────────────────────────────────────────
            int    rtId        = parseIntSafe(request.getParameter("roomTypeId"), 0);
            String date        = request.getParameter("date");
            String multStr     = request.getParameter("priceMultiplier");
            String customStr   = request.getParameter("customPrice");
            boolean isLocked   = "true".equalsIgnoreCase(request.getParameter("isLocked"));

            if (rtId > 0 && date != null && !date.isEmpty()) {
                DynamicPrice dp = new DynamicPrice();
                dp.setRoomTypeId(rtId);
                dp.setDate(java.sql.Date.valueOf(date));
                dp.setPriceMultiplier(parseBigDecimalSafe(multStr));
                dp.setCustomPrice(parseBigDecimalSafe(customStr));
                dp.setLocked(isLocked);
                calendarDAO.upsertDynamicPrice(dp);
            }

        } else {
            // ── Bulk upsert (default) ────────────────────────────────────────
            String[] rtIdStrs  = request.getParameterValues("roomTypeIds");
            String[] dateStrs  = request.getParameterValues("dates");
            String multStr     = request.getParameter("priceMultiplier");
            String customStr   = request.getParameter("customPrice");
            boolean isLocked   = "true".equalsIgnoreCase(request.getParameter("isLocked"));

            List<Integer> rtIds = new ArrayList<>();
            if (rtIdStrs != null) {
                for (String s : rtIdStrs) {
                    int id = parseIntSafe(s, 0);
                    if (id > 0) rtIds.add(id);
                }
            }
            List<String> dates = (dateStrs != null)
                    ? Arrays.asList(dateStrs)
                    : Collections.emptyList();

            if (!rtIds.isEmpty() && !dates.isEmpty()) {
                calendarDAO.bulkUpsert(rtIds, dates,
                        parseBigDecimalSafe(multStr),
                        parseBigDecimalSafe(customStr),
                        isLocked);
            }
        }

        // Redirect back to same month/homestay
        response.sendRedirect(request.getContextPath()
                + "/owner/calendar?year=" + year
                + "&month=" + month
                + "&homestayId=" + homestayId);
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private int parseIntSafe(String s, int fallback) {
        if (s == null || s.trim().isEmpty()) return fallback;
        try { return Integer.parseInt(s.trim()); } catch (NumberFormatException e) { return fallback; }
    }

    private BigDecimal parseBigDecimalSafe(String s) {
        if (s == null || s.trim().isEmpty()) return null;
        try { return new BigDecimal(s.trim()); } catch (NumberFormatException e) { return null; }
    }
}
