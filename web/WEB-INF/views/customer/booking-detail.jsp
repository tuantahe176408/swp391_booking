<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="container py-5">
    <div class="d-flex align-items-center justify-content-between mb-4">
        <div>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-1">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/customer/bookings">Đơn đặt phòng</a></li>
                    <li class="breadcrumb-item active" aria-current="page">#${booking.bookingCode}</li>
                </ol>
            </nav>
            <h3 class="fw-bold mb-0">Chi tiết đơn đặt phòng #${booking.bookingCode}</h3>
        </div>
        <a href="${pageContext.request.contextPath}/customer/bookings" class="btn btn-outline-secondary btn-sm rounded-pill px-3">
            <i class="fa-solid fa-arrow-left me-1"></i> Quay lại danh sách
        </a>
    </div>

    <div class="row g-4">
        <!-- Main details -->
        <div class="col-lg-8">
            <!-- Property & Room Card -->
            <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4">
                <div class="card-body p-4">
                    <div class="d-flex flex-wrap align-items-center justify-content-between gap-2 mb-3">
                        <span class="badge bg-primary-subtle text-primary border border-primary px-3 py-2 fs-6">
                            <i class="fa-solid fa-hotel me-1"></i> ${booking.roomTypeName}
                        </span>
                        <div>
                            <c:choose>
                                <c:when test="${booking.bookingStatus == 'CONFIRMED'}">
                                    <span class="badge bg-success text-white px-3 py-2"><i class="fa-solid fa-circle-check me-1"></i> Đã xác nhận</span>
                                </c:when>
                                <c:when test="${booking.bookingStatus == 'PENDING'}">
                                    <span class="badge bg-warning text-dark px-3 py-2"><i class="fa-solid fa-clock me-1"></i> Chờ thanh toán</span>
                                </c:when>
                                <c:when test="${booking.bookingStatus == 'CHECKED_IN'}">
                                    <span class="badge bg-info text-white px-3 py-2"><i class="fa-solid fa-key me-1"></i> Đang lưu trú</span>
                                </c:when>
                                <c:when test="${booking.bookingStatus == 'CHECKED_OUT'}">
                                    <span class="badge bg-secondary text-white px-3 py-2"><i class="fa-solid fa-check-double me-1"></i> Đã hoàn thành</span>
                                </c:when>
                                <c:when test="${booking.bookingStatus == 'CANCELLED'}">
                                    <span class="badge bg-danger text-white px-3 py-2"><i class="fa-solid fa-ban me-1"></i> Đã hủy</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-light text-dark border px-3 py-2">${booking.bookingStatus}</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <h4 class="fw-bold mb-2">${booking.homestayName}</h4>
                    <p class="text-muted mb-4"><i class="fa-solid fa-location-dot me-2 text-danger"></i>${booking.homestayAddress}, ${booking.homestayCity}</p>

                    <div class="row g-3 p-3 bg-light rounded-4 mb-4">
                        <div class="col-sm-6">
                            <small class="text-muted d-block mb-1">Ngày nhận phòng</small>
                            <div class="fw-bold text-dark fs-5">
                                <i class="fa-regular fa-calendar-days text-primary me-2"></i>
                                <fmt:formatDate value="${booking.checkinDate}" pattern="dd/MM/yyyy"/>
                            </div>
                            <small class="text-muted">Từ 14:00</small>
                        </div>
                        <div class="col-sm-6 border-start-sm">
                            <small class="text-muted d-block mb-1">Ngày trả phòng</small>
                            <div class="fw-bold text-dark fs-5">
                                <i class="fa-regular fa-calendar-check text-success me-2"></i>
                                <fmt:formatDate value="${booking.checkoutDate}" pattern="dd/MM/yyyy"/>
                            </div>
                            <small class="text-muted">Trước 12:00 (${booking.totalNights} đêm)</small>
                        </div>
                    </div>

                    <h5 class="fw-bold mb-3">Thông tin khách hàng</h5>
                    <div class="row g-3 text-secondary small">
                        <div class="col-md-4">
                            <div class="text-muted">Họ và tên</div>
                            <div class="fw-bold text-dark">${booking.guestName}</div>
                        </div>
                        <div class="col-md-4">
                            <div class="text-muted">Email</div>
                            <div class="fw-bold text-dark">${booking.guestEmail}</div>
                        </div>
                        <div class="col-md-4">
                            <div class="text-muted">Số điện thoại</div>
                            <div class="fw-bold text-dark">${booking.guestPhone}</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- UC10: Review Section -->
            <c:if test="${booking.bookingStatus == 'CHECKED_OUT'}">
                <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4">
                    <div class="card-body p-4">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="fw-bold mb-0">
                                <i class="fa-solid fa-star me-2 text-warning"></i>Đánh giá của bạn
                            </h5>
                            <%-- Create button: only when no review yet --%>
                            <c:if test="${empty review}">
                                <a href="${pageContext.request.contextPath}/customer/review?bookingId=${booking.bookingId}"
                                   class="btn btn-warning btn-sm rounded-pill px-3 fw-semibold">
                                    <i class="fa-solid fa-pen-to-square me-1"></i> Viết đánh giá
                                </a>
                            </c:if>
                            <%-- Edit button: only when review already exists --%>
                            <c:if test="${not empty review}">
                                <a href="${pageContext.request.contextPath}/customer/review?bookingId=${booking.bookingId}"
                                   class="btn btn-outline-primary btn-sm rounded-pill px-3 fw-semibold">
                                    <i class="fa-solid fa-pen-to-square me-1"></i> Sửa đánh giá
                                </a>
                            </c:if>
                        </div>

                        <c:choose>
                            <%-- ── Đã có review: hiển thị đầy đủ ── --%>
                            <c:when test="${not empty review}">
                                <%-- Dimension ratings grid --%>
                                <div class="row g-2 mb-3">
                                    <div class="col-6 col-md-3">
                                        <div class="p-2 bg-light rounded-3 text-center">
                                            <div class="text-muted small mb-1">Vệ sinh</div>
                                            <div class="fw-bold text-warning">${review.ratingCleanliness} <i class="fa-solid fa-star small"></i></div>
                                        </div>
                                    </div>
                                    <div class="col-6 col-md-3">
                                        <div class="p-2 bg-light rounded-3 text-center">
                                            <div class="text-muted small mb-1">Dịch vụ</div>
                                            <div class="fw-bold text-warning">${review.ratingService} <i class="fa-solid fa-star small"></i></div>
                                        </div>
                                    </div>
                                    <div class="col-6 col-md-3">
                                        <div class="p-2 bg-light rounded-3 text-center">
                                            <div class="text-muted small mb-1">Vị trí</div>
                                            <div class="fw-bold text-warning">${review.ratingLocation} <i class="fa-solid fa-star small"></i></div>
                                        </div>
                                    </div>
                                    <div class="col-6 col-md-3">
                                        <div class="p-2 bg-light rounded-3 text-center">
                                            <div class="text-muted small mb-1">Giá trị</div>
                                            <div class="fw-bold text-warning">${review.ratingValue} <i class="fa-solid fa-star small"></i></div>
                                        </div>
                                    </div>
                                </div>

                                <%-- Overall score --%>
                                <div class="d-flex align-items-center gap-3 mb-3 p-3 rounded-3" style="background:#fffbeb;">
                                    <div class="display-6 fw-bold text-warning">${review.ratingOverall}</div>
                                    <div>
                                        <div class="text-warning mb-1">
                                            <c:set var="rvFull" value="${review.ratingOverall - (review.ratingOverall mod 1)}"/>
                                            <c:set var="rvHalf" value="${(review.ratingOverall mod 1) >= 0.3}"/>
                                            <c:forEach begin="1" end="${rvFull}"><i class="fa-solid fa-star"></i></c:forEach>
                                            <c:if test="${rvHalf}"><i class="fa-solid fa-star-half-stroke"></i></c:if>
                                        </div>
                                        <small class="text-muted">
                                            Gửi lúc <fmt:formatDate value="${review.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </small>
                                    </div>
                                </div>

                                <%-- Comment --%>
                                <blockquote class="blockquote bg-light rounded-3 p-3 mb-3 border-start border-warning border-3">
                                    <p class="mb-0 text-secondary fst-italic">"${review.comment}"</p>
                                </blockquote>

                                <%-- Owner reply (if exists) --%>
                                <c:if test="${not empty review.ownerReply}">
                                    <div class="p-3 rounded-3 border" style="background:#f0fdf4;">
                                        <div class="d-flex align-items-center gap-2 mb-2">
                                            <i class="fa-solid fa-house-user text-success"></i>
                                            <span class="fw-semibold text-success small">Phản hồi từ Chủ nhà</span>
                                            <small class="text-muted ms-auto">
                                                <fmt:formatDate value="${review.ownerRepliedAt}" pattern="dd/MM/yyyy"/>
                                            </small>
                                        </div>
                                        <p class="mb-0 text-secondary small">${review.ownerReply}</p>
                                    </div>
                                </c:if>
                            </c:when>

                            <%-- ── Chưa có review ── --%>
                            <c:otherwise>
                                <div class="text-center py-3 text-muted">
                                    <i class="fa-regular fa-star fa-2x mb-2 d-block text-warning"></i>
                                    <p class="mb-1">Bạn chưa gửi đánh giá cho kỳ lưu trú này.</p>
                                    <small>Đánh giá giúp các du khách khác lựa chọn tốt hơn và hỗ trợ chủ nhà cải thiện dịch vụ.</small>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:if>

            <!-- Payment History -->
            <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                <div class="card-body p-4">
                    <h5 class="fw-bold mb-3"><i class="fa-solid fa-receipt me-2 text-primary"></i>Lịch sử giao dịch thanh toán</h5>
                    <c:choose>
                        <c:when test="${not empty payments}">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light small text-muted">
                                        <tr>
                                            <th>Mã GD</th>
                                            <th>Phương thức</th>
                                            <th>Loại GD</th>
                                            <th>Số tiền</th>
                                            <th>Trạng thái</th>
                                            <th>Thời gian</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="p" items="${payments}">
                                            <tr>
                                                <td class="fw-semibold"><code>${p.transactionCode != null ? p.transactionCode : 'N/A'}</code></td>
                                                <td><span class="badge bg-light text-dark border">${p.paymentMethod}</span></td>
                                                <td><small class="text-muted">${p.paymentType}</small></td>
                                                <td class="fw-bold text-primary">
                                                    <fmt:formatNumber value="${p.amount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${p.paymentStatus == 'SUCCESS'}">
                                                            <span class="badge bg-success-subtle text-success">Thành công</span>
                                                        </c:when>
                                                        <c:when test="${p.paymentStatus == 'PENDING'}">
                                                            <span class="badge bg-warning-subtle text-warning">Đang xử lý</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-danger-subtle text-danger">${p.paymentStatus}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td><small class="text-muted"><fmt:formatDate value="${p.createdAt}" pattern="dd/MM/yyyy HH:mm"/></small></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted mb-0">Chưa có giao dịch thanh toán nào được ghi nhận cho đơn đặt này.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- Sidebar Summary -->
        <div class="col-lg-4">
            <!-- Price Summary Card -->
            <div class="card border-0 shadow-sm rounded-4 p-4 mb-4">
                <h5 class="fw-bold mb-3">Tóm tắt thanh toán</h5>
                <div class="d-flex justify-content-between mb-2">
                    <span class="text-muted">Tiền phòng (${booking.totalNights} đêm)</span>
                    <span class="fw-semibold"><fmt:formatNumber value="${booking.roomPriceTotal}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
                </div>
                <c:if test="${booking.addonPriceTotal > 0}">
                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted">Dịch vụ gia tăng</span>
                        <span class="fw-semibold"><fmt:formatNumber value="${booking.addonPriceTotal}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
                    </div>
                </c:if>
                <c:if test="${booking.surchargeTotal > 0}">
                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted">Phụ phí phát sinh</span>
                        <span class="fw-semibold"><fmt:formatNumber value="${booking.surchargeTotal}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
                    </div>
                </c:if>
                <c:if test="${booking.discountAmount > 0}">
                    <div class="d-flex justify-content-between mb-2 text-success">
                        <span>Giảm giá Voucher</span>
                        <span class="fw-semibold">-<fmt:formatNumber value="${booking.discountAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
                    </div>
                </c:if>
                <hr>
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <span class="fw-bold fs-6">Tổng cộng</span>
                    <span class="fs-4 fw-bold text-primary">
                        <fmt:formatNumber value="${booking.finalTotal}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                    </span>
                </div>

                <!-- QR Check-in Box -->
                <div class="p-3 bg-light rounded-4 text-center mb-3 border">
                    <h6 class="fw-bold mb-2"><i class="fa-solid fa-qrcode text-primary me-1"></i> Mã QR Check-in</h6>
                    <img src="https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=${booking.bookingCode}" alt="QR Check-in" class="mb-2">
                    <div class="small text-muted">Mã vé: <strong>#${booking.bookingCode}</strong></div>
                </div>

                <div class="d-grid gap-2">
                    <c:if test="${booking.bookingStatus == 'PENDING'}">
                        <a href="${pageContext.request.contextPath}/payment?bookingId=${booking.bookingId}" class="btn btn-primary-custom py-2">
                            <i class="fa-solid fa-credit-card me-1"></i> Tiếp tục thanh toán
                        </a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>
