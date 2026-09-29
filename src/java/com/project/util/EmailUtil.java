package com.project.util;

import com.project.config.MailConfig;
import com.project.model.Booking;

import javax.net.ssl.SSLSocket;
import javax.net.ssl.SSLSocketFactory;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.Socket;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Utility: Email Notification Service (OTP, Booking confirmation, Forgot Password)
 * Supports real SMTP transmission via Gmail/Custom SMTP and fallback audit logging.
 * Package: com.project.util
 */
public class EmailUtil {

    private static final Logger LOGGER = Logger.getLogger(EmailUtil.class.getName());

    /**
     * Send temporary password email to user with HTML styling
     *
     * @param recipientEmail recipient's email address
     * @param recipientName recipient's full name
     * @param temporaryPassword auto-generated temporary password
     * @return true if dispatched or successfully logged
     */
    public static boolean sendForgotPasswordEmail(String recipientEmail, String recipientName, String temporaryPassword) {
        if (recipientEmail == null || recipientEmail.trim().isEmpty()) {
            return false;
        }

        String displayName = (recipientName != null && !recipientName.trim().isEmpty()) ? recipientName : "Quý khách";
        String subject = "Smart Booking - Cấp lại mật khẩu đăng nhập tạm thời";

        String htmlBody = "<!DOCTYPE html>" +
                "<html><head><meta charset='UTF-8'></head><body style='font-family: Arial, sans-serif; background-color: #f8fafc; padding: 20px; color: #333;'>" +
                "<div style='max-width: 560px; margin: 0 auto; background: #ffffff; border-radius: 12px; padding: 30px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); border: 1px solid #e2e8f0;'>" +
                "<div style='text-align: center; margin-bottom: 25px;'>" +
                "<h2 style='color: #4f46e5; margin: 0; font-size: 24px;'>Smart Booking Platform</h2>" +
                "<p style='color: #64748b; font-size: 14px; margin-top: 5px;'>Hệ thống Đặt phòng Homestay & Khách sạn Thông minh</p>" +
                "</div>" +
                "<hr style='border: none; border-top: 1px solid #e2e8f0; margin: 20px 0;' />" +
                "<p style='font-size: 16px;'>Xin chào <strong>" + escapeHtml(displayName) + "</strong>,</p>" +
                "<p style='font-size: 15px; line-height: 1.6;'>Chúng tôi nhận được yêu cầu cấp lại mật khẩu cho tài khoản của bạn. Dưới đây là mật khẩu tạm thời mới được cấp phát ngẫu nhiên:</p>" +
                "<div style='background-color: #f1f5f9; border-left: 4px solid #4f46e5; padding: 15px 20px; border-radius: 6px; margin: 25px 0; text-align: center;'>" +
                "<span style='font-size: 13px; color: #64748b; text-transform: uppercase; letter-spacing: 1px; display: block; margin-bottom: 6px;'>Mật khẩu tạm thời của bạn:</span>" +
                "<span style='font-size: 26px; font-family: monospace; font-weight: bold; color: #1e293b; letter-spacing: 2px;'>" + escapeHtml(temporaryPassword) + "</span>" +
                "</div>" +
                "<div style='background-color: #fffbeb; border: 1px solid #fef3c7; border-radius: 8px; padding: 12px 16px; margin-bottom: 20px;'>" +
                "<p style='color: #92400e; font-size: 13px; margin: 0;'><strong>Lưu ý quan trọng:</strong> Vì lý do an toàn bảo mật, sau khi đăng nhập thành công bằng mật khẩu tạm này, hệ thống sẽ <strong>bắt buộc bạn đổi sang một mật khẩu mới</strong> trước khi tiếp tục sử dụng dịch vụ.</p>" +
                "</div>" +
                "<p style='font-size: 14px; color: #64748b; margin-top: 20px;'>Nếu bạn không thực hiện yêu cầu này, vui lòng bỏ qua email này hoặc liên hệ ngay với bộ phận hỗ trợ của chúng tôi.</p>" +
                "<hr style='border: none; border-top: 1px solid #e2e8f0; margin: 25px 0;' />" +
                "<p style='font-size: 12px; color: #94a3b8; text-align: center; margin: 0;'>© Smart Booking Platform. Mọi quyền được bảo lưu.</p>" +
                "</div></body></html>";

        LOGGER.info(String.format(
            "[EMAIL DISPATCH] To: %s (%s) | Subject: %s | Temp Password: %s",
            recipientEmail, displayName, subject, temporaryPassword
        ));

        if (MailConfig.isConfigured()) {
            boolean sent = sendSmtpEmail(recipientEmail, subject, htmlBody);
            if (sent) {
                LOGGER.info("Email sent successfully via SMTP to " + recipientEmail);
                return true;
            } else {
                LOGGER.warning("SMTP dispatch failed. Logged fallback temporary password.");
                return false;
            }
        } else {
            LOGGER.warning("[SMTP CHƯA CẤU HÌNH] Vui lòng cập nhật tài khoản và mật khẩu ứng dụng Gmail (16 ký tự) trong file 'mail.properties' để gửi email thực tế.");
            return true;
        }
    }

