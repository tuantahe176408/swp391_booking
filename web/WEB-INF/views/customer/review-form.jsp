<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<style>
    /* ── JS-driven star widget ──────────────────────────────────────────── */
    .star-rating {
        display: flex;
        gap: 6px;
        align-items: center;
    }
    .star-rating .star {
        font-size: 1.9rem;
        color: #dee2e6;
        cursor: pointer;
        transition: color .12s, transform .1s;
        line-height: 1;
        user-select: none;
    }
    .star-rating .star:hover,
    .star-rating .star.active {
        color: #ffc107;
    }
    .star-rating .star:hover {
        transform: scale(1.15);
    }
</style>

<div class="container py-5" style="max-width: 760px;">

    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-3">
        <ol class="breadcrumb mb-0">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/customer/bookings">Đơn đặt phòng</a></li>
            <li class="breadcrumb-item active" aria-current="page">Viết đánh giá</li>
        </ol>
    </nav>

    <!-- Page heading -->
    <div class="mb-4">
        <h3 class="fw-bold mb-1">
            <i class="fa-solid fa-${editMode ? 'pen-to-square' : 'star'} ${editMode ? 'text-primary' : 'text-warning'} me-2"></i>
            ${editMode ? 'Sửa đánh giá của bạn' : 'Viết đánh giá của bạn'}
        </h3>
        <p class="text-muted mb-0">
            ${editMode ? 'Cập nhật trải nghiệm của bạn — điểm tổng thể sẽ được tính lại ngay.' : 'Chia sẻ trải nghiệm để giúp các khách hàng khác lựa chọn tốt hơn.'}
        </p>
    </div>

    <!-- Homestay info card -->
    <div class="card border-0 shadow-sm rounded-4 mb-4">
        <div class="card-body p-4">
            <div class="d-flex align-items-center gap-3">
                <c:choose>
                    <c:when test="${not empty booking.homestayImageUrl}">
                        <img src="${booking.homestayImageUrl}" alt="${booking.homestayName}"
                             class="rounded-3 object-fit-cover flex-shrink-0"
                             style="width:80px;height:80px;"
                             onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/images/default-homestay.svg';">
                    </c:when>
                    <c:otherwise>
                        <div class="rounded-3 bg-light border d-flex align-items-center justify-content-center flex-shrink-0"
                             style="width:80px;height:80px;">
                            <i class="fa-solid fa-house-chimney text-secondary fa-2x"></i>
                        </div>
                    </c:otherwise>
                </c:choose>
                <div>
                    <h5 class="fw-bold mb-1">${booking.homestayName}</h5>
                    <p class="text-muted small mb-1">
                        <i class="fa-solid fa-location-dot me-1 text-danger"></i>
                        ${booking.homestayAddress}<c:if test="${not empty booking.homestayCity}">, ${booking.homestayCity}</c:if>
                    </p>
                    <span class="badge bg-light text-dark border small">
                        <i class="fa-solid fa-calendar-days me-1 text-primary"></i>
                        <fmt:formatDate value="${booking.checkinDate}" pattern="dd/MM/yyyy"/> –
                        <fmt:formatDate value="${booking.checkoutDate}" pattern="dd/MM/yyyy"/>
                        (${booking.totalNights} đêm)
                    </span>
                </div>
                <div class="ms-auto text-end d-none d-md-block">
                    <small class="text-muted d-block">Mã đơn</small>
                    <strong class="text-primary">#${booking.bookingCode}</strong>
                </div>
            </div>
        </div>
    </div>

    <!-- Error alert (validation failure re-show) -->
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger rounded-4 shadow-sm mb-4" role="alert">
            <i class="fa-solid fa-circle-exclamation me-2"></i>${errorMessage}
        </div>
    </c:if>

    <!-- Review form -->
    <form action="${pageContext.request.contextPath}/customer/review" method="POST" id="reviewForm" novalidate>
        <input type="hidden" name="bookingId" value="${booking.bookingId}">
        <%-- reviewId=0 → insert mode; reviewId>0 → edit/update mode --%>
        <input type="hidden" name="reviewId"  value="${not empty reviewId ? reviewId : 0}">

        <!-- Dimension ratings -->
        <div class="card border-0 shadow-sm rounded-4 mb-4">
            <div class="card-body p-4">
                <h5 class="fw-bold mb-4"><i class="fa-solid fa-sliders me-2 text-primary"></i>Đánh giá theo tiêu chí</h5>

                <!-- Cleanliness -->
                <div class="row align-items-center mb-4">
                    <div class="col-md-4 mb-2 mb-md-0">
                        <span class="fw-semibold">
                            <i class="fa-solid fa-soap me-2 text-primary"></i>Vệ sinh &amp; Sạch sẽ
                        </span>
                    </div>
                    <div class="col-md-8">
                        <div class="star-rating" id="stars-ratingCleanliness">
                            <span class="star" data-val="1"><i class="fa-solid fa-star"></i></span>
                            <span class="star" data-val="2"><i class="fa-solid fa-star"></i></span>
                            <span class="star" data-val="3"><i class="fa-solid fa-star"></i></span>
                            <span class="star" data-val="4"><i class="fa-solid fa-star"></i></span>
                            <span class="star" data-val="5"><i class="fa-solid fa-star"></i></span>
                        </div>
                        <input type="hidden" name="ratingCleanliness" id="val-ratingCleanliness"
                               value="${not empty ratingCleanliness ? ratingCleanliness : 5}">
                        <div class="text-muted small mt-1" id="label-ratingCleanliness">Xuất sắc</div>
                    </div>
                </div>

                <!-- Service -->
                <div class="row align-items-center mb-4">
                    <div class="col-md-4 mb-2 mb-md-0">
                        <span class="fw-semibold">
                            <i class="fa-solid fa-bell-concierge me-2 text-primary"></i>Dịch vụ &amp; Nhân viên
                        </span>
                    </div>
                    <div class="col-md-8">
                        <div class="star-rating" id="stars-ratingService">
                            <span class="star" data-val="1"><i class="fa-solid fa-star"></i></span>
                            <span class="star" data-val="2"><i class="fa-solid fa-star"></i></span>
                            <span class="star" data-val="3"><i class="fa-solid fa-star"></i></span>
                            <span class="star" data-val="4"><i class="fa-solid fa-star"></i></span>
                            <span class="star" data-val="5"><i class="fa-solid fa-star"></i></span>
                        </div>
                        <input type="hidden" name="ratingService" id="val-ratingService"
                               value="${not empty ratingService ? ratingService : 5}">
                        <div class="text-muted small mt-1" id="label-ratingService">Xuất sắc</div>
                    </div>
                </div>

                <!-- Location -->
                <div class="row align-items-center mb-4">
                    <div class="col-md-4 mb-2 mb-md-0">
                        <span class="fw-semibold">
                            <i class="fa-solid fa-map-location-dot me-2 text-primary"></i>Vị trí &amp; Địa điểm
                        </span>
                    </div>
                    <div class="col-md-8">
                        <div class="star-rating" id="stars-ratingLocation">
                            <span class="star" data-val="1"><i class="fa-solid fa-star"></i></span>
                            <span class="star" data-val="2"><i class="fa-solid fa-star"></i></span>
                            <span class="star" data-val="3"><i class="fa-solid fa-star"></i></span>
                            <span class="star" data-val="4"><i class="fa-solid fa-star"></i></span>
                            <span class="star" data-val="5"><i class="fa-solid fa-star"></i></span>
                        </div>
                        <input type="hidden" name="ratingLocation" id="val-ratingLocation"
                               value="${not empty ratingLocation ? ratingLocation : 5}">
                        <div class="text-muted small mt-1" id="label-ratingLocation">Xuất sắc</div>
                    </div>
                </div>

                <!-- Value -->
                <div class="row align-items-center mb-2">
                    <div class="col-md-4 mb-2 mb-md-0">
                        <span class="fw-semibold">
                            <i class="fa-solid fa-tag me-2 text-primary"></i>Giá trị &amp; Tương xứng
                        </span>
                    </div>
                    <div class="col-md-8">
                        <div class="star-rating" id="stars-ratingValue">
                            <span class="star" data-val="1"><i class="fa-solid fa-star"></i></span>
                            <span class="star" data-val="2"><i class="fa-solid fa-star"></i></span>
                            <span class="star" data-val="3"><i class="fa-solid fa-star"></i></span>
                            <span class="star" data-val="4"><i class="fa-solid fa-star"></i></span>
                            <span class="star" data-val="5"><i class="fa-solid fa-star"></i></span>
                        </div>
                        <input type="hidden" name="ratingValue" id="val-ratingValue"
                               value="${not empty ratingValue ? ratingValue : 5}">
                        <div class="text-muted small mt-1" id="label-ratingValue">Xuất sắc</div>
                    </div>
                </div>

            </div>
        </div>

        <!-- Overall score preview -->
        <div class="card border-0 shadow-sm rounded-4 mb-4" style="background:#fffbeb; border:1px solid #fde68a !important;">
            <div class="card-body p-3 d-flex align-items-center gap-3">
                <div class="text-center" style="min-width:64px;">
                    <div class="display-6 fw-bold text-warning" id="overallScore">5.0</div>
                    <div class="text-muted small">/ 5.0</div>
                </div>
                <div>
                    <div class="fw-semibold mb-1">Điểm tổng thể (trung bình 4 tiêu chí)</div>
                    <div class="text-warning fs-5" id="overallStars">
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Comment -->
        <div class="card border-0 shadow-sm rounded-4 mb-4">
            <div class="card-body p-4">
                <h5 class="fw-bold mb-3"><i class="fa-solid fa-pen-to-square me-2 text-primary"></i>Nhận xét chi tiết</h5>
                <textarea name="comment" id="commentInput" class="form-control rounded-3" rows="5"
                          placeholder="Chia sẻ trải nghiệm thực tế của bạn: không gian, phục vụ, vị trí, ẩm thực... (tối thiểu 10 ký tự)"
                          maxlength="2000" required><c:out value="${comment}"/></textarea>
                <div class="d-flex justify-content-between mt-2">
                    <div id="commentError" class="text-danger small" style="display:none;">
                        Vui lòng nhập ít nhất 10 ký tự.
                    </div>
                    <div class="text-muted small ms-auto" id="charCount">0 / 2000</div>
                </div>
            </div>
        </div>

        <!-- Actions -->
        <div class="d-flex gap-3 justify-content-end">
            <a href="${pageContext.request.contextPath}/customer/bookings"
               class="btn btn-outline-secondary rounded-pill px-4">
                <i class="fa-solid fa-arrow-left me-1"></i> Quay lại
            </a>
            <button type="submit" class="btn ${editMode ? 'btn-primary' : 'btn-warning'} fw-bold rounded-pill px-5 shadow-sm" id="submitBtn">
                <i class="fa-solid fa-${editMode ? 'floppy-disk' : 'paper-plane'} me-2"></i>${editMode ? 'Lưu thay đổi' : 'Gửi đánh giá'}
            </button>
        </div>
    </form>

