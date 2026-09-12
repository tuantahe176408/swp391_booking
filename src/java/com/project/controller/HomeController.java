package com.project.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Controller: Public Home Page Orchestration
 * Package: com.project.controller
 */
@WebServlet(name = "HomeController", urlPatterns = {"/home", ""})
public class HomeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setAttribute("pageTitle", "Trang chủ - Hệ thống Đặt phòng Homestay & Hotel Thông minh");
        request.getRequestDispatcher("/WEB-INF/views/customer/home.jsp").forward(request, response);
    }
}
