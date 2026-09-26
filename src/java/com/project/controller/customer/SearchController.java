package com.project.controller.customer;

import com.project.dao.HomestayDAO;
import com.project.dao.HomestayDAOImpl;
import com.project.model.Amenity;
import com.project.model.Homestay;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Controller: Tìm kiếm Homestay & Khách sạn (UC03)
 * Package: com.project.controller.customer
 */
@WebServlet(name = "SearchController", urlPatterns = {"/search"})
public class SearchController extends HttpServlet {

    private HomestayDAO homestayDAO;

    @Override
    public void init() throws ServletException {
        this.homestayDAO = new HomestayDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy tham số tìm kiếm
        String location = request.getParameter("location");
        String checkin  = request.getParameter("checkin");
        String checkout = request.getParameter("checkout");
        String guestsParam = request.getParameter("guests");
        String minPriceParam = request.getParameter("minPrice");
        String maxPriceParam = request.getParameter("maxPrice");
        String sortBy   = request.getParameter("sortBy");
        String pageParam = request.getParameter("page");
        String[] amenityIds = request.getParameterValues("amenities");

        // Parse
        Integer guests  = parseIntOrNull(guestsParam);
        Double minPrice = parseDoubleOrNull(minPriceParam);
        Double maxPrice = parseDoubleOrNull(maxPriceParam);
        int page = (pageParam != null && pageParam.matches("\\d+")) ? Integer.parseInt(pageParam) : 1;
        int pageSize = 9;
        int offset = (page - 1) * pageSize;

        List<Integer> amenityList = new java.util.ArrayList<>();
        if (amenityIds != null) {
            for (String id : amenityIds) {
                try { amenityList.add(Integer.parseInt(id)); } catch (NumberFormatException ignored) {}
            }
        }

        // Query
        List<Homestay> results = homestayDAO.searchHomestays(
                location, checkin, checkout, guests,
                minPrice, maxPrice, amenityList, sortBy,
                offset, pageSize);

        int totalResults = homestayDAO.countSearchResults(
                location, checkin, checkout, guests,
                minPrice, maxPrice, amenityList);

        int totalPages = (int) Math.ceil((double) totalResults / pageSize);

        // Danh sách tiện ích + thành phố cho sidebar filter
        List<Amenity> allAmenities = homestayDAO.getAllAmenities();
        List<String> cities = homestayDAO.getAllCities();

        // Set attributes
        request.setAttribute("results", results);
        request.setAttribute("totalResults", totalResults);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("allAmenities", allAmenities);
        request.setAttribute("cities", cities);
        request.setAttribute("searchLocation", location);
        request.setAttribute("searchCheckin", checkin);
        request.setAttribute("searchCheckout", checkout);
        request.setAttribute("searchGuests", guests);
        request.setAttribute("searchMinPrice", minPrice);
        request.setAttribute("searchMaxPrice", maxPrice);
        request.setAttribute("searchSortBy", sortBy);
        request.setAttribute("pageTitle", "Tìm kiếm Homestay - Smart Booking Platform");
        request.setAttribute("activeNav", "search");

        request.getRequestDispatcher("/WEB-INF/views/customer/search.jsp").forward(request, response);
    }

    private Integer parseIntOrNull(String val) {
        if (val == null || val.trim().isEmpty()) return null;
        try { return Integer.parseInt(val.trim()); } catch (NumberFormatException e) { return null; }
    }

    private Double parseDoubleOrNull(String val) {
        if (val == null || val.trim().isEmpty()) return null;
        try { return Double.parseDouble(val.trim()); } catch (NumberFormatException e) { return null; }
    }
}
