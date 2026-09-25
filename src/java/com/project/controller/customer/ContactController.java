package com.project.controller.customer;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Controller: Trang Liên hệ & Hỗ trợ
 * URL: /contact
 * Package: com.project.controller.customer
 */
@WebServlet(name = "ContactController", urlPatterns = {"/contact"})
public class ContactController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("pageTitle", "Liên hệ & Hỗ trợ - Smart Booking Platform");
        request.setAttribute("activeNav", "contact");
        request.getRequestDispatcher("/WEB-INF/views/customer/contact.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Xử lý gửi form liên hệ (có thể mở rộng để gửi email qua EmailUtil)
        String name = request.getParameter("contactName");
        String email = request.getParameter("contactEmail");
        String subject = request.getParameter("contactSubject");
        String message = request.getParameter("contactMessage");

        // TODO: Gọi EmailUtil.sendContactEmail(name, email, subject, message) nếu cần
        request.setAttribute("successMsg", "Cảm ơn " + name + "! Chúng tôi đã nhận được tin nhắn và sẽ phản hồi qua email " + email + " trong vòng 24h.");
        request.setAttribute("pageTitle", "Liên hệ & Hỗ trợ - Smart Booking Platform");
        request.setAttribute("activeNav", "contact");
        request.getRequestDispatcher("/WEB-INF/views/customer/contact.jsp").forward(request, response);
    }
}
