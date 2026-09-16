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
                        <h4 class="fw-bold mb-1 text-dark"><i class="fa-solid fa-broom text-info me-2"></i>UC16: Khai báo Tạm trú & Trạng thái Buồng phòng</h4>
                        <p class="text-muted mb-0">Danh sách khách lưu trú theo ngày và phân công lịch làm vệ sinh phòng</p>
                    </div>
                    <button class="btn btn-outline-success btn-sm rounded-pill fw-semibold">
                        <i class="fa-solid fa-file-excel me-1 text-success"></i> Xuất file Excel (.xlsx) Apache POI
                    </button>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>Mã phòng</th>
                                <th>Hạng phòng</th>
                                <th>Khách lưu trú</th>
                                <th>Số CCCD</th>
                                <th>Trạng thái Buồng</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><strong>P.101</strong></td>
                                <td>Deluxe View Biển</td>
                                <td>Nguyễn Văn A</td>
                                <td>012345678901</td>
                                <td><span class="badge bg-success">Clean & Ready</span></td>
                                <td><button class="btn btn-sm btn-outline-secondary">Đổi trạng thái</button></td>
                            </tr>
                            <tr>
                                <td><strong>P.103</strong></td>
                                <td>Superior Double</td>
                                <td>Trần Thị C</td>
                                <td>098765432109</td>
                                <td><span class="badge bg-warning text-dark">Needs Housekeeping</span></td>
                                <td><button class="btn btn-sm btn-success">Đánh dấu Đã dọn xong</button></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>
