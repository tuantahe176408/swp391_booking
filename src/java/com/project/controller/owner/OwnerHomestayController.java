package com.project.controller.owner;

import com.project.dao.HomestayDAO;
import com.project.dao.HomestayDAOImpl;
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
 * Controller: Homestay & Room Property Listing Management (UC17)
 * GET /owner/homestays — list all homestays of current owner with stats
 * Package: com.project.controller.owner
 */
@WebServlet(name = "OwnerHomestayController", urlPatterns = {"/owner/homestays"})
public class OwnerHomestayController extends HttpServlet {

    private final HomestayDAO homestayDAO = new HomestayDAOImpl();

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

        // ── Load homestay list ────────────────────────────────────────────────
        List<Homestay> homestays = homestayDAO.getHomestaysByOwnerId(ownerId);

        // ── Stats: count by status ────────────────────────────────────────────
        int countTotal    = homestays.size();
        int countActive   = homestayDAO.countHomestaysByOwnerAndStatus(ownerId, Homestay.Status.ACTIVE);
        int countPending  = homestayDAO.countHomestaysByOwnerAndStatus(ownerId, Homestay.Status.PENDING_APPROVAL);
        int countRejected = homestayDAO.countHomestaysByOwnerAndStatus(ownerId, Homestay.Status.REJECTED);
        int countInactive = homestayDAO.countHomestaysByOwnerAndStatus(ownerId, Homestay.Status.INACTIVE);

        // Total room count across all homestays
        int totalRooms = homestays.stream().mapToInt(Homestay::getRoomCount).sum();

        // ── Push to request ───────────────────────────────────────────────────
        request.setAttribute("homestays",     homestays);
        request.setAttribute("countTotal",    countTotal);
        request.setAttribute("countActive",   countActive);
        request.setAttribute("countPending",  countPending);
        request.setAttribute("countRejected", countRejected);
        request.setAttribute("countInactive", countInactive);
        request.setAttribute("totalRooms",    totalRooms);

        request.setAttribute("activeTab",     "homestays");
        request.setAttribute("pageTitle",     "Cơ sở Homestay");
        request.setAttribute("pageBreadcrumb","Quản lý Tài sản");

        request.getRequestDispatcher("/WEB-INF/views/owner/homestay-form.jsp")
               .forward(request, response);
    }
}
