<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="container py-5">
    <div class="rounded-4 p-4 p-md-5 mb-5 shadow-lg text-white" style="background: linear-gradient(135deg, #1e1b4b 0%, #4338ca 60%, #3b82f6 100%) !important;">
        <div class="row align-items-center">
            <div class="col-lg-8">
                <span class="badge bg-white fw-bold mb-3 px-3 py-2 shadow-sm rounded-pill" style="font-size: 0.85rem; color: #4338ca !important;">
                    <i class="fa-solid fa-wand-magic-sparkles me-1" style="color: #4f46e5;"></i> UC05: AI Collaborative Filtering
                </span>
                <h2 class="fw-bold text-white mb-2" style="font-size: 2rem; text-shadow: 0 2px 10px rgba(0,0,0,0.2);">
                    Gợi Ý Thông Minh Cho ${sessionScope.currentUser.fullName}
                </h2>
                <p class="mb-0" style="color: #e0e7ff !important; font-size: 1rem; line-height: 1.6;">
                    Mô hình AI tự động phân tích lịch sử tìm kiếm, sở thích cá nhân và đánh giá từ cộng đồng để đề xuất các Homestay có độ tương thích cao nhất.
                </p>
            </div>
            <div class="col-lg-4 text-lg-end mt-4 mt-lg-0">
                <div class="rounded-4 p-4 d-inline-block text-center border border-white border-opacity-25 shadow" style="background: rgba(255, 255, 255, 0.12); backdrop-filter: blur(12px); -webkit-backdrop-filter: blur(12px); min-width: 160px;">
                    <span class="fs-1 fw-bold text-white d-block" style="letter-spacing: 0.5px;">98.5%</span>
                    <small class="fw-semibold text-uppercase" style="color: #c7d2fe; letter-spacing: 1px; font-size: 0.75rem;">AI Match Accuracy</small>
                </div>
            </div>
        </div>
    </div>

    <!-- Recommendation Cards Grid -->
    <h4 class="fw-bold mb-4 text-dark"><i class="fa-solid fa-fire text-danger me-2"></i>Dành riêng cho bạn hôm nay</h4>
    <div class="row g-4">
        <c:forEach var="h" items="${recommendations}">
            <div class="col-md-6 col-lg-4">
                <div class="card homestay-card border-0 shadow-sm rounded-4 h-100 position-relative">
                    <span class="position-absolute top-0 end-0 m-3 badge bg-danger rounded-pill px-3 py-2 shadow-sm" style="z-index: 5; font-weight: 700; font-size: 0.82rem;">
                        <i class="fa-solid fa-bolt me-1"></i> Match ${h.matchScore}%
                    </span>
                    <div class="position-relative overflow-hidden" style="height: 200px;">
                        <c:choose>
                            <c:when test="${not empty h.primaryImageUrl}">
                                <img src="${h.primaryImageUrl}" class="card-img-top w-100 h-100 object-fit-cover" alt="${h.name}" onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/images/default-homestay.svg';">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/assets/images/default-homestay.svg" class="card-img-top w-100 h-100 object-fit-cover" alt="${h.name}" onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=600&q=80';">
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="card-body p-4 d-flex flex-column justify-content-between">
                        <div>
                            <span class="badge-tag mb-2 d-inline-block" style="background: #e0e7ff; color: #3730a3; font-weight: 600; font-size: 0.8rem; padding: 6px 12px; border-radius: 20px;">
                                <i class="fa-solid fa-tag me-1" style="color: #4f46e5;"></i> ${h.reasonTag}
                            </span>
                            <h5 class="fw-bold text-truncate mt-1 mb-2" title="${h.name}" style="color: #0f172a !important;">${h.name}</h5>
                            <p class="small mb-3" style="color: #64748b;"><i class="fa-solid fa-location-dot text-danger me-1"></i> ${h.city}</p>
                        </div>
                        <div class="d-flex align-items-center justify-content-between pt-3 border-top mt-3">
                            <div>
                                <small class="text-muted d-block" style="font-size: 0.78rem;">Chỉ từ</small>
                                <div class="price-tag" style="color: #4f46e5; font-size: 1.2rem; font-weight: 700;">
                                    <fmt:formatNumber value="${h.minPrice}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                    <small class="text-muted fw-normal" style="font-size: 0.82rem;"> / đêm</small>
                                </div>
                            </div>
                            <a href="${pageContext.request.contextPath}/detail?id=${h.homestayId}" class="btn btn-outline-primary btn-sm rounded-pill fw-semibold px-3">Xem chi tiết</a>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>
