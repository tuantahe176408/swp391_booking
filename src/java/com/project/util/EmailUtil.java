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
            LOGGER.warning("[SMTP CHƯA CẤU HÌNH] Vui lòng cập nhật tài khoản và mật khẩu ứng dụng Gmail (16 ký tự) trong file 'application.properties' để gửi email thực tế.");
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
     * Send booking confirmation email with full booking details and embedded QR code.
     * QR image is fetched from api.qrserver.com and embedded as base64 data URI
     * so it renders correctly in all email clients without external image loading.
     */
    public static void sendBookingConfirmation(Booking booking) {
        if (booking == null) return;

        String recipient = booking.getGuestEmail();
        if (recipient == null || recipient.trim().isEmpty()) {
            LOGGER.warning("sendBookingConfirmation: no email address for booking " + booking.getBookingCode());
            return;
        }

        try {
            String bookingCode  = booking.getBookingCode() != null ? booking.getBookingCode() : "";
            String guestName    = booking.getGuestName()   != null ? booking.getGuestName()   : "Quý khách";
            String homestayName = booking.getHomestayName()!= null ? booking.getHomestayName(): "Homestay";
            String homestayAddr = booking.getHomestayAddress() != null ? booking.getHomestayAddress() : "";
            String roomType     = booking.getRoomTypeName() != null ? booking.getRoomTypeName() : "";
            String checkin      = booking.getCheckinDate()  != null ? booking.getCheckinDate().toString()  : "";
            String checkout     = booking.getCheckoutDate() != null ? booking.getCheckoutDate().toString() : "";
            int    nights       = booking.getTotalNights();
            String total        = booking.getFinalTotal() != null
                                  ? String.format("%,.0f", booking.getFinalTotal().doubleValue())
                                  : "0";

            // ── QR code image URL (Email clients như Gmail/Apple Mail/Outlook chặn data:base64 URI, cần dùng HTTPS URL trực tiếp) ──
            String qrUrl = "https://api.qrserver.com/v1/create-qr-code/?size=160x160&data="
                         + java.net.URLEncoder.encode(bookingCode, "UTF-8")
                         + "&color=1e1b4b&bgcolor=ffffff&margin=1";

            // ── Format dates đẹp hơn (yyyy-MM-dd → dd/MM/yyyy) ───────────────
            String checkinFmt  = formatDate(checkin);
            String checkoutFmt = formatDate(checkout);

            // ── Build HTML email body ────────────────────────────────────────
            String subject = "✅ Đặt phòng thành công #" + bookingCode + " — Smart Booking";

            String qrImgTag = "<img src=\"" + qrUrl + "\" width=\"160\" height=\"160\" alt=\"QR Check-in\" style=\"display:block;border-radius:8px;border:none;outline:none;\">";

            String html =
                "<!DOCTYPE html>" +
                "<html><head><meta charset='UTF-8'><meta name='viewport' content='width=device-width,initial-scale=1'></head>" +
                "<body style='margin:0;padding:0;background:#f1f5f9;font-family:Arial,Helvetica,sans-serif;color:#1e293b;'>" +

                // Wrapper
                "<table width='100%' cellpadding='0' cellspacing='0' style='background:#f1f5f9;padding:32px 0;'><tr><td align='center'>" +
                "<table width='600' cellpadding='0' cellspacing='0' style='background:#ffffff;border-radius:16px;overflow:hidden;box-shadow:0 4px 24px rgba(0,0,0,.08);'>" +

                // Header banner
                "<tr><td style='background:linear-gradient(135deg,#4f46e5 0%,#7c3aed 100%);padding:32px 40px;text-align:center;'>" +
                "<div style='background:rgba(255,255,255,.15);display:inline-block;border-radius:50%;width:56px;height:56px;line-height:56px;font-size:28px;margin-bottom:12px;'>🏠</div>" +
                "<h1 style='margin:0;color:#ffffff;font-size:22px;font-weight:800;letter-spacing:-.3px;'>Đặt phòng thành công!</h1>" +
                "<p style='margin:8px 0 0;color:rgba(255,255,255,.85);font-size:14px;'>Smart Booking Platform</p>" +
                "</td></tr>" +

                // Greeting
                "<tr><td style='padding:32px 40px 0;'>" +
                "<p style='font-size:16px;margin:0 0 6px;'>Xin chào <strong>" + escapeHtml(guestName) + "</strong>,</p>" +
                "<p style='font-size:14px;color:#64748b;margin:0;line-height:1.6;'>" +
                "Đơn đặt phòng của bạn đã được xác nhận và thanh toán thành công. " +
                "Vui lòng xuất trình <strong>mã QR bên dưới</strong> tại quầy lễ tân để check-in nhanh không cần giấy tờ." +
                "</p>" +
                "</td></tr>" +

                // Booking code badge
                "<tr><td style='padding:20px 40px 0;text-align:center;'>" +
                "<div style='display:inline-block;background:#f0fdf4;border:1.5px solid #86efac;border-radius:10px;padding:10px 24px;'>" +
                "<span style='font-size:11px;text-transform:uppercase;letter-spacing:.08em;color:#16a34a;font-weight:700;display:block;margin-bottom:4px;'>Mã đặt phòng</span>" +
                "<span style='font-family:monospace;font-size:22px;font-weight:900;color:#15803d;letter-spacing:2px;'>" + escapeHtml(bookingCode) + "</span>" +
                "</div>" +
                "</td></tr>" +

                // Details table + QR side by side
                "<tr><td style='padding:24px 40px;'>" +
                "<table width='100%' cellpadding='0' cellspacing='0'><tr>" +

                // Left: booking details
                "<td style='vertical-align:top;padding-right:20px;'>" +
                "<table width='100%' cellpadding='0' cellspacing='0' style='background:#f8fafc;border-radius:12px;overflow:hidden;'>" +
                detailRow("🏨", "Homestay",   escapeHtml(homestayName)) +
                (homestayAddr.isEmpty() ? "" : detailRow("📍", "Địa chỉ", escapeHtml(homestayAddr))) +
                (roomType.isEmpty()     ? "" : detailRow("🛏", "Loại phòng", escapeHtml(roomType))) +
                detailRow("📅", "Nhận phòng", "<strong>" + checkinFmt  + "</strong>") +
                detailRow("📅", "Trả phòng",  "<strong>" + checkoutFmt + "</strong>") +
                detailRow("🌙", "Số đêm",     nights + " đêm") +
                detailRowLast("💳", "Tổng thanh toán",
                    "<strong style='color:#4f46e5;font-size:16px;'>" + total + " ₫</strong>") +
                "</table></td>" +

                // Right: QR code
                "<td style='vertical-align:top;width:180px;text-align:center;'>" +
                "<div style='background:#f8fafc;border:1.5px dashed #cbd5e1;border-radius:12px;padding:16px;display:inline-block;'>" +
                qrImgTag +
                "<p style='margin:8px 0 0;font-size:11px;color:#64748b;font-weight:600;text-transform:uppercase;letter-spacing:.05em;'>QR Check-in</p>" +
                "</div>" +
                "</td>" +
                "</tr></table>" +
                "</td></tr>" +

                // Info note
                "<tr><td style='padding:0 40px 24px;'>" +
                "<div style='background:#fffbeb;border:1px solid #fef08a;border-radius:10px;padding:14px 18px;'>" +
                "<p style='margin:0;font-size:13px;color:#854d0e;line-height:1.6;'>" +
                "<strong>📌 Lưu ý:</strong> Bạn có thể xem lại mã QR này bất cứ lúc nào trong mục " +
                "<strong>Lịch sử đặt phòng → Xem Vé &amp; QR</strong> sau khi đăng nhập vào hệ thống." +
                "</p>" +
                "</div>" +
                "</td></tr>" +

                // Divider + footer
                "<tr><td style='padding:0 40px 28px;'>" +
                "<hr style='border:none;border-top:1px solid #e2e8f0;margin:0 0 20px;'/>" +
                "<p style='font-size:12px;color:#94a3b8;text-align:center;margin:0;line-height:1.8;'>" +
                "Nếu bạn cần hỗ trợ, vui lòng liên hệ chúng tôi qua trang <strong>Liên hệ</strong>.<br>" +
                "© Smart Booking Platform — Hệ thống Đặt phòng Homestay &amp; Khách sạn Thông minh" +
                "</p>" +
                "</td></tr>" +

                "</table>" + // inner table
                "</td></tr></table>" + // outer table
                "</body></html>";

            LOGGER.info("[EMAIL BOOKING CONFIRM] To: " + recipient + " | Code: " + bookingCode);

            if (MailConfig.isConfigured()) {
                boolean sent = sendSmtpEmail(recipient, subject, html);
                if (sent) {
                    LOGGER.info("Booking confirmation email sent to " + recipient);
                } else {
                    LOGGER.warning("Failed to send booking confirmation to " + recipient);
                }
            } else {
                LOGGER.warning("[SMTP CHƯA CẤU HÌNH] Booking confirmation logged for " + recipient + " | Code: " + bookingCode);
            }

        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to send booking confirmation for booking: " + booking.getBookingCode(), e);
        }
    }

    /** Fetch QR PNG from api.qrserver.com and return Base64-encoded string, or null on failure. */
    private static String fetchQrBase64(String data, int size) {
        try {
            String urlStr = "https://api.qrserver.com/v1/create-qr-code/?size=" + size + "x" + size
                          + "&data=" + java.net.URLEncoder.encode(data, "UTF-8")
                          + "&color=1e1b4b&bgcolor=ffffff&margin=1";
            java.net.URL url = new java.net.URL(urlStr);
            java.net.HttpURLConnection conn = (java.net.HttpURLConnection) url.openConnection();
            conn.setConnectTimeout(5000);
            conn.setReadTimeout(5000);
            conn.setRequestMethod("GET");
            if (conn.getResponseCode() == 200) {
                byte[] bytes = conn.getInputStream().readAllBytes();
                return Base64.getEncoder().encodeToString(bytes);
            }
        } catch (Exception e) {
            LOGGER.warning("Could not fetch QR image for " + data + ": " + e.getMessage());
        }
        return null;
    }

    /** Format yyyy-MM-dd → dd/MM/yyyy, returns original string on parse failure. */
    private static String formatDate(String iso) {
        if (iso == null || iso.length() < 10) return iso != null ? iso : "";
        try {
            String[] p = iso.substring(0, 10).split("-");
            return p[2] + "/" + p[1] + "/" + p[0];
        } catch (Exception e) { return iso; }
    }

    /** HTML table row for booking details (not last). */
    private static String detailRow(String icon, String label, String value) {
        return "<tr><td style='padding:9px 14px;border-bottom:1px solid #e2e8f0;font-size:13px;color:#64748b;white-space:nowrap;width:130px;'>"
             + icon + " " + label + "</td>"
             + "<td style='padding:9px 14px;border-bottom:1px solid #e2e8f0;font-size:13px;color:#1e293b;'>" + value + "</td></tr>";
    }

    /** HTML table row for booking details (last row, no bottom border). */
    private static String detailRowLast(String icon, String label, String value) {
        return "<tr><td style='padding:9px 14px;font-size:13px;color:#64748b;white-space:nowrap;width:130px;'>"
             + icon + " " + label + "</td>"
             + "<td style='padding:9px 14px;font-size:13px;color:#1e293b;'>" + value + "</td></tr>";
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

    /**
     * Gửi email OTP kích hoạt tài khoản được tạo bởi Admin.
     */
    public static boolean sendActivationOtpEmail(String recipientEmail, String recipientName, String otpCode) {
        if (recipientEmail == null || recipientEmail.trim().isEmpty()) return false;
        String displayName = (recipientName != null && !recipientName.trim().isEmpty()) ? recipientName : "Quý khách";
        String subject = "Smart Booking - Mã xác thực kích hoạt tài khoản";
        String htmlBody =
            "<!DOCTYPE html><html><head><meta charset='UTF-8'></head>" +
            "<body style='font-family:Arial,sans-serif;background:#f8fafc;padding:20px;color:#333;'>" +
            "<div style='max-width:520px;margin:0 auto;background:#fff;border-radius:12px;padding:30px;" +
            "box-shadow:0 4px 15px rgba(0,0,0,.05);border:1px solid #e2e8f0;'>" +
            "<h2 style='color:#4f46e5;margin:0 0 4px;'>Smart Booking Platform</h2>" +
            "<p style='color:#64748b;font-size:13px;margin:0 0 20px;'>Hệ thống Đặt phòng Homestay &amp; Khách sạn</p>" +
            "<hr style='border:none;border-top:1px solid #e2e8f0;margin:0 0 20px;'/>" +
            "<p>Xin chào <strong>" + escapeHtml(displayName) + "</strong>,</p>" +
            "<p style='line-height:1.6;'>Tài khoản của bạn đã được tạo trên <strong>Smart Booking Platform</strong>." +
            " Vui lòng nhập mã OTP dưới đây để xác thực và kích hoạt tài khoản:</p>" +
            "<div style='background:#f1f5f9;border-left:4px solid #4f46e5;padding:18px;border-radius:6px;" +
            "margin:20px 0;text-align:center;'>" +
            "<span style='font-size:12px;color:#64748b;text-transform:uppercase;letter-spacing:1px;" +
            "display:block;margin-bottom:8px;'>Mã xác thực (OTP)</span>" +
            "<span style='font-size:36px;font-family:monospace;font-weight:900;color:#4f46e5;" +
            "letter-spacing:8px;'>" + escapeHtml(otpCode) + "</span>" +
            "<p style='font-size:12px;color:#94a3b8;margin:8px 0 0;'>Mã có hiệu lực trong <strong>10 phút</strong></p>" +
            "</div>" +
            "<div style='background:#fffbeb;border:1px solid #fef3c7;border-radius:8px;padding:12px 16px;margin-bottom:20px;'>" +
            "<p style='color:#92400e;font-size:13px;margin:0;'><strong>Lưu ý:</strong> Sau khi xác thực, " +
            "bạn sẽ được yêu cầu đặt mật khẩu mới cho tài khoản.</p>" +
            "</div>" +
            "<p style='font-size:13px;color:#64748b;'>Nếu bạn không yêu cầu điều này, vui lòng bỏ qua email này.</p>" +
            "<hr style='border:none;border-top:1px solid #e2e8f0;margin:20px 0 0;'/>" +
            "<p style='font-size:11px;color:#94a3b8;text-align:center;margin:10px 0 0;'>" +
            "© Smart Booking Platform. Mọi quyền được bảo lưu.</p>" +
            "</div></body></html>";

        LOGGER.info(String.format("[EMAIL OTP] To: %s | OTP: %s", recipientEmail, otpCode));

        if (MailConfig.isConfigured()) {
            boolean sent = sendSmtpEmail(recipientEmail, subject, htmlBody);
            if (sent) LOGGER.info("Activation OTP email sent to " + recipientEmail);
            return sent;
        }
        LOGGER.warning("[SMTP CHƯA CẤU HÌNH] OTP=" + otpCode + " cho " + recipientEmail);
        return true;
    }
}