    /**
     * Send booking cancellation email
     */
    public static void sendCancellationEmail(Booking booking) {
        if (booking == null) return;
        try {
            String recipient = booking.getGuestEmail();
            String bookingCode = booking.getBookingCode();
            String homestayName = booking.getHomestayName() != null ? booking.getHomestayName() : "Homestay";
            String reason = booking.getCancellationReason() != null ? booking.getCancellationReason() : "Khách hàng yêu cầu hủy";

            String subject = "Xác nhận hủy đơn đặt phòng #" + bookingCode;
            String html = "<h3>Xác nhận hủy đơn đặt phòng #" + bookingCode + "</h3>" +
                    "<p>Homestay: <strong>" + escapeHtml(homestayName) + "</strong></p>" +
                    "<p>Lý do hủy: " + escapeHtml(reason) + "</p>";

            LOGGER.info("[EMAIL DISPATCH] To: " + recipient + " | Subject: " + subject);
            if (MailConfig.isConfigured() && recipient != null) {
                sendSmtpEmail(recipient, subject, html);
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to send cancellation email for booking: " + booking.getBookingCode(), e);
        }
    }

    /**
     * Send booking confirmation email
     */
    public static void sendBookingConfirmation(Booking booking) {
        if (booking == null) return;
        try {
            String recipient = booking.getGuestEmail();
            String bookingCode = booking.getBookingCode();
            String homestayName = booking.getHomestayName() != null ? booking.getHomestayName() : "Homestay";

            String subject = "Xác nhận đặt phòng thành công #" + bookingCode;
            String html = "<h3>Đặt phòng thành công #" + bookingCode + "</h3>" +
                    "<p>Homestay: <strong>" + escapeHtml(homestayName) + "</strong></p>" +
                    "<p>Cảm ơn quý khách đã sử dụng dịch vụ của Smart Booking Platform!</p>";

            LOGGER.info("[EMAIL DISPATCH] To: " + recipient + " | Subject: " + subject);
            if (MailConfig.isConfigured() && recipient != null) {
                sendSmtpEmail(recipient, subject, html);
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to send booking confirmation email for booking: " + booking.getBookingCode(), e);
        }
    }

    /**
     * Sends an email via pure Java SE SMTP over TLS / STARTTLS or SSL (no extra jars required).
     */
    public static boolean sendSmtpEmail(String recipientEmail, String subject, String htmlContent) {
        String host = MailConfig.getSmtpHost();
        int port = MailConfig.getSmtpPort();
        String senderEmail = MailConfig.getSenderEmail();
        String senderPassword = MailConfig.getSenderPassword();
        String senderName = MailConfig.getSenderName();

        Socket socket = null;
        BufferedReader reader = null;
        BufferedWriter writer = null;

        try {
            if (port == 465) {
                SSLSocketFactory sslFactory = (SSLSocketFactory) SSLSocketFactory.getDefault();
                socket = sslFactory.createSocket(host, port);
            } else {
                socket = new Socket(host, port);
            }
            socket.setSoTimeout(15000);

            reader = new BufferedReader(new InputStreamReader(socket.getInputStream(), StandardCharsets.UTF_8));
            writer = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream(), StandardCharsets.UTF_8));

            readResponse(reader, "220");

            sendCmd(writer, "EHLO " + host);
            readMultiLineResponse(reader);

            // STARTTLS for port 587
            if (port != 465) {
                sendCmd(writer, "STARTTLS");
                readResponse(reader, "220");

                SSLSocketFactory sslFactory = (SSLSocketFactory) SSLSocketFactory.getDefault();
                SSLSocket sslSocket = (SSLSocket) sslFactory.createSocket(socket, host, port, true);
                sslSocket.setUseClientMode(true);
                sslSocket.startHandshake();

                socket = sslSocket;
                reader = new BufferedReader(new InputStreamReader(socket.getInputStream(), StandardCharsets.UTF_8));
                writer = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream(), StandardCharsets.UTF_8));

                sendCmd(writer, "EHLO " + host);
                readMultiLineResponse(reader);
            }

