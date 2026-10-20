package com.project.controller;

import com.project.dao.BookingDAO;
import com.project.dao.BookingDAOImpl;
import com.project.dao.HomestayDAO;
import com.project.dao.HomestayDAOImpl;
import com.project.dao.WishlistDAO;
import com.project.dao.WishlistDAOImpl;
import com.project.model.Booking;
import com.project.model.Homestay;
import com.project.model.User;
import com.project.util.GeminiAIUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Controller: Public Home Page Orchestration
 * Package: com.project.controller
 */
@WebServlet(name = "HomeController", urlPatterns = {"/home", "/index", "/default"})
public class HomeController extends HttpServlet {

    private HomestayDAO homestayDAO;
    private BookingDAO  bookingDAO;
    private WishlistDAO wishlistDAO;

    @Override
    public void init() throws ServletException {
        this.homestayDAO  = new HomestayDAOImpl();
        this.bookingDAO   = new BookingDAOImpl();
        this.wishlistDAO  = new WishlistDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session   = request.getSession(false);
        User currentUser      = (session != null) ? (User) session.getAttribute("currentUser") : null;

        // Pool 20 candidates — AI chọn top 6 phù hợp nhất cho từng user
        List<Homestay> pool = homestayDAO.getFeaturedHomestays(20);

        boolean aiReranked = false;

        if (GeminiAIUtil.isEnabled() && !pool.isEmpty()) {
            String userCtx = buildUserContext(currentUser, session);
            List<Homestay> aiList = GeminiAIUtil.rerankForRecommendations(pool, userCtx);
            if (aiList != null && !aiList.isEmpty()) {
                // Lấy top 6 từ danh sách AI đã chọn & sắp xếp
                pool       = aiList.subList(0, Math.min(6, aiList.size()));
                aiReranked = true;
            } else {
                // Fallback: lấy 6 đầu từ rule-based pool
                pool = pool.subList(0, Math.min(6, pool.size()));
            }
        } else {
            pool = pool.subList(0, Math.min(6, pool.size()));
        }

        request.setAttribute("featuredList", pool);
        request.setAttribute("aiReranked",   aiReranked);
        request.setAttribute("pageTitle", "Trang chủ - Hệ thống Đặt phòng Homestay & Hotel Thông minh");
        request.getRequestDispatcher("/WEB-INF/views/customer/home.jsp").forward(request, response);
    }

    /**
     * Build a rich, per-user context string for Gemini reranking.
     * Prioritises real signals: booking history → wishlist cities → last search city → fallback.
     */
    private String buildUserContext(User user, HttpSession session) {
        List<String> signals = new ArrayList<>();

        if (user != null) {
            // 1. Booking history — cities user has actually stayed in
            try {
                List<Booking> bookings = bookingDAO.getBookingsByCustomerId(user.getUserId());
                Map<String, Long> cityCounts = bookings.stream()
                        .filter(b -> b.getHomestayCity() != null && !b.getHomestayCity().isBlank())
                        .collect(Collectors.groupingBy(Booking::getHomestayCity, Collectors.counting()));

                if (!cityCounts.isEmpty()) {
                    String topCities = cityCounts.entrySet().stream()
                            .sorted(Map.Entry.<String, Long>comparingByValue().reversed())
                            .limit(3)
                            .map(Map.Entry::getKey)
                            .collect(Collectors.joining(", "));
                    signals.add("Đã từng đặt phòng tại: " + topCities);
                    signals.add("Tổng số lần đặt phòng: " + bookings.size());
                }
            } catch (Exception ignored) { /* không block nếu lỗi DAO */ }

            // 2. Wishlist — cities / homestays user has saved
            try {
                List<Homestay> wishlist = wishlistDAO.getWishlistByUserId(user.getUserId());
                if (!wishlist.isEmpty()) {
                    String wishCities = wishlist.stream()
                            .map(Homestay::getCity)
                            .filter(Objects::nonNull)
                            .distinct().limit(3)
                            .collect(Collectors.joining(", "));
                    if (!wishCities.isBlank()) {
                        signals.add("Đã lưu yêu thích ở: " + wishCities);
                    }
                }
            } catch (Exception ignored) { }
        }

        // 3. Last search inputs from session
        if (session != null) {
            String lastCity      = (String) session.getAttribute("lastSearchCity");
            String lastGuests    = (String) session.getAttribute("lastSearchGuests");
            String lastMaxPrice  = (String) session.getAttribute("lastSearchMaxPrice");

            if (lastCity     != null && !lastCity.isBlank())
                signals.add("Vừa tìm kiếm tại: " + lastCity);
            if (lastGuests   != null && !lastGuests.isBlank())
                signals.add("Số khách: " + lastGuests);
            if (lastMaxPrice != null && !lastMaxPrice.isBlank())
                signals.add("Ngân sách tối đa: " + lastMaxPrice + " VNĐ/đêm");
        }

        // 4. Fallback
        if (signals.isEmpty()) {
            signals.add("Khách mới, chưa có lịch sử — ưu tiên homestay rating cao và giá phổ biến");
        }

        return String.join(". ", signals);
    }
}
