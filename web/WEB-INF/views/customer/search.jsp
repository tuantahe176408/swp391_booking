<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<style>
.search-filter-sidebar { background:#fff; border-radius:16px; border:1px solid rgba(0,0,0,0.07); padding:1.5rem; position:sticky; top:80px; }
.filter-section-title { font-weight:700; font-size:0.82rem; text-transform:uppercase; letter-spacing:0.5px; color:#6b7280; margin-bottom:0.75rem; }
.homestay-card { background:#fff; border-radius:16px; border:1px solid rgba(0,0,0,0.07); overflow:hidden; transition:transform 0.25s ease, box-shadow 0.25s ease; }
.homestay-card:hover { transform:translateY(-4px); box-shadow:0 16px 48px rgba(0,0,0,0.1); }
.homestay-card img { width:100%; height:200px; object-fit:cover; transition:transform 0.4s ease; }
.homestay-card:hover img { transform:scale(1.04); }
.badge-city { background:rgba(99,102,241,0.1); color:#6366f1; border:1px solid rgba(99,102,241,0.2); border-radius:6px; padding:2px 8px; font-size:0.75rem; }
.sort-bar { background:#fff; border-radius:12px; border:1px solid rgba(0,0,0,0.07); padding:0.75rem 1rem; margin-bottom:1.25rem; }
.search-hero { background:linear-gradient(135deg,#1a1a2e,#16213e); padding:40px 0 30px; color:#fff; }
.rating-star { color:#f59e0b; }
.price-tag { font-size:1.2rem; font-weight:800; color:#6366f1; }
</style>

<!-- Search Hero -->
<div class="search-hero">
    <div class="container">
        <form action="${pageContext.request.contextPath}/search" method="GET" id="mainSearchForm">
            <div class="row g-2 align-items-end">
                <div class="col-md-4">
                    <label class="form-label text-white-50 small">Địa điểm</label>
                    <input type="text" name="location" class="form-control rounded-3" placeholder="Đà Lạt, Nha Trang..." value="${searchLocation}">
                </div>
                <div class="col-md-2">
                    <label class="form-label text-white-50 small">Nhận phòng</label>
                    <input type="date" name="checkin" class="form-control rounded-3" value="${searchCheckin}">
                </div>
                <div class="col-md-2">
                    <label class="form-label text-white-50 small">Trả phòng</label>
                    <input type="date" name="checkout" class="form-control rounded-3" value="${searchCheckout}">
                </div>
                <div class="col-md-2">
                    <label class="form-label text-white-50 small">Số khách</label>
                    <select name="guests" class="form-select rounded-3">
                        <c:forEach var="i" begin="1" end="10">
                            <option value="${i}" ${searchGuests == i ? 'selected' : ''}>${i} Khách</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-primary w-100 fw-semibold">
                        <i class="fa-solid fa-magnifying-glass me-1"></i> Tìm kiếm
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

<div class="container py-4">
    <div class="row g-4">
        <!-- Sidebar Filter -->
        <div class="col-lg-3">
            <form action="${pageContext.request.contextPath}/search" method="GET" id="filterForm">
                <input type="hidden" name="location" value="${searchLocation}">
                <input type="hidden" name="checkin" value="${searchCheckin}">
                <input type="hidden" name="checkout" value="${searchCheckout}">
                <input type="hidden" name="guests" value="${searchGuests}">

                <div class="search-filter-sidebar">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h6 class="fw-bold mb-0"><i class="fa-solid fa-sliders me-2 text-primary"></i>Bộ lọc</h6>
                        <a href="${pageContext.request.contextPath}/search" class="text-muted small">Xóa bộ lọc</a>
                    </div>

                    <!-- Khoảng giá -->
                    <div class="mb-4">
                        <div class="filter-section-title">Khoảng giá / đêm</div>
                        <div class="row g-2">
                            <div class="col-6">
                                <input type="number" name="minPrice" class="form-control form-control-sm" placeholder="Từ" value="${searchMinPrice}">
                            </div>
                            <div class="col-6">
                                <input type="number" name="maxPrice" class="form-control form-control-sm" placeholder="Đến" value="${searchMaxPrice}">
                            </div>
                        </div>
                    </div>

                    <!-- Tiện ích -->
                    <c:if test="${not empty allAmenities}">
                        <div class="mb-4">
                            <div class="filter-section-title">Tiện ích</div>
                            <c:forEach var="a" items="${allAmenities}">
                                <div class="form-check mb-1">
                                    <input class="form-check-input" type="checkbox" name="amenities" value="${a.amenityId}" id="am${a.amenityId}">
                                    <label class="form-check-label small" for="am${a.amenityId}">${a.name}</label>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>

                    <button type="submit" class="btn btn-primary-custom w-100 fw-semibold">
                        <i class="fa-solid fa-filter me-1"></i> Áp dụng bộ lọc
                    </button>
                </div>
            </form>
        </div>

        <!-- Results -->
        <div class="col-lg-9">
            <!-- Sort Bar -->
            <div class="sort-bar d-flex align-items-center justify-content-between flex-wrap gap-2">
                <div class="text-muted small">
                    <i class="fa-solid fa-list me-1"></i>
                    <c:choose>
                        <c:when test="${totalResults > 0}">
                            Tìm thấy <strong>${totalResults}</strong> homestay
                            <c:if test="${not empty searchLocation}"> tại <strong>${searchLocation}</strong></c:if>
                        </c:when>
                        <c:otherwise>Không tìm thấy kết quả phù hợp</c:otherwise>
                    </c:choose>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <span class="text-muted small">Sắp xếp:</span>
                    <select class="form-select form-select-sm" style="width:auto;" onchange="applySortBy(this.value)">
                        <option value="rating" ${searchSortBy == 'rating' ? 'selected' : ''}>Đánh giá cao nhất</option>
                        <option value="price_asc" ${searchSortBy == 'price_asc' ? 'selected' : ''}>Giá thấp đến cao</option>
                        <option value="price_desc" ${searchSortBy == 'price_desc' ? 'selected' : ''}>Giá cao đến thấp</option>
                        <option value="newest" ${searchSortBy == 'newest' ? 'selected' : ''}>Mới nhất</option>
                    </select>
                </div>
            </div>

            <!-- Cards Grid -->
            <c:choose>
                <c:when test="${not empty results}">
                    <div class="row g-4">
                        <c:forEach var="h" items="${results}">
                            <div class="col-md-6 col-xl-4">
                                <div class="homestay-card h-100">
                                    <div style="overflow:hidden; position:relative;">
                                        <a href="${pageContext.request.contextPath}/homestay/detail?id=${h.homestayId}&checkin=${searchCheckin}&checkout=${searchCheckout}&guests=${searchGuests}">
                                            <c:choose>
                                                <c:when test="${not empty h.primaryImageUrl}">
                                                    <img src="${h.primaryImageUrl}" alt="${h.name}" loading="lazy">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=600&q=80" alt="${h.name}" loading="lazy">
                                                </c:otherwise>
                                            </c:choose>
                                        </a>
                                        <c:if test="${h.wishlisted}">
                                            <span style="position:absolute;top:10px;right:12px;"><i class="fa-solid fa-heart text-danger fs-5"></i></span>
                                        </c:if>
                                    </div>
                                    <div class="p-3">
                                        <div class="d-flex justify-content-between align-items-start mb-1">
                                            <span class="badge-city">${h.city}</span>
                                            <span class="small rating-star"><i class="fa-solid fa-star"></i> <strong>${h.ratingAvg}</strong> <span class="text-muted">(${h.reviewCount})</span></span>
                                        </div>
                                        <h6 class="fw-bold mb-1 mt-2">
                                            <a href="${pageContext.request.contextPath}/homestay/detail?id=${h.homestayId}" class="text-dark text-decoration-none">${h.name}</a>
                                        </h6>
                                        <p class="text-muted small mb-2"><i class="fa-solid fa-location-dot me-1"></i>${h.address}</p>
                                        <c:if test="${not empty h.amenityNames}">
                                            <div class="mb-2">
                                                <c:forEach var="am" items="${h.amenityNames}" end="2">
                                                    <span class="badge bg-light text-muted border me-1 small">${am}</span>
                                                </c:forEach>
                                            </div>
                                        </c:if>
                                        <div class="d-flex justify-content-between align-items-center mt-2">
                                            <div>
                                                <span class="price-tag"><fmt:formatNumber value="${h.minPrice}" type="number" groupingUsed="true"/>₫</span>
                                                <span class="text-muted small"> / đêm</span>
                                            </div>
                                            <a href="${pageContext.request.contextPath}/homestay/detail?id=${h.homestayId}&checkin=${searchCheckin}&checkout=${searchCheckout}&guests=${searchGuests}"
                                               class="btn btn-sm btn-primary-custom">Xem phòng</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <nav class="mt-4">
                            <ul class="pagination justify-content-center">
                                <c:if test="${currentPage > 1}">
                                    <li class="page-item"><a class="page-link" href="?location=${searchLocation}&checkin=${searchCheckin}&checkout=${searchCheckout}&guests=${searchGuests}&page=${currentPage-1}">«</a></li>
                                </c:if>
                                <c:forEach var="p" begin="1" end="${totalPages}">
                                    <li class="page-item ${p == currentPage ? 'active' : ''}">
                                        <a class="page-link" href="?location=${searchLocation}&checkin=${searchCheckin}&checkout=${searchCheckout}&guests=${searchGuests}&page=${p}">${p}</a>
                                    </li>
                                </c:forEach>
                                <c:if test="${currentPage < totalPages}">
                                    <li class="page-item"><a class="page-link" href="?location=${searchLocation}&checkin=${searchCheckin}&checkout=${searchCheckout}&guests=${searchGuests}&page=${currentPage+1}">»</a></li>
                                </c:if>
                            </ul>
                        </nav>
                    </c:if>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-5">
                        <i class="fa-solid fa-face-sad-tear fs-1 text-muted mb-3"></i>
                        <h5 class="fw-bold">Không tìm thấy homestay phù hợp</h5>
                        <p class="text-muted">Thử thay đổi địa điểm hoặc điều chỉnh bộ lọc.</p>
                        <a href="${pageContext.request.contextPath}/search" class="btn btn-primary-custom">Xóa bộ lọc & Tìm lại</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script>
function applySortBy(val) {
    const url = new URL(window.location.href);
    url.searchParams.set('sortBy', val);
    url.searchParams.set('page', '1');
    window.location.href = url.toString();
}
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