            // Authenticate with AUTH LOGIN
            sendCmd(writer, "AUTH LOGIN");
            readResponse(reader, "334");

            String encodedUser = Base64.getEncoder().encodeToString(senderEmail.getBytes(StandardCharsets.UTF_8));
            sendCmd(writer, encodedUser);
            readResponse(reader, "334");

            String cleanPassword = senderPassword.replaceAll("\\s+", "");
            String encodedPass = Base64.getEncoder().encodeToString(cleanPassword.getBytes(StandardCharsets.UTF_8));
            sendCmd(writer, encodedPass);
            readResponse(reader, "235");

            // Mail Transaction
            sendCmd(writer, "MAIL FROM:<" + senderEmail + ">");
            readResponse(reader, "250");

            sendCmd(writer, "RCPT TO:<" + recipientEmail + ">");
            readResponse(reader, "250");

            sendCmd(writer, "DATA");
            readResponse(reader, "354");

            String encodedSubject = "=?UTF-8?B?" + Base64.getEncoder().encodeToString(subject.getBytes(StandardCharsets.UTF_8)) + "?=";
            String encodedSenderName = "=?UTF-8?B?" + Base64.getEncoder().encodeToString(senderName.getBytes(StandardCharsets.UTF_8)) + "?=";

            writer.write("From: " + encodedSenderName + " <" + senderEmail + ">\r\n");
            writer.write("To: <" + recipientEmail + ">\r\n");
            writer.write("Subject: " + encodedSubject + "\r\n");
            writer.write("MIME-Version: 1.0\r\n");
            writer.write("Content-Type: text/html; charset=UTF-8\r\n");
            writer.write("Content-Transfer-Encoding: 8bit\r\n");
            writer.write("\r\n");
            writer.write(htmlContent + "\r\n");
            writer.write(".\r\n");
            writer.flush();

            readResponse(reader, "250");

            sendCmd(writer, "QUIT");
            return true;
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error sending email via SMTP to " + recipientEmail + ": " + e.getMessage(), e);
            return false;
        } finally {
            try {
                if (writer != null) writer.close();
                if (reader != null) reader.close();
                if (socket != null) socket.close();
            } catch (Exception ignored) {}
        }
    }

    private static void sendCmd(BufferedWriter writer, String cmd) throws Exception {
        writer.write(cmd + "\r\n");
        writer.flush();
    }

    private static void readResponse(BufferedReader reader, String expectedCode) throws Exception {
        String line = reader.readLine();
        if (line == null || !line.startsWith(expectedCode)) {
            throw new IllegalStateException("Unexpected SMTP response: " + line + " (expected code: " + expectedCode + ")");
        }
    }

    private static void readMultiLineResponse(BufferedReader reader) throws Exception {
        String line;
        while ((line = reader.readLine()) != null) {
            if (line.length() >= 4 && line.charAt(3) == ' ') {
                break;
            }
        }
    }

    private static String escapeHtml(String text) {
        if (text == null) return "";
        return text.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&#39;");
    }
}
