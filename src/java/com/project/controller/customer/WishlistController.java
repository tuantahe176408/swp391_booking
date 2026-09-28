package com.project.controller.customer;

import com.google.gson.JsonObject;
import com.project.dao.WishlistDAO;
import com.project.dao.WishlistDAOImpl;
import com.project.model.Homestay;
import com.project.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Controller: Manage Wishlist & Saved Lists (UC06)
 * Package: com.project.controller.customer
 */
@WebServlet(name = "WishlistController", urlPatterns = {"/customer/wishlist", "/customer/wishlist/toggle"})
public class WishlistController extends HttpServlet {

    private WishlistDAO wishlistDAO;

    @Override
    public void init() throws ServletException {
        this.wishlistDAO = new WishlistDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=" +
                    java.net.URLEncoder.encode("Vui lòng đăng nhập để xem danh sách yêu thích", "UTF-8"));
            return;
        }

        List<Homestay> savedHomestays = wishlistDAO.getWishlistByUserId(currentUser.getUserId());
        request.setAttribute("savedHomestays", savedHomestays);
        request.setAttribute("activeTab", "wishlist");
        request.setAttribute("pageTitle", "Danh sách Yêu thích của tôi - Smart Booking Platform");

        request.getRequestDispatcher("/WEB-INF/views/customer/wishlist.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        response.setContentType("application/json;charset=UTF-8");
        JsonObject json = new JsonObject();

        if (currentUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            json.addProperty("status", "error");
            json.addProperty("message", "Vui lòng đăng nhập trước khi thêm vào danh sách yêu thích.");
            response.getWriter().write(json.toString());
            return;
        }

        String homestayIdStr = request.getParameter("homestayId");
        if (homestayIdStr == null || homestayIdStr.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            json.addProperty("status", "error");
            json.addProperty("message", "Thiếu homestayId.");
            response.getWriter().write(json.toString());
            return;
        }

        try {
            int homestayId = Integer.parseInt(homestayIdStr);
            boolean currentlySaved = wishlistDAO.isWishlisted(currentUser.getUserId(), homestayId);
            if (currentlySaved) {
                wishlistDAO.removeFromWishlist(currentUser.getUserId(), homestayId);
                json.addProperty("status", "success");
                json.addProperty("is_saved", false);
                json.addProperty("wishlisted", false);
                json.addProperty("saved", false);
            } else {
                wishlistDAO.addToWishlist(currentUser.getUserId(), homestayId);
                json.addProperty("status", "success");
                json.addProperty("is_saved", true);
                json.addProperty("wishlisted", true);
                json.addProperty("saved", true);
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            json.addProperty("status", "error");
            json.addProperty("message", "Mã homestay không hợp lệ.");
        }

        response.getWriter().write(json.toString());
    }
}
