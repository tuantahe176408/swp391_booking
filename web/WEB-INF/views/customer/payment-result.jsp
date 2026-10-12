<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<%-- QR code library (local asset with CDN fallback) --%>
<script src="${pageContext.request.contextPath}/assets/js/qrcode.min.js"></script>
<script>
if (typeof QRCode === 'undefined') {
    document.write('<script src="https://cdn.jsdelivr.net/npm/qrcode/build/qrcode.min.js"><\/script>');
}
</script>

<style>
.result-hero { padding:80px 0; text-align:center; }
.result-icon { width:100px; height:100px; border-radius:50%; display:flex; align-items:center; justify-content:center; font-size:2.8rem; margin:0 auto 1.5rem; }
.result-icon.success { background:linear-gradient(135deg,#d1fae5,#a7f3d0); color:#059669; }
.result-icon.failed { background:linear-gradient(135deg,#fee2e2,#fecaca); color:#dc2626; }
.info-table td { padding:0.6rem 0; border-bottom:1px solid rgba(0,0,0,0.05); }
.info-table td:first-child { color:#6b7280; width:45%; }
.info-table td:last-child { font-weight:600; }

/* QR section */
.qr-wrapper {
    display:flex; flex-direction:column; align-items:center; gap:.75rem;
    background:#f8fafc; border:1.5px dashed #cbd5e1; border-radius:16px;
    padding:1.25rem 1.5rem; margin-top:1.25rem;
}
.qr-wrapper canvas, .qr-wrapper img { border-radius:8px; }
.qr-label {
    font-size:.72rem; font-weight:700; text-transform:uppercase;
    letter-spacing:.06em; color:#64748b;
}
.qr-code-text {
    font-family:monospace; font-size:.82rem; color:#4f46e5;
    background:#eef2ff; padding:3px 10px; border-radius:6px;
}
</style>

<div class="result-hero">
    <div class="container">
        <c:choose>
            <c:when test="${paymentSuccess}">
                <div class="result-icon success"><i class="fa-solid fa-circle-check"></i></div>
                <h1 class="fw-bold fs-2 text-success mb-2">Thanh toán thành công!</h1>
                <p class="text-muted mb-4">Đơn đặt phòng của bạn đã được xác nhận. Kiểm tra email để nhận vé điện tử.</p>

                <c:if test="${not empty booking}">
                    <div class="card border-0 shadow-sm rounded-4 p-4 mx-auto" style="max-width:520px;">
                        <h6 class="fw-bold text-center mb-3">
                            <i class="fa-solid fa-receipt text-primary me-2"></i>Chi tiết giao dịch
                        </h6>
                        <table class="info-table w-100">
                            <tr><td>Mã đặt phòng</td><td class="font-monospace text-primary">${booking.bookingCode}</td></tr>
                            <tr><td>Homestay</td><td>${booking.homestayName}</td></tr>
                            <tr><td>Hạng phòng</td><td>${booking.roomTypeName}</td></tr>
                            <tr><td>Nhận phòng</td><td>${booking.checkinDate}</td></tr>
                            <tr><td>Trả phòng</td><td>${booking.checkoutDate}</td></tr>
                            <tr><td>Tổng thanh toán</td>
                                <td class="text-success">
                                    <fmt:formatNumber value="${booking.finalTotal}" type="number"/>₫
                                </td>
                            </tr>
                            <c:if test="${not empty vnpBankCode}">
                                <tr><td>Ngân hàng</td><td>${vnpBankCode}</td></tr>
                            </c:if>
                            <c:if test="${not empty vnpTransactionNo}">
                                <tr><td>Mã GD VNPay</td><td class="font-monospace">${vnpTransactionNo}</td></tr>
                            </c:if>
                        </table>

                        <%-- QR Code section --%>
                        <div class="qr-wrapper">
                            <div class="qr-label">
                                <i class="fa-solid fa-qrcode me-1"></i>Mã QR check-in — xuất trình cho lễ tân
                            </div>
                            <div class="d-flex justify-content-center align-items-center" style="min-height: 180px;">
                                <canvas id="bookingQrCanvas" style="display:none;"></canvas>
                                <img id="bookingQrImg" 
                                     src="https://api.qrserver.com/v1/create-qr-code/?size=180x180&data=${booking.bookingCode}" 
                                     alt="QR Check-in" 
                                     width="180" height="180" 
                                     class="rounded-3 shadow-sm border p-1 bg-white"
                                     onerror="this.style.display='none';">
                            </div>
                            <div class="qr-code-text">${booking.bookingCode}</div>
                            <small class="text-muted" style="font-size:.72rem;">
                                Lễ tân sẽ quét mã này để xác nhận check-in nhanh
                            </small>
                        </div>
                    </div>

                    <script>
                    (function() {
                        var code = '${booking.bookingCode}';
                        if (!code) return;
                        var canvas = document.getElementById('bookingQrCanvas');
                        var img = document.getElementById('bookingQrImg');
                        
                        function tryRender() {
                            if (window.QRCode && typeof QRCode.toCanvas === 'function') {
                                QRCode.toCanvas(
                                    canvas,
                                    code,
                                    { width: 180, margin: 2, color: { dark: '#1e1b4b', light: '#ffffff' } },
                                    function(err) {
                                        if (!err) {
                                            canvas.style.display = 'block';
                                            if (img) img.style.display = 'none';
                                        } else {
                                            console.warn('QR canvas error, using img fallback:', err);
                                            if (img) img.style.display = 'block';
                                        }
                                    }
                                );
                            } else {
                                // Fallback image remains visible
                                if (img) img.style.display = 'block';
                            }
                        }

                        if (document.readyState === 'loading') {
                            document.addEventListener('DOMContentLoaded', tryRender);
                        } else {
                            tryRender();
                        }
                    })();
                    </script>
                </c:if>

                <div class="d-flex justify-content-center gap-3 mt-4 flex-wrap">
                    <a href="${pageContext.request.contextPath}/customer/bookings" class="btn btn-primary-custom px-4">
                        <i class="fa-solid fa-list me-2"></i>Xem đơn đặt phòng
                    </a>
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary px-4">
                        <i class="fa-solid fa-house me-2"></i>Về trang chủ
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="result-icon failed"><i class="fa-solid fa-circle-xmark"></i></div>
                <h1 class="fw-bold fs-2 text-danger mb-2">Thanh toán thất bại</h1>
                <p class="text-muted mb-2">
                    <c:choose>
                        <c:when test="${vnpResponseCode == '24'}">Giao dịch bị hủy bởi người dùng.</c:when>
                        <c:when test="${vnpResponseCode == '11'}">Đã hết thời gian chờ thanh toán.</c:when>
                        <c:when test="${vnpResponseCode == '09'}">Thẻ/Tài khoản bị khóa.</c:when>
                        <c:otherwise>Có lỗi xảy ra trong quá trình thanh toán (Mã lỗi: ${vnpResponseCode}).</c:otherwise>
                    </c:choose>
                </p>
                <p class="text-muted mb-4">Đơn đặt phòng vẫn đang chờ thanh toán. Bạn có thể thử lại.</p>
                <div class="d-flex justify-content-center gap-3 flex-wrap">
                    <a href="javascript:history.back()" class="btn btn-primary-custom px-4">
                        <i class="fa-solid fa-rotate-right me-2"></i>Thử lại thanh toán
                    </a>
                    <a href="${pageContext.request.contextPath}/customer/bookings" class="btn btn-outline-secondary px-4">
                        <i class="fa-solid fa-list me-2"></i>Xem đơn đặt phòng
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
