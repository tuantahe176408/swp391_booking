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
                            <button class="btn btn-sm btn-outline-danger mt-1" onclick="toggleWishlist(${homestay.homestayId}, this)">
                                <i class="fa-${homestay.wishlisted ? 'solid' : 'regular'} fa-heart me-1"></i>
                                ${homestay.wishlisted ? 'Đã lưu' : 'Lưu yêu thích'}
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

                <!-- Room Types -->
                <c:if test="${not empty homestay.roomTypes}">
                    <div class="mb-4">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="fw-bold mb-0"><i class="fa-solid fa-door-open text-primary me-2"></i>Hạng phòng khả dụng</h5>
                            <span class="badge bg-light text-secondary border">${homestay.roomTypes.size()} loại phòng</span>
                        </div>
                        <c:forEach var="rt" items="${homestay.roomTypes}">
                            <div class="room-type-card mb-3 p-3 rounded-4 border bg-white shadow-sm" id="room-card-${rt.roomTypeId}" onclick="selectRoom(${rt.roomTypeId}, ${rt.basePrice}, '${rt.name}', this)">
                                <div class="d-flex flex-column flex-md-row justify-content-between align-items-start gap-3">
                                    <div class="flex-grow-1">
                                        <div class="d-flex align-items-center gap-2 mb-1">
                                            <h6 class="fw-bold mb-0 text-dark">${rt.name}</h6>
                                            <span class="badge bg-primary-subtle text-primary border border-primary px-2 py-0 small" style="font-size: 0.72rem;">Phổ biến</span>
                                        </div>
                                        <div class="text-muted small mb-2 d-flex flex-wrap gap-2">
                                            <span><i class="fa-solid fa-bed text-primary me-1"></i>${rt.bedCount} giường</span>
                                            <span>•</span>
                                            <span><i class="fa-solid fa-user-group text-primary me-1"></i>Tối đa ${rt.maxOccupancy} khách</span>
                                            <c:if test="${rt.roomSizeSqm != null}">
                                                <span>•</span>
                                                <span><i class="fa-solid fa-vector-square text-primary me-1"></i>${rt.roomSizeSqm} m²</span>
                                            </c:if>
                                        </div>
                                        <p class="text-secondary small mb-2 text-truncate" style="max-width: 500px;">${rt.description}</p>
                                        <div>
                                            <button type="button" class="btn btn-link text-primary p-0 small fw-semibold text-decoration-none" onclick="event.stopPropagation(); showRoomDetail(${rt.roomTypeId}, '${rt.name}', '${rt.description}', ${rt.basePrice}, ${rt.maxOccupancy}, ${rt.bedCount}, '${rt.roomSizeSqm != null ? rt.roomSizeSqm : 25}')">
                                                <i class="fa-solid fa-circle-info me-1"></i>Xem chi tiết phòng &amp; tiện nghi
                                            </button>
                                        </div>
                                    </div>
                                    <div class="text-md-end d-flex flex-column justify-content-between align-items-md-end w-100 w-md-auto">
                                        <div>
                                            <div class="price-big text-primary fw-bold fs-4"><fmt:formatNumber value="${rt.basePrice}" type="number" groupingUsed="true"/>₫</div>
                                            <div class="text-muted small">/ đêm</div>
                                        </div>
                                        <button type="button" class="btn btn-outline-primary btn-sm rounded-pill mt-2 px-3 fw-semibold">
                                            <i class="fa-solid fa-check me-1"></i> Chọn phòng
                                        </button>
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

                <!-- Reviews -->
                <c:if test="${not empty homestay.reviews}">
                    <div class="mb-4">
                        <h5 class="fw-bold mb-3">Đánh giá từ khách hàng</h5>
                        <c:forEach var="rv" items="${homestay.reviews}" end="4">
                            <div class="d-flex gap-3 mb-4">
                                <div class="review-avatar">${rv.reviewerName != null ? rv.reviewerName.substring(0,1).toUpperCase() : 'K'}</div>
                                <div>
                                    <div class="fw-semibold">${rv.reviewerName}</div>
                                    <div class="text-warning small mb-1">
                                        <c:forEach begin="1" end="${rv.rating}"><i class="fa-solid fa-star"></i></c:forEach>
                                        <span class="text-muted ms-1">${rv.createdAt}</span>
                                    </div>
                                    <p class="text-muted small mb-0">${rv.comment}</p>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
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
                                <label class="form-label fw-semibold small">Ngày nhận phòng</label>
                                <input type="date" name="checkin" class="form-control rounded-3" value="${checkin}" required id="checkinInput">
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-semibold small">Ngày trả phòng</label>
                                <input type="date" name="checkout" class="form-control rounded-3" value="${checkout}" required id="checkoutInput">
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-semibold small">Số khách</label>
                                <select name="guests" class="form-select rounded-3">
                                    <c:forEach var="i" begin="1" end="10">
                                        <option value="${i}">${i} Khách</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <c:choose>
                                <c:when test="${not empty sessionScope.currentUser}">
                                    <button type="submit" class="btn btn-primary-custom w-100 fw-bold py-2" id="bookBtn" disabled>
                                        <i class="fa-solid fa-calendar-check me-2"></i>Đặt phòng ngay
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-primary w-100 fw-bold py-2">
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
    document.getElementById('bookBtn').disabled = false;
}

function toggleWishlist(homestayId, btn) {
    fetch('${pageContext.request.contextPath}/customer/wishlist', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'action=toggle&homestayId=' + homestayId
    }).then(r => r.json()).then(data => {
        if (data.wishlisted) {
            btn.innerHTML = '<i class="fa-solid fa-heart me-1"></i>Đã lưu';
        } else {
            btn.innerHTML = '<i class="fa-regular fa-heart me-1"></i>Lưu yêu thích';
        }
    });
}
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
