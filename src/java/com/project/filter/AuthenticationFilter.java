package com.project.filter;

import com.project.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet Filter: Authentication & Role-Based Access Control (RBAC) Filter
 * Package: com.project.filter
 */
@WebFilter(urlPatterns = {"/admin/*", "/owner/*", "/reception/*", "/customer/profile", "/customer/bookings", "/customer/recommendations"})
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null || !currentUser.isActive()) {
            if (session != null) {
                session.invalidate();
            }
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login?error=unauthorized");
            return;
        }

        String uri = httpRequest.getRequestURI();
        User.Role role = currentUser.getRole();

        if (uri.contains("/admin/") && role != User.Role.ADMIN) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Admin Privilege Required");
            return;
        }

        if (uri.contains("/owner/") && role != User.Role.OWNER && role != User.Role.ADMIN) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Owner Privilege Required");
            return;
        }

        if (uri.contains("/reception/") && role != User.Role.RECEPTIONIST && role != User.Role.OWNER && role != User.Role.ADMIN) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Receptionist Privilege Required");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
