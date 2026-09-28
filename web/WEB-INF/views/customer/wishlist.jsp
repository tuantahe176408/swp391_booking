<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="container py-5">
    <div class="d-flex align-items-center justify-content-between mb-4">
        <div>
            <h3 class="fw-bold mb-1"><i class="fa-solid fa-heart text-danger me-2"></i>Danh sách Homestay Yêu thích (UC06)</h3>
            <p class="text-muted mb-0">Các chỗ nghỉ bạn đã lưu lại để chuẩn bị cho kỳ nghỉ sắp tới</p>
        </div>
        <a href="${pageContext.request.contextPath}/search" class="btn btn-outline-primary rounded-pill btn-sm">
            <i class="fa-solid fa-compass me-1"></i> Khám phá thêm
        </a>
    </div>

    <c:choose>
        <c:when test="${not empty savedHomestays}">
            <div class="row g-4">
                <c:forEach var="h" items="${savedHomestays}">
                    <div class="col-md-6 col-lg-4" id="wishlist-card-${h.homestayId}">
                        <div class="card homestay-card border-0 shadow-sm rounded-4 h-100 position-relative overflow-hidden">
                            <div class="position-relative overflow-hidden" style="height: 200px;">
                                <c:choose>
                                    <c:when test="${not empty h.primaryImageUrl}">
                                        <img src="${h.primaryImageUrl}" class="w-100 h-100 object-fit-cover" alt="${h.name}" onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/images/default-homestay.svg';">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/assets/images/default-homestay.svg" class="w-100 h-100 object-fit-cover" alt="${h.name}" onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=600&q=80';">
                                    </c:otherwise>
                                </c:choose>
                                <span class="badge bg-dark bg-opacity-75 text-white position-absolute top-0 end-0 m-2 px-2 py-1 rounded-pill small">
                                    <i class="fa-solid fa-star text-warning me-1"></i>${h.ratingAvg} (${h.reviewCount})
                                </span>
                            </div>

                            <div class="card-body p-3 d-flex flex-column justify-content-between">
                                <div>
                                    <div class="text-muted small mb-1"><i class="fa-solid fa-location-dot text-danger me-1"></i>${h.city}</div>
                                    <h6 class="fw-bold text-dark text-truncate mb-2" title="${h.name}">${h.name}</h6>
                                    <p class="text-secondary small mb-3 text-truncate">${h.description}</p>
                                </div>

                                <div class="pt-3 border-top d-flex align-items-center justify-content-between">
                                    <div>
                                        <small class="text-muted d-block">Giá từ</small>
                                        <span class="price-tag fs-6">
                                            <fmt:formatNumber value="${h.minPrice}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                            <small class="text-muted fw-normal">/ đêm</small>
                                        </span>
                                    </div>
                                    <div class="d-flex gap-2">
                                        <button class="btn btn-outline-danger btn-sm rounded-pill" onclick="removeWishlistItem(${h.homestayId})" title="Bỏ lưu">
                                            <i class="fa-solid fa-trash-can"></i>
                                        </button>
                                        <a href="${pageContext.request.contextPath}/detail?id=${h.homestayId}" class="btn btn-primary-custom btn-sm rounded-pill px-3">
                                            Đặt ngay
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="card border-0 shadow-sm rounded-4 p-5 text-center my-4">
                <div class="rounded-circle bg-danger-subtle text-danger mx-auto d-flex align-items-center justify-content-center mb-3" style="width: 72px; height: 72px; font-size: 32px;">
                    <i class="fa-regular fa-heart"></i>
                </div>
                <h4 class="fw-bold">Danh sách yêu thích đang trống</h4>
                <p class="text-muted mb-4">Bạn chưa lưu homestay nào. Hãy khám phá và bấm vào biểu tượng Trái tim để lưu lại những chỗ nghỉ yêu thích!</p>
                <div>
                    <a href="${pageContext.request.contextPath}/search" class="btn btn-primary-custom px-4">
                        <i class="fa-solid fa-magnifying-glass me-2"></i>Tìm kiếm chỗ nghỉ ngay
                    </a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="../common/footer.jsp"/>

<script>
function removeWishlistItem(homestayId) {
    if (!confirm('Bạn có chắc chắn muốn bỏ homestay này khỏi danh sách yêu thích?')) return;

    fetch('${pageContext.request.contextPath}/customer/wishlist/toggle', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'homestayId=' + encodeURIComponent(homestayId)
    })
    .then(res => res.json())
    .then(data => {
        if (data && data.status === 'success' && !data.is_saved) {
            const card = document.getElementById('wishlist-card-' + homestayId);
            if (card) {
                card.remove();
            }
        }
    })
    .catch(err => console.error(err));
}
</script>
