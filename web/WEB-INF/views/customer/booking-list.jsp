<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="container py-5">
    <div class="d-flex align-items-center justify-content-between mb-4">
        <div>
            <h3 class="fw-bold mb-1"><i class="fa-solid fa-receipt text-primary me-2"></i>Đơn đặt phòng của tôi</h3>
            <p class="text-muted mb-0">Quản lý lịch sử đặt phòng, thanh toán trực tuyến, xem vé điện tử QR và thực hiện hủy phòng</p>
        </div>
        <a href="${pageContext.request.contextPath}/search" class="btn btn-outline-primary btn-sm rounded-pill px-3">
            <i class="fa-solid fa-plus me-1"></i> Đặt phòng mới
        </a>
    </div>

    <!-- Feedback Alerts -->
    <c:if test="${not empty sessionScope.sessionSuccessMessage}">
        <div class="alert alert-success alert-dismissible fade show rounded-4 mb-4 shadow-sm" role="alert">
            <i class="fa-solid fa-circle-check me-2"></i> ${sessionScope.sessionSuccessMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="sessionSuccessMessage" scope="session"/>
    </c:if>

    <c:if test="${not empty sessionScope.sessionErrorMessage}">
        <div class="alert alert-danger alert-dismissible fade show rounded-4 mb-4 shadow-sm" role="alert">
            <i class="fa-solid fa-circle-exclamation me-2"></i> ${sessionScope.sessionErrorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="sessionErrorMessage" scope="session"/>
    </c:if>

    <!-- Booking List -->
    <c:choose>
        <c:when test="${not empty bookingList}">
            <c:forEach var="b" items="${bookingList}">
                <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4">
                    <div class="card-body p-4">
                        <div class="row align-items-center g-4">
                            <!-- Thumbnail -->
                            <div class="col-md-3">
                                <c:choose>
                                    <c:when test="${not empty b.homestayImageUrl}">
                                        <img src="${b.homestayImageUrl}" class="img-fluid rounded-3 object-fit-cover w-100" style="height: 150px;" alt="${b.homestayName}" onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/images/default-homestay.svg';">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/assets/images/default-homestay.svg" class="img-fluid rounded-3 object-fit-cover w-100" style="height: 150px;" alt="${b.homestayName}" onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=600&q=80';">
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Booking Info -->
                            <div class="col-md-6">
                                <div class="d-flex flex-wrap align-items-center gap-2 mb-2">
                                    <c:choose>
                                        <c:when test="${b.bookingStatus == 'CONFIRMED'}">
                                            <span class="badge bg-success-subtle text-success border border-success px-2 py-1"><i class="fa-solid fa-circle-check me-1"></i> Đã xác nhận</span>
                                        </c:when>
                                        <c:when test="${b.bookingStatus == 'PENDING'}">
                                            <span class="badge bg-warning-subtle text-warning border border-warning px-2 py-1"><i class="fa-solid fa-clock me-1"></i> Chờ thanh toán</span>
                                        </c:when>
                                        <c:when test="${b.bookingStatus == 'CHECKED_IN'}">
                                            <span class="badge bg-info-subtle text-info border border-info px-2 py-1"><i class="fa-solid fa-key me-1"></i> Đang lưu trú</span>
                                        </c:when>
                                        <c:when test="${b.bookingStatus == 'CHECKED_OUT'}">
                                            <span class="badge bg-secondary-subtle text-secondary border border-secondary px-2 py-1"><i class="fa-solid fa-check-double me-1"></i> Đã hoàn thành</span>
                                        </c:when>
                                        <c:when test="${b.bookingStatus == 'CANCELLED'}">
                                            <span class="badge bg-danger-subtle text-danger border border-danger px-2 py-1"><i class="fa-solid fa-ban me-1"></i> Đã hủy</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-light text-dark border px-2 py-1">${b.bookingStatus}</span>
                                        </c:otherwise>
                                    </c:choose>
                                    <span class="text-muted small">Mã đơn: <strong>#${b.bookingCode}</strong></span>
                                </div>

                                <h5 class="fw-bold text-dark mb-1">${b.homestayName}</h5>
                                <p class="text-muted small mb-2"><i class="fa-solid fa-location-dot me-1 text-danger"></i>${b.homestayAddress}, ${b.homestayCity}</p>
                                <div class="badge bg-light text-dark border mb-2">${b.roomTypeName}</div>

                                <div class="d-flex flex-wrap gap-3 text-secondary small">
                                    <span><i class="fa-regular fa-calendar me-1"></i> Nhận: <strong><fmt:formatDate value="${b.checkinDate}" pattern="dd/MM/yyyy"/></strong></span>
                                    <span><i class="fa-regular fa-calendar-check me-1"></i> Trả: <strong><fmt:formatDate value="${b.checkoutDate}" pattern="dd/MM/yyyy"/></strong> (${b.totalNights} đêm)</span>
                                </div>
                            </div>

                            <!-- Price & Actions -->
                            <div class="col-md-3 text-md-end border-start-md">
                                <div class="mb-3">
                                    <small class="text-muted d-block">Tổng thanh toán</small>
                                    <span class="fs-4 fw-bold text-primary">
                                        <fmt:formatNumber value="${b.finalTotal}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                    </span>
                                </div>

                                <div class="d-flex flex-column gap-2">
                                    <c:if test="${b.bookingStatus == 'PENDING'}">
                                        <a href="${pageContext.request.contextPath}/payment/create?bookingId=${b.bookingId}" class="btn btn-primary-custom btn-sm rounded-3">
                                            <i class="fa-solid fa-credit-card me-1"></i> Thanh toán ngay
                                        </a>
                                    </c:if>

                                    <c:if test="${b.bookingStatus == 'CONFIRMED' || b.bookingStatus == 'CHECKED_IN'}">
                                        <button class="btn btn-outline-primary btn-sm rounded-3" data-bs-toggle="modal" data-bs-target="#qrModal_${b.bookingId}">
                                            <i class="fa-solid fa-qrcode me-1"></i> Xem Vé &amp; QR
                                        </button>
                                    </c:if>

                                    <a href="${pageContext.request.contextPath}/customer/booking-detail?id=${b.bookingId}" class="btn btn-outline-secondary btn-sm rounded-3">
                                        Chi tiết đơn đặt
                                    </a>

                                    <c:if test="${b.bookingStatus == 'PENDING' || b.bookingStatus == 'CONFIRMED'}">
                                        <button class="btn btn-link text-danger btn-sm text-decoration-none p-0 mt-1" 
                                                data-bs-toggle="modal" data-bs-target="#cancelModal_${b.bookingId}">
                                            Hủy đặt phòng
                                        </button>
                                    </c:if>

                                    <%-- UC10: "Viết đánh giá" — chỉ hiện cho CHECKED_OUT chưa review --%>
                                    <c:if test="${b.bookingStatus == 'CHECKED_OUT' and not reviewedBookingIds.contains(b.bookingId)}">
                                        <a href="${pageContext.request.contextPath}/customer/review?bookingId=${b.bookingId}"
                                           class="btn btn-warning btn-sm rounded-3 fw-semibold">
                                            <i class="fa-solid fa-star me-1"></i> Viết đánh giá
                                        </a>
                                    </c:if>

                                    <%-- UC10: Đã đánh giá → badge + nút Sửa --%>
                                    <c:if test="${b.bookingStatus == 'CHECKED_OUT' and reviewedBookingIds.contains(b.bookingId)}">
                                        <span class="badge bg-success-subtle text-success border border-success px-2 py-1">
                                            <i class="fa-solid fa-circle-check me-1"></i> Đã đánh giá
                                        </span>
                                        <a href="${pageContext.request.contextPath}/customer/review?bookingId=${b.bookingId}"
                                           class="btn btn-outline-primary btn-sm rounded-3">
                                            <i class="fa-solid fa-pen-to-square me-1"></i> Sửa đánh giá
                                        </a>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Modal QR Code -->
                <div class="modal fade" id="qrModal_${b.bookingId}" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content rounded-4 border-0 p-3">
                            <div class="modal-header border-0 pb-0">
                                <h5 class="modal-title fw-bold">Vé điện tử #${b.bookingCode}</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body text-center py-4">
                                <div class="p-3 bg-light rounded-4 d-inline-block border mb-3">
                                    <img src="https://api.qrserver.com/v1/create-qr-code/?size=180x180&data=${b.bookingCode}" alt="QR Checkin">
                                </div>
                                <h6 class="fw-bold text-dark mb-1">${b.homestayName}</h6>
                                <p class="text-muted small mb-0">Xuất trình mã QR này tại Bàn Lễ tân để Check-in nhanh không cần giấy tờ.</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Modal Cancel Booking -->
                <div class="modal fade" id="cancelModal_${b.bookingId}" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content rounded-4 border-0 p-4">
                            <div class="modal-header border-0 pb-0">
                                <h5 class="modal-title fw-bold text-danger"><i class="fa-solid fa-triangle-exclamation me-2"></i>Hủy đơn đặt #${b.bookingCode}</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <form action="${pageContext.request.contextPath}/customer/cancel-booking" method="POST">
                                <input type="hidden" name="bookingId" value="${b.bookingId}">
                                <div class="modal-body py-3">
                                    <p class="text-secondary small">Bạn có chắc chắn muốn hủy đơn đặt phòng này? Sau khi hủy, lịch phòng sẽ được mở lại cho khách hàng khác.</p>
                                    <div class="mb-3">
                                        <label class="form-label fw-semibold small">Lý do hủy phòng</label>
                                        <select name="reason" class="form-select form-select-sm">
                                            <option value="Thay đổi kế hoạch du lịch">Thay đổi kế hoạch du lịch</option>
                                            <option value="Tìm thấy chỗ nghỉ khác phù hợp hơn">Tìm thấy chỗ nghỉ khác phù hợp hơn</option>
                                            <option value="Đặt nhầm ngày hoặc thông tin phòng">Đặt nhầm ngày hoặc thông tin phòng</option>
                                            <option value="Lý do cá nhân / Sức khỏe">Lý do cá nhân / Sức khỏe</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="modal-footer border-0 pt-0">
                                    <button type="button" class="btn btn-secondary btn-sm rounded-pill px-3" data-bs-dismiss="modal">Đóng</button>
                                    <button type="submit" class="btn btn-danger btn-sm rounded-pill px-4">Xác nhận Hủy phòng</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <div class="card border-0 shadow-sm rounded-4 p-5 text-center my-4">
                <div class="rounded-circle bg-primary-subtle text-primary mx-auto d-flex align-items-center justify-content-center mb-3" style="width: 72px; height: 72px; font-size: 32px;">
                    <i class="fa-solid fa-receipt"></i>
                </div>
                <h4 class="fw-bold">Bạn chưa có đơn đặt phòng nào</h4>
                <p class="text-muted mb-4">Hãy khám phá các homestay nổi bật và đặt phòng để tận hưởng chuyến đi nghỉ dưỡng tuyệt vời!</p>
                <div>
                    <a href="${pageContext.request.contextPath}/search" class="btn btn-primary-custom px-4">
                        <i class="fa-solid fa-magnifying-glass me-2"></i>Tìm kiếm Homestay ngay
                    </a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="../common/footer.jsp"/>
