<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<style>
.detail-gallery { display:grid; grid-template-columns:2fr 1fr 1fr; grid-template-rows:auto auto; gap:8px; border-radius:16px; overflow:hidden; }
.detail-gallery img { width:100%; height:100%; object-fit:cover; }
.detail-gallery .main-img { grid-row:1/3; height:420px; }
.detail-gallery .side-img { height:206px; }
.amenity-badge { background:#f8f9ff; border:1px solid rgba(99,102,241,0.15); border-radius:10px; padding:0.5rem 0.9rem; display:flex; align-items:center; gap:0.5rem; font-size:0.85rem; }
.room-type-card { border:2px solid rgba(0,0,0,0.07); border-radius:16px; padding:1.25rem; cursor:pointer; transition:all 0.25s; }
.room-type-card:hover, .room-type-card.selected { border-color:#6366f1; background:rgba(99,102,241,0.04); }
.price-big { font-size:1.6rem; font-weight:800; color:#6366f1; }
.review-avatar { width:40px; height:40px; border-radius:50%; background:linear-gradient(135deg,#6366f1,#8b5cf6); color:#fff; display:flex; align-items:center; justify-content:center; font-weight:700; flex-shrink:0; }
.sticky-booking-box { position:sticky; top:85px; }
.addon-item { border:1px solid rgba(0,0,0,0.07); border-radius:12px; padding:0.75rem 1rem; display:flex; align-items:center; justify-content:space-between; margin-bottom:0.5rem; }
</style>

<div class="container py-4">
    <c:if test="${not empty homestay}">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-3">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/search">Tìm kiếm</a></li>
                <li class="breadcrumb-item active">${homestay.name}</li>
            </ol>
        </nav>

        <div class="row g-4">
            <!-- LEFT: Main Content -->
            <div class="col-lg-8">
                <!-- Gallery -->
                <c:choose>
                    <c:when test="${not empty homestay.images}">
                        <div class="detail-gallery mb-4">
                            <img class="main-img" src="${homestay.images[0].imageUrl}" alt="${homestay.name}" onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/images/default-homestay.svg';">
                            <c:if test="${homestay.images.size() > 1}"><img class="side-img" src="${homestay.images[1].imageUrl}" alt="" onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/images/default-homestay.svg';"></c:if>
                            <c:if test="${homestay.images.size() > 2}"><img class="side-img" src="${homestay.images[2].imageUrl}" alt="" onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/images/default-homestay.svg';"></c:if>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <img src="${pageContext.request.contextPath}/assets/images/default-homestay.svg" class="w-100 rounded-3 mb-4" style="height:400px;object-fit:cover;" alt="${homestay.name}" onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1200&q=80';">
                    </c:otherwise>
                </c:choose>

                <!-- Header Info -->
                <div class="d-flex justify-content-between align-items-start mb-3">
                    <div>
                        <h1 class="fw-bold fs-3 mb-1">${homestay.name}</h1>
                        <p class="text-muted mb-0"><i class="fa-solid fa-location-dot me-1 text-primary"></i>${homestay.address}, ${homestay.city}</p>
                    </div>
                    <div class="text-end">
                        <div class="fs-5 fw-bold text-warning"><i class="fa-solid fa-star"></i> ${homestay.ratingAvg}</div>
                        <div class="text-muted small">${homestay.reviewCount} đánh giá</div>
                        <c:if test="${not empty sessionScope.currentUser}">
                            <button class="btn btn-sm ${homestay.wishlisted ? 'btn-danger text-white' : 'btn-outline-danger'} mt-1 rounded-pill px-3 shadow-sm" id="wishlistBtn" onclick="toggleWishlist(${homestay.homestayId}, this)">
                                <i class="fa-${homestay.wishlisted ? 'solid' : 'regular'} fa-heart me-1"></i>
                                <span>${homestay.wishlisted ? 'Đã lưu' : 'Lưu yêu thích'}</span>
                            </button>
                        </c:if>
                    </div>
                </div>

                <!-- Amenities -->
                <c:if test="${not empty homestay.amenityNames}">
                    <div class="mb-4">
                        <h5 class="fw-bold mb-3">Tiện ích nổi bật</h5>
                        <div class="d-flex flex-wrap gap-2">
                            <c:forEach var="am" items="${homestay.amenityNames}">
                                <span class="amenity-badge"><i class="fa-solid fa-check-circle text-primary"></i> ${am}</span>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>

                <!-- Description -->
                <div class="mb-4">
                    <h5 class="fw-bold mb-2">Mô tả</h5>
                    <p class="text-muted lh-lg">${not empty homestay.description ? homestay.description : 'Không có mô tả.'}</p>
                </div>

                <!-- Sold out / Error Banner -->
                <c:if test="${param.error == 'sold_out' || totalAvailableRooms le 0}">
                    <div class="alert alert-danger d-flex align-items-center mb-4 rounded-4 shadow-sm" role="alert">
                        <i class="fa-solid fa-circle-exclamation fs-4 me-3 text-danger"></i>
                        <div>
                            <strong>Thông báo:</strong> Homestay này hiện không còn phòng trống khả dụng trong khoảng thời gian đã chọn. Quý khách vui lòng chọn ngày khác hoặc tham khảo homestay khác.
                        </div>
                    </div>
                </c:if>

                <!-- Room Types -->
                <c:if test="${not empty homestay.roomTypes}">
                    <div class="mb-4">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="fw-bold mb-0"><i class="fa-solid fa-door-open text-primary me-2"></i>Hạng phòng khả dụng</h5>
                            <span class="badge bg-light text-secondary border">${homestay.roomTypes.size()} loại phòng</span>
                        </div>
                        <c:forEach var="rt" items="${homestay.roomTypes}">
                            <%-- Kiểm tra còn phòng trống trong khoảng ngày đã chọn --%>
                            <c:set var="isUnavailable" value="false"/>
                            <c:set var="avail" value="0"/>
                            <c:if test="${not empty availMap}">
                                <c:set var="avail" value="${availMap[rt.roomTypeId]}"/>
                                <c:if test="${avail le 0}">
                                    <c:set var="isUnavailable" value="true"/>
                                </c:if>
                            </c:if>

                            <%-- Card: disable onclick + style khi hết phòng --%>
                            <c:choose>
                                <c:when test="${isUnavailable}">
                                    <div class="room-type-card mb-3 p-3 rounded-4 border bg-light shadow-sm"
                                         id="room-card-${rt.roomTypeId}"
                                         style="opacity:0.65; cursor:not-allowed;">
                                </c:when>
                                <c:otherwise>
                                    <div class="room-type-card mb-3 p-3 rounded-4 border bg-white shadow-sm"
                                         id="room-card-${rt.roomTypeId}"
                                         onclick="selectRoom(${rt.roomTypeId}, ${rt.basePrice}, '${rt.name}', this)">
                                </c:otherwise>
                            </c:choose>

                                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
                                    <div class="flex-grow-1" style="min-width: 0;">
                                        <div class="d-flex align-items-center flex-wrap gap-2 mb-1">
                                            <h6 class="fw-bold mb-0 text-dark">${rt.name}</h6>
                                            <%-- Badge: Hết phòng hoặc Còn X phòng --%>
                                            <c:choose>
                                                <c:when test="${isUnavailable}">
                                                    <span class="badge bg-danger-subtle text-danger border border-danger-subtle px-2 py-1 small" style="font-size:0.72rem;">
                                                        <i class="fa-solid fa-ban me-1"></i>Hết phòng
                                                    </span>
                                                </c:when>
                                                <c:when test="${avail > 0 and avail <= 3}">
                                                    <span class="badge bg-warning-subtle text-warning-emphasis border border-warning px-2 py-1 small" style="font-size:0.72rem;">
                                                        <i class="fa-solid fa-fire me-1"></i>Chỉ còn ${avail} phòng!
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-primary-subtle text-primary border border-primary px-2 py-1 small" style="font-size:0.72rem;">Còn ${avail} phòng</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="text-muted small mb-1.5 d-flex align-items-center flex-wrap gap-2">
                                            <span><i class="fa-solid fa-bed text-primary me-1"></i>${rt.bedCount} giường</span>
                                            <span class="text-muted opacity-50">•</span>
                                            <span><i class="fa-solid fa-user-group text-primary me-1"></i>Tối đa ${rt.maxOccupancy} khách</span>
                                            <c:if test="${rt.roomSizeSqm != null}">
                                                <span class="text-muted opacity-50">•</span>
                                                <span><i class="fa-solid fa-vector-square text-primary me-1"></i>${rt.roomSizeSqm} m²</span>
                                            </c:if>
                                        </div>
                                        <p class="text-secondary small mb-1.5 text-truncate" style="max-width: 520px;">${rt.description}</p>
                                        <div>
                                            <button type="button" class="btn btn-link text-primary p-0 small fw-semibold text-decoration-none text-nowrap" onclick="event.stopPropagation(); showRoomDetail(${rt.roomTypeId}, '${rt.name}', '${rt.description}', ${rt.basePrice}, ${rt.maxOccupancy}, ${rt.bedCount}, '${rt.roomSizeSqm != null ? rt.roomSizeSqm : 25}')">
                                                <i class="fa-solid fa-circle-info me-1"></i>Xem chi tiết phòng &amp; tiện nghi
                                            </button>
                                        </div>
                                    </div>
                                    <div class="text-md-end d-flex flex-column justify-content-center align-items-md-end flex-shrink-0" style="min-width: 175px;">
                                        <div class="d-flex align-items-baseline justify-content-md-end gap-1">
                                            <span class="price-big fw-bold fs-4 ${isUnavailable ? 'text-muted' : 'text-primary'}">
                                                <fmt:formatNumber value="${rt.basePrice}" type="number" groupingUsed="true"/>₫
                                            </span>
                                            <span class="text-muted small">/ đêm</span>
                                        </div>
                                        <%-- Nút Chọn phòng / Hết phòng --%>
                                        <c:choose>
                                            <c:when test="${isUnavailable}">
                                                <button type="button" class="btn btn-outline-secondary btn-sm rounded-pill mt-1.5 px-3 fw-semibold text-nowrap" disabled>
                                                    <i class="fa-solid fa-calendar-xmark me-1"></i>Hết phòng
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <button type="button" class="btn btn-outline-primary btn-sm rounded-pill mt-1.5 px-3 fw-semibold text-nowrap">
                                                    <i class="fa-solid fa-check me-1"></i>Chọn phòng
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>

                <!-- Addons -->
                <c:if test="${not empty addons}">
                    <div class="mb-4">
                        <h5 class="fw-bold mb-3"><i class="fa-solid fa-bell-concierge text-primary me-2"></i>Dịch vụ bổ sung</h5>
                        <c:forEach var="a" items="${addons}">
                            <div class="addon-item">
                                <div>
                                    <div class="fw-semibold">${a.name}</div>
                                    <div class="text-muted small">${a.description}</div>
                                </div>
                                <div class="text-end">
                                    <div class="text-primary fw-bold"><fmt:formatNumber value="${a.price}" type="number"/>₫</div>
                                    <div class="text-muted small">${a.unit}</div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>

                <!-- ═══════════════════════════════════════════════════════
                     ĐÁNH GIÁ KHÁCH HÀNG  (A+C combined)
                     ═══════════════════════════════════════════════════════ -->
                <c:if test="${not empty homestay.reviews}">
                <style>
                /* ══ Review Section: A+C Combined ══════════════════════════ */
                .rv-section { margin-top:2rem; padding-top:1.75rem; border-top:1px solid #e9ecef; }

                /* ── Header: big score + progress bars (Option C) ── */
                .rv-header        { display:flex; align-items:flex-start; gap:28px; margin-bottom:1.75rem; flex-wrap:wrap; }
                .rv-score-area    { display:flex; align-items:center; gap:10px; flex-shrink:0; }
                .rv-big-num       { font-size:3.5rem; font-weight:900; color:#1e293b; line-height:1; }
                .rv-big-star      { color:#f59e0b; font-size:1.4rem; line-height:1; }
                .rv-big-count     { font-size:.78rem; color:#94a3b8; margin-top:3px; }
                .rv-bars          { flex:1; min-width:200px; padding-top:4px; }
                .rv-bar-row       { display:flex; align-items:center; gap:10px; margin-bottom:8px; }
                .rv-bar-label     { font-size:.8rem; color:#475569; min-width:65px; }
                .rv-bar-track     { flex:1; height:6px; background:#e9ecef; border-radius:50px; overflow:hidden; }
                .rv-bar-fill      { height:100%; background:linear-gradient(90deg,#6366f1,#8b5cf6);
                                    border-radius:50px; transition:width .9s ease; width:0; }
                .rv-bar-val       { font-size:.78rem; color:#64748b; min-width:26px; text-align:right; font-weight:600; }

                /* ── Cards: masonry 2 col (Option A) ── */
                .rv-grid          { columns:2; column-gap:14px; margin-top:1.25rem; }
                @media(max-width:767px){ .rv-grid{ columns:1; } }

                .rv-card          { break-inside:avoid; background:#fafafa; border:1px solid #e9ecef;
                                    border-radius:16px; padding:1.1rem 1.2rem 1rem 1.4rem;
                                    margin-bottom:14px; position:relative;
                                    transition:box-shadow .2s, transform .2s; }
                .rv-card:hover    { box-shadow:0 4px 18px rgba(99,102,241,.10); transform:translateY(-2px); }
                /* dấu ngoặc kép trang trí */
                .rv-card::before  { content:'\201C'; position:absolute; top:8px; left:11px;
                                    font-size:2.4rem; color:#6366f1; opacity:.13;
                                    font-family:Georgia,serif; line-height:1; pointer-events:none; }
                .rv-card.rv-hidden{ display:none; }
                .rv-card.rv-new   { animation:rvPop .3s ease both; }
                @keyframes rvPop  { from{opacity:0;transform:scale(.97)} to{opacity:1;transform:scale(1)} }

                /* avatar gradient random per initial */
                .rv-av            { width:36px; height:36px; border-radius:50%; flex-shrink:0;
                                    background:linear-gradient(135deg,#6366f1,#a78bfa);
                                    color:#fff; font-weight:700; font-size:.85rem;
                                    display:flex; align-items:center; justify-content:center;
                                    border:2px solid #fff; box-shadow:0 0 0 2px #c7d2fe; }
                .rv-name          { font-weight:600; font-size:.88rem; color:#1e293b; }
                .rv-date          { font-size:.72rem; color:#94a3b8; }
                /* rating pill (Option A style) */
                .rv-pill          { background:#ede9fe; color:#7c3aed; font-size:.72rem; font-weight:700;
                                    border-radius:50px; padding:2px 9px; flex-shrink:0;
                                    display:inline-flex; align-items:center; gap:3px; }
                .rv-comment       { font-size:.84rem; color:#475569; line-height:1.6;
                                    margin:8px 0 0; padding-left:4px; }

                /* ── Nút Xem thêm (gradient Option A) ── */
                .rv-more-wrap     { text-align:center; margin-top:10px; display:none; }
                .rv-more-btn      { display:inline-flex; align-items:center; gap:8px;
                                    border:none; border-radius:12px;
                                    background:linear-gradient(135deg,#6366f1,#8b5cf6);
                                    color:#fff; padding:10px 28px; font-size:.875rem;
                                    font-weight:600; cursor:pointer;
                                    box-shadow:0 4px 14px rgba(99,102,241,.35);
                                    transition:box-shadow .2s, transform .2s; }
                .rv-more-btn:hover{ box-shadow:0 6px 20px rgba(99,102,241,.45); transform:translateY(-1px); }
                .rv-more-badge    { background:rgba(255,255,255,.25); border-radius:50px;
                                    padding:1px 9px; font-size:.72rem; font-weight:700; }
                </style>

                <div class="rv-section" id="reviewSection">

                    <%-- ── Header: score + bars ── --%>
                    <div class="rv-header">
                        <div class="rv-score-area">
                            <div class="rv-big-num">${homestay.ratingAvg}</div>
                            <div>
                                <div class="rv-big-star"><i class="fa-solid fa-star"></i></div>
                                <div class="rv-big-count">${homestay.reviewCount} đánh giá</div>
                            </div>
                        </div>
                        <div class="rv-bars">
                            <%-- Tính trung bình từng tiêu chí trực tiếp từ reviews list --%>
                            <c:set var="sumC" value="0"/>
                            <c:set var="sumS" value="0"/>
                            <c:set var="sumL" value="0"/>
                            <c:set var="sumV" value="0"/>
                            <c:set var="cnt"  value="0"/>
                            <c:forEach var="rv" items="${homestay.reviews}">
                                <c:set var="sumC" value="${sumC + rv.ratingCleanliness}"/>
                                <c:set var="sumS" value="${sumS + rv.ratingService}"/>
                                <c:set var="sumL" value="${sumL + rv.ratingLocation}"/>
                                <c:set var="sumV" value="${sumV + rv.ratingValue}"/>
                                <c:set var="cnt"  value="${cnt  + 1}"/>
                            </c:forEach>
                            <c:set var="avgC" value="${cnt > 0 ? sumC / cnt : homestay.ratingAvg}"/>
                            <c:set var="avgS" value="${cnt > 0 ? sumS / cnt : homestay.ratingAvg}"/>
                            <c:set var="avgL" value="${cnt > 0 ? sumL / cnt : homestay.ratingAvg}"/>
                            <c:set var="avgV" value="${cnt > 0 ? sumV / cnt : homestay.ratingAvg}"/>

                            <div class="rv-bar-row">
                                <span class="rv-bar-label">Sạch sẽ</span>
                                <div class="rv-bar-track"><div class="rv-bar-fill" data-val="<fmt:formatNumber value="${avgC}" maxFractionDigits="1"/>"></div></div>
                                <span class="rv-bar-val"><fmt:formatNumber value="${avgC}" maxFractionDigits="1"/></span>
                            </div>
                            <div class="rv-bar-row">
                                <span class="rv-bar-label">Dịch vụ</span>
                                <div class="rv-bar-track"><div class="rv-bar-fill" data-val="<fmt:formatNumber value="${avgS}" maxFractionDigits="1"/>"></div></div>
                                <span class="rv-bar-val"><fmt:formatNumber value="${avgS}" maxFractionDigits="1"/></span>
                            </div>
                            <div class="rv-bar-row">
                                <span class="rv-bar-label">Vị trí</span>
                                <div class="rv-bar-track"><div class="rv-bar-fill" data-val="<fmt:formatNumber value="${avgL}" maxFractionDigits="1"/>"></div></div>
                                <span class="rv-bar-val"><fmt:formatNumber value="${avgL}" maxFractionDigits="1"/></span>
                            </div>
                            <div class="rv-bar-row">
                                <span class="rv-bar-label">Giá trị</span>
                                <div class="rv-bar-track"><div class="rv-bar-fill" data-val="<fmt:formatNumber value="${avgV}" maxFractionDigits="1"/>"></div></div>
                                <span class="rv-bar-val"><fmt:formatNumber value="${avgV}" maxFractionDigits="1"/></span>
                            </div>
                        </div>
                    </div>

                    <%-- ── Danh sách review cards (masonry 2 cột) ── --%>
                    <div class="rv-grid" id="rvList">
                        <c:forEach var="rv" items="${homestay.reviews}">
                            <div class="rv-card">
                                <%-- avatar + tên + ngày + rating pill --%>
                                <div style="display:flex;align-items:center;gap:9px;margin-bottom:6px;">
                                    <div class="rv-av">${not empty rv.customerName ? rv.customerName.substring(0,1).toUpperCase() : 'K'}</div>
                                    <div style="flex:1;min-width:0;">
                                        <div class="rv-name">${rv.customerName}</div>
                                        <div class="rv-date"><fmt:formatDate value="${rv.createdAt}" pattern="dd/MM/yyyy"/></div>
                                    </div>
                                    <span class="rv-pill">
                                        <i class="fa-solid fa-star" style="font-size:.6rem;"></i>${rv.ratingOverall}
                                    </span>
                                </div>
                                <%-- comment --%>
                                <p class="rv-comment">${rv.comment}</p>
                            </div>
                        </c:forEach>
                    </div>

                    <%-- ── Nút Xem thêm / Thu gọn ── --%>
                    <div class="rv-more-wrap" id="rvMoreWrap">
                        <button type="button" class="rv-more-btn" id="rvMoreBtn">
                            <i class="fa-solid fa-chevron-down" id="rvMoreIcon"></i>
                            <span id="rvMoreLabel">Xem thêm đánh giá</span>
                            <span class="rv-more-badge" id="rvMoreBadge"></span>
                        </button>
                    </div>

                </div><%-- /rv-section --%>

                <script>
                (function () {
                    /* ── Animate progress bars khi section scroll vào view ── */
                    var fills = document.querySelectorAll('#reviewSection .rv-bar-fill');
                    fills.forEach(function (el) {
                        var val = parseFloat(el.getAttribute('data-val')) || 0;
                        el.style.width = (val / 5 * 100).toFixed(1) + '%';
                    });

                    /* ── Show-more logic ── */
                    var INIT  = 4; /* 2 hàng × 2 cột */
                    var list  = document.getElementById('rvList');
                    var wrap  = document.getElementById('rvMoreWrap');
                    var btn   = document.getElementById('rvMoreBtn');
                    var icon  = document.getElementById('rvMoreIcon');
                    var lbl   = document.getElementById('rvMoreLabel');
                    var badge = document.getElementById('rvMoreBadge');

                    /* children trực tiếp = các rv-card, không bị nhiễu bởi card khác trên trang */
                    var cards = Array.prototype.slice.call(list.children);
                    var total = cards.length;
                    var open  = false;

                    if (total <= INIT) return; /* ≤ 4 review: hiện hết, ẩn nút */

                    /* Ẩn cards thừa bằng display:none qua class — không đụng Bootstrap */
                    for (var i = INIT; i < total; i++) {
                        cards[i].classList.add('rv-hidden');
                    }
                    badge.textContent = total - INIT;
                    wrap.style.display = 'block';

                    btn.addEventListener('click', function () {
                        open = !open;
                        if (open) {
                            for (var i = INIT; i < total; i++) {
                                cards[i].classList.remove('rv-hidden');
                                cards[i].classList.remove('rv-new');
                                void cards[i].offsetWidth; /* reflow để restart animation */
                                cards[i].classList.add('rv-new');
                            }
                            icon.className    = 'fa-solid fa-chevron-up';
                            lbl.textContent   = 'Thu gọn';
                            badge.style.display = 'none';
                        } else {
                            for (var i = INIT; i < total; i++) {
                                cards[i].classList.remove('rv-new');
                                cards[i].classList.add('rv-hidden');
                            }
                            icon.className    = 'fa-solid fa-chevron-down';
                            lbl.textContent   = 'Xem thêm đánh giá';
                            badge.textContent = total - INIT;
                            badge.style.display = '';
                            document.getElementById('reviewSection')
                                    .scrollIntoView({ behavior:'smooth', block:'start' });
                        }
                    });
                }());
                </script>
                </c:if>
            </div>

            <!-- RIGHT: Booking Box -->
            <div class="col-lg-4">
                <div class="sticky-booking-box">
                    <div class="card border-0 shadow rounded-4 p-4">
                        <h5 class="fw-bold mb-1" id="selectedRoomName">Chọn hạng phòng</h5>
                        <div class="price-big mb-3" id="selectedRoomPrice">
                            <c:if test="${not empty homestay.minPrice}"><fmt:formatNumber value="${homestay.minPrice}" type="number"/>₫</c:if>
                            <span class="text-muted fs-6 fw-normal"> / đêm</span>
                        </div>
                        <form action="${pageContext.request.contextPath}/booking/checkout" method="GET" id="bookingForm">
                            <input type="hidden" name="homestayId" value="${homestay.homestayId}">
                            <input type="hidden" name="roomTypeId" id="selectedRoomTypeId" value="">
                            <div class="mb-3">
                                <label class="form-label fw-semibold small"><i class="fa-regular fa-calendar text-primary me-1"></i>Ngày nhận phòng</label>
                                <input type="date" name="checkin" class="form-control rounded-3" value="${checkin}" required id="checkinInput">
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-semibold small"><i class="fa-regular fa-calendar-check text-primary me-1"></i>Ngày trả phòng</label>
                                <input type="date" name="checkout" class="form-control rounded-3" value="${checkout}" required id="checkoutInput">
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-semibold small"><i class="fa-solid fa-user-group text-primary me-1"></i>Số khách</label>
                                <select name="guests" class="form-select rounded-3">
                                    <c:forEach var="i" begin="1" end="10">
                                        <option value="${i}">${i} Khách</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <c:choose>
                                <c:when test="${not empty sessionScope.currentUser}">
                                    <button type="submit" class="btn btn-primary-custom w-100 fw-bold py-2 shadow-sm" id="bookBtn">
                                        <i class="fa-solid fa-calendar-check me-2"></i>Đặt phòng ngay
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/login?redirect=${pageContext.request.contextPath}/homestay/detail?id=${homestay.homestayId}" class="btn btn-outline-primary w-100 fw-bold py-2">
                                        <i class="fa-solid fa-right-to-bracket me-2"></i>Đăng nhập để đặt phòng
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </form>
                        <div class="text-center mt-3 text-muted small">
                            <i class="fa-solid fa-shield-halved text-success me-1"></i>Thanh toán an toàn qua VNPay &amp; MoMo
                        </div>
                        <hr>
                        <div class="text-muted small">
                            <div class="d-flex justify-content-between mb-1">
                                <span>Check-in:</span><strong>${not empty homestay.checkinTime ? homestay.checkinTime : '14:00'}</strong>
                            </div>
                            <div class="d-flex justify-content-between">
                                <span>Check-out:</span><strong>${not empty homestay.checkoutTime ? homestay.checkoutTime : '12:00'}</strong>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </c:if>
</div>

<!-- Modal Xem Chi Tiết Phòng (Room Detail Modal) -->
<div class="modal fade" id="roomDetailModal" tabindex="-1" aria-labelledby="roomDetailModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content rounded-4 border-0 shadow-lg overflow-hidden">
            <div class="modal-header bg-primary text-white p-4">
                <div>
                    <h5 class="modal-title fw-bold text-white mb-1" id="modalRoomName">Chi tiết hạng phòng</h5>
                    <span class="text-white-50 small"><i class="fa-solid fa-hotel me-1"></i> ${homestay.name}</span>
                </div>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                <div class="position-relative rounded-4 overflow-hidden mb-4" style="height: 260px; background: #e0e7ff;">
                    <img id="modalRoomImg" src="${pageContext.request.contextPath}/assets/images/default-homestay.svg" class="w-100 h-100 object-fit-cover" alt="Hình ảnh phòng" onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/images/default-homestay.svg';">
                    <span class="position-absolute bottom-0 start-0 m-3 badge bg-dark bg-opacity-75 text-white px-3 py-2 rounded-pill">
                        <i class="fa-solid fa-camera me-1"></i> Không gian phòng tiêu chuẩn
                    </span>
                </div>

                <!-- Specs Grid -->
                <div class="row g-3 mb-4 text-center">
                    <div class="col-4">
                        <div class="p-3 bg-light rounded-3 border">
                            <i class="fa-solid fa-bed fs-4 text-primary mb-1 d-block"></i>
                            <strong id="modalBedCount">1 Giường</strong>
                            <div class="text-muted small">Loại giường</div>
                        </div>
                    </div>
                    <div class="col-4">
                        <div class="p-3 bg-light rounded-3 border">
                            <i class="fa-solid fa-user-group fs-4 text-primary mb-1 d-block"></i>
                            <strong id="modalOccupancy">2 Khách</strong>
                            <div class="text-muted small">Sức chứa tối đa</div>
                        </div>
                    </div>
                    <div class="col-4">
                        <div class="p-3 bg-light rounded-3 border">
                            <i class="fa-solid fa-vector-square fs-4 text-primary mb-1 d-block"></i>
                            <strong id="modalRoomSize">25 m²</strong>
                            <div class="text-muted small">Diện tích phòng</div>
                        </div>
                    </div>
                </div>

                <!-- Description -->
                <div class="mb-4">
                    <h6 class="fw-bold mb-2 text-dark"><i class="fa-solid fa-align-left text-primary me-2"></i>Mô tả phòng</h6>
                    <p class="text-muted" id="modalRoomDesc">Không gian thoáng mát, nội thất sang trọng, trang bị đầy đủ tiện nghi chuẩn cao cấp.</p>
                </div>

                <!-- Amenities list -->
                <div class="mb-4">
                    <h6 class="fw-bold mb-3 text-dark"><i class="fa-solid fa-sparkles text-warning me-2"></i>Tiện nghi phòng chi tiết</h6>
                    <div class="row g-2 text-secondary small">
                        <div class="col-6 col-md-4"><i class="fa-solid fa-snowflake text-primary me-2"></i>Điều hòa 2 chiều</div>
                        <div class="col-6 col-md-4"><i class="fa-solid fa-wifi text-primary me-2"></i>Wifi tốc độ cao</div>
                        <div class="col-6 col-md-4"><i class="fa-solid fa-tv text-primary me-2"></i>Smart TV 4K</div>
                        <div class="col-6 col-md-4"><i class="fa-solid fa-bath text-primary me-2"></i>Phòng tắm riêng</div>
                        <div class="col-6 col-md-4"><i class="fa-solid fa-wind text-primary me-2"></i>Máy sấy tóc</div>
                        <div class="col-6 col-md-4"><i class="fa-solid fa-mug-hot text-primary me-2"></i>Ấm đun siêu tốc</div>
                        <div class="col-6 col-md-4"><i class="fa-solid fa-bottle-water text-primary me-2"></i>Nước khoáng miễn phí</div>
                        <div class="col-6 col-md-4"><i class="fa-solid fa-vault text-primary me-2"></i>Két an toàn</div>
                        <div class="col-6 col-md-4"><i class="fa-solid fa-mountain-sun text-primary me-2"></i>Cửa sổ view thoáng</div>
                    </div>
                </div>

                <!-- Policies -->
                <div class="p-3 bg-light rounded-3 border">
                    <h6 class="fw-bold mb-2 text-dark"><i class="fa-solid fa-shield-halved text-success me-2"></i>Quy định &amp; Chính sách phòng</h6>
                    <ul class="mb-0 small text-muted ps-3">
                        <li>Nhận phòng từ <strong>${not empty homestay.checkinTime ? homestay.checkinTime : '14:00'}</strong> - Trả phòng trước <strong>${not empty homestay.checkoutTime ? homestay.checkoutTime : '12:00'}</strong>.</li>
                        <li>Miễn phí hủy phòng trước 24 giờ kể từ thời điểm nhận phòng.</li>
                        <li>Nghiêm cấm hút thuốc và tổ chức tiệc gây tiếng ồn trong phòng nghỉ.</li>
                    </ul>
                </div>
            </div>
            <div class="modal-footer bg-light p-3 d-flex justify-content-between align-items-center">
                <div>
                    <span class="text-muted small d-block">Giá phòng mỗi đêm</span>
                    <span class="fs-4 fw-bold text-primary" id="modalRoomPrice">0₫</span>
                </div>
                <div>
                    <button type="button" class="btn btn-secondary rounded-pill px-3" data-bs-dismiss="modal">Đóng</button>
                    <button type="button" class="btn btn-primary rounded-pill px-4 fw-semibold" id="modalSelectBtn" onclick="selectFromModal()">
                        <i class="fa-solid fa-calendar-check me-1"></i> Chọn phòng này
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
/* ── Room data map: roomTypeId → {price, name} for availability restore ── */
var ROOM_DATA = {
<c:forEach var="rt" items="${homestay.roomTypes}" varStatus="s">
    "${rt.roomTypeId}": { price: ${rt.basePrice}, name: "${rt.name}" }<c:if test="${!s.last}">,</c:if>
</c:forEach>
};

let currentModalRoom = {};

function showRoomDetail(roomTypeId, name, description, price, occupancy, bedCount, roomSize) {
    currentModalRoom = { roomTypeId, name, description, price, occupancy, bedCount, roomSize };
    document.getElementById('modalRoomName').textContent = name;
    document.getElementById('modalRoomDesc').textContent = description && description.trim() !== '' ? description : 'Không gian nghỉ ngơi yên tĩnh, trang trí sang trọng và đầy đủ tiện nghi chuẩn cao cấp.';
    document.getElementById('modalBedCount').textContent = bedCount + ' Giường';
    document.getElementById('modalOccupancy').textContent = occupancy + ' Khách tối đa';
    document.getElementById('modalRoomSize').textContent = roomSize + ' m²';
    document.getElementById('modalRoomPrice').textContent = new Intl.NumberFormat('vi-VN').format(price) + '₫ / đêm';
    
    const modalEl = document.getElementById('roomDetailModal');
    const modal = new bootstrap.Modal(modalEl);
    modal.show();
}

function selectFromModal() {
    if (currentModalRoom.roomTypeId) {
        selectRoom(currentModalRoom.roomTypeId, currentModalRoom.price, currentModalRoom.name, document.getElementById('room-card-' + currentModalRoom.roomTypeId));
        const modalEl = document.getElementById('roomDetailModal');
        const modalInstance = bootstrap.Modal.getInstance(modalEl);
        if (modalInstance) modalInstance.hide();
        // Scroll to booking sidebar
        const box = document.querySelector('.sticky-booking-box');
        if (box) box.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }
}

function selectRoom(roomTypeId, price, name, cardElem) {
    document.getElementById('selectedRoomTypeId').value = roomTypeId;
    document.getElementById('selectedRoomName').textContent = name;
    document.getElementById('selectedRoomPrice').innerHTML = new Intl.NumberFormat('vi-VN').format(price) + '₫ <span class="text-muted fs-6 fw-normal"> / đêm</span>';
    
    document.querySelectorAll('.room-type-card').forEach(c => {
        c.classList.remove('border-primary', 'bg-primary-subtle');
        c.style.borderWidth = '1px';
    });
    if (cardElem) {
        cardElem.classList.add('border-primary', 'bg-primary-subtle');
        cardElem.style.borderWidth = '2px';
    }
    const bookBtn = document.getElementById('bookBtn');
    if (bookBtn) {
        bookBtn.disabled = false;
    }
}

function toggleWishlist(homestayId, btn) {
    btn.disabled = true;
    fetch('${pageContext.request.contextPath}/customer/wishlist/toggle', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'homestayId=' + encodeURIComponent(homestayId)
    })
    .then(r => r.json())
    .then(data => {
        btn.disabled = false;
        const isSaved = (data.status === 'success' && (data.is_saved === true || data.wishlisted === true || data.saved === true));
        if (isSaved) {
            btn.className = 'btn btn-sm btn-danger text-white mt-1 rounded-pill px-3 shadow-sm';
            btn.innerHTML = '<i class="fa-solid fa-heart me-1"></i><span>Đã lưu</span>';
        } else {
            btn.className = 'btn btn-sm btn-outline-danger mt-1 rounded-pill px-3';
            btn.innerHTML = '<i class="fa-regular fa-heart me-1"></i><span>Lưu yêu thích</span>';
        }
    })
    .catch(err => {
        btn.disabled = false;
        console.error('Error toggling wishlist:', err);
    });
}

// ── Availability re-check when dates change ────────────────────────────

/**
 * Gọi AJAX endpoint để lấy availMap mới khi ngày check-in/out thay đổi,
 * sau đó cập nhật trạng thái từng card loại phòng.
 */
function checkAvailability() {
    var ci = document.getElementById('checkinInput').value;
    var co = document.getElementById('checkoutInput').value;
    if (!ci) return;

    fetch('${pageContext.request.contextPath}/homestay/detail?id=${homestay.homestayId}'
        + '&checkin='  + encodeURIComponent(ci)
        + '&checkout=' + encodeURIComponent(co || '')
        + '&format=availability')
    .then(function(r) { return r.json(); })
    .then(function(data) { if (data && data.availMap) updateRoomAvailability(data.availMap); })
    .catch(function(e) { console.warn('[Availability] fetch failed:', e); });
}

/**
 * Cập nhật DOM của từng room-type-card dựa trên availMap nhận được.
 * - availCount <= 0 → disable card, badge "Hết phòng", button disabled
 * - availCount  > 0 → restore onclick, badge "Phổ biến", button enabled
 */
function updateRoomAvailability(availMap) {
    var selectedRtId = parseInt(document.getElementById('selectedRoomTypeId').value || '0');
    var currentRoomDeselected = false;

    Object.keys(availMap).forEach(function(rtId) {
        var card = document.getElementById('room-card-' + rtId);
        if (!card) return;

        var isUnavail = (availMap[rtId] <= 0);
        var rd = ROOM_DATA[rtId];

        if (isUnavail) {
            /* ── Hết phòng: disable ───────── */
            card.removeAttribute('onclick');
            card.style.opacity     = '0.65';
            card.style.cursor      = 'not-allowed';
            card.style.background  = '#f8f9fa';

            var badge = card.querySelector('.badge');
            if (badge) {
                badge.className = 'badge bg-danger-subtle text-danger border border-danger-subtle px-2 py-0 small';
                badge.innerHTML = '<i class="fa-solid fa-ban me-1"></i>Hết phòng';
            }
            var btn = card.querySelector('button:not(.btn-link)');
            if (btn) {
                btn.className = 'btn btn-outline-secondary btn-sm rounded-pill mt-2 px-3 fw-semibold';
                btn.disabled  = true;
                btn.innerHTML = '<i class="fa-solid fa-calendar-xmark me-1"></i>Hết phòng trong ngày này';
            }

            /* Bỏ chọn nếu đang select phòng này */
            if (parseInt(rtId) === selectedRtId) {
                card.classList.remove('border-primary', 'bg-primary-subtle');
                card.style.borderWidth = '1px';
                currentRoomDeselected  = true;
            }
        } else {
            /* ── Còn phòng: restore ──────── */
            if (rd) {
                card.setAttribute('onclick',
                    'selectRoom(' + rtId + ',' + rd.price + ',"' + rd.name.replace(/"/g, '\\"') + '",this)');
            }
            card.style.opacity    = '';
            card.style.cursor     = '';
            card.style.background = '';

            var badge = card.querySelector('.badge');
            if (badge) {
                badge.className = 'badge bg-primary-subtle text-primary border border-primary px-2 py-0 small';
                badge.innerHTML = 'Phổ biến';
            }
            var btn = card.querySelector('button:not(.btn-link)');
            if (btn) {
                btn.className = 'btn btn-outline-primary btn-sm rounded-pill mt-2 px-3 fw-semibold';
                btn.disabled  = false;
                btn.innerHTML = '<i class="fa-solid fa-check me-1"></i>Chọn phòng';
            }
        }
    });

    /* Nếu phòng đang chọn bị hết → reset booking widget */
    if (currentRoomDeselected) {
        document.getElementById('selectedRoomTypeId').value = '';
        document.getElementById('selectedRoomName').textContent   = 'Chọn hạng phòng';
        document.getElementById('selectedRoomPrice').innerHTML    = '<span class="text-muted fs-6 fw-normal">/ đêm</span>';
        var bookBtn = document.getElementById('bookBtn');
        if (bookBtn) bookBtn.disabled = true;
    }
}

// ── Khởi tạo ngày tháng không cho chọn quá khứ & tự động chọn hạng phòng đầu tiên
document.addEventListener('DOMContentLoaded', function() {
    const today = new Date();
    const todayStr = today.toISOString().split('T')[0];
    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);
    const tomorrowStr = tomorrow.toISOString().split('T')[0];

    // Lấy giờ check-in từ homestay (hiển thị trên trang, ví dụ "14:00:00" → 14)
    // Nếu đã qua giờ check-in hôm nay → min = ngày mai
    var checkinHourStr = '${not empty homestay.checkinTime ? homestay.checkinTime : "14:00:00"}';
    var checkinHour = parseInt(checkinHourStr.split(':')[0], 10) || 14;
    var minCheckinStr = (today.getHours() >= checkinHour) ? tomorrowStr : todayStr;

    const checkinInput = document.getElementById('checkinInput');
    const checkoutInput = document.getElementById('checkoutInput');

    if (checkinInput) {
        checkinInput.min = minCheckinStr;
        if (!checkinInput.value || checkinInput.value < minCheckinStr) {
            checkinInput.value = minCheckinStr;
        }
    }

    if (checkoutInput) {
        const currentCheckin = (checkinInput && checkinInput.value && checkinInput.value >= minCheckinStr) ? checkinInput.value : minCheckinStr;
        const d = new Date(currentCheckin);
        d.setDate(d.getDate() + 1);
        const minCheckoutStr = d.toISOString().split('T')[0];
        checkoutInput.min = minCheckoutStr;
        if (!checkoutInput.value || checkoutInput.value <= currentCheckin) {
            checkoutInput.value = minCheckoutStr;
        }

        if (checkinInput) {
            checkinInput.addEventListener('change', function() {
                const val = this.value || todayStr;
                const nextD = new Date(val);
                nextD.setDate(nextD.getDate() + 1);
                const nextStr = nextD.toISOString().split('T')[0];
                checkoutInput.min = nextStr;
                if (!checkoutInput.value || checkoutInput.value <= val) {
                    checkoutInput.value = nextStr;
                }
                checkAvailability(); // ← re-check khi đổi ngày nhận phòng
            });
        }
    }

    // Lắng nghe đổi ngày trả phòng để re-check availability
    if (checkoutInput) {
        checkoutInput.addEventListener('change', function() {
            checkAvailability(); // ← re-check khi đổi ngày trả phòng
        });
    }

    // Tự động chọn hạng phòng khả dụng đầu tiên nếu có
    const firstAvailableRoomCard = document.querySelector('.room-type-card:not([style*="not-allowed"])');
    if (firstAvailableRoomCard) {
        firstAvailableRoomCard.click();
    } else {
        const bookBtn = document.getElementById('bookBtn');
        if (bookBtn) {
            bookBtn.disabled = true;
        }
    }
});
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
