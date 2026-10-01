<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle"      value="Đặt phòng Khách vãng lai"      scope="request"/>
<c:set var="pageBreadcrumb" value="Đón tiếp &amp; Quản lý Phòng"  scope="request"/>
<jsp:include page="../common/header.jsp"/>

<style>
/* ── Walk-in page styles ───────────────────────────── */
.wk-page-header {
    display: flex; align-items: center; justify-content: space-between;
    flex-wrap: wrap; gap: 12px;
    margin-bottom: 1.5rem;
    padding-bottom: 1rem;
    border-bottom: 1px solid #f0f3f7;
}
.wk-title    { font-size: 1.1rem; font-weight: 800; color: #1e293b; margin: 0; }
.wk-subtitle { font-size: 0.8rem; color: #94a3b8; margin: 2px 0 0; }
.wk-property-tag {
    display: inline-flex; align-items: center; gap: 6px;
    padding: 5px 14px; background: #f8fafc;
    border: 1px solid #e2e8f0; border-radius: 8px;
    font-size: 0.78rem; font-weight: 600; color: #475569;
}

/* ── Section heading ───────────────────────────────── */
.wk-section-label {
    font-size: 0.72rem; font-weight: 700; letter-spacing: 0.6px;
    color: #94a3b8; text-transform: uppercase; margin-bottom: 10px;
    display: flex; align-items: center; gap: 6px;
}
.wk-section-label::after {
    content: ''; flex: 1; height: 1px; background: #f1f5f9;
}

/* ── Room selection cards ──────────────────────────── */
.room-opt-label {
    cursor: pointer; display: block;
    border: 1.5px solid #e8ecf2;
    border-radius: 12px; padding: 11px 14px;
    background: #ffffff;
    transition: all 0.15s ease;
    user-select: none;
}
.room-opt-label:hover { border-color: #bddece; background: #f9fdfb; }
.room-opt-radio { display: none; }
.room-opt-radio:checked + .room-opt-label {
    border-color: #7ab896;
    background: #f2f8f4;
    box-shadow: 0 0 0 3px rgba(122,184,150,0.15);
}
.room-opt-num   { font-size: 1.1rem; font-weight: 800; color: #1e293b; line-height: 1; }
.room-opt-type  { font-size: 0.72rem; color: #94a3b8; font-weight: 500; margin-top: 1px; }
.room-opt-price { font-size: 0.76rem; font-weight: 700; color: #3d7a56; margin-top: 4px; }

/* ── Booking summary card ──────────────────────────── */
.wk-summary {
    background: #f8fafc; border: 1px solid #edf0f5;
    border-radius: 14px; padding: 20px;
    position: sticky; top: 1.5rem;
}
.wk-sum-title { font-size: 0.8rem; font-weight: 700; color: #334155; margin-bottom: 14px; }
.wk-sum-row {
    display: flex; justify-content: space-between;
    font-size: 0.8rem; color: #64748b;
    padding: 5px 0; border-bottom: 1px solid #f1f5f9;
}
.wk-sum-row:last-of-type { border-bottom: none; }
.wk-sum-row strong { color: #1e293b; }
.wk-sum-total {
    display: flex; justify-content: space-between; align-items: center;
    margin-top: 12px; padding-top: 12px;
    border-top: 1.5px solid #e2e8f0;
    font-size: 0.9rem; font-weight: 700; color: #1e293b;
}
.wk-sum-total .total-amount {
    font-size: 1.1rem; font-weight: 800; color: #3d7a56;
}
.wk-empty-state {
    text-align: center; color: #94a3b8;
    padding: 1.5rem 0; font-size: 0.82rem;
}

/* ── Submit button ─────────────────────────────────── */
.btn-walkin-submit {
    background: #3d7a56; color: #ffffff;
    border: none; border-radius: 10px;
    padding: 12px 28px; font-size: 0.9rem; font-weight: 700;
    cursor: pointer; transition: background 0.15s ease;
    display: flex; align-items: center; gap: 8px;
}
.btn-walkin-submit:hover { background: #2e5e41; }
.btn-walkin-submit:disabled { background: #94a3b8; cursor: not-allowed; }
</style>

<div class="owner-shell">
    <jsp:include page="../common/sidebar-reception.jsp"/>
    <div class="owner-main">
        <jsp:include page="../common/reception-topbar.jsp"/>
        <div class="owner-content">

            <%-- Flash: success ─────────────────────────────────────────── --%>
            <c:if test="${not empty param.success}">
                <div class="alert alert-dismissible fade show d-flex align-items-start gap-3 mb-3 rounded-4"
                     style="background:#f2f8f4; border:1px solid #bddece; color:#3d7a56;" role="alert">
                    <i class="fa-solid fa-circle-check fs-4 flex-shrink-0 mt-1"></i>
                    <div>
                        <div class="fw-bold mb-1">Đặt phòng Walk-in thành công!</div>
                        <div class="small">
                            Mã đặt phòng: <strong>${param.success}</strong> &nbsp;·&nbsp;
                            Phòng: <strong>${param.room}</strong> &nbsp;·&nbsp;
                            Khách: <strong>${param.guest}</strong>
                        </div>
                        <div class="small mt-1">Phòng đã chuyển sang trạng thái <strong>Đang có khách</strong>.</div>
                    </div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <%-- Flash: error ───────────────────────────────────────────── --%>
            <c:if test="${not empty param.error}">
                <div class="alert alert-dismissible fade show d-flex align-items-center gap-2 mb-3 rounded-4"
                     style="background:#faf2f2; border:1px solid #ddbfbf; color:#8e4a4a;" role="alert">
                    <i class="fa-solid fa-circle-exclamation fs-5"></i>
                    <span>
                        <c:choose>
                            <c:when test="${param.error eq 'missing_fields'}">Vui lòng điền đầy đủ: Họ tên, Số điện thoại và chọn Phòng.</c:when>
                            <c:when test="${param.error eq 'room_unavailable'}">Phòng đã được đặt bởi người khác. Vui lòng chọn phòng khác.</c:when>
                            <c:when test="${param.error eq 'no_homestay'}">Lễ tân chưa được gán cơ sở — không thể tạo đơn walk-in.</c:when>
                            <c:when test="${param.error eq 'booking_failed'}">Tạo đơn thất bại. Vui lòng thử lại.</c:when>
                            <c:otherwise>Đã xảy ra lỗi khi xử lý. Vui lòng thử lại.</c:otherwise>
                        </c:choose>
                    </span>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <%-- Warning: no homestay ───────────────────────────────────── --%>
            <c:if test="${empty homestayId}">
                <div class="d-flex gap-3 p-3 mb-3 rounded-4"
                     style="background:#faf6ec; border:1px solid #d8c085; font-size:0.84rem; color:#6b4e1a;">
                    <i class="fa-solid fa-triangle-exclamation mt-1 flex-shrink-0" style="color:#c4a050;"></i>
                    <span><strong>Chưa được phân công:</strong> Tài khoản lễ tân chưa được gán cho cơ sở nào.</span>
                </div>
            </c:if>

            <%-- Page header ────────────────────────────────────────────── --%>
            <div class="wk-page-header">
                <div>
                    <h4 class="wk-title">
                        <i class="fa-solid fa-person-walking-luggage me-2" style="color:#7ab896; font-size:1rem;"></i>Đặt phòng Khách vãng lai
                    </h4>
                    <p class="wk-subtitle">Tạo đơn đặt chỗ và nhận phòng trực tiếp — không cần đặt trước online</p>
                </div>
                <c:if test="${not empty homestayName}">
                    <div class="wk-property-tag">
                        <i class="fa-solid fa-hotel" style="color:#90a8bc;"></i>${homestayName}
                    </div>
                </c:if>
            </div>

            <%-- Main form ──────────────────────────────────────────────── --%>
            <c:if test="${not empty homestayId}">
                <form action="${pageContext.request.contextPath}/reception/walk-in"
                      method="POST" id="walkInForm" novalidate>

                    <div class="row g-4">

                        <%-- ── LEFT PANEL ────────────────────────────── --%>
                        <div class="col-lg-7">

                            <%-- Guest Info ─────────────────────────────── --%>
                            <div class="mb-4">
                                <div class="wk-section-label">
                                    <i class="fa-solid fa-user"></i>Thông tin khách hàng
                                </div>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold text-dark small mb-1">
                                            Họ và tên <span class="text-danger">*</span>
                                        </label>
                                        <input type="text" name="guestName" id="guestName"
                                               class="form-control rounded-3"
                                               placeholder="Nguyễn Văn An"
                                               value="${not empty param.guestName ? param.guestName : ''}"
                                               required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold text-dark small mb-1">
                                            Số điện thoại <span class="text-danger">*</span>
                                        </label>
                                        <input type="tel" name="guestPhone" id="guestPhone"
                                               class="form-control rounded-3"
                                               placeholder="0901234567"
                                               pattern="[0-9+]{9,15}"
                                               value="${not empty param.guestPhone ? param.guestPhone : ''}"
                                               required>
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label fw-semibold text-dark small mb-1">
                                            Email <span class="text-muted fw-normal">(tuỳ chọn)</span>
                                        </label>
                                        <input type="email" name="guestEmail" id="guestEmail"
                                               class="form-control rounded-3"
                                               placeholder="nguyen@example.com"
                                               value="${not empty param.guestEmail ? param.guestEmail : ''}">
                                    </div>
                                </div>
                            </div>

                            <%-- Stay Duration ──────────────────────────── --%>
                            <div class="mb-4">
                                <div class="wk-section-label">
                                    <i class="fa-solid fa-calendar-days"></i>Thời gian lưu trú
                                </div>
                                <div class="row g-3">
                                    <div class="col-md-5">
                                        <label class="form-label fw-semibold text-dark small mb-1">Check-in</label>
                                        <input type="text" class="form-control rounded-3 bg-light text-muted"
                                               value="Hôm nay — ${today}" readonly>
                                    </div>
                                    <div class="col-md-5">
                                        <label class="form-label fw-semibold text-dark small mb-1">
                                            Check-out <span class="text-danger">*</span>
                                        </label>
                                        <input type="date" name="checkoutDate" id="checkoutDate"
                                               class="form-control rounded-3"
                                               min="${tomorrow}"
                                               value="${tomorrow}"
                                               required>
                                    </div>
                                    <div class="col-md-2">
                                        <label class="form-label fw-semibold text-dark small mb-1">Số đêm</label>
                                        <div class="form-control rounded-3 bg-light text-center fw-bold"
                                             id="nightsDisplay" style="color:#3d7a56;">1</div>
                                    </div>
                                </div>
                            </div>

                            <%-- Room Selection ─────────────────────────── --%>
                            <div>
                                <div class="wk-section-label">
                                    <i class="fa-solid fa-door-open"></i>Chọn phòng
                                    <span class="text-muted fw-normal normal-case" style="text-transform:none; letter-spacing:0;">
                                        (${fn:length(availableRooms)} phòng trống)
                                    </span>
                                </div>

                                <c:choose>
                                    <c:when test="${empty availableRooms}">
                                        <div class="wk-empty-state p-4 rounded-3" style="background:#f8fafc; border:1px dashed #dde2ea;">
                                            <i class="fa-solid fa-door-closed fs-2 mb-2 d-block" style="color:#c8d4de;"></i>
                                            Hiện không có phòng nào trống tại cơ sở này.
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="row g-2" id="roomGrid">
                                            <c:forEach var="room" items="${availableRooms}">
                                                <div class="col-6 col-md-4">
                                                    <input type="radio"
                                                           name="roomId"
                                                           id="room${room.roomId}"
                                                           value="${room.roomId}"
                                                           class="room-opt-radio"
                                                           data-price="${room.basePrice}"
                                                           data-name="P.${room.roomNumber}"
                                                           data-type="${room.roomTypeName}"
                                                           required>
                                                    <label for="room${room.roomId}" class="room-opt-label">
                                                        <div class="d-flex align-items-center justify-content-between mb-1">
                                                            <span class="room-opt-num">P.${room.roomNumber}</span>
                                                            <i class="fa-solid fa-circle-check text-success opacity-0 room-check-icon" style="font-size:0.85rem;"></i>
                                                        </div>
                                                        <div class="room-opt-type">${room.roomTypeName}</div>
                                                        <div class="room-opt-price">
                                                            <fmt:formatNumber value="${room.basePrice}" type="number" groupingUsed="true"/> VNĐ/đêm
                                                        </div>
                                                    </label>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                        </div><%-- /left panel --%>

                        <%-- ── RIGHT PANEL: Booking Summary ──────────── --%>
                        <div class="col-lg-5">
                            <div class="wk-summary">
                                <div class="wk-sum-title">
                                    <i class="fa-solid fa-receipt me-2" style="color:#7ab896;"></i>Tóm tắt đặt phòng
                                </div>

                                <%-- Empty state --%>
                                <div id="sumEmpty" class="wk-empty-state">
                                    <i class="fa-solid fa-hand-pointer mb-2 d-block" style="color:#c8d4de; font-size:1.8rem;"></i>
                                    Chọn phòng để xem tóm tắt
                                </div>

                                <%-- Summary rows (hidden until room selected) --%>
                                <div id="sumContent" style="display:none;">
                                    <div class="wk-sum-row">
                                        <span>Phòng</span>
                                        <strong id="sumRoom">—</strong>
                                    </div>
                                    <div class="wk-sum-row">
                                        <span>Loại phòng</span>
                                        <strong id="sumType">—</strong>
                                    </div>
                                    <div class="wk-sum-row">
                                        <span>Check-in</span>
                                        <strong>${today}</strong>
                                    </div>
                                    <div class="wk-sum-row">
                                        <span>Check-out</span>
                                        <strong id="sumCheckout">${tomorrow}</strong>
                                    </div>
                                    <div class="wk-sum-row">
                                        <span>Số đêm</span>
                                        <strong id="sumNights">1</strong>
                                    </div>
                                    <div class="wk-sum-row">
                                        <span>Giá/đêm</span>
                                        <strong id="sumPricePerNight">—</strong>
                                    </div>
                                    <div class="wk-sum-total">
                                        <span>Tổng tiền</span>
                                        <span class="total-amount" id="sumTotal">—</span>
                                    </div>
                                </div>

                                <div class="mt-4">
                                    <button type="submit" class="btn-walkin-submit w-100" id="submitBtn" disabled>
                                        <i class="fa-solid fa-right-to-bracket"></i>
                                        Tạo đơn &amp; Check-in ngay
                                    </button>
                                    <p class="text-center mt-2 mb-0" style="font-size:0.72rem; color:#94a3b8;">
                                        <i class="fa-solid fa-circle-info me-1"></i>
                                        Phòng sẽ chuyển sang <strong>Đang có khách</strong> ngay sau khi xác nhận
                                    </p>
                                </div>
                            </div>
                        </div><%-- /right panel --%>

                    </div><%-- /row --%>
                </form>
            </c:if>

        </div>
    </div>
</div>

<script>
(function () {
    var checkinDate  = '${today}';
    var selectedRoom = null;
    var checkoutInput = document.getElementById('checkoutDate');

    /* Format VND */
    function fmtVnd(n) {
        return new Intl.NumberFormat('vi-VN').format(n) + ' VNĐ';
    }

    /* Calculate nights between checkin (today) and checkout */
    function calcNights() {
        if (!checkoutInput || !checkoutInput.value) return 1;
        var co   = new Date(checkoutInput.value);
        var ci   = new Date(checkinDate);
        var diff = Math.round((co - ci) / 86400000);
        return diff > 0 ? diff : 1;
    }

    /* Update summary panel */
    function updateSummary() {
        var nights     = calcNights();
        var sumEmpty   = document.getElementById('sumEmpty');
        var sumContent = document.getElementById('sumContent');
        var submitBtn  = document.getElementById('submitBtn');

        document.getElementById('nightsDisplay').textContent = nights;
        document.getElementById('sumNights').textContent     = nights + ' đêm';
        document.getElementById('sumCheckout').textContent   = checkoutInput ? checkoutInput.value : '';

        if (!selectedRoom) {
            sumEmpty.style.display   = '';
            sumContent.style.display = 'none';
            submitBtn.disabled       = true;
            return;
        }

        var price = parseFloat(selectedRoom.dataset.price || 0);
        var total = price * nights;

        document.getElementById('sumRoom').textContent         = selectedRoom.dataset.name;
        document.getElementById('sumType').textContent         = selectedRoom.dataset.type;
        document.getElementById('sumPricePerNight').textContent = fmtVnd(price);
        document.getElementById('sumTotal').textContent        = fmtVnd(total);

        sumEmpty.style.display   = 'none';
        sumContent.style.display = '';
        submitBtn.disabled       = false;
    }

    /* Room radio change */
    document.querySelectorAll('.room-opt-radio').forEach(function (radio) {
        radio.addEventListener('change', function () {
            selectedRoom = this;

            /* Toggle checkmark icons */
            document.querySelectorAll('.room-check-icon').forEach(function (icon) {
                icon.classList.add('opacity-0');
            });
            var label = document.querySelector('label[for="' + radio.id + '"]');
            if (label) {
                var icon = label.querySelector('.room-check-icon');
                if (icon) icon.classList.remove('opacity-0');
            }

            updateSummary();
        });
    });

    /* Checkout date change */
    if (checkoutInput) {
        checkoutInput.addEventListener('change', updateSummary);
    }

    /* Form submit validation */
    var form = document.getElementById('walkInForm');
    if (form) {
        form.addEventListener('submit', function (e) {
            var guestName  = document.getElementById('guestName');
            var guestPhone = document.getElementById('guestPhone');
            var roomInputs = document.querySelectorAll('[name="roomId"]');
            var roomChosen = Array.from(roomInputs).some(function (r) { return r.checked; });

            if (!guestName || !guestName.value.trim() ||
                !guestPhone || !guestPhone.value.trim() || !roomChosen) {
                e.preventDefault();
                alert('Vui lòng điền đầy đủ: Họ tên, Số điện thoại và chọn Phòng.');
            }
        });
    }

    /* Init */
    updateSummary();
})();
</script>

<jsp:include page="../common/footer.jsp"/>
