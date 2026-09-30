<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle"      value="Quản lý Buồng phòng &amp; Dọn dẹp" scope="request"/>
<c:set var="pageBreadcrumb" value="Báo cáo &amp; Vệ sinh"               scope="request"/>
<jsp:include page="../common/header.jsp"/>

<div class="owner-shell">
    <jsp:include page="../common/sidebar-reception.jsp"/>
    <div class="owner-main">
        <jsp:include page="../common/reception-topbar.jsp"/>
        <div class="owner-content">
            <div class="card border-0 shadow-sm rounded-4 p-4 mb-4">
                <div class="d-flex align-items-center justify-content-between mb-4 border-bottom pb-3">
                    <div>
                        <h4 class="fw-bold mb-1 text-dark"><i class="fa-solid fa-broom text-warning me-2"></i>Quản lý Buồng phòng & Dọn dẹp</h4>
                        <p class="text-muted mb-0">Cập nhật trạng thái vệ sinh phòng và đánh dấu phòng sẵn sàng đón khách mới</p>
                    </div>
                </div>

                <!-- Status Filter Tabs -->
                <ul class="nav nav-pills mb-4">
                    <li class="nav-item"><a class="nav-link active" href="?status=HOUSEKEEPING">Cần dọn dẹp</a></li>
                    <li class="nav-item"><a class="nav-link" href="?status=AVAILABLE">Đã sẵn sàng</a></li>
                    <li class="nav-item"><a class="nav-link" href="?status=MAINTENANCE">Bảo trì</a></li>
                    <li class="nav-item"><a class="nav-link" href="?status=ALL">Tất cả phòng</a></li>
                </ul>

                <!-- Rooms Grid -->
                <c:choose>
                    <c:when test="${not empty rooms}">
                        <div class="row g-3">
                            <c:forEach var="room" items="${rooms}">
                                <div class="col-md-4">
                                    <div class="card border rounded-4 p-3 h-100">
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <div>
                                                <h6 class="fw-bold mb-0">Phòng ${room.roomNumber}</h6>
                                                <small class="text-muted">${room.roomTypeName}</small>
                                            </div>
                                            <c:choose>
                                                <c:when test="${room.status == 'HOUSEKEEPING'}">
                                                    <span class="badge bg-warning text-dark">Cần dọn</span>
                                                </c:when>
                                                <c:when test="${room.status == 'AVAILABLE'}">
                                                    <span class="badge bg-success">Sẵn sàng</span>
                                                </c:when>
                                                <c:when test="${room.status == 'OCCUPIED'}">
                                                    <span class="badge bg-danger">Đang ở</span>
                                                </c:when>
                                                <c:when test="${room.status == 'MAINTENANCE'}">
                                                    <span class="badge bg-secondary">Bảo trì</span>
                                                </c:when>
                                            </c:choose>
                                        </div>
                                        <c:if test="${not empty room.notes}">
                                            <p class="text-muted small mb-2">${room.notes}</p>
                                        </c:if>
                                        <div class="d-flex gap-2 mt-auto">
                                            <c:if test="${room.status == 'HOUSEKEEPING'}">
                                                <form action="${pageContext.request.contextPath}/reception/housekeeping" method="POST" class="flex-grow-1">
                                                    <input type="hidden" name="roomId" value="${room.roomId}">
                                                    <input type="hidden" name="action" value="markReady">
                                                    <button type="submit" class="btn btn-sm btn-success w-100 fw-semibold">
                                                        <i class="fa-solid fa-check me-1"></i>Đã dọn xong
                                                    </button>
                                                </form>
                                            </c:if>
                                            <c:if test="${room.status == 'AVAILABLE'}">
                                                <form action="${pageContext.request.contextPath}/reception/housekeeping" method="POST" class="flex-grow-1">
                                                    <input type="hidden" name="roomId" value="${room.roomId}">
                                                    <input type="hidden" name="action" value="markHousekeeping">
                                                    <button type="submit" class="btn btn-sm btn-outline-warning w-100">
                                                        <i class="fa-solid fa-broom me-1"></i>Đánh dấu dọn dẹp
                                                    </button>
                                                </form>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Mẫu static khi chưa có data -->
                        <div class="row g-3">
                            <div class="col-md-4">
                                <div class="card border rounded-4 p-3">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <div><h6 class="fw-bold mb-0">Phòng 101</h6><small class="text-muted">Deluxe Sea View</small></div>
                                        <span class="badge bg-warning text-dark">Cần dọn</span>
                                    </div>
                                    <p class="text-muted small mb-2">Khách vừa check-out lúc 11:30</p>
                                    <button class="btn btn-sm btn-success w-100 fw-semibold"><i class="fa-solid fa-check me-1"></i>Đã dọn xong</button>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card border rounded-4 p-3">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <div><h6 class="fw-bold mb-0">Phòng 205</h6><small class="text-muted">Family Suite</small></div>
                                        <span class="badge bg-success">Sẵn sàng</span>
                                    </div>
                                    <p class="text-muted small mb-2">Đã vệ sinh lúc 13:00</p>
                                    <button class="btn btn-sm btn-outline-warning w-100"><i class="fa-solid fa-broom me-1"></i>Đánh dấu dọn dẹp</button>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card border rounded-4 p-3">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <div><h6 class="fw-bold mb-0">Phòng 312</h6><small class="text-muted">Standard Twin</small></div>
                                        <span class="badge bg-secondary">Bảo trì</span>
                                    </div>
                                    <p class="text-muted small mb-2">Đang sửa điều hòa</p>
                                </div>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
