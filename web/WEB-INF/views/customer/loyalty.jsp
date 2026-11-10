<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<style>
/* ── Tier badge colors ── */
.tier-badge-BRONZE   { background: linear-gradient(135deg,#cd7f32,#b87333); }
.tier-badge-SILVER   { background: linear-gradient(135deg,#9e9e9e,#c0c0c0); }
.tier-badge-GOLD     { background: linear-gradient(135deg,#f5a623,#f7c948); }
.tier-badge-PLATINUM { background: linear-gradient(135deg,#8b5cf6,#4f46e5); }

.loyalty-hero {
    border-radius: 24px;
    color: #fff;
    padding: 2rem 2.5rem;
    position: relative;
    overflow: hidden;
}
.loyalty-hero::before {
    content: '';
    position: absolute;
    top: -60px; right: -60px;
    width: 220px; height: 220px;
    border-radius: 50%;
    background: rgba(255,255,255,0.08);
}
.loyalty-hero::after {
    content: '';
    position: absolute;
    bottom: -80px; left: -40px;
    width: 180px; height: 180px;
    border-radius: 50%;
    background: rgba(255,255,255,0.05);
}
.balance-number {
    font-size: 3rem;
    font-weight: 900;
    line-height: 1;
    letter-spacing: -2px;
}
.tier-pill {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    font-size: 0.8rem;
    font-weight: 700;
    letter-spacing: .5px;
    text-transform: uppercase;
    padding: 4px 14px;
    border-radius: 50px;
    background: rgba(255,255,255,0.22);
    backdrop-filter: blur(4px);
}
.progress-tier {
    height: 8px;
    border-radius: 10px;
    background: rgba(255,255,255,0.25);
    overflow: hidden;
}
.progress-tier-bar {
    height: 100%;
    border-radius: 10px;
    background: rgba(255,255,255,0.85);
    transition: width 0.6s ease;
}
.info-card {
    background: #fff;
    border: 1px solid rgba(0,0,0,0.07);
    border-radius: 20px;
    padding: 1.5rem;
}
.rule-item {
    display: flex;
    align-items: flex-start;
    gap: 1rem;
    padding: 1rem 0;
    border-bottom: 1px solid rgba(0,0,0,0.06);
}
.rule-item:last-child { border-bottom: none; }
.rule-icon {
    width: 42px; height: 42px;
    border-radius: 12px;
    display: flex; align-items: center; justify-content: center;
    font-size: 1.1rem;
    flex-shrink: 0;
}
.tx-row { transition: background 0.15s; }
.tx-row:hover { background: rgba(99,102,241,0.03); }
.tx-earn    { color: #16a34a; }
.tx-redeem  { color: #dc2626; }
.tx-refund  { color: #2563eb; }
.tier-card {
    border-radius: 16px;
    padding: 1rem 1.25rem;
    text-align: center;
    border: 2px solid transparent;
    transition: all 0.2s;
}
.tier-card.current-tier { border-color: #6366f1; box-shadow: 0 4px 16px rgba(99,102,241,0.18); }
</style>

<div class="container py-4">
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/profile">Hồ sơ</a></li>
            <li class="breadcrumb-item active">Điểm thưởng Loyalty</li>
        </ol>
    </nav>

    <div class="row g-4">
        <!-- LEFT: Hero card + History -->
        <div class="col-lg-8">

            <%-- Hero card — color depends on tier --%>
            <div class="loyalty-hero tier-badge-${tier} mb-4">
                <div class="d-flex justify-content-between align-items-start mb-3 position-relative" style="z-index:1;">
                    <div>
                        <div class="tier-pill mb-2">
                            <c:choose>
                                <c:when test="${tier == 'PLATINUM'}">💎 Platinum</c:when>
                                <c:when test="${tier == 'GOLD'}">🥇 Gold</c:when>
                                <c:when test="${tier == 'SILVER'}">🥈 Silver</c:when>
                                <c:otherwise>🥉 Bronze</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="text-white-50 small mb-1">Điểm thưởng hiện có</div>
                        <div class="balance-number"><fmt:formatNumber value="${balance}" type="number"/></div>
                        <div class="text-white-50 small mt-1">điểm</div>
                    </div>
                    <div class="text-end">
                        <div class="text-white-50 small mb-1">Tổng tích lũy</div>
                        <div class="fw-bold fs-4"><fmt:formatNumber value="${totalEarned}" type="number"/> pts</div>
                    </div>
                </div>

                <%-- Progress to next tier --%>
                <div class="position-relative" style="z-index:1;">
                    <c:choose>
                        <c:when test="${nextThresh > 0}">
                            <div class="d-flex justify-content-between text-white-50 small mb-1">
                                <span>Tiến độ lên hạng tiếp theo</span>
                                <span><fmt:formatNumber value="${totalEarned}" type="number"/> / <fmt:formatNumber value="${nextThresh}" type="number"/> pts</span>
                            </div>
                            <div class="progress-tier">
                                <div class="progress-tier-bar" style="width:${progressPct}%;"></div>
                            </div>
                            <div class="text-white-50 small mt-1">
                                Cần thêm <strong class="text-white"><fmt:formatNumber value="${nextThresh - totalEarned}" type="number"/></strong> điểm để lên hạng
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="progress-tier">
                                <div class="progress-tier-bar" style="width:100%;"></div>
                            </div>
                            <div class="text-white-50 small mt-1">🎉 Bạn đã đạt hạng cao nhất — <strong class="text-white">PLATINUM!</strong></div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <%-- Transaction History --%>
            <div class="info-card">
                <h5 class="fw-bold mb-3"><i class="fa-solid fa-clock-rotate-left me-2 text-primary"></i>Lịch sử điểm thưởng</h5>

                <c:choose>
                    <c:when test="${empty history}">
                        <div class="text-center py-5 text-muted">
                            <i class="fa-solid fa-star fa-2x mb-3 d-block opacity-25"></i>
                            Chưa có giao dịch điểm nào. Hãy đặt phòng để bắt đầu tích điểm!
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="table table-borderless align-middle small">
                                <thead class="bg-light rounded-3">
                                    <tr>
                                        <th class="rounded-start ps-3">Ngày</th>
                                        <th>Mô tả</th>
                                        <th>Mã đặt phòng</th>
                                        <th class="text-end rounded-end pe-3">Điểm</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="tx" items="${history}">
                                        <tr class="tx-row">
                                            <td class="ps-3 text-muted">
                                                <fmt:formatDate value="${tx.createdAt}" pattern="dd/MM/yyyy"/>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${tx.transactionType == 'EARN'}">
                                                        <span class="badge bg-success-subtle text-success me-1"><i class="fa-solid fa-plus"></i></span>
                                                    </c:when>
                                                    <c:when test="${tx.transactionType == 'REDEEM'}">
                                                        <span class="badge bg-danger-subtle text-danger me-1"><i class="fa-solid fa-minus"></i></span>
                                                    </c:when>
                                                    <c:when test="${tx.transactionType == 'REFUND'}">
                                                        <span class="badge bg-info-subtle text-info me-1"><i class="fa-solid fa-rotate-left"></i></span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary-subtle text-secondary me-1"><i class="fa-solid fa-sliders"></i></span>
                                                    </c:otherwise>
                                                </c:choose>
                                                ${tx.description}
                                            </td>
                                            <td class="text-muted font-monospace">
                                                <c:if test="${not empty tx.bookingCode}">
                                                    <a href="${pageContext.request.contextPath}/customer/booking-detail?id=${tx.bookingId}"
                                                       class="text-decoration-none">${tx.bookingCode}</a>
                                                </c:if>
                                                <c:if test="${empty tx.bookingCode}">—</c:if>
                                            </td>
                                            <td class="text-end pe-3 fw-bold">
                                                <c:choose>
                                                    <c:when test="${tx.points > 0}">
                                                        <span class="tx-earn">+<fmt:formatNumber value="${tx.points}" type="number"/></span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="tx-redeem"><fmt:formatNumber value="${tx.points}" type="number"/></span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <%-- Pagination --%>
                        <c:if test="${totalPages > 1}">
                            <nav class="mt-3">
                                <ul class="pagination pagination-sm justify-content-center mb-0">
                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                        <a class="page-link rounded-3" href="?page=${currentPage - 1}">‹</a>
                                    </li>
                                    <c:forEach begin="1" end="${totalPages}" var="p">
                                        <li class="page-item ${p == currentPage ? 'active' : ''}">
                                            <a class="page-link rounded-3" href="?page=${p}">${p}</a>
                                        </li>
                                    </c:forEach>
                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                        <a class="page-link rounded-3" href="?page=${currentPage + 1}">›</a>
                                    </li>
                                </ul>
                            </nav>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- RIGHT: Rules + Tier table -->
        <div class="col-lg-4">

            <%-- How to earn --%>
            <div class="info-card mb-4">
                <h6 class="fw-bold mb-3"><i class="fa-solid fa-circle-info me-2 text-primary"></i>Cách tích & dùng điểm</h6>

                <div class="rule-item">
                    <div class="rule-icon bg-success-subtle text-success">
                        <i class="fa-solid fa-star"></i>
                    </div>
                    <div>
                        <div class="fw-semibold small">Tích điểm sau khi thanh toán</div>
                        <div class="text-muted" style="font-size:0.82rem;">1 điểm / 10,000 VND (đã xác nhận). Hạng cao hưởng nhân hệ số.</div>
                    </div>
                </div>

                <div class="rule-item">
                    <div class="rule-icon bg-warning-subtle text-warning">
                        <i class="fa-solid fa-ticket"></i>
                    </div>
                    <div>
                        <div class="fw-semibold small">Quy đổi điểm</div>
                        <div class="text-muted" style="font-size:0.82rem;">1 điểm = 100 VND giảm giá. Dùng tại bước Xác nhận đặt phòng.</div>
                    </div>
                </div>

                <div class="rule-item">
                    <div class="rule-icon bg-info-subtle text-info">
                        <i class="fa-solid fa-shield-halved"></i>
                    </div>
                    <div>
                        <div class="fw-semibold small">Giới hạn dùng điểm</div>
                        <div class="text-muted" style="font-size:0.82rem;">Tối thiểu 100 điểm (10,000 VND). Tối đa 20% giá trị đơn.</div>
                    </div>
                </div>

                <div class="rule-item">
                    <div class="rule-icon bg-danger-subtle text-danger">
                        <i class="fa-solid fa-rotate-left"></i>
                    </div>
                    <div>
                        <div class="fw-semibold small">Hoàn điểm khi hủy</div>
                        <div class="text-muted" style="font-size:0.82rem;">Điểm đã dùng được hoàn tự động nếu đơn bị hủy.</div>
                    </div>
                </div>
            </div>

            <%-- Tier table --%>
            <div class="info-card">
                <h6 class="fw-bold mb-3"><i class="fa-solid fa-trophy me-2 text-warning"></i>Bảng hạng thành viên</h6>
                <div class="row g-2">
                    <div class="col-6">
                        <div class="tier-card ${tier == 'BRONZE' ? 'current-tier' : ''}" style="background:linear-gradient(135deg,#fff8f0,#fdebd0);">
                            <div class="fs-4 mb-1">🥉</div>
                            <div class="fw-bold small text-warning-emphasis">Bronze</div>
                            <div style="font-size:0.72rem;" class="text-muted">0 – 999 pts</div>
                            <div style="font-size:0.72rem;" class="text-muted mt-1">×1.0 tích điểm</div>
                            <c:if test="${tier == 'BRONZE'}"><span class="badge bg-warning-subtle text-warning mt-1" style="font-size:.65rem;">Hạng hiện tại</span></c:if>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="tier-card ${tier == 'SILVER' ? 'current-tier' : ''}" style="background:linear-gradient(135deg,#f8f9fa,#e9ecef);">
                            <div class="fs-4 mb-1">🥈</div>
                            <div class="fw-bold small" style="color:#6c757d;">Silver</div>
                            <div style="font-size:0.72rem;" class="text-muted">1,000 – 4,999 pts</div>
                            <div style="font-size:0.72rem;" class="text-muted mt-1">×1.25 tích điểm</div>
                            <c:if test="${tier == 'SILVER'}"><span class="badge bg-secondary-subtle text-secondary mt-1" style="font-size:.65rem;">Hạng hiện tại</span></c:if>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="tier-card ${tier == 'GOLD' ? 'current-tier' : ''}" style="background:linear-gradient(135deg,#fffbeb,#fef3c7);">
                            <div class="fs-4 mb-1">🥇</div>
                            <div class="fw-bold small text-warning">Gold</div>
                            <div style="font-size:0.72rem;" class="text-muted">5,000 – 14,999 pts</div>
                            <div style="font-size:0.72rem;" class="text-muted mt-1">×1.5 tích điểm</div>
                            <c:if test="${tier == 'GOLD'}"><span class="badge bg-warning-subtle text-warning mt-1" style="font-size:.65rem;">Hạng hiện tại</span></c:if>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="tier-card ${tier == 'PLATINUM' ? 'current-tier' : ''}" style="background:linear-gradient(135deg,#f5f3ff,#ede9fe);">
                            <div class="fs-4 mb-1">💎</div>
                            <div class="fw-bold small text-primary">Platinum</div>
                            <div style="font-size:0.72rem;" class="text-muted">15,000+ pts</div>
                            <div style="font-size:0.72rem;" class="text-muted mt-1">×2.0 tích điểm</div>
                            <c:if test="${tier == 'PLATINUM'}"><span class="badge bg-primary-subtle text-primary mt-1" style="font-size:.65rem;">Hạng hiện tại</span></c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
