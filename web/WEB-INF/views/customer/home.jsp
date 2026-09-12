<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

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
                    <div class="col-md-4">
                        <label class="form-label"><i class="fa-solid fa-location-dot text-primary me-1"></i> Địa điểm</label>
                        <input type="text" name="location" class="form-control" placeholder="Đà Lạt, Nha Trang, Phú Quốc...">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label"><i class="fa-solid fa-calendar-days text-primary me-1"></i> Ngày nhận / trả phòng</label>
                        <input type="date" name="checkin" class="form-control">
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
        <!-- Card 1 -->
        <div class="col-lg-4 col-md-6">
            <div class="homestay-card">
                <div class="position-relative overflow-hidden">
                    <img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=800&q=80" alt="Homestay Đà Lạt">
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

        <!-- Card 2 -->
        <div class="col-lg-4 col-md-6">
            <div class="homestay-card">
                <div class="position-relative overflow-hidden">
                    <img src="https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=800&q=80" alt="Homestay Phú Quốc">
                    <span class="badge badge-tag position-absolute top-0 end-0 m-3">
                        <i class="fa-solid fa-star text-warning me-1"></i>4.95 (210)
                    </span>
                </div>
                <div class="homestay-card-body">
                    <span class="text-muted small text-uppercase fw-semibold">Phú Quốc, Kiên Giang</span>
                    <h3 class="h5 mt-1 mb-2">Ocean Breeze Beachfront Resort</h3>
                    <p class="text-secondary small mb-3">Ngay sát bãi biển Bãi Trường, có hồ bơi vô cực ngắm hoàng hôn ngắm biển đẹp ngất ngây.</p>
                    <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                        <div>
                            <span class="text-muted small">Giá từ</span>
                            <div class="price-tag">1.450.000đ <small class="text-muted fw-normal">/ đêm</small></div>
                        </div>
                        <a href="${pageContext.request.contextPath}/detail?id=2" class="btn btn-outline-primary btn-sm rounded-pill">Xem chi tiết</a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Card 3 -->
        <div class="col-lg-4 col-md-6">
            <div class="homestay-card">
                <div class="position-relative overflow-hidden">
                    <img src="https://images.unsplash.com/photo-1540555700478-4be289fbecef?auto=format&fit=crop&w=800&q=80" alt="Homestay Hội An">
                    <span class="badge badge-tag position-absolute top-0 end-0 m-3">
                        <i class="fa-solid fa-star text-warning me-1"></i>4.85 (95)
                    </span>
                </div>
                <div class="homestay-card-body">
                    <span class="text-muted small text-uppercase fw-semibold">Hội An, Quảng Nam</span>
                    <h3 class="h5 mt-1 mb-2">Ancient Town Heritage Homestay</h3>
                    <p class="text-secondary small mb-3">Kiến trúc hoài cổ độc đáo, cách Phố cổ Hội An 5 phút đi xe đạp, bao gồm ăn sáng miễn phí.</p>
                    <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                        <div>
                            <span class="text-muted small">Giá từ</span>
                            <div class="price-tag">690.000đ <small class="text-muted fw-normal">/ đêm</small></div>
                        </div>
                        <a href="${pageContext.request.contextPath}/detail?id=3" class="btn btn-outline-primary btn-sm rounded-pill">Xem chi tiết</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
