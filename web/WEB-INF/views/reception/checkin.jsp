<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle"      value="Check-in &amp; Quét CCCD OCR"      scope="request"/>
<c:set var="pageBreadcrumb" value="Đón tiếp &amp; Quản lý Phòng"       scope="request"/>
<jsp:include page="../common/header.jsp"/>

<div class="owner-shell">
    <jsp:include page="../common/sidebar-reception.jsp"/>
    <div class="owner-main">
        <jsp:include page="../common/reception-topbar.jsp"/>
        <div class="owner-content">

            <%-- ── Flash messages ─────────────────────────────────────────── --%>
            <c:if test="${not empty param.success}">
                <div class="alert alert-success alert-dismissible fade show rounded-4 mb-3 shadow-sm" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i>
                    Check-in thành công đơn <strong>${param.success}</strong>!
                    Phòng đã được cập nhật sang trạng thái <strong>OCCUPIED</strong>.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty param.checkoutSuccess}">
                <div class="alert alert-dismissible fade show rounded-4 mb-3 shadow-sm d-flex align-items-center gap-2"
                     style="background:#f2f8f4; border:1px solid #bddece; color:#3d7a56;" role="alert">
                    <i class="fa-solid fa-right-from-bracket fs-5"></i>
                    <span>Check-out thành công đơn <strong>${param.checkoutSuccess}</strong>!
                    Phòng đã chuyển sang trạng thái <strong>Cần dọn dẹp</strong>.</span>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="alert alert-danger alert-dismissible fade show rounded-4 mb-3 shadow-sm" role="alert">
                    <i class="fa-solid fa-circle-xmark me-2"></i>
                    <c:choose>
                        <c:when test="${param.error eq 'checkin_failed'}">
                            Check-in thất bại. Đơn phòng có thể không còn ở trạng thái CONFIRMED hoặc phòng đã được giao cho người khác.
                        </c:when>
                        <c:when test="${param.error eq 'missing_params'}">
                            Vui lòng chọn phòng trước khi xác nhận check-in.
                        </c:when>
                        <c:when test="${param.error eq 'checkout_failed'}">
                            Check-out thất bại. Đơn phòng có thể không còn ở trạng thái CHECKED_IN.
                        </c:when>
                        <c:otherwise>Đã xảy ra lỗi khi xử lý. Vui lòng thử lại.</c:otherwise>
                    </c:choose>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <%-- ── Main card ───────────────────────────────────────────────── --%>
            <div class="card border-0 shadow-sm rounded-4 p-4 mb-4">

                <%-- Page header --%>
                <div class="d-flex align-items-center justify-content-between mb-4 border-bottom pb-3">
                    <div>
                        <h4 class="fw-bold mb-1 text-dark">
                            <i class="fa-solid fa-passport text-info me-2"></i>Check-in Khách &amp; Quét CCCD OCR
                        </h4>
                        <p class="text-muted mb-0">Tra cứu đặt phòng, bóc tách thông tin CCCD tự động và xác nhận giao phòng</p>
                    </div>
                    <span class="badge bg-info-subtle text-info border border-info px-3 py-2 fs-6">
                        <i class="fa-solid fa-hotel me-1"></i>
                        <c:choose>
                            <c:when test="${not empty homestayName}">${homestayName}</c:when>
                            <c:otherwise>Chưa được gán cơ sở</c:otherwise>
                        </c:choose>
                    </span>
                </div>

                <%-- Warning: chưa được gán homestay --%>
                <c:if test="${empty homestayId}">
                    <div class="alert alert-warning rounded-4 mb-4">
                        <i class="fa-solid fa-triangle-exclamation me-2"></i>
                        <strong>Chưa được phân công:</strong> Tài khoản lễ tân của bạn chưa được gán cho cơ sở homestay nào.
                        Vui lòng liên hệ Owner hoặc Admin để được phân công qua trang Quản lý Nhân viên.
                    </div>
                </c:if>

                <%-- ── Search bar ──────────────────────────────────────────── --%>
                <form method="GET" action="${pageContext.request.contextPath}/reception/checkin" class="mb-4">
                    <div class="card border rounded-4 p-3 bg-light">
                        <h6 class="fw-bold mb-3">
                            <i class="fa-solid fa-magnifying-glass me-2 text-primary"></i>Tra cứu đơn đặt phòng
                        </h6>
                        <div class="input-group input-group-lg">
                            <input type="text" class="form-control" name="q"
                                   placeholder="Nhập mã đặt phòng (VD: BK-20261001-0001) hoặc số điện thoại khách..."
                                   value="${searchQuery}" autofocus>
                            <button class="btn btn-primary fw-semibold" type="submit">
                                <i class="fa-solid fa-search me-1"></i> Tìm kiếm
                            </button>
                        </div>
                        <small class="text-muted mt-2 d-block">
                            <i class="fa-solid fa-circle-info text-info me-1"></i>
                            Nhập mã bắt đầu bằng <code>BK-</code> để tìm theo mã đặt phòng,
                            hoặc nhập số điện thoại 10 chữ số để tìm theo SĐT khách.
                        </small>
                    </div>
                </form>

                <%-- ── Chưa tìm kiếm: welcome panel ──────────────────────── --%>
                <c:if test="${empty searchQuery and empty param.success}">
                    <div class="text-center py-5 text-muted">
                        <div class="rounded-circle bg-light d-inline-flex align-items-center justify-content-center mb-3"
                             style="width:88px;height:88px;">
                            <i class="fa-solid fa-qrcode fs-1 text-info"></i>
                        </div>
                        <h5 class="fw-bold text-dark mb-2">Nhập mã hoặc SĐT để bắt đầu</h5>
                        <p class="mb-0">
                            Tra cứu theo <strong>mã đặt phòng</strong> (BK-...) hoặc
                            <strong>số điện thoại</strong> của khách đã đặt
                        </p>
                    </div>
                </c:if>

                <%-- ── Search error ────────────────────────────────────────── --%>
                <c:if test="${not empty searchError}">
                    <div class="alert alert-warning rounded-4 mb-3">
                        <i class="fa-solid fa-magnifying-glass me-2"></i>${searchError}
                    </div>
                </c:if>

                <%-- ── Multiple results (tìm theo SĐT có nhiều booking) ───── --%>
                <c:if test="${not empty multipleResults}">
                    <div class="alert alert-info rounded-4 mb-3 small">
                        <i class="fa-solid fa-circle-info me-1"></i>
                        Tìm thấy <strong>${multipleResults.size()}</strong> đơn cho SĐT <code>${searchQuery}</code>.
                        Đang hiển thị đơn gần nhất — các đơn khác:
                        <c:forEach var="b" items="${multipleResults}" begin="1">
                            <a href="?q=${b.bookingCode}" class="ms-1 badge bg-secondary text-decoration-none">
                                ${b.bookingCode}
                            </a>
                        </c:forEach>
                    </div>
                </c:if>

                <%-- ── Booking found ───────────────────────────────────────── --%>
                <c:if test="${not empty booking}">
                    <div class="row g-4">

                        <%-- LEFT: Booking info + check-in form ──────────────── --%>
                        <div class="col-lg-7">

                            <%-- Booking summary --%>
                            <div class="card border rounded-4 p-4 mb-3 shadow-sm">
                                <div class="d-flex align-items-center justify-content-between mb-3 border-bottom pb-2">
                                    <h6 class="fw-bold mb-0">
                                        <i class="fa-solid fa-receipt text-primary me-1"></i>${booking.bookingCode}
                                    </h6>
                                    <c:choose>
                                        <c:when test="${booking.bookingStatus eq 'CONFIRMED'}">
                                            <span class="badge bg-success px-3 py-2">CONFIRMED</span>
                                        </c:when>
                                        <c:when test="${booking.bookingStatus eq 'CHECKED_IN'}">
                                            <span class="badge bg-primary px-3 py-2">CHECKED_IN</span>
                                        </c:when>
                                        <c:when test="${booking.bookingStatus eq 'PENDING'}">
                                            <span class="badge bg-warning text-dark px-3 py-2">PENDING</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary px-3 py-2">${booking.bookingStatus}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="row g-3">
                                    <div class="col-6">
                                        <small class="text-muted d-block">Tên khách</small>
                                        <strong>${booking.guestName}</strong>
                                    </div>
                                    <div class="col-6">
                                        <small class="text-muted d-block">Số điện thoại</small>
                                        <strong>${booking.guestPhone}</strong>
                                    </div>
                                    <div class="col-6">
                                        <small class="text-muted d-block">Hạng phòng</small>
                                        <strong>${booking.roomTypeName}</strong>
                                    </div>
                                    <div class="col-6">
                                        <small class="text-muted d-block">Homestay</small>
                                        <strong>${booking.homestayName}</strong>
                                    </div>
                                    <div class="col-6">
                                        <small class="text-muted d-block">Check-in</small>
                                        <strong>${booking.checkinDate}</strong>
                                    </div>
                                    <div class="col-6">
                                        <small class="text-muted d-block">Check-out</small>
                                        <strong>${booking.checkoutDate}</strong>
                                    </div>
                                    <div class="col-6">
                                        <small class="text-muted d-block">Số đêm</small>
                                        <strong>${booking.totalNights} đêm</strong>
                                    </div>
                                    <div class="col-6">
                                        <small class="text-muted d-block">Tổng tiền</small>
                                        <strong class="text-success fs-6">
                                            <fmt:formatNumber value="${booking.finalTotal}" pattern="#,##0"/> VNĐ
                                        </strong>
                                    </div>
                                    <c:if test="${not empty booking.guestEmail}">
                                        <div class="col-12">
                                            <small class="text-muted d-block">Email</small>
                                            <strong>${booking.guestEmail}</strong>
                                        </div>
                                    </c:if>
                                    <%-- Hiện CCCD nếu đã CHECKED_IN --%>
                                    <c:if test="${booking.bookingStatus eq 'CHECKED_IN' and not empty booking.guestIdCardNumber}">
                                        <div class="col-12">
                                            <small class="text-muted d-block">Số CCCD đã ghi nhận</small>
                                            <strong class="font-monospace">${booking.guestIdCardNumber}</strong>
                                        </div>
                                    </c:if>
                                </div>
                            </div>

                            <%-- ── Check-in form (chỉ khi CONFIRMED) ──────── --%>
                            <c:if test="${booking.bookingStatus eq 'CONFIRMED'}">
                                <div class="card border-2 border-success rounded-4 p-4 shadow-sm">
                                    <h6 class="fw-bold mb-3 text-success">
                                        <i class="fa-solid fa-key me-2"></i>Xác nhận Check-in &amp; Giao phòng
                                    </h6>

                                    <form id="checkinForm" method="POST"
                                          action="${pageContext.request.contextPath}/reception/checkin">
                                        <input type="hidden" name="action"    value="checkin">
                                        <input type="hidden" name="bookingId" value="${booking.bookingId}">
                                        <input type="hidden" id="rawOcrJson"  name="rawOcrJson" value="{}">

                                        <%-- Chọn phòng giao khách --%>
                                        <div class="mb-3">
                                            <label class="form-label fw-semibold">
                                                Phòng giao cho khách
                                                <span class="text-danger">*</span>
                                            </label>
                                            <c:choose>
                                                <c:when test="${not empty availableRooms}">
                                                    <select name="selectedRoomId" class="form-select" required>
                                                        <option value="">— Chọn phòng —</option>
                                                        <c:forEach var="room" items="${availableRooms}">
                                                            <option value="${room.roomId}">
                                                                Phòng ${room.roomNumber}
                                                                (${room.roomTypeName})
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                    <small class="text-success">
                                                        <i class="fa-solid fa-circle-check me-1"></i>
                                                        ${availableRooms.size()} phòng ${booking.roomTypeName} đang trống
                                                    </small>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="alert alert-warning rounded-3 py-2 mb-0">
                                                        <i class="fa-solid fa-triangle-exclamation me-1"></i>
                                                        Không còn phòng trống loại <strong>${booking.roomTypeName}</strong>
                                                        trong khoảng thời gian này.
                                                        Cần vào <a href="${pageContext.request.contextPath}/reception/housekeeping"
                                                                   class="alert-link">Quản lý Buồng phòng</a> để giải phóng phòng.
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <%-- Số CCCD / Passport --%>
                                        <div class="mb-4">
                                            <label for="idCardNumber" class="form-label fw-semibold">
                                                Số CCCD / Passport
                                            </label>
                                            <div class="input-group">
                                                <span class="input-group-text bg-light">
                                                    <i class="fa-solid fa-id-card text-info"></i>
                                                </span>
                                                <input type="text" class="form-control font-monospace"
                                                       id="idCardNumber" name="idCardNumber"
                                                       placeholder="Tự động điền sau khi quét OCR, hoặc nhập thủ công..."
                                                       maxlength="50">
                                            </div>
                                            <small class="text-muted">
                                                Quét ảnh CCCD ở ô bên phải — số sẽ được điền tự động.
                                            </small>
                                        </div>

                                        <c:if test="${not empty availableRooms}">
                                            <button type="submit" class="btn btn-success w-100 fw-semibold py-2 rounded-3">
                                                <i class="fa-solid fa-key me-2"></i>Xác nhận Check-in &amp; Giao phòng
                                            </button>
                                        </c:if>
                                    </form>
                                </div>
                            </c:if>

                            <%-- Đã check-in → cho phép checkout --%>
                            <c:if test="${booking.bookingStatus eq 'CHECKED_IN'}">
                                <div class="alert alert-primary rounded-4 shadow-sm d-flex align-items-center justify-content-between flex-wrap gap-3">
                                    <div>
                                        <i class="fa-solid fa-circle-check me-2"></i>
                                        Khách đã được <strong>Check-in</strong> thành công.
                                        Phòng hiện đang phục vụ.
                                    </div>
                                    <form action="${pageContext.request.contextPath}/reception/checkin"
                                          method="POST"
                                          onsubmit="return confirm('Xác nhận Check-out cho đơn phòng ${booking.bookingCode}?\n\nKhách: ${booking.guestName}\nPhòng sẽ chuyển sang trạng thái Cần dọn dẹp.');">
                                        <input type="hidden" name="action"    value="checkout">
                                        <input type="hidden" name="bookingId" value="${booking.bookingId}">
                                        <button type="submit"
                                                class="btn btn-sm fw-bold rounded-pill px-4 py-2"
                                                style="background:#fff; color:#1d4ed8; border:1.5px solid #93c5fd;">
                                            <i class="fa-solid fa-right-from-bracket me-1"></i>Check-out ngay
                                        </button>
                                    </form>
                                </div>
                            </c:if>

                            <%-- Trạng thái khác --%>
                            <c:if test="${booking.bookingStatus ne 'CONFIRMED' and booking.bookingStatus ne 'CHECKED_IN'}">
                                <div class="alert alert-secondary rounded-4">
                                    <i class="fa-solid fa-circle-info me-2"></i>
                                    Đơn phòng này không thể check-in
                                    (trạng thái hiện tại: <strong>${booking.bookingStatus}</strong>).
                                </div>
                            </c:if>
                        </div>

                        <%-- RIGHT: OCR Panel ──────────────────────────────── --%>
                        <div class="col-lg-5">
                            <div class="card border-2 border-info rounded-4 p-4 shadow-sm h-100">
                                <div class="text-center mb-3">
                                    <div class="rounded-circle bg-info-subtle text-info d-inline-flex
                                                align-items-center justify-content-center mb-2"
                                         style="width:64px;height:64px;">
                                        <i class="fa-solid fa-camera-retro fs-2"></i>
                                    </div>
                                    <h6 class="fw-bold mb-1">Quét CCCD / Passport — OCR</h6>
                                    <p class="text-muted small mb-0">
                                        Kéo thả hoặc chọn ảnh mặt trước CCCD để bóc tách thông tin tự động
                                    </p>
                                </div>

                                <%-- Drop zone --%>
                                <div id="ocrDropZone"
                                     class="border border-2 rounded-3 p-4 text-center mb-3 bg-light"
                                     style="cursor:pointer; border-style:dashed !important; border-color:#adb5bd !important; transition: border-color .2s;">
                                    <i class="fa-solid fa-cloud-arrow-up fs-2 text-muted mb-2 d-block"></i>
                                    <small class="text-muted d-block mb-1">Kéo thả ảnh CCCD vào đây</small>
                                    <button type="button" class="btn btn-sm btn-outline-info"
                                            onclick="document.getElementById('ocrFileInput').click()">
                                        <i class="fa-solid fa-folder-open me-1"></i> Chọn file ảnh
                                    </button>
                                    <input type="file" id="ocrFileInput" accept="image/*" class="d-none">
                                </div>

                                <%-- Loading --%>
                                <div id="ocrLoading" class="text-center py-3 d-none">
                                    <div class="spinner-border text-info" role="status">
                                        <span class="visually-hidden">Đang xử lý...</span>
                                    </div>
                                    <small class="d-block text-muted mt-2">Đang gửi lên OCR API...</small>
                                </div>

                                <%-- OCR error --%>
                                <div id="ocrError" class="alert alert-warning rounded-3 small d-none mb-2">
                                    <i class="fa-solid fa-triangle-exclamation me-1"></i>
                                    <span id="ocrErrorMsg"></span>
                                    <br><small class="text-muted mt-1 d-block">
                                        Vui lòng nhập số CCCD thủ công vào ô Số CCCD bên trái.
                                    </small>
                                </div>

                                <%-- OCR result --%>
                                <div id="ocrResult" class="bg-success-subtle border border-success rounded-3 p-3 small d-none">
                                    <p class="fw-bold text-success mb-2">
                                        <i class="fa-solid fa-circle-check me-1"></i> Bóc tách OCR thành công
                                    </p>
                                    <table class="table table-sm table-borderless mb-0">
                                        <tr>
                                            <td class="text-muted py-1" style="width:38%">Số CCCD:</td>
                                            <td class="fw-semibold font-monospace py-1" id="ocrIdNumber">—</td>
                                        </tr>
                                        <tr>
                                            <td class="text-muted py-1">Họ tên:</td>
                                            <td class="fw-semibold py-1" id="ocrFullName">—</td>
                                        </tr>
                                        <tr>
                                            <td class="text-muted py-1">Ngày sinh:</td>
                                            <td class="py-1" id="ocrDob">—</td>
                                        </tr>
                                        <tr>
                                            <td class="text-muted py-1">Giới tính:</td>
                                            <td class="py-1" id="ocrSex">—</td>
                                        </tr>
                                        <tr>
                                            <td class="text-muted py-1">Địa chỉ:</td>
                                            <td class="py-1" id="ocrAddress" style="word-break:break-word">—</td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>

                    </div><%-- /row --%>
                </c:if>

            </div><%-- /main card --%>
        </div>
    </div>
