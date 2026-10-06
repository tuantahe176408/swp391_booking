package com.project.controller.customer;

import com.project.dao.ContactDAO;
import com.project.dao.ContactDAOImpl;
import com.project.model.ContactMessage;
import com.project.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Controller: Trang Liên hệ & Hỗ trợ
 * GET  /contact — hiển thị form
 * POST /contact — lưu tin nhắn vào DB
 */
@WebServlet(name = "ContactController", urlPatterns = {"/contact"})
public class ContactController extends HttpServlet {

    private final ContactDAO contactDAO = new ContactDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Pre-fill form nếu đã đăng nhập
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (currentUser != null) {
            request.setAttribute("prefillName",  currentUser.getFullName());
            request.setAttribute("prefillEmail", currentUser.getEmail());
            request.setAttribute("prefillPhone", currentUser.getPhoneNumber());
        }
        request.setAttribute("pageTitle", "Liên hệ & Hỗ trợ - Smart Booking Platform");
        request.setAttribute("activeNav", "contact");
        request.getRequestDispatcher("/WEB-INF/views/customer/contact.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String name    = trim(request.getParameter("contactName"));
        String email   = trim(request.getParameter("contactEmail"));
        String phone   = trim(request.getParameter("contactPhone"));
        String subject = trim(request.getParameter("contactSubject"));
        String message = trim(request.getParameter("contactMessage"));

        // Basic validation
        if (name.isEmpty() || email.isEmpty() || subject.isEmpty() || message.isEmpty()) {
            request.setAttribute("errorMsg", "Vui lòng điền đầy đủ các trường bắt buộc.");
            request.setAttribute("pageTitle", "Liên hệ & Hỗ trợ - Smart Booking Platform");
            request.setAttribute("activeNav", "contact");
            request.getRequestDispatcher("/WEB-INF/views/customer/contact.jsp").forward(request, response);
            return;
        }

        // Lưu vào DB
        ContactMessage msg = new ContactMessage();
        msg.setSenderName(name);
        msg.setSenderEmail(email);
        msg.setSenderPhone(phone.isEmpty() ? null : phone);
        msg.setSubject(subject);
        msg.setMessage(message);

        boolean saved = contactDAO.insertMessage(msg);

        if (saved) {
            request.setAttribute("successMsg",
                "Cảm ơn " + name + "! Chúng tôi đã nhận được tin nhắn và sẽ phản hồi qua email "
                + email + " trong vòng 24h.");
        } else {
            request.setAttribute("errorMsg",
                "Có lỗi xảy ra khi gửi tin nhắn. Vui lòng thử lại hoặc liên hệ qua hotline.");
        }

        request.setAttribute("pageTitle", "Liên hệ & Hỗ trợ - Smart Booking Platform");
        request.setAttribute("activeNav", "contact");
        request.getRequestDispatcher("/WEB-INF/views/customer/contact.jsp").forward(request, response);
    }

    private String trim(String s) { return s != null ? s.trim() : ""; }
}
