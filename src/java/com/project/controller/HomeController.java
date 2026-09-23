package com.project.controller;

import com.project.dao.HomestayDAO;
import com.project.dao.HomestayDAOImpl;
import com.project.model.Homestay;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Controller: Public Home Page Orchestration
 * Package: com.project.controller
 */
@WebServlet(name = "HomeController", urlPatterns = {"/home", "/index", "/default"})
public class HomeController extends HttpServlet {

    private HomestayDAO homestayDAO;

    @Override
    public void init() throws ServletException {
        this.homestayDAO = new HomestayDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Homestay> featuredList = homestayDAO.getFeaturedHomestays(6);
        request.setAttribute("featuredList", featuredList);
        request.setAttribute("pageTitle", "Trang chủ - Hệ thống Đặt phòng Homestay & Hotel Thông minh");
        request.getRequestDispatcher("/WEB-INF/views/customer/home.jsp").forward(request, response);
    }
}
