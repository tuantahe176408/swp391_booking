<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="container py-5">
    <div class="card border-0 bg-gradient text-white rounded-4 p-4 p-md-5 mb-5 shadow-lg" style="background: linear-gradient(135deg, #4f46e5 0%, #06b6d4 100%);">
        <div class="row align-items-center">
            <div class="col-lg-8">
                <span class="badge bg-white text-primary fw-bold mb-2"><i class="fa-solid fa-wand-magic-sparkles me-1"></i> UC05: AI Collaborative Filtering</span>
                <h2 class="fw-bold text-white mb-2">Gợi Ý Thông Minh Cho ${sessionScope.currentUser.fullName}</h2>
                <p class="mb-0 text-white-50">Mô hình AI tự động phân tích lịch sử tìm kiếm, sở thích cá nhân và đánh giá từ cộng đồng để đề xuất các Homestay có độ tương thích cao nhất.</p>
            </div>
            <div class="col-lg-4 text-lg-end mt-3 mt-lg-0">
                <div class="bg-white bg-opacity-20 backdrop-blur rounded-4 p-3 d-inline-block text-center border border-white border-opacity-25">
                    <span class="fs-1 fw-bold text-white d-block">98.5%</span>
                    <small class="text-white-50">AI Match Accuracy</small>
                </div>
            </div>
        </div>
    </div>

    <!-- Recommendation Cards Grid -->
    <h4 class="fw-bold mb-4 text-dark"><i class="fa-solid fa-fire text-danger me-2"></i>Dành riêng cho bạn hôm nay</h4>
    <div class="row g-4">
        <div class="col-md-4">
            <div class="card homestay-card border-0 shadow-sm rounded-4 h-100 position-relative">
                <span class="position-absolute top-0 end-0 m-3 badge bg-danger rounded-pill px-3 py-2 shadow-sm">
                    <i class="fa-solid fa-bolt me-1"></i> Match 96%
                </span>
                <img src="https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=600&q=80" class="card-img-top" alt="Homestay">
                <div class="card-body p-4 d-flex flex-column justify-content-between">
                    <div>
                        <span class="badge-tag mb-2 d-inline-block"><i class="fa-solid fa-tag me-1"></i> Phù hợp sở thích View biển</span>
                        <h5 class="fw-bold text-dark">Ocean Breeze Villa & Beachfront</h5>
                        <p class="text-muted small"><i class="fa-solid fa-location-dot text-danger me-1"></i> Mỹ Khê, Đà Nẵng</p>
                    </div>
                    <div class="d-flex align-items-center justify-content-between pt-3 border-top mt-3">
                        <div>
                            <small class="text-muted d-block">Chỉ từ</small>
                            <span class="price-tag">1.250.000₫ <small class="text-muted fw-normal">/ đêm</small></span>
                        </div>
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-primary btn-sm rounded-3 fw-semibold">Xem chi tiết</a>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card homestay-card border-0 shadow-sm rounded-4 h-100 position-relative">
                <span class="position-absolute top-0 end-0 m-3 badge bg-danger rounded-pill px-3 py-2 shadow-sm">
                    <i class="fa-solid fa-bolt me-1"></i> Match 92%
                </span>
                <img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=600&q=80" class="card-img-top" alt="Homestay">
                <div class="card-body p-4 d-flex flex-column justify-content-between">
                    <div>
                        <span class="badge-tag mb-2 d-inline-block"><i class="fa-solid fa-tag me-1"></i> Thích hợp nghỉ dưỡng yên tĩnh</span>
                        <h5 class="fw-bold text-dark">Dalat Pine Forest Glasshouse</h5>
                        <p class="text-muted small"><i class="fa-solid fa-location-dot text-danger me-1"></i> Phường 11, Đà Lạt</p>
                    </div>
                    <div class="d-flex align-items-center justify-content-between pt-3 border-top mt-3">
                        <div>
                            <small class="text-muted d-block">Chỉ từ</small>
                            <span class="price-tag">950.000₫ <small class="text-muted fw-normal">/ đêm</small></span>
                        </div>
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-primary btn-sm rounded-3 fw-semibold">Xem chi tiết</a>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card homestay-card border-0 shadow-sm rounded-4 h-100 position-relative">
                <span class="position-absolute top-0 end-0 m-3 badge bg-danger rounded-pill px-3 py-2 shadow-sm">
                    <i class="fa-solid fa-bolt me-1"></i> Match 89%
                </span>
                <img src="https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=600&q=80" class="card-img-top" alt="Homestay">
                <div class="card-body p-4 d-flex flex-column justify-content-between">
                    <div>
                        <span class="badge-tag mb-2 d-inline-block"><i class="fa-solid fa-tag me-1"></i> Phong cách Eco Natural</span>
                        <h5 class="fw-bold text-dark">Sapa Cloud Horizon Bungalow</h5>
                        <p class="text-muted small"><i class="fa-solid fa-location-dot text-danger me-1"></i> Tả Van, Sa Pa</p>
                    </div>
                    <div class="d-flex align-items-center justify-content-between pt-3 border-top mt-3">
                        <div>
                            <small class="text-muted d-block">Chỉ từ</small>
                            <span class="price-tag">1.100.000₫ <small class="text-muted fw-normal">/ đêm</small></span>
                        </div>
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-primary btn-sm rounded-3 fw-semibold">Xem chi tiết</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>
