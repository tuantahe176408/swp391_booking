<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="container py-5">
    <div class="d-flex align-items-center justify-content-between mb-4">
        <div>
            <h3 class="fw-bold mb-1"><i class="fa-solid fa-receipt text-primary me-2"></i>UC09: Danh sách đơn đặt phòng</h3>
            <p class="text-muted mb-0">Quản lý lịch sử đặt chỗ, mã QR check-in và gửi yêu cầu hủy/hoàn tiền tự động</p>
        </div>
        <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-primary btn-sm rounded-pill">
            <i class="fa-solid fa-plus me-1"></i> Đặt phòng mới
        </a>
    </div>

    <!-- Booking Item Card 1 -->
    <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4">
        <div class="card-body p-4">
            <div class="row align-items-center g-4">
                <div class="col-md-3">
                    <img src="https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=600&q=80" class="img-fluid rounded-3 object-fit-cover w-100" style="height: 140px;" alt="Homestay">
                </div>
                <div class="col-md-6">
                    <div class="d-flex align-items-center gap-2 mb-2">
                        <span class="badge bg-success-subtle text-success border border-success px-2 py-1"><i class="fa-solid fa-circle-check me-1"></i> Đã xác nhận (CONFIRMED)</span>
                        <span class="text-muted small">Mã đơn: <strong>#BK-882941</strong></span>
                    </div>
                    <h5 class="fw-bold text-dark mb-1">Ocean Breeze Luxury Homestay Đà Nẵng</h5>
                    <p class="text-muted small mb-2"><i class="fa-solid fa-location-dot me-1 text-danger"></i> Võ Nguyên Giáp, Sơn Trà, Đà Nẵng</p>
                    <div class="d-flex flex-wrap gap-3 text-secondary small">
                        <span><i class="fa-regular fa-calendar me-1"></i> Nhận phòng: <strong>20/10/2026</strong></span>
                        <span><i class="fa-regular fa-calendar-check me-1"></i> Trả phòng: <strong>22/10/2026</strong> (2 đêm)</span>
                    </div>
                </div>
                <div class="col-md-3 text-md-end border-start-md">
                    <div class="mb-3">
                        <small class="text-muted d-block">Tổng thanh toán</small>
                        <span class="fs-4 fw-bold text-primary">2.450.000 VNĐ</span>
                    </div>
                    <div class="d-flex flex-column gap-2">
                        <button class="btn btn-outline-primary btn-sm rounded-3" data-bs-toggle="modal" data-bs-target="#qrModal1">
                            <i class="fa-solid fa-qrcode me-1"></i> Xem Vé & QR Check-in
                        </button>
                        <button class="btn btn-link text-danger btn-sm text-decoration-none">Hủy & Hoàn tiền</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Booking Item Card 2 -->
    <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4">
        <div class="card-body p-4">
            <div class="row align-items-center g-4">
                <div class="col-md-3">
                    <img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=600&q=80" class="img-fluid rounded-3 object-fit-cover w-100" style="height: 140px;" alt="Homestay">
                </div>
                <div class="col-md-6">
                    <div class="d-flex align-items-center gap-2 mb-2">
                        <span class="badge bg-secondary-subtle text-secondary border border-secondary px-2 py-1"><i class="fa-solid fa-clock-rotate-left me-1"></i> Hoàn thành (COMPLETED)</span>
                        <span class="text-muted small">Mã đơn: <strong>#BK-771209</strong></span>
                    </div>
                    <h5 class="fw-bold text-dark mb-1">Dalat Pine Hill View Homestay</h5>
                    <p class="text-muted small mb-2"><i class="fa-solid fa-location-dot me-1 text-danger"></i> Đường Hùng Vương, Phường 10, Đà Lạt</p>
                    <div class="d-flex flex-wrap gap-3 text-secondary small">
                        <span><i class="fa-regular fa-calendar me-1"></i> Nhận phòng: <strong>05/09/2026</strong></span>
                        <span><i class="fa-regular fa-calendar-check me-1"></i> Trả phòng: <strong>07/09/2026</strong></span>
                    </div>
                </div>
                <div class="col-md-3 text-md-end border-start-md">
                    <div class="mb-3">
                        <small class="text-muted d-block">Tổng thanh toán</small>
                        <span class="fs-4 fw-bold text-dark">1.800.000 VNĐ</span>
                    </div>
                    <a href="${pageContext.request.contextPath}/customer/bookings" class="btn btn-warning text-dark btn-sm rounded-3 fw-semibold">
                        <i class="fa-solid fa-star me-1"></i> Viết Đánh giá (UC10)
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal QR Code -->
<div class="modal fade" id="qrModal1" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content rounded-4 border-0 p-3">
            <div class="modal-header border-0 pb-0">
                <h5 class="modal-title fw-bold">Vé điện tử #BK-882941</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body text-center py-4">
                <div class="p-3 bg-light rounded-4 d-inline-block border mb-3">
                    <img src="https://api.qrserver.com/v1/create-qr-code/?size=180x180&data=BK-882941" alt="QR Checkin">
                </div>
                <h6 class="fw-bold text-dark mb-1">Ocean Breeze Luxury Homestay</h6>
                <p class="text-muted small mb-0">Vui lòng xuất trình mã QR này tại Bàn Lễ tân để Check-in nhanh.</p>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>
