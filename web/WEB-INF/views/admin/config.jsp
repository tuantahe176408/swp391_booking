<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="container-fluid px-4 py-4">
    <div class="row">
        <!-- Sidebar Navigation -->
        <div class="col-lg-3">
            <jsp:include page="../common/sidebar-admin.jsp"/>
        </div>

        <!-- Main Content Area -->
        <div class="col-lg-9">
            <div class="card border-0 shadow-sm rounded-4 p-4 mb-4">
                <div class="d-flex align-items-center justify-content-between mb-4 border-bottom pb-3">
                    <div>
                        <h4 class="fw-bold mb-1 text-dark"><i class="fa-solid fa-sliders text-danger me-2"></i>UC24: Cấu hình System & AI Model Monitoring</h4>
                        <p class="text-muted mb-0">Thiết lập tỷ lệ phí hoa hồng sàn, thời gian tạm giữ phòng và giám sát mô hình AI Recommendation</p>
                    </div>
                </div>

                <div class="row g-4">
                    <div class="col-md-6">
                        <div class="card border rounded-4 p-3 h-100">
                            <h6 class="fw-bold mb-3"><i class="fa-solid fa-gears text-primary me-2"></i>Tham số Hệ thống Sàn</h6>
                            <form>
                                <div class="mb-3">
                                    <label class="form-label small fw-semibold">Tỷ lệ Phí Hoa hồng Sàn (%)</label>
                                    <input type="number" class="form-control" value="8.5" step="0.1">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label small fw-semibold">Thời gian Giữ phòng Tạm thời (Phút)</label>
                                    <input type="number" class="form-control" value="15">
                                </div>
                                <button type="button" class="btn btn-primary-custom btn-sm w-100">Lưu Tham số</button>
                            </form>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="card border border-warning rounded-4 p-3 h-100 bg-warning-subtle">
                            <h6 class="fw-bold mb-3 text-dark"><i class="fa-solid fa-brain text-warning me-2"></i>Giám sát AI Recommendation Engine</h6>
                            <div class="small">
                                <p class="mb-1"><strong>Trạng thái Model:</strong> <span class="badge bg-success">HEALTHY</span></p>
                                <p class="mb-1"><strong>Độ chính xác (Precision):</strong> 94.2%</p>
                                <p class="mb-3"><strong>Độ trễ phản hồi (Latency):</strong> 42ms</p>
                            </div>
                            <button type="button" class="btn btn-warning text-dark btn-sm fw-semibold w-100">
                                <i class="fa-solid fa-rotate me-1"></i> Trigger Retrain AI Model
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>