</div>

<script>
(function () {
    'use strict';

    const LABELS = ['', 'Tệ', 'Kém', 'Bình thường', 'Tốt', 'Xuất sắc'];
    const DIMS   = ['ratingCleanliness', 'ratingService', 'ratingLocation', 'ratingValue'];

    /* ── Overall score ─────────────────────────────────────────────────── */
    function updateOverall() {
        var sum = 0;
        DIMS.forEach(function (name) {
            sum += parseInt(document.getElementById('val-' + name).value, 10) || 5;
        });
        var avg     = sum / DIMS.length;
        var rounded = Math.round(avg * 10) / 10;

        document.getElementById('overallScore').textContent = rounded.toFixed(1);

        var starsEl = document.getElementById('overallStars');
        starsEl.innerHTML = '';
        for (var i = 1; i <= 5; i++) {
            var icon = document.createElement('i');
            if (avg >= i)           icon.className = 'fa-solid fa-star';
            else if (avg >= i - 0.5) icon.className = 'fa-solid fa-star-half-stroke';
            else                     icon.className = 'fa-regular fa-star';
            starsEl.appendChild(icon);
        }
    }

    /* ── Per-dimension star widget ─────────────────────────────────────── */
    DIMS.forEach(function (name) {
        var group    = document.getElementById('stars-' + name);
        var hidden   = document.getElementById('val-'   + name);
        var labelEl  = document.getElementById('label-' + name);
        if (!group || !hidden) return;

        var stars    = group.querySelectorAll('.star');
        var selected = parseInt(hidden.value, 10) || 5;

        /* Render filled/empty icons for a given value */
        function renderStars(val) {
            stars.forEach(function (star) {
                var v = parseInt(star.getAttribute('data-val'), 10);
                var icon = star.querySelector('i');
                if (v <= val) {
                    star.classList.add('active');
                    icon.style.color = '#ffc107';
                } else {
                    star.classList.remove('active');
                    icon.style.color = '#dee2e6';
                }
            });
            if (labelEl) labelEl.textContent = LABELS[val] || '';
        }

        /* Hover preview */
        stars.forEach(function (star) {
            star.addEventListener('mouseenter', function () {
                var hoverVal = parseInt(this.getAttribute('data-val'), 10);
                stars.forEach(function (s) {
                    var sv = parseInt(s.getAttribute('data-val'), 10);
                    s.querySelector('i').style.color = sv <= hoverVal ? '#ffc107' : '#dee2e6';
                });
            });
            star.addEventListener('mouseleave', function () {
                renderStars(selected);
            });
        });

        /* Click → lock selection */
        stars.forEach(function (star) {
            star.addEventListener('click', function () {
                selected       = parseInt(this.getAttribute('data-val'), 10);
                hidden.value   = selected;
                renderStars(selected);
                updateOverall();
            });
        });

        /* Init */
        renderStars(selected);
    });

    /* ── Overall init ──────────────────────────────────────────────────── */
    updateOverall();

    /* ── Character counter ─────────────────────────────────────────────── */
    var commentInput = document.getElementById('commentInput');
    var charCountEl  = document.getElementById('charCount');
    function updateCharCount() {
        charCountEl.textContent = commentInput.value.length + ' / 2000';
    }
    commentInput.addEventListener('input', updateCharCount);
    updateCharCount();

    /* ── Client-side submit validation ────────────────────────────────── */
    document.getElementById('reviewForm').addEventListener('submit', function (e) {
        var errEl = document.getElementById('commentError');
        if (commentInput.value.trim().length < 10) {
            e.preventDefault();
            errEl.style.display = 'block';
            commentInput.focus();
        } else {
            errEl.style.display = 'none';
        }
    });
}());
</script>

<jsp:include page="../common/footer.jsp"/>
