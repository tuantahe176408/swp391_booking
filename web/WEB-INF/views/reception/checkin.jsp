<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="container-fluid px-4 py-4">
    <div class="row">
        <!-- Sidebar Navigation -->
        <div class="col-lg-3">
            <jsp:include page="../common/sidebar-reception.jsp"/>
        </div>

        <!-- Main Content Area -->
        <div class="col-lg-9">
            <div class="card border-0 shadow-sm rounded-4 p-4 mb-4">
                <div class="d-flex align-items-center justify-content-between mb-4 border-bottom pb-3">
                    <div>
                        <h4 class="fw-bold mb-1 text-dark"><i class="fa-solid fa-passport text-info me-2"></i>UC12: Quản lý Check-in & Quét CCCD OCR</h4>
                        <p class="text-muted mb-0">Xử lý thủ tục nhận/trả phòng nhanh chóng với công nghệ bóc tách dữ liệu CCCD/Passport tự động</p>
                    </div>
                    <span class="badge bg-info-subtle text-info border border-info px-3 py-2 fs-6">
                        <i class="fa-solid fa-hotel me-1"></i> Cơ sở: Beachfront Villa #1
                    </span>
                </div>

                <div class="row g-4">
                    <!-- Search & Checkin Form -->
                    <div class="col-md-7">
                        <div class="card border rounded-4 p-3 bg-light mb-4">
                            <h6 class="fw-bold mb-3"><i class="fa-solid fa-magnifying-glass me-2 text-primary"></i>Tra cứu mã đặt phòng / QR Code</h6>
                            <div class="input-group">
                                <input type="text" class="form-control" placeholder="Nhập mã đơn (VD: BK-882941) hoặc Số ĐT..." value="BK-882941">
                                <button class="btn btn-primary-custom" type="button"><i class="fa-solid fa-search me-1"></i> Tìm kiếm</button>
                            </div>
                        </div>

                        <!-- Booking Details Card -->
                        <div class="card border rounded-4 p-4">
                            <div class="d-flex align-items-center justify-content-between mb-3 border-bottom pb-2">
                                <h6 class="fw-bold mb-0 text-primary">Thông tin đơn hàng #BK-882941</h6>
                                <span class="badge bg-success">CONFIRMED</span>
                            </div>
                            <div class="row g-3 small">
                                <div class="col-6"><strong>Tên khách:</strong> Nguyễn Văn A</div>
                                <div class="col-6"><strong>Số điện thoại:</strong> 0987654321</div>
                                <div class="col-6"><strong>Hạng phòng:</strong> Deluxe Sea View (P.201)</div>
                                <div class="col-6"><strong>Thời gian lưu trú:</strong> 2 đêm (20/10 - 22/10)</div>
                                <div class="col-6"><strong>Tổng tiền:</strong> 2.450.000 VNĐ</div>
                                <div class="col-6"><strong>Thanh toán:</strong> <span class="badge bg-success-subtle text-success">Đã thanh toán VNPay</span></div>
                            </div>
                        </div>
                    </div>

                    <!-- OCR ID Scanning Card -->
                    <div class="col-md-5">
                        <div class="card border border-info border-2 rounded-4 p-4 text-center bg-white h-100">
                            <div class="rounded-circle bg-info-subtle text-info p-3 d-inline-flex align-items-center justify-content-center mb-3" style="width: 60px; height: 60px;">
                                <i class="fa-solid fa-camera-retro fs-3"></i>
                            </div>
                            <h6 class="fw-bold mb-2">OCR ID Card Scanner Service</h6>
                            <p class="text-muted small mb-3">Tải lên hoặc chụp ảnh CCCD để tự động trích xuất thông tin khách lưu trú</p>

                            <div class="border border-dashed rounded-3 p-3 bg-light mb-3">
                                <i class="fa-solid fa-cloud-arrow-up fs-2 text-muted mb-2"></i>
                                <small class="d-block text-muted">Kéo thả mặt trước CCCD vào đây</small>
                                <button class="btn btn-sm btn-outline-info mt-2" onclick="simulateOCR()"><i class="fa-solid fa-bolt me-1"></i> Chạy Giả lập OCR API</button>
                            </div>

                            <div id="ocrResult" class="text-start bg-light p-3 rounded-3 small border d-none">
                                <h6 class="fw-bold text-success mb-2"><i class="fa-solid fa-circle-check me-1"></i> Kết quả bóc tách OCR:</h6>
                                <p class="mb-1"><strong>Số CCCD:</strong> <span id="ocrId">012345678901</span></p>
                                <p class="mb-1"><strong>Họ tên:</strong> <span id="ocrName">NGUYỄN VĂN A</span></p>
                                <p class="mb-0"><strong>Ngày sinh:</strong> 15/08/1995</p>
                            </div>

                            <button class="btn btn-success rounded-3 w-100 mt-3 fw-semibold"><i class="fa-solid fa-key me-1"></i> Xác nhận Check-in & Giao phòng</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function simulateOCR() {
    const ocrResult = document.getElementById('ocrResult');
    ocrResult.classList.remove('d-none');
}
</script>

<jsp:include page="../common/footer.jsp"/>
