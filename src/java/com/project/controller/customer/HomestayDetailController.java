package com.project.controller.customer;

import com.project.dao.*;
import com.project.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

/**
 * Controller: Chi tiết Homestay (UC03 - UC07)
 * Package: com.project.controller.customer
 */
@WebServlet(name = "HomestayDetailController", urlPatterns = {"/homestay/detail", "/detail"})
public class HomestayDetailController extends HttpServlet {

    private HomestayDAO homestayDAO;
    private AddonDAO addonDAO;
    private WishlistDAO wishlistDAO;

    @Override
    public void init() throws ServletException {
        this.homestayDAO = new HomestayDAOImpl();
        this.addonDAO    = new AddonDAOImpl();
        this.wishlistDAO = new WishlistDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null || !idParam.matches("\\d+")) {
            response.sendRedirect(request.getContextPath() + "/search");
            return;
        }

        int homestayId = Integer.parseInt(idParam);
        Optional<Homestay> opt = homestayDAO.getHomestayById(homestayId);

        if (!opt.isPresent()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Homestay không tồn tại");
            return;
        }

        Homestay homestay = opt.get();

        // Load ảnh, tiện ích, reviews
        homestay.setImages(homestayDAO.getHomestayImages(homestayId));
        homestay.setAmenityNames(
            homestayDAO.getHomestayAmenities(homestayId).stream()
                .map(Amenity::getName).collect(java.util.stream.Collectors.toList())
        );
        homestay.setReviews(homestayDAO.getReviewsByHomestayId(homestayId));

        // Addons
        List<Addon> addons = addonDAO.getAddonsByHomestayId(homestayId);

        // Wishlist check
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (currentUser != null) {
            boolean wishlisted = wishlistDAO.isWishlisted(currentUser.getUserId(), homestayId);
            homestay.setWishlisted(wishlisted);
        }

        // Tham số ngày từ search
        String checkin  = request.getParameter("checkin");
        String checkout = request.getParameter("checkout");
        String guests   = request.getParameter("guests");

        request.setAttribute("homestay", homestay);
        request.setAttribute("addons", addons);
        request.setAttribute("checkin", checkin);
        request.setAttribute("checkout", checkout);
        request.setAttribute("guests", guests);
        request.setAttribute("pageTitle", homestay.getName() + " - Smart Booking Platform");

        request.getRequestDispatcher("/WEB-INF/views/customer/detail.jsp").forward(request, response);
    }
}
