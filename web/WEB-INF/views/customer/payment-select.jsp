<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<jsp:include page="/WEB-INF/views/common/navbar.jsp"/>

<style>
.pay-method-card {
    border: 2px solid #e2e8f0;
    border-radius: 16px;
    padding: 1.5rem;
    cursor: pointer;
    transition: all .2s ease;
    background: #fff;
    display: flex;
    align-items: center;
    gap: 1rem;
    position: relative;
}
.pay-method-card:hover { border-color: #6366f1; box-shadow: 0 4px 20px rgba(99,102,241,.12); }
.pay-method-card.selected { border-color: #6366f1; background: #f5f3ff; box-shadow: 0 4px 20px rgba(99,102,241,.15); }
.pay-method-card .check-dot {
    position: absolute; top: .85rem; right: .85rem;
    width: 20px; height: 20px; border-radius: 50%;
    border: 2px solid #e2e8f0;
    display: flex; align-items: center; justify-content: center;
    transition: all .2s ease;
}
.pay-method-card.selected .check-dot {
    background: #6366f1; border-color: #6366f1; color: #fff; font-size: .65rem;
}
.method-logo {
    width: 56px; height: 36px; object-fit: contain; border-radius: 6px;
    flex-shrink: 0;
}
.booking-summary-card {
    background: linear-gradient(135deg, #1e1b4b 0%, #312e81 100%);
    border-radius: 16px; color: #fff; padding: 1.5rem;
}
</style>

<div class="container py-5" style="max-width:980px;">
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb" style="font-size:.85rem;">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/search">Tìm phòng</a></li>
            <li class="breadcrumb-item active">Thanh toán</li>
        </ol>
    </nav>

    <div class="row g-4">
        <!-- Left: payment method selection -->
        <div class="col-lg-7">
            <div class="card border-0 shadow-sm rounded-4 p-4">
                <h5 class="fw-bold mb-1">
                    <i class="fa-solid fa-credit-card text-primary me-2"></i>Chọn phương thức thanh toán
                </h5>
                <p class="text-muted mb-4" style="font-size:.88rem;">Chọn cổng thanh toán phù hợp với bạn</p>

                <div class="d-flex flex-column gap-3 mb-4" id="methodList">

                    <!-- VNPay -->
                    <div class="pay-method-card selected" data-method="VNPAY" onclick="selectMethod('VNPAY', this)">
                        <img src="https://cdn.haitrieu.com/wp-content/uploads/2022/10/Logo-VNPAY-QR-1.png"
                             alt="VNPay" class="method-logo"
                             onerror="this.onerror=null;this.style.display='none'">
                        <div>
                            <div class="fw-semibold">VNPay</div>
                            <div class="text-muted" style="font-size:.8rem;">Thanh toán qua ATM nội địa, thẻ quốc tế Visa/Mastercard, QR Code</div>
                        </div>
                        <div class="check-dot"><i class="fa-solid fa-check"></i></div>
                    </div>

                    <!-- MoMo -->
                    <div class="pay-method-card" data-method="MOMO" onclick="selectMethod('MOMO', this)">
                        <img src="https://upload.wikimedia.org/wikipedia/vi/f/fe/MoMo_Logo.png"
                             alt="MoMo" class="method-logo"
                             onerror="this.onerror=null;this.style.display='none'">
                        <div>
                            <div class="fw-semibold">MoMo</div>
                            <div class="text-muted" style="font-size:.8rem;">Thanh toán qua ví điện tử MoMo, quét QR nhanh chóng</div>
                        </div>
                        <div class="check-dot"><i class="fa-solid fa-check"></i></div>
                    </div>

                </div>

                <!-- Security notice -->
                <div class="alert alert-info d-flex align-items-center gap-2 rounded-3 mb-4" style="font-size:.82rem;">
                    <i class="fa-solid fa-shield-halved flex-shrink-0 text-info"></i>
                    <span>Giao dịch được bảo mật bằng <strong>SHA-512 HMAC</strong>. Thông tin thanh toán không được lưu trên máy chủ của chúng tôi.</span>
                </div>

                <!-- Submit form -->
                <form method="get" action="${pageContext.request.contextPath}/payment/create" id="paymentForm">
                    <input type="hidden" name="bookingId" value="${booking.bookingId}">
                    <input type="hidden" name="confirm"   value="1">
                    <input type="hidden" name="method"    id="selectedMethod" value="VNPAY">
                    <button type="submit" class="btn btn-primary-custom w-100 py-3 fw-semibold fs-6">
                        <i class="fa-solid fa-lock me-2"></i>
                        Tiếp tục thanh toán
                        <span id="methodLabel"> qua VNPay</span>
                    </button>
                </form>

                <div class="text-center mt-3">
                    <a href="${pageContext.request.contextPath}/customer/bookings"
                       class="text-muted" style="font-size:.82rem;">
                        <i class="fa-solid fa-arrow-left me-1"></i>Hủy và quay lại đơn đặt phòng
                    </a>
                </div>
            </div>
        </div>

        <!-- Right: booking summary -->
        <div class="col-lg-5">
            <div class="booking-summary-card mb-3">
                <div class="d-flex align-items-center gap-3 mb-3">
                    <div style="width:48px;height:48px;border-radius:12px;background:rgba(255,255,255,.15);display:flex;align-items:center;justify-content:center;font-size:1.3rem;">
                        <i class="fa-solid fa-hotel"></i>
                    </div>
                    <div>
                        <div class="fw-bold" style="font-size:.95rem;">${booking.homestayName}</div>
                        <div style="font-size:.78rem;opacity:.7;">${booking.homestayCity}</div>
                    </div>
                </div>
                <hr style="border-color:rgba(255,255,255,.2);">
                <div style="font-size:.83rem;opacity:.85;">
                    <div class="d-flex justify-content-between mb-2">
                        <span>Mã đặt phòng</span>
                        <span class="fw-semibold font-monospace">${booking.bookingCode}</span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span>Hạng phòng</span>
                        <span class="fw-semibold">${booking.roomTypeName}</span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span>Nhận phòng</span>
                        <span class="fw-semibold">${booking.checkinDate}</span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span>Trả phòng</span>
                        <span class="fw-semibold">${booking.checkoutDate}</span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span>Số đêm</span>
                        <span class="fw-semibold">${booking.totalNights} đêm</span>
                    </div>
                    <c:if test="${booking.discountAmount > 0}">
                        <div class="d-flex justify-content-between mb-2">
                            <span>Giảm giá voucher</span>
                            <span class="fw-semibold text-warning">
                                -<fmt:formatNumber value="${booking.discountAmount}" type="number" groupingUsed="true"/>₫
                            </span>
                        </div>
                    </c:if>
                </div>
                <hr style="border-color:rgba(255,255,255,.2);">
                <div class="d-flex justify-content-between align-items-center">
                    <span class="fw-semibold" style="font-size:.9rem;">Tổng thanh toán</span>
                    <span class="fw-bold" style="font-size:1.3rem;">
                        <fmt:formatNumber value="${booking.finalTotal}" type="number" groupingUsed="true"/>₫
                    </span>
                </div>
            </div>

            <!-- Trust badges -->
            <div class="card border-0 shadow-sm rounded-4 p-3">
                <div class="d-flex flex-column gap-2" style="font-size:.8rem;">
                    <div class="d-flex align-items-center gap-2 text-muted">
                        <i class="fa-solid fa-shield-halved text-success"></i>
                        Bảo mật SSL 256-bit
                    </div>
                    <div class="d-flex align-items-center gap-2 text-muted">
                        <i class="fa-solid fa-clock-rotate-left text-primary"></i>
                        Phòng được giữ trong 15 phút
                    </div>
                    <div class="d-flex align-items-center gap-2 text-muted">
                        <i class="fa-solid fa-headset text-warning"></i>
                        Hỗ trợ 24/7 nếu có vấn đề
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

<script>
function selectMethod(method, card) {
    // deselect all
    document.querySelectorAll('.pay-method-card').forEach(function(c) {
        c.classList.remove('selected');
    });
    card.classList.add('selected');
    document.getElementById('selectedMethod').value = method;

    var labels = { 'VNPAY': ' qua VNPay', 'MOMO': ' qua MoMo' };
    document.getElementById('methodLabel').textContent = labels[method] || '';
}
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
