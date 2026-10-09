<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../common/header.jsp"/>

<div class="owner-shell">
    <jsp:include page="../common/sidebar-owner.jsp"/>

    <div class="owner-main">
        <jsp:include page="../common/owner-topbar.jsp"/>

        <div class="owner-content">

            <!-- Page Header -->
            <div class="owner-page-header">
                <div class="owner-page-header__info">
                    <h2><i class="fa-solid fa-list-check text-primary me-2"></i>Tất cả Đơn đặt phòng</h2>
                    <p>Lọc, tra cứu và theo dõi trạng thái toàn bộ đơn đặt phòng của bạn</p>
                </div>
                <a href="${pageContext.request.contextPath}/owner/analytics"
                   class="btn btn-outline-primary btn-sm rounded-3">
                    <i class="fa-solid fa-chart-pie me-1"></i>Xem thống kê
                </a>
            </div>

            <!-- Filter Card -->
            <div class="owner-card mb-4">
                <form method="get" action="${pageContext.request.contextPath}/owner/bookings"
                      class="row g-3 align-items-end">

                    <div class="col-sm-6 col-lg-3">
                        <label class="form-label fw-semibold" style="font-size:.82rem;">Cơ sở Homestay</label>
                        <select name="homestayId" class="form-select form-select-sm">
                            <option value="">Tất cả cơ sở</option>
                            <c:forEach var="hs" items="${myHomestays}">
                                <option value="${hs.homestayId}"
                                    <c:if test="${filterHomestayId == hs.homestayId}">selected</c:if>>
                                    ${hs.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-sm-6 col-lg-2">
                        <label class="form-label fw-semibold" style="font-size:.82rem;">Trạng thái</label>
                        <select name="status" class="form-select form-select-sm">
                            <option value="">Tất cả</option>
                            <option value="PENDING"     <c:if test="${filterStatus == 'PENDING'}">selected</c:if>>Chờ xác nhận</option>
                            <option value="CONFIRMED"   <c:if test="${filterStatus == 'CONFIRMED'}">selected</c:if>>Đã xác nhận</option>
                            <option value="CHECKED_IN"  <c:if test="${filterStatus == 'CHECKED_IN'}">selected</c:if>>Đang ở</option>
                            <option value="CHECKED_OUT" <c:if test="${filterStatus == 'CHECKED_OUT'}">selected</c:if>>Đã trả phòng</option>
                            <option value="CANCELLED"   <c:if test="${filterStatus == 'CANCELLED'}">selected</c:if>>Đã hủy</option>
                        </select>
                    </div>

                    <div class="col-sm-6 col-lg-2">
                        <label class="form-label fw-semibold" style="font-size:.82rem;">Check-in từ</label>
                        <input type="date" name="fromDate" class="form-control form-control-sm"
                               value="${not empty filterFromDate ? filterFromDate : ''}">
                    </div>

                    <div class="col-sm-6 col-lg-2">
                        <label class="form-label fw-semibold" style="font-size:.82rem;">Check-in đến</label>
                        <input type="date" name="toDate" class="form-control form-control-sm"
                               value="${not empty filterToDate ? filterToDate : ''}">
                    </div>

                    <div class="col-12 col-lg-3 d-flex gap-2">
                        <button type="submit" class="btn btn-primary-custom btn-sm flex-grow-1">
                            <i class="fa-solid fa-filter me-1"></i>Lọc kết quả
                        </button>
                        <a href="${pageContext.request.contextPath}/owner/bookings"
                           class="btn btn-outline-secondary btn-sm px-3">
                            <i class="fa-solid fa-rotate-left"></i>
                        </a>
                    </div>
                </form>
            </div>

            <!-- Summary badges -->
            <div class="d-flex align-items-center gap-3 mb-3 flex-wrap">
                <span class="text-muted" style="font-size:.85rem;">
                    Tìm thấy <strong class="text-dark">${totalRows}</strong> đơn đặt phòng
                </span>
                <c:if test="${not empty filterStatus}">
                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-2 py-1">
                        ${filterStatus}
                        <a href="${pageContext.request.contextPath}/owner/bookings?homestayId=${filterHomestayId}&fromDate=${filterFromDate}&toDate=${filterToDate}"
                           class="text-primary ms-1" style="text-decoration:none;">×</a>
                    </span>
                </c:if>
                <c:if test="${not empty filterFromDate || not empty filterToDate}">
                    <span class="badge bg-info-subtle text-info border border-info-subtle px-2 py-1">
                        <i class="fa-regular fa-calendar me-1"></i>
                        ${not empty filterFromDate ? filterFromDate : '...'}
                        →
                        ${not empty filterToDate ? filterToDate : '...'}
                    </span>
                </c:if>
            </div>

            <!-- Table -->
            <div class="owner-card p-0 overflow-hidden">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-4" style="width:40px;">#</th>
                                <th>Mã đặt phòng</th>
                                <th>Khách hàng</th>
                                <th>Cơ sở</th>
                                <th>Loại phòng</th>
                                <th>Check-in</th>
                                <th>Check-out</th>
                                <th>Tổng tiền</th>
                                <th>Trạng thái</th>
                                <th class="pe-4">Loại</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty bookings}">
                                    <tr>
                                        <td colspan="10" class="text-center py-5 text-muted">
                                            <i class="fa-solid fa-inbox fa-2x mb-2 d-block opacity-25"></i>
                                            Không tìm thấy đơn đặt phòng nào phù hợp với bộ lọc.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="b" items="${bookings}" varStatus="loop">
                                        <tr>
                                            <td class="ps-4 text-muted" style="font-size:.8rem;">
                                                ${(currentPage - 1) * 15 + loop.index + 1}
                                            </td>
                                            <td>
                                                <span class="fw-semibold text-primary" style="font-size:.85rem;font-family:monospace;">
                                                    ${b.bookingCode}
                                                </span>
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div style="width:30px;height:30px;border-radius:50%;background:linear-gradient(135deg,#6366f1,#8b5cf6);display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:.78rem;flex-shrink:0;">
                                                        ${not empty b.guestName ? b.guestName.substring(0,1).toUpperCase() : '?'}
                                                    </div>
                                                    <div>
                                                        <div class="fw-semibold" style="font-size:.84rem;">${b.guestName}</div>
                                                        <div class="text-muted" style="font-size:.74rem;">${b.guestPhone}</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td style="font-size:.83rem;">
                                                <div class="fw-semibold">${b.homestayName}</div>
                                                <div class="text-muted" style="font-size:.75rem;">${b.homestayCity}</div>
                                            </td>
                                            <td class="text-muted" style="font-size:.83rem;">${b.roomTypeName}</td>
                                            <td style="font-size:.83rem;">
                                                <fmt:formatDate value="${b.checkinDate}" pattern="dd/MM/yyyy"/>
                                            </td>
                                            <td style="font-size:.83rem;">
                                                <fmt:formatDate value="${b.checkoutDate}" pattern="dd/MM/yyyy"/>
                                                <div class="text-muted" style="font-size:.75rem;">${b.totalNights} đêm</div>
                                            </td>
                                            <td class="fw-semibold" style="font-size:.84rem;">
                                                <fmt:formatNumber value="${b.finalTotal}" type="number" groupingUsed="true"/> ₫
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${b.bookingStatus == 'PENDING'}">
                                                        <span class="badge bg-warning-subtle text-warning border border-warning px-2">Chờ xác nhận</span>
                                                    </c:when>
                                                    <c:when test="${b.bookingStatus == 'CONFIRMED'}">
                                                        <span class="badge bg-primary-subtle text-primary border border-primary px-2">Đã xác nhận</span>
                                                    </c:when>
                                                    <c:when test="${b.bookingStatus == 'CHECKED_IN'}">
                                                        <span class="badge bg-info-subtle text-info border border-info px-2">Đang ở</span>
                                                    </c:when>
                                                    <c:when test="${b.bookingStatus == 'CHECKED_OUT'}">
                                                        <span class="badge bg-success-subtle text-success border border-success px-2">Hoàn thành</span>
                                                    </c:when>
                                                    <c:when test="${b.bookingStatus == 'CANCELLED'}">
                                                        <span class="badge bg-danger-subtle text-danger border border-danger px-2">Đã hủy</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary px-2">${b.bookingStatus}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="pe-4">
                                                <c:choose>
                                                    <c:when test="${b.bookingType == 'WALK_IN'}">
                                                        <span class="badge bg-light text-dark border" style="font-size:.72rem;">
                                                            <i class="fa-solid fa-person-walking me-1"></i>Walk-in
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-light text-dark border" style="font-size:.72rem;">
                                                            <i class="fa-solid fa-globe me-1"></i>Online
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination footer -->
                <style>
                    .bk-pager { display: flex; align-items: center; gap: 6px; }
                    .bk-pager .bk-page {
                        display: inline-flex; align-items: center; justify-content: center;
                        min-width: 34px; height: 34px; padding: 0 8px;
                        border-radius: 9px; border: 1px solid #e2e8f0;
                        background: #fff; color: #475569; font-size: 14px; line-height: 1;
                        text-decoration: none; transition: all .15s ease;
                    }
                    .bk-pager .bk-page:hover {
                        background: #eef2ff; border-color: #6366f1; color: #6366f1;
                    }
                    .bk-pager .bk-page.active {
                        background: #6366f1; border-color: #6366f1; color: #fff;
                        pointer-events: none;
                    }
                    .bk-pager .bk-page.disabled {
                        opacity: .38; pointer-events: none;
                    }
                    .bk-pager .bk-ellipsis {
                        display: inline-flex; align-items: center; justify-content: center;
                        min-width: 34px; height: 34px; color: #94a3b8; font-size: 14px;
                        user-select: none;
                    }
                </style>
                <div class="d-flex align-items-center justify-content-between px-4 py-3 border-top flex-wrap gap-2">
                    <small class="text-muted">
                        Trang ${currentPage} / ${totalPages} &nbsp;·&nbsp; ${totalRows} đơn
                    </small>
                    <nav aria-label="Phân trang danh sách đơn">
                        <div class="bk-pager">
                            <!-- Prev -->
                            <a class="bk-page ${currentPage <= 1 ? 'disabled' : ''}"
                               aria-label="Trang trước"
                               href="${pageContext.request.contextPath}/owner/bookings?page=${currentPage - 1}&homestayId=${filterHomestayId}&status=${filterStatus}&fromDate=${filterFromDate}&toDate=${filterToDate}">
                                <i class="fa-solid fa-chevron-left"></i>
                            </a>

                            <c:choose>
                                <%-- Few pages: show all --%>
                                <c:when test="${totalPages <= 7}">
                                    <c:forEach begin="1" end="${totalPages}" var="p">
                                        <a class="bk-page ${p == currentPage ? 'active' : ''}"
                                           href="${pageContext.request.contextPath}/owner/bookings?page=${p}&homestayId=${filterHomestayId}&status=${filterStatus}&fromDate=${filterFromDate}&toDate=${filterToDate}">${p}</a>
                                    </c:forEach>
                                </c:when>
                                <%-- Many pages: sliding window around currentPage --%>
                                <%-- Window: [max(2,cur-1) .. min(total-1,cur+1)]  --%>
                                <c:otherwise>
                                    <c:set var="winStart" value="${currentPage - 1 > 2 ? currentPage - 1 : 2}"/>
                                    <c:set var="winEnd"   value="${currentPage + 1 < totalPages ? currentPage + 1 : totalPages - 1}"/>

                                    <%-- Page 1 always --%>
                                    <a class="bk-page ${1 == currentPage ? 'active' : ''}"
                                       href="${pageContext.request.contextPath}/owner/bookings?page=1&homestayId=${filterHomestayId}&status=${filterStatus}&fromDate=${filterFromDate}&toDate=${filterToDate}">1</a>

                                    <%-- Left ellipsis if window doesn't start at 2 --%>
                                    <c:if test="${winStart > 2}">
                                        <span class="bk-ellipsis">…</span>
                                    </c:if>

                                    <%-- Window pages --%>
                                    <c:forEach begin="${winStart}" end="${winEnd}" var="p">
                                        <a class="bk-page ${p == currentPage ? 'active' : ''}"
                                           href="${pageContext.request.contextPath}/owner/bookings?page=${p}&homestayId=${filterHomestayId}&status=${filterStatus}&fromDate=${filterFromDate}&toDate=${filterToDate}">${p}</a>
                                    </c:forEach>

                                    <%-- Right ellipsis if window doesn't reach totalPages-1 --%>
                                    <c:if test="${winEnd < totalPages - 1}">
                                        <span class="bk-ellipsis">…</span>
                                    </c:if>

                                    <%-- Last page always --%>
                                    <a class="bk-page ${totalPages == currentPage ? 'active' : ''}"
                                       href="${pageContext.request.contextPath}/owner/bookings?page=${totalPages}&homestayId=${filterHomestayId}&status=${filterStatus}&fromDate=${filterFromDate}&toDate=${filterToDate}">${totalPages}</a>
                                </c:otherwise>
                            </c:choose>

                            <!-- Next -->
                            <a class="bk-page ${currentPage >= totalPages ? 'disabled' : ''}"
                               aria-label="Trang sau"
                               href="${pageContext.request.contextPath}/owner/bookings?page=${currentPage + 1}&homestayId=${filterHomestayId}&status=${filterStatus}&fromDate=${filterFromDate}&toDate=${filterToDate}">
                                <i class="fa-solid fa-chevron-right"></i>
                            </a>
                        </div>
                    </nav>
                </div>
            </div>

        </div><!-- /.owner-content -->
    </div><!-- /.owner-main -->
</div><!-- /.owner-shell -->

<jsp:include page="../common/footer.jsp"/>
