package com.project.filter;

import com.project.dao.BookingDAO;
import com.project.dao.BookingDAOImpl;
import com.project.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet Filter: Inject booking notification count vào mọi request.
 * Chỉ query DB khi user đã đăng nhập và có role CUSTOMER.
 * Kết quả được cache trong session 60 giây để tránh query liên tục.
 *
 * Attribute được set: request.notifCount (int) — dùng trong navbar.jsp
 * Package: com.project.filter
 */
@WebFilter(filterName = "NotificationFilter", urlPatterns = {"/*"})
public class NotificationFilter implements Filter {

    private static final int CACHE_TTL_MS = 60_000; // 60 giây

    private BookingDAO bookingDAO;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        this.bookingDAO = new BookingDAOImpl();
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpReq = (HttpServletRequest) request;
        HttpSession session = httpReq.getSession(false);

        if (session != null) {
            User user = (User) session.getAttribute("currentUser");

            if (user != null && user.isActive() && user.getRole() == User.Role.CUSTOMER) {
                // Cache trong session để không query mỗi request
                Long lastFetch = (Long)  session.getAttribute("notifCount_ts");
                Integer cached = (Integer) session.getAttribute("notifCount_cache");

                long now = System.currentTimeMillis();
                if (cached == null || lastFetch == null || (now - lastFetch) > CACHE_TTL_MS) {
                    try {
                        cached = bookingDAO.countBookingNotifications(user.getUserId());
                    } catch (Exception e) {
                        cached = 0;
                    }
                    session.setAttribute("notifCount_cache", cached);
                    session.setAttribute("notifCount_ts",    now);
                }

                httpReq.setAttribute("notifCount", cached);
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
