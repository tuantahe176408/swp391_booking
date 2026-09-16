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
                        <h4 class="fw-bold mb-1 text-dark"><i class="fa-solid fa-table-cells text-info me-2"></i>UC14: Ma trận Trạng thái Phòng (Room Matrix Grid)</h4>
                        <p class="text-muted mb-0">Theo dõi trực quan thời gian thực tình trạng toàn bộ các phòng tại Homestay</p>
                    </div>
                    <button class="btn btn-outline-secondary btn-sm rounded-pill"><i class="fa-solid fa-rotate me-1"></i> AJAX Polling Live</button>
                </div>

                <!-- Legend status badges -->
                <div class="d-flex flex-wrap gap-3 mb-4 p-3 bg-light rounded-3 border">
                    <span class="badge bg-success px-3 py-2"><i class="fa-solid fa-circle me-1"></i> Trống (AVAILABLE): 12</span>
                    <span class="badge bg-danger px-3 py-2"><i class="fa-solid fa-circle me-1"></i> Đang ở (OCCUPIED): 8</span>
                    <span class="badge bg-warning text-dark px-3 py-2"><i class="fa-solid fa-circle me-1"></i> Cần dọn dẹp (CLEANING): 3</span>
                    <span class="badge bg-secondary px-3 py-2"><i class="fa-solid fa-circle me-1"></i> Bảo trì (MAINTENANCE): 1</span>
                </div>

                <!-- Room Grid -->
                <div class="row g-3">
                    <div class="col-6 col-md-3">
                        <div class="card border-2 border-danger rounded-4 p-3 text-center shadow-sm">
                            <span class="badge bg-danger mb-2 align-self-center">OCCUPIED</span>
                            <h4 class="fw-bold text-dark mb-1">P.101</h4>
                            <small class="text-muted">Deluxe View Biển</small>
                            <div class="mt-2 pt-2 border-top small text-secondary">Khách: N.V.A</div>
                        </div>
                    </div>

                    <div class="col-6 col-md-3">
                        <div class="card border-2 border-success rounded-4 p-3 text-center shadow-sm">
                            <span class="badge bg-success mb-2 align-self-center">AVAILABLE</span>
                            <h4 class="fw-bold text-dark mb-1">P.102</h4>
                            <small class="text-muted">Standard King</small>
                            <div class="mt-2 pt-2 border-top small text-success">Sẵn sàng đón khách</div>
                        </div>
                    </div>

                    <div class="col-6 col-md-3">
                        <div class="card border-2 border-warning rounded-4 p-3 text-center shadow-sm">
                            <span class="badge bg-warning text-dark mb-2 align-self-center">CLEANING</span>
                            <h4 class="fw-bold text-dark mb-1">P.103</h4>
                            <small class="text-muted">Superior Double</small>
                            <div class="mt-2 pt-2 border-top small text-warning fw-semibold">Buồng phòng đang dọn</div>
                        </div>
                    </div>

                    <div class="col-6 col-md-3">
                        <div class="card border-2 border-success rounded-4 p-3 text-center shadow-sm">
                            <span class="badge bg-success mb-2 align-self-center">AVAILABLE</span>
                            <h4 class="fw-bold text-dark mb-1">P.104</h4>
                            <small class="text-muted">Family Suite</small>
                            <div class="mt-2 pt-2 border-top small text-success">Sẵn sàng đón khách</div>
                        </div>
                    </div>

                    <div class="col-6 col-md-3">
                        <div class="card border-2 border-danger rounded-4 p-3 text-center shadow-sm">
                            <span class="badge bg-danger mb-2 align-self-center">OCCUPIED</span>
                            <h4 class="fw-bold text-dark mb-1">P.201</h4>
                            <small class="text-muted">Executive Sea View</small>
                            <div class="mt-2 pt-2 border-top small text-secondary">Khách: T.V.B</div>
                        </div>
                    </div>

                    <div class="col-6 col-md-3">
                        <div class="card border-2 border-secondary rounded-4 p-3 text-center shadow-sm">
                            <span class="badge bg-secondary mb-2 align-self-center">MAINTENANCE</span>
                            <h4 class="fw-bold text-dark mb-1">P.202</h4>
                            <small class="text-muted">Standard Twin</small>
                            <div class="mt-2 pt-2 border-top small text-muted">Sửa điều hòa</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>
