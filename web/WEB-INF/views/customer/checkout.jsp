<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<style>
.checkout-card { background:#fff; border-radius:20px; border:1px solid rgba(0,0,0,0.07); padding:2rem; }
.order-summary { background:linear-gradient(135deg,#f8f9ff,#fff); border:1px solid rgba(99,102,241,0.15); border-radius:20px; padding:1.5rem; position:sticky; top:85px; }
.order-row { display:flex; justify-content:space-between; padding:0.5rem 0; border-bottom:1px solid rgba(0,0,0,0.05); font-size:0.9rem; }
.order-row:last-child { border-bottom:none; }
.total-row { font-size:1.1rem; font-weight:800; color:#6366f1; }
.addon-check-item { border:1px solid rgba(0,0,0,0.07); border-radius:12px; padding:0.75rem 1rem; margin-bottom:0.5rem; cursor:pointer; transition:all 0.2s; }
.addon-check-item:hover { border-color:#6366f1; background:rgba(99,102,241,0.03); }
.voucher-input { border-radius:12px 0 0 12px; }
.btn-apply-voucher { border-radius:0 12px 12px 0; }
.step-badge { width:32px; height:32px; border-radius:50%; background:linear-gradient(135deg,#6366f1,#8b5cf6); color:#fff; display:flex; align-items:center; justify-content:center; font-weight:700; font-size:0.9rem; flex-shrink:0; }
</style>

<div class="container py-4">
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
            <li class="breadcrumb-item"><a href="javascript:history.back()">Chi tiết homestay</a></li>
            <li class="breadcrumb-item active">Xác nhận đặt phòng</li>
        </ol>
    </nav>

    <c:if test="${not empty errorMsg}">
        <div class="alert alert-danger rounded-3 mb-4"><i class="fa-solid fa-triangle-exclamation me-2"></i>${errorMsg}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/booking/confirm" method="POST" id="checkoutForm">
        <input type="hidden" name="homestayId" value="${homestay.homestayId}">
        <input type="hidden" name="roomTypeId" value="${selectedRoomType.roomTypeId}">
        <input type="hidden" name="checkin" value="${checkin}">
        <input type="hidden" name="checkout" value="${checkout}">

        <div class="row g-4">
            <!-- LEFT -->
            <div class="col-lg-8">

                <!-- Step 1: Thông tin khách -->
                <div class="checkout-card mb-3">
                    <div class="d-flex align-items-center gap-3 mb-4">
                        <div class="step-badge">1</div>
                        <h5 class="fw-bold mb-0">Thông tin khách lưu trú</h5>
                    </div>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold small">Họ và tên <span class="text-danger">*</span></label>
                            <input type="text" name="guestName" class="form-control rounded-3" value="${currentUser.fullName}" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold small">Email <span class="text-danger">*</span></label>
                            <input type="email" name="guestEmail" class="form-control rounded-3" value="${currentUser.email}" readonly>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold small">Số điện thoại <span class="text-danger">*</span></label>
                            <input type="tel" name="guestPhone" class="form-control rounded-3" value="${currentUser.phoneNumber}" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold small">Ghi chú đặc biệt</label>
                            <input type="text" name="guestNote" class="form-control rounded-3" placeholder="Yêu cầu tầng cao, phòng không hút thuốc...">
                        </div>
                    </div>
                </div>

                <!-- Step 2: Chọn dịch vụ bổ sung -->
                <c:if test="${not empty addons}">
                    <div class="checkout-card mb-3">
                        <div class="d-flex align-items-center gap-3 mb-4">
                            <div class="step-badge">2</div>
                            <h5 class="fw-bold mb-0">Dịch vụ bổ sung (Tùy chọn)</h5>
                        </div>
                        <c:forEach var="a" items="${addons}">
                            <label class="addon-check-item d-flex align-items-center gap-3 w-100">
                                <input type="checkbox" name="addonIds" value="${a.addonId}" class="form-check-input mt-0" onchange="recalcTotal()">
                                <div class="flex-grow-1">
                                    <div class="fw-semibold">${a.name}</div>
                                    <div class="text-muted small">${a.description}</div>
                                </div>
                                <div class="text-primary fw-bold">+<fmt:formatNumber value="${a.price}" type="number"/>₫</div>
                            </label>
                        </c:forEach>
                    </div>
                </c:if>

                <!-- Step 3: Mã giảm giá -->
                <div class="checkout-card mb-3">
                    <div class="d-flex align-items-center gap-3 mb-4">
                        <div class="step-badge">3</div>
                        <h5 class="fw-bold mb-0">Mã giảm giá Voucher</h5>
                    </div>
                    <%-- Hidden field chứa code đã validated để submit form --%>
                    <input type="hidden" name="voucherCode" id="voucherCodeHidden" value="">
                    <div id="voucherInputGroup">
                        <div class="input-group">
                            <input type="text" id="voucherCodeInput"
                                   class="form-control voucher-input text-uppercase"
                                   placeholder="Nhập mã voucher (VD: SALE30BEACH)"
                                   oninput="this.value=this.value.toUpperCase()"
                                   onkeydown="if(event.key==='Enter'){event.preventDefault();applyVoucher();}">
                            <button type="button" id="btnApplyVoucher"
                                    class="btn btn-outline-primary btn-apply-voucher fw-semibold"
                                    onclick="applyVoucher()">
                                <span id="voucherBtnText">Áp dụng</span>
                                <span id="voucherSpinner" class="spinner-border spinner-border-sm ms-1 d-none"></span>
                            </button>
                        </div>
                        <div id="voucherMsg" class="mt-2 small"></div>
                    </div>
                    <%-- Applied voucher tag (ẩn lúc đầu) --%>
                    <div id="voucherApplied" class="d-none">
                        <div class="d-flex align-items-center justify-content-between p-2 rounded-3"
                             style="background:rgba(34,197,94,.08);border:1px solid rgba(34,197,94,.3);">
                            <div class="d-flex align-items-center gap-2">
                                <i class="fa-solid fa-tag text-success"></i>
                                <span class="fw-semibold text-success font-monospace" id="appliedCode"></span>
                                <span class="text-muted small" id="appliedDesc"></span>
                            </div>
                            <button type="button" class="btn btn-sm text-danger p-0 ms-2"
                                    onclick="removeVoucher()" title="Xóa voucher">
                                <i class="fa-solid fa-xmark"></i>
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Step 4: Phương thức thanh toán -->
                <div class="checkout-card mb-3">
                    <div class="d-flex align-items-center gap-3 mb-4">
                        <div class="step-badge">4</div>
                        <h5 class="fw-bold mb-0">Phương thức thanh toán</h5>
                    </div>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="d-flex align-items-center gap-3 border rounded-3 p-3 cursor-pointer" style="cursor:pointer;">
                                <input type="radio" name="paymentMethod" value="VNPAY" checked>
                                <img src="https://sandbox.vnpayment.vn/apis/assets/images/icon/vnpay-icon.png" height="28" alt="VNPay" onerror="this.style.display='none'">
                                <span class="fw-semibold">VNPay</span>
                            </label>
                        </div>
                        <div class="col-md-6">
                            <label class="d-flex align-items-center gap-3 border rounded-3 p-3" style="cursor:pointer;">
                                <input type="radio" name="paymentMethod" value="MOMO">
                                <i class="fa-solid fa-wallet text-danger fs-4"></i>
                                <span class="fw-semibold">MoMo</span>
                            </label>
                        </div>
                    </div>
                </div>
            </div>

            <!-- RIGHT: Order Summary -->
            <div class="col-lg-4">
                <div class="order-summary">
                    <h5 class="fw-bold mb-3">Tóm tắt đơn đặt</h5>
                    <div class="d-flex gap-3 mb-3 pb-3 border-bottom">
                        <img src="${not empty homestay.primaryImageUrl ? homestay.primaryImageUrl : pageContext.request.contextPath.concat('/assets/images/default-homestay.svg')}"
                             class="rounded-2" width="70" height="56" style="object-fit:cover;" alt=""
                             onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/images/default-homestay.svg';">
                        <div>
                            <div class="fw-bold small">${homestay.name}</div>
                            <div class="text-muted small">${homestay.city}</div>
                            <div class="text-muted small mt-1">${selectedRoomType.name}</div>
                        </div>
                    </div>

                    <div class="order-row">
                        <span class="text-muted">Nhận phòng</span><strong>${checkin}</strong>
                    </div>
                    <div class="order-row">
                        <span class="text-muted">Trả phòng</span><strong>${checkout}</strong>
                    </div>
                    <div class="order-row">
                        <span class="text-muted">Số đêm</span><strong>${totalNights} đêm</strong>
                    </div>
                    <div class="order-row">
                        <span class="text-muted">Giá phòng</span>
                        <strong id="roomTotal"><fmt:formatNumber value="${selectedRoomType.basePrice * totalNights}" type="number"/>₫</strong>
                    </div>
                    <div class="order-row" id="addonRow" style="display:none;">
                        <span class="text-muted">Dịch vụ bổ sung</span><strong id="addonTotal">0₫</strong>
                    </div>
                    <div class="order-row" id="discountRow" style="display:none;">
                        <span class="text-success">Giảm giá Voucher</span><strong class="text-success" id="discountAmt">-0₫</strong>
                    </div>
                    <div class="order-row total-row mt-2 pt-2 border-top">
                        <span>Tổng thanh toán</span>
                        <span id="finalTotal"><fmt:formatNumber value="${selectedRoomType.basePrice * totalNights}" type="number"/>₫</span>
                    </div>

                    <button type="submit" class="btn btn-primary-custom w-100 fw-bold py-2 mt-3">
                        <i class="fa-solid fa-lock me-2"></i>Xác nhận & Thanh toán
                    </button>
                    <p class="text-muted text-center small mt-2">
                        <i class="fa-solid fa-shield-halved text-success me-1"></i>Bảo mật SHA-512 HMAC
                    </p>
                </div>
            </div>
        </div>
    </form>
</div>

<script>
const roomPrice = ${selectedRoomType.basePrice};
const totalNights = ${totalNights};
let addonTotal = 0;
let discount = 0;

function recalcTotal() {
    addonTotal = 0;
    document.querySelectorAll('input[name="addonIds"]:checked').forEach(cb => {
        const priceText = cb.closest('.addon-check-item').querySelector('.text-primary').textContent;
        addonTotal += parseInt(priceText.replace(/\D/g, ''));
    });
    const addonRow = document.getElementById('addonRow');
    if (addonTotal > 0) {
        addonRow.style.display = 'flex';
        document.getElementById('addonTotal').textContent = new Intl.NumberFormat('vi-VN').format(addonTotal) + '₫';
    } else {
        addonRow.style.display = 'none';
    }
    updateFinal();
}

function updateFinal() {
    const subtotal = roomPrice * totalNights + addonTotal;
    const total    = Math.max(0, subtotal - appliedDiscount);
    // Hiện/ẩn discount row
    const discRow  = document.getElementById('discountRow');
    if (appliedDiscount > 0) {
        discRow.style.display = 'flex';
        document.getElementById('discountAmt').textContent = '-' + new Intl.NumberFormat('vi-VN').format(appliedDiscount) + '₫';
    } else {
        discRow.style.display = 'none';
    }
    document.getElementById('finalTotal').textContent = new Intl.NumberFormat('vi-VN').format(total) + '₫';
}

// ---------- Voucher Logic ----------
let appliedDiscount = 0;

function applyVoucher() {
    const code = document.getElementById('voucherCodeInput').value.trim().toUpperCase();
    const msg  = document.getElementById('voucherMsg');
    const btn  = document.getElementById('btnApplyVoucher');
    const spin = document.getElementById('voucherSpinner');

    if (!code) {
        msg.innerHTML = '<span class="text-danger"><i class="fa-solid fa-circle-exclamation me-1"></i>Vui lòng nhập mã voucher.</span>';
        return;
    }

    const orderTotal = roomPrice * totalNights + addonTotal;
    btn.disabled = true;
    spin.classList.remove('d-none');
    msg.innerHTML = '<span class="text-muted">Đang kiểm tra...</span>';

    fetch(contextPath + '/api/voucher/validate?code=' + encodeURIComponent(code)
              + '&orderTotal=' + orderTotal)
        .then(r => r.json())
        .then(data => {
            btn.disabled = false;
            spin.classList.add('d-none');

            if (data.valid) {
                // Lưu discount
                appliedDiscount = parseFloat(data.discountAmount) || 0;
                document.getElementById('voucherCodeHidden').value = code;

                // Hiện tag applied, ẩn input group
                document.getElementById('appliedCode').textContent = data.code;
                document.getElementById('appliedDesc').textContent = data.description || '';
                document.getElementById('voucherApplied').classList.remove('d-none');
                document.getElementById('voucherInputGroup').classList.add('d-none');

                // Update order summary
                updateFinal();
            } else {
                appliedDiscount = 0;
                document.getElementById('voucherCodeHidden').value = '';
                msg.innerHTML = '<span class="text-danger"><i class="fa-solid fa-circle-xmark me-1"></i>'
                    + escapeHtml(data.message) + '</span>';
                updateFinal();
            }
        })
        .catch(() => {
            btn.disabled = false;
            spin.classList.add('d-none');
            msg.innerHTML = '<span class="text-danger"><i class="fa-solid fa-circle-exclamation me-1"></i>Lỗi kết nối. Vui lòng thử lại.</span>';
        });
}

function removeVoucher() {
    appliedDiscount = 0;
    document.getElementById('voucherCodeHidden').value = '';
    document.getElementById('voucherCodeInput').value  = '';
    document.getElementById('voucherMsg').innerHTML    = '';
    document.getElementById('voucherApplied').classList.add('d-none');
    document.getElementById('voucherInputGroup').classList.remove('d-none');
    updateFinal();
}

function escapeHtml(str) {
    const d = document.createElement('div');
    d.textContent = str;
    return d.innerHTML;
}

const contextPath = '${pageContext.request.contextPath}';
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