</div>

<%-- ── OCR JavaScript ──────────────────────────────────────────────────────── --%>
<script>
(function () {
    var ctxPath    = '${pageContext.request.contextPath}';
    var dropZone   = document.getElementById('ocrDropZone');
    var fileInput  = document.getElementById('ocrFileInput');
    var loadingEl  = document.getElementById('ocrLoading');
    var resultEl   = document.getElementById('ocrResult');
    var errorEl    = document.getElementById('ocrError');
    var errorMsgEl = document.getElementById('ocrErrorMsg');
    var idField    = document.getElementById('idCardNumber');
    var rawField   = document.getElementById('rawOcrJson');

    if (!dropZone) return; // Trang chưa có booking — bỏ qua

    /* Drag & drop */
    dropZone.addEventListener('dragover', function (e) {
        e.preventDefault();
        dropZone.style.borderColor = '#0dcaf0';
        dropZone.style.background  = '#e8f8fc';
    });
    dropZone.addEventListener('dragleave', function () {
        dropZone.style.borderColor = '#adb5bd';
        dropZone.style.background  = '';
    });
    dropZone.addEventListener('drop', function (e) {
        e.preventDefault();
        dropZone.style.borderColor = '#adb5bd';
        dropZone.style.background  = '';
        var file = e.dataTransfer.files[0];
        if (file) uploadOcr(file);
    });

    /* File input change */
    if (fileInput) {
        fileInput.addEventListener('change', function (e) {
            if (e.target.files[0]) uploadOcr(e.target.files[0]);
        });
    }

    function uploadOcr(file) {
        /* Reset UI */
        if (loadingEl) loadingEl.classList.remove('d-none');
        if (resultEl)  resultEl.classList.add('d-none');
        if (errorEl)   errorEl.classList.add('d-none');

        var formData = new FormData();
        formData.append('image', file);

        fetch(ctxPath + '/reception/ocr-scan', {
            method: 'POST',
            body:   formData
        })
        .then(function (r) { return r.json(); })
        .then(function (data) {
            if (loadingEl) loadingEl.classList.add('d-none');

            if (data.success) {
                /* Điền vào form */
                if (idField)  idField.value  = data.idNumber  || '';
                if (rawField) rawField.value = data.rawJson   || '{}';

                /* Hiện kết quả */
                setText('ocrIdNumber', data.idNumber    || '—');
                setText('ocrFullName', data.fullName    || '—');
                setText('ocrDob',      data.dateOfBirth || '—');
                setText('ocrSex',      data.sex         || '—');
                setText('ocrAddress',  data.address     || '—');

                if (resultEl) resultEl.classList.remove('d-none');
            } else {
                if (errorMsgEl) errorMsgEl.textContent = data.error || 'Lỗi không xác định';
                if (errorEl)    errorEl.classList.remove('d-none');
            }
        })
        .catch(function (err) {
            if (loadingEl) loadingEl.classList.add('d-none');
            if (errorMsgEl) errorMsgEl.textContent = 'Lỗi kết nối: ' + err.message;
            if (errorEl)    errorEl.classList.remove('d-none');
        });
    }

    function setText(id, value) {
        var el = document.getElementById(id);
        if (el) el.textContent = value;
    }
})();
</script>

<jsp:include page="../common/footer.jsp"/>
