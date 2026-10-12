<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<style>
body { background: #f5f0f8; }
.mock-wrapper {
    min-height: 100vh;
    display: flex; align-items: center; justify-content: center;
    padding: 2rem 1rem;
}
.mock-card {
    background: #fff;
    border-radius: 20px;
    box-shadow: 0 8px 40px rgba(174,32,112,.15);
    width: 100%;
    max-width: 420px;
    overflow: hidden;
}
.mock-header {
    background: linear-gradient(135deg, #ae2070 0%, #d0206d 50%, #a01d6a 100%);
    padding: 1.5rem;
    display: flex; align-items: center; gap: .75rem;
}
.mock-header-logo {
    background: #fff; border-radius: 50%;
    width: 48px; height: 48px;
    display: flex; align-items: center; justify-content: center;
    flex-shrink: 0; overflow: hidden;
}
.mock-header-logo img { width: 36px; height: 36px; object-fit: contain; }
.mock-body { padding: 1.5rem; }
.mock-amount-box {
    background: linear-gradient(135deg, #fdf2f8, #fce7f3);
    border: 1.5px solid #f9a8d4;
    border-radius: 14px;
    padding: 1.25rem;
    text-align: center;
    margin-bottom: 1.25rem;
}
.mock-amount-box .label { font-size:.78rem; color:#9d174d; font-weight:600; margin-bottom:.3rem; text-transform:uppercase; letter-spacing:.04em; }
.mock-amount-box .amount { font-size: 2rem; font-weight: 900; color: #831843; }
.mock-info-row {
    display:flex; justify-content:space-between;
    font-size:.83rem; padding:.45rem 0;
    border-bottom: 1px solid #fdf2f8;
}
.mock-info-row:last-child { border-bottom:none; }
.mock-info-row .key { color:#9d174d; }
.mock-info-row .val { font-weight:600; color:#1e293b; }

/* QR Area */
.qr-area {
    background: #fdf2f8;
    border: 1.5px dashed #f9a8d4;
    border-radius: 14px;
    padding: 1.1rem;
    text-align: center;
    margin: 1.1rem 0;
}
.qr-area canvas { border-radius: 8px; }
.qr-area .qr-hint { font-size:.72rem; color:#9d174d; margin-top:.5rem; font-weight:600; }

/* Buttons */
.btn-pay-momo {
    width:100%; padding:.85rem;
    background: linear-gradient(135deg, #ae2070, #d0206d);
    color:#fff; border:none; border-radius:12px;
    font-size:1rem; font-weight:700; cursor:pointer;
    transition: all .2s ease; margin-top:.75rem;
    display:flex; align-items:center; justify-content:center; gap:.5rem;
}
.btn-pay-momo:hover { box-shadow:0 6px 24px rgba(174,32,112,.4); transform:translateY(-1px); }
.btn-cancel {
    width:100%; padding:.6rem;
    background:none; color:#94a3b8; border:none;
    font-size:.82rem; cursor:pointer; margin-top:.4rem;
    transition:color .15s;
}
.btn-cancel:hover { color:#ae2070; }
.mock-footer {
    background:#fdf2f8; padding:.75rem 1.5rem;
    display:flex; align-items:center; justify-content:space-between;
    border-top: 1px solid #fce7f3;
}
.mock-footer .secure { font-size:.72rem; color:#be185d; display:flex; align-items:center; gap:.3rem; }
.demo-badge {
    background:#fce7f3; color:#be185d; border:1px solid #f9a8d4;
    border-radius:6px; padding:2px 8px; font-size:.7rem; font-weight:700;
}

/* Countdown */
.countdown-wrap { display:flex; justify-content:space-between; font-size:.78rem; margin-bottom:.9rem; }
.countdown-wrap .exp { color:#be185d; font-weight:700; }
</style>

<%-- Load qrcode.js for QR display (local asset + CDN fallback) --%>
<script src="${pageContext.request.contextPath}/assets/js/qrcode.min.js"></script>
<script>
if (typeof QRCode === 'undefined') {
    document.write('<script src="https://cdn.jsdelivr.net/npm/qrcode/build/qrcode.min.js"><\/script>');
}
</script>

<div class="mock-wrapper">
    <div class="mock-card">

        <%-- Header --%>
        <div class="mock-header">
            <div class="mock-header-logo">
                <img src="https://upload.wikimedia.org/wikipedia/vi/f/fe/MoMo_Logo.png"
                     alt="MoMo" onerror="this.onerror=null;this.style.background='#ae2070';this.style.borderRadius='50%';">
            </div>
            <div style="flex:1;">
                <div style="color:#fff;font-weight:700;font-size:.95rem;">Ví MoMo</div>
                <div style="color:rgba(255,255,255,.8);font-size:.78rem;">Smart Booking Platform · Môi trường Demo</div>
            </div>
            <span class="demo-badge">DEMO</span>
        </div>

        <%-- Body --%>
        <div class="mock-body">

            <%-- Amount --%>
            <div class="mock-amount-box">
                <div class="label">Số tiền thanh toán</div>
                <div class="amount">
                    <fmt:formatNumber value="${booking.finalTotal}" type="number" groupingUsed="true"/>₫
                </div>
            </div>

            <%-- Order info --%>
            <div class="mock-info-row"><span class="key">Mã đơn hàng</span><span class="val font-monospace">${booking.bookingCode}</span></div>
            <div class="mock-info-row"><span class="key">Nội dung</span><span class="val">Đặt phòng ${booking.homestayName}</span></div>
            <div class="countdown-wrap">
                <span style="color:#64748b;">Ngày tạo: <span id="txnDate"></span></span>
                <span class="exp">Hết hạn: <span id="countdown"></span></span>
            </div>

            <%-- QR code area --%>
            <div class="qr-area">
                <canvas id="momoQr" style="display:none;"></canvas>
                <img id="momoQrImg" 
                     src="https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=${booking.bookingCode}&color=831843" 
                     alt="QR MoMo" width="150" height="150" 
                     class="rounded-3 shadow-sm border p-1 bg-white"
                     onerror="this.style.display='none';">
                <div class="qr-hint"><i class="fa-solid fa-qrcode me-1"></i>Quét mã QR bằng ứng dụng MoMo</div>
            </div>

            <div style="font-size:.72rem;color:#94a3b8;text-align:center;margin-bottom:.75rem;">
                <i class="fa-solid fa-circle-info me-1"></i>
                Đây là môi trường Demo — nhấn nút bên dưới để mô phỏng kết quả
            </div>

            <%-- Success button --%>
            <form method="get" action="${pageContext.request.contextPath}/payment/momo-return">
                <input type="hidden" name="resultCode"  value="0">
                <input type="hidden" name="orderId"     value="${booking.bookingCode}_<%= System.currentTimeMillis() %>">
                <input type="hidden" name="requestId"   value="demo-<%= System.currentTimeMillis() %>">
                <input type="hidden" name="amount"      value="${booking.finalTotal}">
                <input type="hidden" name="transId"     value="<%= (long)(Math.random()*9000000000L+1000000000L) %>">
                <input type="hidden" name="message"     value="Thanh cong">
                <input type="hidden" name="payType"     value="qr">
                <input type="hidden" name="signature"   value="DEMO_BYPASS">
                <button type="submit" class="btn-pay-momo">
                    <i class="fa-solid fa-check-circle"></i>Thanh toán thành công
                </button>
            </form>

            <%-- Cancel button --%>
            <form method="get" action="${pageContext.request.contextPath}/payment/momo-return">
                <input type="hidden" name="resultCode"  value="1006">
                <input type="hidden" name="orderId"     value="${booking.bookingCode}_<%= System.currentTimeMillis() %>">
                <input type="hidden" name="requestId"   value="demo-<%= System.currentTimeMillis() %>">
                <input type="hidden" name="amount"      value="${booking.finalTotal}">
                <input type="hidden" name="transId"     value="0">
                <input type="hidden" name="message"     value="Khach hang huy giao dich">
                <input type="hidden" name="signature"   value="DEMO_BYPASS">
                <button type="submit" class="btn-cancel">
                    <i class="fa-solid fa-xmark me-1"></i>Hủy giao dịch (mô phỏng thất bại)
                </button>
            </form>

        </div>

        <%-- Footer --%>
        <div class="mock-footer">
            <div class="secure">
                <i class="fa-solid fa-shield-halved"></i>Bảo mật MoMo
            </div>
            <div style="font-size:.7rem;color:#be185d;">© MoMo 2026 · Demo Only</div>
        </div>

    </div>
</div>

<script>
// Generate QR với bookingCode
(function() {
    var code = '${booking.bookingCode}';
    var canvas = document.getElementById('momoQr');
    var img = document.getElementById('momoQrImg');

    function tryRender() {
        if (code && window.QRCode && typeof QRCode.toCanvas === 'function') {
            QRCode.toCanvas(canvas, code,
                { width: 150, margin: 1, color: { dark: '#831843', light: '#fdf2f8' } },
                function(err) {
                    if (!err) {
                        canvas.style.display = 'block';
                        if (img) img.style.display = 'none';
                    } else if (img) {
                        img.style.display = 'block';
                    }
                });
        } else if (img) {
            img.style.display = 'block';
        }
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', tryRender);
    } else {
        tryRender();
    }

    // Date + Countdown 15 phút
    var now = new Date();
    document.getElementById('txnDate').textContent =
        now.toLocaleDateString('vi-VN') + ' ' + now.toLocaleTimeString('vi-VN', {hour:'2-digit',minute:'2-digit'});
    var end = new Date(now.getTime() + 15 * 60 * 1000);
    function tick() {
        var diff = Math.max(0, Math.floor((end - new Date()) / 1000));
        var m = Math.floor(diff / 60), s = diff % 60;
        var el = document.getElementById('countdown');
        if (!el) return;
        el.textContent = m + ':' + (s < 10 ? '0' : '') + s;
        if (diff > 0) setTimeout(tick, 1000);
        else el.textContent = 'Hết hạn';
    }
    tick();
})();
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
