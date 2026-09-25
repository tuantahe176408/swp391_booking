package com.project.controller.customer;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Controller: Trang Giới thiệu Về chúng tôi
 * URL: /about
 * Package: com.project.controller.customer
 */
@WebServlet(name = "AboutController", urlPatterns = {"/about"})
public class AboutController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("pageTitle", "Về chúng tôi - Smart Booking Platform");
        request.setAttribute("activeNav", "about");
        request.getRequestDispatcher("/WEB-INF/views/customer/about.jsp").forward(request, response);
    }
}
