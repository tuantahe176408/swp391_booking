package com.project.filter;

import com.project.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet Filter: Authentication & Role-Based Access Control (RBAC) Filter
 * Package: com.project.filter
 */
@WebFilter(urlPatterns = {"/admin/*", "/owner/*", "/reception/*", "/profile", "/customer/profile", "/customer/bookings", "/customer/recommendations", "/customer/wishlist", "/customer/payment-history"})
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
            String targetUri = httpRequest.getRequestURI();
            String contextPath = httpRequest.getContextPath();
            String relativePath = targetUri.startsWith(contextPath) ? targetUri.substring(contextPath.length()) : targetUri;
            String queryString = httpRequest.getQueryString();
            String fullRedirect = relativePath + (queryString != null && !queryString.trim().isEmpty() ? "?" + queryString : "");

            if (fullRedirect != null && !fullRedirect.isEmpty() && !fullRedirect.contains("/login") && !fullRedirect.contains("/register") && !fullRedirect.contains("/logout")) {
                String encodedRedirect = java.net.URLEncoder.encode(fullRedirect, "UTF-8");
                httpResponse.sendRedirect(contextPath + "/login?redirect=" + encodedRedirect);
            } else {
                httpResponse.sendRedirect(contextPath + "/login");
            }
            return;
        }

        String uri = httpRequest.getRequestURI();

        if (currentUser.isMustChangePassword()) {
            if (!uri.contains("/force-change-password") && !uri.contains("/logout")) {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/force-change-password");
                return;
            }
        }

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
