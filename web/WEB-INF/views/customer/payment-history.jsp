<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="fw-bold mb-0"><i class="fa-solid fa-receipt text-primary me-2"></i>Lịch sử giao dịch thanh toán</h4>
    </div>

    <c:choose>
        <c:when test="${not empty payments}">
            <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Mã giao dịch</th>
                                <th>Mã đặt phòng</th>
                                <th>Homestay</th>
                                <th>Số tiền</th>
                                <th>Cổng TT</th>
                                <th>Thời gian</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${payments}">
                                <tr>
                                    <td><span class="font-monospace text-muted small">${p.transactionCode}</span></td>
                                    <td><span class="badge bg-primary-subtle text-primary font-monospace">${p.bookingCode}</span></td>
                                    <td>${p.homestayName}</td>
                                    <td class="fw-bold"><fmt:formatNumber value="${p.amount}" type="number"/>₫</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${p.gateway == 'VNPAY'}"><span class="badge bg-info-subtle text-info border">VNPay</span></c:when>
                                            <c:when test="${p.gateway == 'MOMO'}"><span class="badge bg-danger-subtle text-danger border">MoMo</span></c:when>
                                            <c:otherwise><span class="badge bg-secondary-subtle text-secondary border">${p.gateway}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-muted small">${p.createdAt}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${p.status == 'SUCCESS'}"><span class="badge bg-success">Thành công</span></c:when>
                                            <c:when test="${p.status == 'FAILED'}"><span class="badge bg-danger">Thất bại</span></c:when>
                                            <c:when test="${p.status == 'PENDING'}"><span class="badge bg-warning">Chờ xử lý</span></c:when>
                                            <c:otherwise><span class="badge bg-secondary">${p.status}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="text-center py-5">
                <i class="fa-solid fa-receipt fs-1 text-muted mb-3"></i>
                <h5 class="fw-bold">Chưa có giao dịch nào</h5>
                <p class="text-muted">Lịch sử thanh toán sẽ xuất hiện tại đây sau khi bạn đặt phòng.</p>
                <a href="${pageContext.request.contextPath}/search" class="btn btn-primary-custom">Tìm phòng ngay</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
