<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<!-- ── Hero + Search ─────────────────────────────────────────── -->
<div class="hero-wrapper">
    <div class="hero-banner">
        <h1>Tìm kiếm Homestay &amp; Khách sạn Ưu đãi Nhất</h1>
        <p class="lead">Trải nghiệm đặt phòng thông minh với công nghệ AI gợi ý cá nhân hóa và thanh toán trực tuyến nhanh chóng.</p>
    </div>

    <div class="hero-search-section">
        <div class="hero-search-box">
            <form action="${pageContext.request.contextPath}/search" method="GET">
                <div class="row g-3 align-items-end">
                    <div class="col-md-3">
                        <label class="form-label"><i class="fa-solid fa-location-dot text-primary me-1"></i> Địa điểm</label>
                        <input type="text" name="location" class="form-control" placeholder="Đà Lạt, Nha Trang, Phú Quốc...">
                    </div>
                    <div class="col-md-2">
                        <label class="form-label"><i class="fa-solid fa-calendar-days text-primary me-1"></i> Nhận phòng</label>
                        <input type="date" name="checkin" id="homeCheckin" class="form-control">
                    </div>
                    <div class="col-md-2">
                        <label class="form-label"><i class="fa-regular fa-calendar-check text-primary me-1"></i> Trả phòng</label>
                        <input type="date" name="checkout" id="homeCheckout" class="form-control">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label"><i class="fa-solid fa-user-group text-primary me-1"></i> Số khách</label>
                        <select name="guests" class="form-select">
                            <option value="1">1 Khách</option>
                            <option value="2" selected>2 Khách</option>
                            <option value="4">4 Khách (Gia đình)</option>
                            <option value="6">Nhóm bạn (6+)</option>
                        </select>
                    </div>
                    <div class="col-md-2 d-grid">
                        <button type="submit" class="btn btn-primary-custom" id="btn-search">
                            <i class="fa-solid fa-magnifying-glass me-2"></i>Tìm kiếm
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- ── Featured Homestays ─────────────────────────────────────── -->
<div class="container section-content">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="h3 mb-1">Điểm đến Hot Nổi bật</h2>
            <p class="text-secondary mb-0">Các homestay được khách hàng đánh giá cao nhất trên hệ thống</p>
        </div>
        <a href="${pageContext.request.contextPath}/search" class="btn btn-outline-primary rounded-pill">
            Xem tất cả <i class="fa-solid fa-arrow-right ms-1"></i>
        </a>
    </div>

    <div class="row g-4">
        <c:choose>
            <c:when test="${not empty featuredList}">
                <c:forEach var="h" items="${featuredList}">
                    <div class="col-lg-4 col-md-6">
                        <div class="homestay-card border-0 shadow-sm rounded-4 h-100 position-relative overflow-hidden">
                            <div class="position-relative overflow-hidden" style="height: 220px;">
                                <c:choose>
                                    <c:when test="${not empty h.primaryImageUrl}">
                                        <img src="${h.primaryImageUrl}" class="w-100 h-100 object-fit-cover" alt="${h.name}" onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/images/default-homestay.svg';">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/assets/images/default-homestay.svg" class="w-100 h-100 object-fit-cover" alt="${h.name}" onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=800&q=80';">
                                    </c:otherwise>
                                </c:choose>
                                <span class="badge badge-tag position-absolute top-0 end-0 m-3 shadow-sm">
                                    <i class="fa-solid fa-star text-warning me-1"></i>${h.ratingAvg} (${h.reviewCount})
                                </span>
                            </div>
                            <div class="homestay-card-body p-4 d-flex flex-column justify-content-between">
                                <div>
                                    <span class="text-muted small text-uppercase fw-semibold"><i class="fa-solid fa-location-dot text-danger me-1"></i>${h.city}</span>
                                    <h3 class="h5 mt-1 mb-2 text-truncate" title="${h.name}">${h.name}</h3>
                                    <p class="text-secondary small mb-3 text-truncate">${h.description}</p>
                                </div>
                                <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                                    <div>
                                        <span class="text-muted small">Giá từ</span>
                                        <div class="price-tag">
                                            <fmt:formatNumber value="${h.minPrice}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                            <small class="text-muted fw-normal">/ đêm</small>
                                        </div>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/detail?id=${h.homestayId}" class="btn btn-outline-primary btn-sm rounded-pill px-3">Xem chi tiết</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <!-- Fallback Cards -->
                <div class="col-lg-4 col-md-6">
                    <div class="homestay-card">
                        <div class="position-relative overflow-hidden">
                            <img src="${pageContext.request.contextPath}/assets/images/default-homestay.svg" class="w-100 h-100 object-fit-cover" alt="Homestay Đà Lạt" onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=800&q=80';">
                            <span class="badge badge-tag position-absolute top-0 end-0 m-3">
                                <i class="fa-solid fa-star text-warning me-1"></i>4.9 (128)
                            </span>
                        </div>
                        <div class="homestay-card-body">
                            <span class="text-muted small text-uppercase fw-semibold">Đà Lạt, Lâm Đồng</span>
                            <h3 class="h5 mt-1 mb-2">Pine Hill Villa &amp; Wooden House</h3>
                            <p class="text-secondary small mb-3">View thung lũng thông reo, không gian yên tĩnh thích hợp nghỉ dưỡng và check-in.</p>
                            <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                                <div>
                                    <span class="text-muted small">Giá từ</span>
                                    <div class="price-tag">850.000đ <small class="text-muted fw-normal">/ đêm</small></div>
                                </div>
                                <a href="${pageContext.request.contextPath}/detail?id=1" class="btn btn-outline-primary btn-sm rounded-pill">Xem chi tiết</a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
