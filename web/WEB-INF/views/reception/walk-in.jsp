<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle"      value="Đặt phòng Khách Vãng lai"       scope="request"/>
<c:set var="pageBreadcrumb" value="Đón tiếp &amp; Quản lý Phòng"   scope="request"/>
<jsp:include page="../common/header.jsp"/>

<div class="owner-shell">
    <jsp:include page="../common/sidebar-reception.jsp"/>
    <div class="owner-main">
        <jsp:include page="../common/reception-topbar.jsp"/>
        <div class="owner-content">
            <div class="card border-0 shadow-sm rounded-4 p-4 mb-4">
                <div class="d-flex align-items-center justify-content-between mb-4 border-bottom pb-3">
                    <div>
                        <h4 class="fw-bold mb-1 text-dark"><i class="fa-solid fa-person-walking-luggage text-info me-2"></i>Đặt phòng tại quầy (Walk-in)</h4>
                        <p class="text-muted mb-0">Tạo đơn đặt chỗ và nhận phòng trực tiếp cho khách không qua đặt trước online</p>
                    </div>
                </div>

                <form>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Họ tên khách hàng</label>
                            <input type="text" class="form-control rounded-3" placeholder="Nguyễn Văn B" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Số điện thoại liên hệ</label>
                            <input type="tel" class="form-control rounded-3" placeholder="0912345678" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Chọn Hạng phòng khả dụng</label>
                            <select class="form-select rounded-3">
                                <option>P.102 - Standard King (800.000 VNĐ / đêm)</option>
                                <option>P.104 - Family Suite (1.500.000 VNĐ / đêm)</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-semibold">Số đêm ở</label>
                            <input type="number" class="form-control rounded-3" value="1" min="1">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-semibold">Hình thức thanh toán</label>
                            <select class="form-select rounded-3">
                                <option>Tiền mặt (Cash)</option>
                                <option>Quẹt thẻ POS</option>
                                <option>Chuyển khoản QR</option>
                            </select>
                        </div>

                        <div class="col-12 mt-4 pt-3 border-top d-flex justify-content-end gap-2">
                            <button type="reset" class="btn btn-outline-secondary px-4">Làm mới</button>
                            <button type="button" class="btn btn-info text-white px-4 fw-semibold"><i class="fa-solid fa-check me-1"></i> Tạo Đơn & Check-in Ngay</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>
