<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<style>
.search-filter-sidebar { background:#fff; border-radius:16px; border:1px solid rgba(0,0,0,0.07); padding:1.5rem; position:sticky; top:80px; }
.filter-section-title { font-weight:700; font-size:0.82rem; text-transform:uppercase; letter-spacing:0.5px; color:#6b7280; margin-bottom:0.75rem; }
.homestay-card { background:#fff; border-radius:16px; border:1px solid rgba(0,0,0,0.07); overflow:hidden; transition:transform 0.25s ease, box-shadow 0.25s ease; display:flex; flex-direction:column; height:100%; min-height:430px; box-shadow:0 2px 8px rgba(0,0,0,0.03); }
.homestay-card:hover { transform:translateY(-4px); box-shadow:0 16px 48px rgba(0,0,0,0.1); }
.homestay-card .card-img-wrap { width:100%; height:190px; position:relative; overflow:hidden; background:#eef2ff; flex-shrink:0; }
.homestay-card .card-img-wrap img { width:100%; height:100%; object-fit:cover; display:block; transition:transform 0.4s ease; }
.homestay-card:hover .card-img-wrap img { transform:scale(1.04); }
.homestay-card .card-body-content { padding:1.15rem; display:flex; flex-direction:column; flex-grow:1; justify-content:space-between; }
.homestay-card .card-meta-row { height:24px; display:flex; justify-content:space-between; align-items:center; margin-bottom:6px; }
.homestay-card .card-title-box { height:44px; margin-bottom:4px; overflow:hidden; }
.homestay-card .card-title { font-size:1rem; font-weight:700; line-height:22px; margin:0; display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; overflow:hidden; text-overflow:ellipsis; }
.homestay-card .card-address { height:20px; line-height:20px; color:#6b7280; font-size:0.82rem; margin-bottom:8px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; display:block; }
.homestay-card .card-amenities-wrap { height:28px; display:flex; align-items:center; gap:4px; overflow:hidden; margin-bottom:0.75rem; flex-wrap:nowrap; }
.homestay-card .card-amenities-wrap .badge { cursor:default; white-space:nowrap; text-overflow:ellipsis; overflow:hidden; max-width:120px; font-weight:500; font-size:0.72rem; padding:4px 8px; }
.homestay-card .card-amenities-wrap .badge-more { cursor:pointer; background:rgba(99,102,241,0.08); color:#4f46e5; border:1px solid rgba(99,102,241,0.2); font-weight:700; flex-shrink:0; transition:all 0.2s ease; }
.homestay-card .card-amenities-wrap .badge-more:hover { background:rgba(99,102,241,0.18); transform:scale(1.05); }
.homestay-card .card-footer-row { height:50px; display:flex; justify-content:space-between; align-items:center; margin-top:auto; pt-2; border-top:1px solid #f1f5f9; }
.badge-city { background:rgba(99,102,241,0.1); color:#6366f1; border:1px solid rgba(99,102,241,0.2); border-radius:6px; padding:2px 8px; font-size:0.75rem; font-weight:600; }
.sort-bar { background:#fff; border-radius:12px; border:1px solid rgba(0,0,0,0.07); padding:0.75rem 1rem; margin-bottom:1.25rem; }
.search-hero { background:linear-gradient(135deg,#1a1a2e,#16213e); padding:40px 0 30px; color:#fff; }
.rating-star { color:#f59e0b; font-size:0.85rem; }
.price-tag { font-size:1.15rem; font-weight:800; color:#4f46e5; }

/* Rich Popover Tooltip for Amenities */
.amenities-rich-tooltip .tooltip-inner {
    background: #ffffff !important;
    color: #1e293b !important;
    border: 1px solid rgba(0, 0, 0, 0.08) !important;
    border-radius: 12px !important;
    box-shadow: 0 12px 36px rgba(0, 0, 0, 0.16) !important;
    padding: 10px 12px !important;
    max-width: 280px !important;
    text-align: left !important;
}
.amenities-rich-tooltip .tooltip-arrow::before {
    border-top-color: #ffffff !important;
    border-bottom-color: #ffffff !important;
}
.popover-amenities-header {
    font-size: 0.78rem;
    font-weight: 700;
    color: #475569;
    padding-bottom: 6px;
    margin-bottom: 8px;
    border-bottom: 1px solid #f1f5f9;
    display: flex;
    align-items: center;
}
.popover-amenities-grid {
    display: flex;
    flex-wrap: wrap;
    gap: 6px;
}
.popover-amenities-grid .badge {
    background: #f8fafc !important;
    color: #475569 !important;
    border: 1px solid #e2e8f0 !important;
    font-size: 0.72rem !important;
    font-weight: 500 !important;
    padding: 4px 8px !important;
    border-radius: 6px !important;
    white-space: normal !important;
    text-align: left !important;
    display: inline-flex !important;
    align-items: center !important;
}

/* Smart Price Filter Styles */
.price-preset-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 6px; margin-bottom: 12px; }
.price-chip { background: #f8f9fc; color: #4b5563; border: 1px solid #e2e8f0; border-radius: 20px; font-size: 0.76rem; font-weight: 600; padding: 5px 8px; text-align: center; cursor: pointer; transition: all 0.2s; user-select: none; }
.price-chip:hover { background: #e0e7ff; color: #4338ca; border-color: #c7d2fe; transform: translateY(-1px); }
.price-chip.active { background: #6366f1; color: #fff; border-color: #6366f1; box-shadow: 0 3px 10px rgba(99,102,241,0.3); }
.price-range-slider { -webkit-appearance: none; appearance: none; width: 100%; height: 6px; border-radius: 5px; background: #e0e7ff; outline: none; transition: background 0.2s; }
.price-range-slider::-webkit-slider-thumb { -webkit-appearance: none; appearance: none; width: 18px; height: 18px; border-radius: 50%; background: #6366f1; cursor: pointer; border: 2px solid #fff; box-shadow: 0 2px 6px rgba(0,0,0,0.25); transition: transform 0.15s; }
.price-range-slider::-webkit-slider-thumb:hover { transform: scale(1.2); }
.price-badge-display { background: #f5f7ff; border: 1px dashed #6366f1; color: #4f46e5; border-radius: 10px; padding: 7px 10px; font-weight: 700; font-size: 0.85rem; text-align: center; margin-bottom: 10px; transition: all 0.2s; }
/* Smart Location Search Styles */
.location-search-wrapper { position: relative; }
.location-suggest-popup {
    position: absolute;
    top: 100%;
    left: 0;
    right: 0;
    margin-top: 6px;
    background: #ffffff;
    border-radius: 14px;
    box-shadow: 0 16px 40px rgba(0, 0, 0, 0.2);
    border: 1px solid rgba(0, 0, 0, 0.08);
    z-index: 1050;
    padding: 10px;
    display: none;
    max-height: 320px;
    overflow-y: auto;
}
.location-suggest-popup.show { display: block; animation: fadeInDown 0.2s ease; }
.location-item {
    display: flex;
    align-items: center;
    padding: 8px 12px;
    border-radius: 10px;
    cursor: pointer;
    color: #1f2937;
    transition: all 0.15s ease;
}
.location-item:hover {
    background: #f0f4ff;
    color: #4338ca;
}
.location-icon-box {
    width: 34px;
    height: 34px;
    border-radius: 8px;
    background: rgba(99, 102, 241, 0.1);
    color: #6366f1;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-right: 12px;
    flex-shrink: 0;
}
.city-filter-grid { display: flex; flex-wrap: wrap; gap: 6px; margin-bottom: 12px; }
.city-chip { background: #f8f9fc; color: #4b5563; border: 1px solid #e2e8f0; border-radius: 16px; font-size: 0.78rem; font-weight: 600; padding: 4px 10px; cursor: pointer; transition: all 0.2s; user-select: none; }
.city-chip:hover { background: #e0e7ff; color: #4338ca; border-color: #c7d2fe; }
.city-chip.active { background: #6366f1; color: #fff; border-color: #6366f1; box-shadow: 0 2px 8px rgba(99,102,241,0.25); }
</style>

<!-- Search Hero -->
<div class="search-hero">
    <div class="container">
        <form action="${pageContext.request.contextPath}/search" method="GET" id="mainSearchForm">
            <div class="row g-2 align-items-end">
                <div class="col-md-4">
                    <label class="form-label text-white small fw-semibold"><i class="fa-solid fa-location-dot me-1 text-primary"></i> Địa điểm</label>
                    <div class="location-search-wrapper">
                        <input type="text" name="location" id="heroLocationInput" class="form-control rounded-3" placeholder="Đà Lạt, Nha Trang, Hội An..." value="${searchLocation}" autocomplete="off">
                        <div class="location-suggest-popup shadow-lg" id="heroLocationPopup">
                            <div class="d-flex justify-content-between align-items-center px-2 py-1 mb-1 border-bottom text-muted" style="font-size: 0.72rem; font-weight: 700; text-transform: uppercase;">
                                <span><i class="fa-solid fa-fire text-danger me-1"></i> Điểm đến nổi bật</span>
                                <span style="font-weight: normal; cursor: pointer;" onclick="selectLocation('')">Xóa</span>
                            </div>
                            <div class="location-list" id="heroLocationList">
                                <c:forEach var="city" items="${cities}">
                                    <div class="location-item" onclick="selectLocation('${city}')">
                                        <div class="location-icon-box"><i class="fa-solid fa-location-dot"></i></div>
                                        <div><div class="fw-bold text-dark" style="font-size:0.9rem;">${city}</div></div>
                                    </div>
                                </c:forEach>
                                <c:if test="${empty cities}">
                                    <div class="px-3 py-2 text-muted small">Không có dữ liệu thành phố.</div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-2">
                    <label class="form-label text-white small fw-semibold"><i class="fa-regular fa-calendar me-1 text-primary"></i> Nhận phòng</label>
                    <input type="date" name="checkin" id="searchCheckin" class="form-control rounded-3" value="${searchCheckin}">
                </div>
                <div class="col-md-2">
                    <label class="form-label text-white small fw-semibold"><i class="fa-regular fa-calendar-check me-1 text-primary"></i> Trả phòng</label>
                    <input type="date" name="checkout" id="searchCheckout" class="form-control rounded-3" value="${searchCheckout}">
                </div>
                <div class="col-md-2">
                    <label class="form-label text-white small fw-semibold"><i class="fa-solid fa-users me-1 text-primary"></i> Số khách</label>
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
                <input type="hidden" name="location" id="filterLocationInput" value="${searchLocation}">
                <input type="hidden" name="checkin" value="${searchCheckin}">
                <input type="hidden" name="checkout" value="${searchCheckout}">
                <input type="hidden" name="guests" value="${searchGuests}">

                <div class="search-filter-sidebar">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h6 class="fw-bold mb-0"><i class="fa-solid fa-sliders me-2 text-primary"></i>Bộ lọc</h6>
                        <a href="${pageContext.request.contextPath}/search" class="text-muted small">Xóa bộ lọc</a>
                    </div>

                    <!-- Khu vực & Thành phố Quick Filter -->
                    <div class="mb-4">
                        <div class="filter-section-title"><i class="fa-solid fa-map-location-dot text-primary me-1"></i> Thành phố / Khu vực</div>
                        <div class="city-filter-grid">
                            <div class="city-chip ${empty searchLocation ? 'active' : ''}" onclick="filterByCity('')">Tất cả</div>
                            <c:forEach var="c" items="${cities}">
                                <div class="city-chip ${searchLocation == c ? 'active' : ''}" onclick="filterByCity('${c}')">${c}</div>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Khoảng giá Thông minh (Smart Price Filter) -->
                    <div class="mb-4">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <div class="filter-section-title mb-0"><i class="fa-solid fa-coins text-warning me-1"></i> Khoảng giá / đêm</div>
                            <button type="button" class="btn btn-link p-0 text-muted small text-decoration-none" onclick="resetPriceFilter()" style="font-size: 0.75rem;">Mặc định</button>
                        </div>

                        <!-- Live Display Badge -->
                        <div class="price-badge-display" id="priceDisplayBadge">
                            <i class="fa-solid fa-tag me-1 text-primary"></i> <span id="priceRangeLabel">Tất cả mức giá</span>
                        </div>

                        <!-- Quick Price Chips -->
                        <div class="price-preset-grid">
                            <div class="price-chip" data-min="" data-max="" onclick="applyPricePreset(this, null, null)">Tất cả</div>
                            <div class="price-chip" data-min="0" data-max="500000" onclick="applyPricePreset(this, 0, 500000)">&lt; 500k</div>
                            <div class="price-chip" data-min="500000" data-max="1000000" onclick="applyPricePreset(this, 500000, 1000000)">500k - 1tr</div>
                            <div class="price-chip" data-min="1000000" data-max="2500000" onclick="applyPricePreset(this, 1000000, 2500000)">1tr - 2.5tr</div>
                            <div class="price-chip" data-min="2500000" data-max="5000000" onclick="applyPricePreset(this, 2500000, 5000000)">2.5tr - 5tr</div>
                            <div class="price-chip" data-min="5000000" data-max="" onclick="applyPricePreset(this, 5000000, null)">&gt; 5 triệu</div>
                        </div>

                        <!-- Price Slider for Max Price -->
                        <div class="mb-3">
                            <div class="d-flex justify-content-between text-muted small mb-1" style="font-size:0.75rem;">
                                <span>Kéo chọn mức trần:</span>
                                <span class="fw-bold text-primary" id="sliderValueLabel">10.000.000₫</span>
                            </div>
                            <input type="range" class="price-range-slider" id="priceMaxSlider" min="500000" max="10000000" step="100000" value="10000000" oninput="onSliderChange(this.value)">
                        </div>

                        <!-- Min / Max input boxes with VND prefix -->
                        <div class="row g-2 align-items-center">
                            <div class="col-6">
                                <div class="input-group input-group-sm">
                                    <span class="input-group-text bg-light text-muted px-1" style="font-size:0.75rem;">Từ</span>
                                    <input type="number" id="minPriceInput" name="minPrice" class="form-control form-control-sm" placeholder="0" value="${searchMinPrice}" oninput="syncFromInputs()">
                                    <span class="input-group-text bg-light text-muted px-1" style="font-size:0.75rem;">₫</span>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="input-group input-group-sm">
                                    <span class="input-group-text bg-light text-muted px-1" style="font-size:0.75rem;">Đến</span>
                                    <input type="number" id="maxPriceInput" name="maxPrice" class="form-control form-control-sm" placeholder="10000000" value="${searchMaxPrice}" oninput="syncFromInputs()">
                                    <span class="input-group-text bg-light text-muted px-1" style="font-size:0.75rem;">₫</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Tiện ích -->
                    <c:if test="${not empty allAmenities}">
                        <div class="mb-4">
                            <div class="filter-section-title"><i class="fa-solid fa-sparkles text-primary me-1"></i> Tiện ích nổi bật</div>
                            <c:forEach var="a" items="${allAmenities}">
                                <div class="form-check mb-1">
                                    <input class="form-check-input" type="checkbox" name="amenities" value="${a.amenityId}" id="am${a.amenityId}"
                                           <c:if test="${not empty selectedAmenities && selectedAmenities.contains(a.amenityId)}">checked</c:if>>
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
                                    <div class="card-img-wrap">
                                        <a href="${pageContext.request.contextPath}/homestay/detail?id=${h.homestayId}&checkin=${searchCheckin}&checkout=${searchCheckout}&guests=${searchGuests}">
                                            <c:choose>
                                                <c:when test="${not empty h.primaryImageUrl}">
                                                    <img src="${h.primaryImageUrl}" alt="${h.name}" loading="lazy" onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/images/default-homestay.svg';">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${pageContext.request.contextPath}/assets/images/default-homestay.svg" alt="${h.name}" loading="lazy" onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/images/default-homestay.svg';">
                                                </c:otherwise>
                                            </c:choose>
                                        </a>
                                        <c:if test="${h.wishlisted}">
                                            <span style="position:absolute;top:10px;right:12px;"><i class="fa-solid fa-heart text-danger fs-5"></i></span>
                                        </c:if>
                                    </div>
                                    <div class="card-body-content">
                                        <div>
                                            <div class="card-meta-row">
                                                <span class="badge-city">${h.city}</span>
                                                <span class="small rating-star"><i class="fa-solid fa-star"></i> <strong>${h.ratingAvg}</strong> <span class="text-muted">(${h.reviewCount})</span></span>
                                            </div>
                                            <div class="card-title-box">
                                                <h6 class="card-title">
                                                    <a href="${pageContext.request.contextPath}/homestay/detail?id=${h.homestayId}&checkin=${searchCheckin}&checkout=${searchCheckout}&guests=${searchGuests}" class="text-dark text-decoration-none" title="${h.name}">${h.name}</a>
                                                </h6>
                                            </div>
                                            <span class="card-address" title="${h.address}"><i class="fa-solid fa-location-dot me-1 text-primary"></i>${h.address}</span>
                                            <div class="card-amenities-wrap">
                                                <c:choose>
                                                    <c:when test="${not empty h.amenityNames}">
                                                        <c:forEach var="am" items="${h.amenityNames}" begin="0" end="1">
                                                            <span class="badge bg-light text-muted border" data-bs-toggle="tooltip" data-bs-placement="top" title="${am}">${am}</span>
                                                        </c:forEach>
                                                        <c:if test="${h.amenityNames.size() > 2}">
                                                            <c:set var="moreAmenitiesHtml" value="<div class='popover-amenities-header'><i class='fa-solid fa-sparkles text-primary me-1'></i>Tiện ích khác (${h.amenityNames.size() - 2})</div><div class='popover-amenities-grid'>" />
                                                            <c:forEach var="am" items="${h.amenityNames}" begin="2">
                                                                <c:set var="moreAmenitiesHtml" value="${moreAmenitiesHtml}<span class='badge'>${am}</span>" />
                                                            </c:forEach>
                                                            <c:set var="moreAmenitiesHtml" value="${moreAmenitiesHtml}</div>" />
                                                            <span class="badge badge-more" data-bs-toggle="tooltip" data-bs-custom-class="amenities-rich-tooltip" data-bs-html="true" data-bs-placement="top" data-bs-title="${moreAmenitiesHtml}">+${h.amenityNames.size() - 2}</span>
                                                        </c:if>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-light text-muted border fst-italic">Tiện nghi cơ bản</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        <div class="card-footer-row">
                                            <div>
                                                <span class="price-tag"><fmt:formatNumber value="${h.minPrice}" type="number" groupingUsed="true"/>₫</span>
                                                <span class="text-muted small"> / đêm</span>
                                            </div>
                                            <a href="${pageContext.request.contextPath}/homestay/detail?id=${h.homestayId}&checkin=${searchCheckin}&checkout=${searchCheckout}&guests=${searchGuests}"
                                               class="btn btn-sm btn-primary-custom px-3">Xem phòng</a>
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

function formatCurrency(val) {
    if (!val || isNaN(val) || val <= 0) return '0₫';
    return new Intl.NumberFormat('vi-VN').format(val) + '₫';
}

function updatePriceBadge(min, max) {
    const label = document.getElementById('priceRangeLabel');
    if (!label) return;

    if ((!min || min <= 0) && (!max || max <= 0 || max >= 10000000)) {
        label.textContent = 'Tất cả mức giá';
    } else if (min > 0 && (!max || max <= 0 || max >= 10000000)) {
        label.textContent = 'Từ ' + formatCurrency(min) + ' trở lên';
    } else if ((!min || min <= 0) && max > 0) {
        label.textContent = 'Dưới ' + formatCurrency(max);
    } else {
        label.textContent = formatCurrency(min) + ' — ' + formatCurrency(max);
    }
}

function applyPricePreset(chip, min, max) {
    document.querySelectorAll('.price-chip').forEach(c => c.classList.remove('active'));
    if (chip) chip.classList.add('active');

    const minInput = document.getElementById('minPriceInput');
    const maxInput = document.getElementById('maxPriceInput');
    const slider = document.getElementById('priceMaxSlider');
    const sliderLabel = document.getElementById('sliderValueLabel');

    minInput.value = (min !== null && min !== undefined) ? min : '';
    maxInput.value = (max !== null && max !== undefined) ? max : '';

    if (max && max <= 10000000) {
        slider.value = max;
        sliderLabel.textContent = formatCurrency(max);
    } else {
        slider.value = 10000000;
        sliderLabel.textContent = '10.000.000₫+';
    }

    updatePriceBadge(min, max);
}

function onSliderChange(val) {
    document.querySelectorAll('.price-chip').forEach(c => c.classList.remove('active'));
    const maxInput = document.getElementById('maxPriceInput');
    const sliderLabel = document.getElementById('sliderValueLabel');
    const minInput = document.getElementById('minPriceInput');

    maxInput.value = val;
    sliderLabel.textContent = formatCurrency(val);
    updatePriceBadge(Number(minInput.value), Number(val));
}

function syncFromInputs() {
    document.querySelectorAll('.price-chip').forEach(c => c.classList.remove('active'));
    const minVal = Number(document.getElementById('minPriceInput').value) || 0;
    const maxVal = Number(document.getElementById('maxPriceInput').value) || 0;
    const slider = document.getElementById('priceMaxSlider');
    const sliderLabel = document.getElementById('sliderValueLabel');

    if (maxVal > 0 && maxVal <= 10000000) {
        slider.value = maxVal;
        sliderLabel.textContent = formatCurrency(maxVal);
    } else {
        slider.value = 10000000;
        sliderLabel.textContent = 'Tối đa';
    }

    updatePriceBadge(minVal, maxVal);
}

function resetPriceFilter() {
    applyPricePreset(document.querySelector('.price-chip[data-min=""][data-max=""]'), null, null);
}

function selectLocation(loc) {
    const input = document.getElementById('heroLocationInput');
    if (input) {
        input.value = loc;
    }
    const popup = document.getElementById('heroLocationPopup');
    if (popup) popup.classList.remove('show');
    
    const filterInput = document.getElementById('filterLocationInput');
    if (filterInput) filterInput.value = loc;
}

function filterByCity(cityName) {
    const filterInput = document.getElementById('filterLocationInput');
    if (filterInput) filterInput.value = cityName;
    const heroInput = document.getElementById('heroLocationInput');
    if (heroInput) heroInput.value = cityName;
    document.getElementById('filterForm').submit();
}

// Tự động đồng bộ trạng thái khi tải trang
document.addEventListener('DOMContentLoaded', function() {
    const locInput = document.getElementById('heroLocationInput');
    const locPopup = document.getElementById('heroLocationPopup');
    if (locInput && locPopup) {
        locInput.addEventListener('focus', function() {
            locPopup.classList.add('show');
        });

        locInput.addEventListener('input', function() {
            locPopup.classList.add('show');
            const term = this.value.trim().toLowerCase();
            document.querySelectorAll('#heroLocationList .location-item').forEach(item => {
                const text = item.textContent.toLowerCase();
                if (!term || text.includes(term)) {
                    item.style.display = 'flex';
                } else {
                    item.style.display = 'none';
                }
            });
        });

        document.addEventListener('click', function(e) {
            if (!locInput.contains(e.target) && !locPopup.contains(e.target)) {
                locPopup.classList.remove('show');
            }
        });
    }

    const minInput = document.getElementById('minPriceInput');
    const maxInput = document.getElementById('maxPriceInput');
    const minVal = minInput && minInput.value ? Number(minInput.value) : 0;
    const maxVal = maxInput && maxInput.value ? Number(maxInput.value) : 0;

    let matched = false;
    document.querySelectorAll('.price-chip').forEach(c => {
        const cMin = c.getAttribute('data-min');
        const cMax = c.getAttribute('data-max');
        const chipMin = cMin ? Number(cMin) : 0;
        const chipMax = cMax ? Number(cMax) : 0;

        if (chipMin === minVal && chipMax === maxVal) {
            c.classList.add('active');
            matched = true;
        }
    });

    if (!matched && !minVal && !maxVal) {
        const allChip = document.querySelector('.price-chip[data-min=""][data-max=""]');
        if (allChip) allChip.classList.add('active');
    }

    if (maxVal > 0) {
        const slider = document.getElementById('priceMaxSlider');
        const sliderLabel = document.getElementById('sliderValueLabel');
        if (slider) slider.value = Math.min(maxVal, 10000000);
        if (sliderLabel) sliderLabel.textContent = formatCurrency(maxVal);
    }

    updatePriceBadge(minVal, maxVal);
});
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<script>
// Initialize Bootstrap Tooltips after bootstrap bundle is loaded
document.addEventListener('DOMContentLoaded', function() {
    if (typeof bootstrap !== 'undefined' && bootstrap.Tooltip) {
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl, {
                html: true,
                sanitize: false,
                delay: { show: 50, hide: 100 }
            });
        });
    }
});
</script>
