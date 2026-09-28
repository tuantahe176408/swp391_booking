<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<style>
body { background: #f0f2f5; }
.mock-wrapper {
    min-height: 100vh;
    display: flex; align-items: center; justify-content: center;
    padding: 2rem 1rem;
}
.mock-card {
    background: #fff;
    border-radius: 16px;
    box-shadow: 0 8px 40px rgba(0,0,0,.12);
    width: 100%;
    max-width: 460px;
    overflow: hidden;
}
.mock-header {
    background: linear-gradient(135deg, #003087, #0057a8);
    padding: 1.25rem 1.5rem;
    display: flex; align-items: center; gap: .75rem;
}
.mock-header-logo {
    background: #fff; border-radius: 8px; padding: 4px 10px;
    font-weight: 900; color: #003087; font-size: 1rem; letter-spacing: -.5px;
}
.mock-header-title { color: #fff; font-size: .85rem; opacity: .85; }
.mock-body { padding: 1.75rem; }
.mock-amount-box {
    background: linear-gradient(135deg, #f0f7ff, #e0edff);
    border: 1px solid #bfdbfe;
    border-radius: 12px;
    padding: 1.25rem;
    text-align: center;
    margin-bottom: 1.5rem;
}
.mock-amount-box .label { font-size: .78rem; color: #64748b; margin-bottom: .3rem; }
.mock-amount-box .amount { font-size: 2rem; font-weight: 800; color: #1e3a8a; }
.mock-info-row {
    display: flex; justify-content: space-between;
    font-size: .83rem; padding: .4rem 0;
    border-bottom: 1px solid #f1f5f9;
}
.mock-info-row:last-child { border-bottom: none; }
.mock-info-row .key { color: #64748b; }
.mock-info-row .val { font-weight: 600; color: #1e293b; }
.mock-section-title {
    font-size: .78rem; font-weight: 700; color: #64748b;
    text-transform: uppercase; letter-spacing: .06em;
    margin: 1.25rem 0 .75rem;
}
.bank-btn {
    border: 1.5px solid #e2e8f0; border-radius: 10px;
    background: #fff; padding: .6rem .75rem;
    cursor: pointer; transition: all .15s;
    display: flex; align-items: center; gap: .5rem;
    font-size: .82rem; font-weight: 600; color: #374151;
}
.bank-btn:hover, .bank-btn.active {
    border-color: #3b82f6; background: #eff6ff; color: #1d4ed8;
}
.bank-btn .bank-icon {
    width: 28px; height: 18px; border-radius: 3px;
    display: flex; align-items: center; justify-content: center;
    font-size: .65rem; font-weight: 800; color: #fff; flex-shrink: 0;
}
.btn-pay {
    width: 100%; padding: .85rem;
    background: linear-gradient(135deg, #1d4ed8, #2563eb);
    color: #fff; border: none; border-radius: 10px;
    font-size: 1rem; font-weight: 700; cursor: pointer;
    transition: all .2s ease; margin-top: 1.25rem;
}
.btn-pay:hover { box-shadow: 0 6px 20px rgba(37,99,235,.4); transform: translateY(-1px); }
.btn-cancel {
    width: 100%; padding: .6rem;
    background: none; color: #94a3b8; border: none;
    font-size: .82rem; cursor: pointer; margin-top: .5rem;
    transition: color .15s;
}
.btn-cancel:hover { color: #ef4444; }
.mock-footer {
    background: #f8fafc; padding: .75rem 1.5rem;
    display: flex; align-items: center; justify-content: space-between;
    border-top: 1px solid #e2e8f0;
}
.mock-footer .secure { font-size: .72rem; color: #94a3b8; display: flex; align-items: center; gap: .3rem; }
.demo-badge {
    background: #fef3c7; color: #d97706; border: 1px solid #fcd34d;
    border-radius: 6px; padding: 2px 8px; font-size: .7rem; font-weight: 700;
}
</style>

<div class="mock-wrapper">
    <div class="mock-card">
        <!-- Header -->
        <div class="mock-header">
            <div class="mock-header-logo">VNPay</div>
            <div>
                <div style="color:#fff;font-weight:600;font-size:.9rem;">Cổng Thanh toán VNPay</div>
                <div class="mock-header-title">Smart Booking Platform · Môi trường Demo</div>
            </div>
            <span class="demo-badge ms-auto">DEMO</span>
        </div>

        <!-- Body -->
        <div class="mock-body">
            <!-- Amount -->
            <div class="mock-amount-box">
                <div class="label">Tổng thanh toán</div>
                <div class="amount">
                    <fmt:formatNumber value="${booking.finalTotal}" type="number" groupingUsed="true"/>₫
                </div>
            </div>

            <!-- Order info -->
            <div class="mock-info-row"><span class="key">Mã đơn hàng</span><span class="val font-monospace">${booking.bookingCode}</span></div>
            <div class="mock-info-row"><span class="key">Nội dung</span><span class="val">Đặt phòng ${booking.homestayName}</span></div>
            <div class="mock-info-row"><span class="key">Ngày tạo</span><span class="val" id="txnDate"></span></div>
            <div class="mock-info-row"><span class="key">Hết hạn sau</span><span class="val" id="countdown" style="color:#ef4444;"></span></div>

            <!-- Bank selection -->
            <div class="mock-section-title">Chọn ngân hàng / phương thức</div>
            <div class="d-flex flex-wrap gap-2">
                <button class="bank-btn active" onclick="selectBank(this)">
                    <div class="bank-icon" style="background:#003087;">VCB</div> Vietcombank
                </button>
                <button class="bank-btn" onclick="selectBank(this)">
                    <div class="bank-icon" style="background:#c0392b;">TCB</div> Techcombank
                </button>
                <button class="bank-btn" onclick="selectBank(this)">
                    <div class="bank-icon" style="background:#e67e22;">MB</div> MB Bank
                </button>
                <button class="bank-btn" onclick="selectBank(this)">
                    <div class="bank-icon" style="background:#27ae60;">VPB</div> VPBank
                </button>
                <button class="bank-btn" onclick="selectBank(this)">
                    <div class="bank-icon" style="background:#8e44ad;">ACB</div> ACB
                </button>
                <button class="bank-btn" onclick="selectBank(this)">
                    <div class="bank-icon" style="background:#16a085;">QR</div> QR Code
                </button>
            </div>

            <div style="font-size:.75rem;color:#94a3b8;margin-top:.75rem;text-align:center;">
                <i class="fa-solid fa-circle-info me-1"></i>
                Đây là môi trường Demo — chọn kết quả thanh toán bên dưới
            </div>

            <!-- Demo action buttons -->
            <div class="d-flex gap-2 mt-3">
                <form method="get" action="${pageContext.request.contextPath}/payment/return" style="flex:1;">
                    <input type="hidden" name="vnp_ResponseCode"  value="00">
                    <input type="hidden" name="vnp_TxnRef"        value="${booking.bookingCode}">
                    <input type="hidden" name="vnp_TransactionNo" value="<%= String.valueOf(System.currentTimeMillis()).substring(6) %>">
                    <input type="hidden" name="vnp_BankCode"      value="VCB">
                    <input type="hidden" name="vnp_Amount"        value="${booking.finalTotal}00">
                    <input type="hidden" name="vnp_SecureHash"    value="DEMO_BYPASS">
                    <input type="hidden" name="demo"              value="1">
                    <button type="submit" class="btn-pay">
                        <i class="fa-solid fa-lock me-2"></i>Thanh toán thành công
                    </button>
                </form>
            </div>

            <form method="get" action="${pageContext.request.contextPath}/payment/return">
                <input type="hidden" name="vnp_ResponseCode"  value="24">
                <input type="hidden" name="vnp_TxnRef"        value="${booking.bookingCode}">
                <input type="hidden" name="vnp_TransactionNo" value="">
                <input type="hidden" name="vnp_SecureHash"    value="DEMO_BYPASS">
                <input type="hidden" name="demo"              value="1">
                <button type="submit" class="btn-cancel">
                    <i class="fa-solid fa-xmark me-1"></i>Hủy giao dịch (mô phỏng thất bại)
                </button>
            </form>
        </div>

        <!-- Footer -->
        <div class="mock-footer">
            <div class="secure"><i class="fa-solid fa-shield-halved text-success"></i> Bảo mật SSL</div>
            <div style="font-size:.7rem;color:#94a3b8;">© VNPay 2026 · Demo Only</div>
        </div>
    </div>
</div>

<script>
// Countdown 15 minutes
(function() {
    var now = new Date();
    document.getElementById('txnDate').textContent =
        now.toLocaleDateString('vi-VN') + ' ' + now.toLocaleTimeString('vi-VN');
    var end = new Date(now.getTime() + 15 * 60 * 1000);
    function tick() {
        var diff = Math.max(0, Math.floor((end - new Date()) / 1000));
        var m = Math.floor(diff / 60), s = diff % 60;
        document.getElementById('countdown').textContent =
            m + ' phút ' + (s < 10 ? '0' : '') + s + ' giây';
        if (diff > 0) setTimeout(tick, 1000);
        else document.getElementById('countdown').textContent = 'Đã hết hạn';
    }
    tick();
})();

function selectBank(btn) {
    document.querySelectorAll('.bank-btn').forEach(function(b){ b.classList.remove('active'); });
    btn.classList.add('active');
}
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
