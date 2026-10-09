<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../common/header.jsp"/>

<style>
/* ── List row layout ────────────────────────────────────────── */
.hs-row {
    background: #fff;
    border: 1px solid #e8ecf0;
    border-radius: 12px;
    padding: .75rem 1rem;
    display: flex;
    align-items: center;
    gap: .9rem;
    transition: box-shadow .15s ease, border-color .15s ease;
}
.hs-row:hover {
    box-shadow: 0 3px 14px rgba(99,102,241,.1);
    border-color: #c7d2fe;
}

/* Status dot icon block */
.hs-row__icon {
    width: 38px; height: 38px;
    border-radius: 10px;
    display: flex; align-items: center; justify-content: center;
    font-size: .95rem; flex-shrink: 0;
}
.hs-row__icon--active   { background:rgba(16,185,129,.12);  color:#059669; }
.hs-row__icon--pending  { background:rgba(245,158,11,.12);  color:#b45309; }
.hs-row__icon--rejected { background:rgba(239,68,68,.12);   color:#dc2626; }
.hs-row__icon--inactive { background:rgba(100,116,139,.1);  color:#64748b; }

/* Main info block */
.hs-row__info { flex: 1; min-width: 0; }
.hs-row__name {
    font-size: .9rem; font-weight: 700; color: #1e293b;
    white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
    margin-bottom: .15rem;
}
.hs-row__sub {
    font-size: .74rem; color: #64748b;
    display: flex; align-items: center; gap: .5rem; flex-wrap: wrap;
}
.hs-row__sub i { font-size: .65rem; }

/* Rejection reason */
.hs-row__rejection {
    font-size: .72rem; color: #dc2626;
    margin-top: .2rem;
    white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
    max-width: 340px;
}

/* Meta chips */
.hs-row__meta {
    display: flex; align-items: center; gap: .5rem;
    flex-shrink: 0; flex-wrap: wrap;
}
.hs-meta-chip {
    display: inline-flex; align-items: center; gap: .25rem;
    font-size: .72rem; color: #475569;
    background: #f8fafc; border: 1px solid #e2e8f0;
    border-radius: 20px; padding: 2px 8px; white-space: nowrap;
}

/* Status badge */
.hs-status-badge {
    display: inline-flex; align-items: center; gap: .25rem;
    font-size: .7rem; font-weight: 700; padding: 3px 9px;
    border-radius: 20px; border: 1px solid; white-space: nowrap; flex-shrink: 0;
}
.hs-status--active   { background:#f0fdf4; color:#059669; border-color:#86efac; }
.hs-status--pending  { background:#fffbeb; color:#b45309; border-color:#fcd34d; }
.hs-status--rejected { background:#fef2f2; color:#dc2626; border-color:#fca5a5; }
.hs-status--inactive { background:#f8fafc; color:#64748b; border-color:#cbd5e1; }

/* Price */
.hs-row__price {
    font-size: .88rem; font-weight: 700; color: #6366f1;
    flex-shrink: 0; white-space: nowrap;
    min-width: 90px; text-align: right;
}
.hs-row__price small { font-size: .68rem; color: #94a3b8; font-weight: 400; }

/* Actions */
.hs-row__actions {
    display: flex; align-items: center; gap: .3rem; flex-shrink: 0;
}
.hs-row__actions .btn { font-size: .72rem; padding: .22rem .55rem; }

/* ── Empty state ──────────────────────────────────────────────── */
.hs-empty-state {
    text-align: center; padding: 3.5rem 1rem; color: #94a3b8;
}
.hs-empty-state i { font-size: 3rem; margin-bottom: 1rem; opacity: .35; display: block; }

/* ── Search & filter bar ─────────────────────────────────────── */
.hs-filter-bar {
    background: #fff; border: 1px solid #e2e8f0;
    border-radius: 14px; padding: 1rem 1.25rem; margin-bottom: 1.25rem;
}
.hs-search-input {
    border-radius: 10px !important;
    padding-left: 2.4rem !important;
    font-size: .85rem; border-color: #e2e8f0;
}
.hs-search-input:focus { border-color: #6366f1; box-shadow: 0 0 0 3px rgba(99,102,241,.1); }
.hs-search-icon {
    position: absolute; left: .85rem; top: 50%;
    transform: translateY(-50%); color: #94a3b8; font-size: .85rem; pointer-events: none;
}

/* ── Status filter pills ─────────────────────────────────────── */
.hs-filter-pill {
    border-radius: 20px; font-size: .78rem; padding: .3rem .85rem;
    border: 1px solid #e2e8f0; background: #f8fafc;
    color: #64748b; cursor: pointer; transition: all .15s ease; white-space: nowrap;
}
.hs-filter-pill:hover { background: #eef2ff; border-color: #6366f1; color: #6366f1; }
.hs-filter-pill.active { background: #6366f1; border-color: #6366f1; color: #fff; }
.hs-filter-pill.pill-active  { background:#ecfdf5; border-color:#10b981; color:#059669; }
.hs-filter-pill.pill-active.active  { background:#10b981; border-color:#10b981; color:#fff; }
.hs-filter-pill.pill-pending { background:#fffbeb; border-color:#f59e0b; color:#b45309; }
.hs-filter-pill.pill-pending.active { background:#f59e0b; border-color:#f59e0b; color:#fff; }
.hs-filter-pill.pill-rejected{ background:#fef2f2; border-color:#ef4444; color:#dc2626; }
.hs-filter-pill.pill-rejected.active{ background:#ef4444; border-color:#ef4444; color:#fff; }
.hs-filter-pill.pill-inactive{ background:#f8fafc; border-color:#94a3b8; color:#475569; }
.hs-filter-pill.pill-inactive.active{ background:#94a3b8; border-color:#94a3b8; color:#fff; }

/* ── Delete modal ─────────────────────────────────────────────── */
.owner-modal-overlay {
    display: none; position: fixed; inset: 0;
    background: rgba(15,23,42,.55); z-index: 1050;
    align-items: center; justify-content: center; padding: 1rem;
}
.owner-modal-overlay.show { display: flex; }
.owner-modal-box {
    background: #fff; border-radius: 18px;
    padding: 2rem; width: 100%; max-width: 460px;
    box-shadow: 0 24px 64px rgba(15,23,42,.2);
    animation: modalIn .18s ease;
}
@keyframes modalIn {
    from { opacity:0; transform:scale(.96) translateY(-10px); }
    to   { opacity:1; transform:scale(1) translateY(0); }
}

/* ── Pagination ───────────────────────────────────────────────── */
.hs-pagination {
    display: flex; align-items: center; justify-content: center;
    gap: .35rem; flex-wrap: wrap; margin-top: 1.25rem;
}
.hs-pagination .pg-btn {
    min-width: 34px; height: 34px; border-radius: 9px;
    border: 1px solid #e2e8f0; background: #fff; color: #475569;
    font-size: .82rem; font-weight: 500; cursor: pointer;
    display: inline-flex; align-items: center; justify-content: center;
    padding: 0 .45rem; transition: all .15s ease; line-height: 1;
}
.hs-pagination .pg-btn:hover:not(:disabled) { background: #eef2ff; border-color: #6366f1; color: #6366f1; }
.hs-pagination .pg-btn.active { background: #6366f1; border-color: #6366f1; color: #fff; font-weight: 700; }
.hs-pagination .pg-btn:disabled { opacity: .38; cursor: default; }
.hs-pagination .pg-info { font-size: .78rem; color: #94a3b8; padding: 0 .35rem; }
</style>

<div class="owner-shell">
    <jsp:include page="../common/sidebar-owner.jsp"/>
    <div class="owner-main">
        <jsp:include page="../common/owner-topbar.jsp"/>
        <div class="owner-content">

            <!-- Flash messages -->
            <c:if test="${not empty sessionScope.flash_success}">
                <div class="alert alert-success alert-dismissible rounded-3 mb-4 d-flex gap-2 align-items-center">
                    <i class="fa-solid fa-circle-check flex-shrink-0"></i>
                    <span>${sessionScope.flash_success}</span>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="flash_success" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.flash_error}">
                <div class="alert alert-danger alert-dismissible rounded-3 mb-4 d-flex gap-2 align-items-center">
                    <i class="fa-solid fa-triangle-exclamation flex-shrink-0"></i>
                    <span>${sessionScope.flash_error}</span>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="flash_error" scope="session"/>
            </c:if>

            <!-- Page Header -->
            <div class="owner-page-header">
                <div class="owner-page-header__info">
                    <h2><i class="fa-solid fa-building-user text-primary me-2"></i>Quản lý Cơ sở Homestay</h2>
                    <p>Quản lý tài sản, hình ảnh HD và cấu hình các loại phòng</p>
                </div>
                <a href="${pageContext.request.contextPath}/owner/homestays/new"
                   class="btn btn-primary-custom btn-sm px-4">
                    <i class="fa-solid fa-plus me-1"></i>Đăng ký Homestay Mới
                </a>
            </div>

            <!-- Stats Row -->
            <div class="row g-3 mb-4">
                <div class="col-6 col-xl-3">
                    <div class="owner-card d-flex align-items-center gap-3 p-3">
                        <div style="width:44px;height:44px;border-radius:12px;background:rgba(99,102,241,.1);display:flex;align-items:center;justify-content:center;font-size:1.2rem;color:#6366f1;flex-shrink:0;">
                            <i class="fa-solid fa-building-user"></i>
                        </div>
                        <div>
                            <div class="fw-bold fs-4 lh-1">${countTotal}</div>
                            <div class="text-muted" style="font-size:.8rem;">Tổng cơ sở</div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-xl-3">
                    <div class="owner-card d-flex align-items-center gap-3 p-3">
                        <div style="width:44px;height:44px;border-radius:12px;background:rgba(16,185,129,.1);display:flex;align-items:center;justify-content:center;font-size:1.2rem;color:#10b981;flex-shrink:0;">
                            <i class="fa-solid fa-circle-check"></i>
                        </div>
                        <div>
                            <div class="fw-bold fs-4 lh-1">${countActive}</div>
                            <div class="text-muted" style="font-size:.8rem;">Đang hoạt động</div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-xl-3">
                    <div class="owner-card d-flex align-items-center gap-3 p-3">
                        <div style="width:44px;height:44px;border-radius:12px;background:rgba(245,158,11,.1);display:flex;align-items:center;justify-content:center;font-size:1.2rem;color:#f59e0b;flex-shrink:0;">
                            <i class="fa-solid fa-clock"></i>
                        </div>
                        <div>
                            <div class="fw-bold fs-4 lh-1">${countPending}</div>
                            <div class="text-muted" style="font-size:.8rem;">Chờ duyệt</div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-xl-3">
                    <div class="owner-card d-flex align-items-center gap-3 p-3">
                        <div style="width:44px;height:44px;border-radius:12px;background:rgba(99,102,241,.08);display:flex;align-items:center;justify-content:center;font-size:1.2rem;color:#6366f1;flex-shrink:0;">
                            <i class="fa-solid fa-bed"></i>
                        </div>
                        <div>
                            <div class="fw-bold fs-4 lh-1">${totalRooms}</div>
                            <div class="text-muted" style="font-size:.8rem;">Tổng số phòng</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Rejected alert -->
            <c:if test="${countRejected > 0}">
                <div class="alert alert-danger d-flex align-items-center gap-2 mb-4 rounded-3">
                    <i class="fa-solid fa-triangle-exclamation flex-shrink-0"></i>
                    <span>Bạn có <strong>${countRejected}</strong> cơ sở bị Admin từ chối.
                    Xem lý do và chỉnh sửa để gửi lại duyệt.</span>
                </div>
            </c:if>

            <!-- ── Search & Filter bar ── -->
            <div class="hs-filter-bar">
                <div class="row g-3 align-items-end">
                    <!-- Search input -->
                    <div class="col-12 col-md-5">
                        <label class="form-label fw-semibold mb-1" style="font-size:.8rem;">
                            <i class="fa-solid fa-magnifying-glass me-1 text-muted"></i>Tìm kiếm cơ sở
                        </label>
                        <div class="position-relative">
                            <i class="fa-solid fa-magnifying-glass hs-search-icon"></i>
                            <input type="text" id="hsSearch"
                                   class="form-control hs-search-input"
                                   placeholder="Tên homestay, địa chỉ, thành phố..."
                                   oninput="applyFilters()">
                        </div>
                    </div>
                    <!-- City filter -->
                    <div class="col-6 col-md-3">
                        <label class="form-label fw-semibold mb-1" style="font-size:.8rem;">
                            <i class="fa-solid fa-map-pin me-1 text-muted"></i>Thành phố
                        </label>
                        <select id="hsCityFilter" class="form-select" style="font-size:.83rem;border-color:#e2e8f0;border-radius:10px;" onchange="applyFilters()">
                            <option value="">Tất cả thành phố</option>
                            <c:forEach var="hs" items="${homestays}">
                                <c:if test="${not empty hs.city}">
                                    <option value="${hs.city}">${hs.city}</option>
                                </c:if>
                            </c:forEach>
                        </select>
                    </div>
                    <!-- Sort -->
                    <div class="col-6 col-md-3">
                        <label class="form-label fw-semibold mb-1" style="font-size:.8rem;">
                            <i class="fa-solid fa-arrow-up-wide-short me-1 text-muted"></i>Sắp xếp
                        </label>
                        <select id="hsSortFilter" class="form-select" style="font-size:.83rem;border-color:#e2e8f0;border-radius:10px;" onchange="applyFilters()">
                            <option value="newest">Mới nhất</option>
                            <option value="name">Tên A-Z</option>
                            <option value="price_asc">Giá tăng dần</option>
                            <option value="price_desc">Giá giảm dần</option>
                            <option value="rooms">Nhiều phòng nhất</option>
                        </select>
                    </div>
                    <!-- Reset button -->
                    <div class="col-12 col-md-1 d-flex align-items-end">
                        <button class="btn btn-outline-secondary w-100 rounded-3"
                                style="font-size:.8rem;" onclick="resetFilters()" title="Xóa bộ lọc">
                            <i class="fa-solid fa-rotate-left"></i>
                        </button>
                    </div>
                </div>

                <!-- Status pills -->
                <div class="d-flex gap-2 flex-wrap mt-3 pt-3 border-top">
                    <span class="text-muted me-1 align-self-center" style="font-size:.78rem;">Trạng thái:</span>
                    <button class="hs-filter-pill active" data-status="all"      onclick="setPillStatus('all', this)">
                        <i class="fa-solid fa-list me-1"></i>Tất cả
                        <span class="ms-1 opacity-75">(${countTotal})</span>
                    </button>
                    <button class="hs-filter-pill pill-active" data-status="ACTIVE" onclick="setPillStatus('ACTIVE', this)">
                        <i class="fa-solid fa-circle-check me-1"></i>Hoạt động
                        <span class="ms-1 opacity-75">(${countActive})</span>
                    </button>
                    <button class="hs-filter-pill pill-pending" data-status="PENDING_APPROVAL" onclick="setPillStatus('PENDING_APPROVAL', this)">
                        <i class="fa-solid fa-clock me-1"></i>Chờ duyệt
                        <span class="ms-1 opacity-75">(${countPending})</span>
                    </button>
                    <button class="hs-filter-pill pill-rejected" data-status="REJECTED" onclick="setPillStatus('REJECTED', this)">
                        <i class="fa-solid fa-ban me-1"></i>Từ chối
                        <span class="ms-1 opacity-75">(${countRejected})</span>
                    </button>
                    <button class="hs-filter-pill pill-inactive" data-status="INACTIVE" onclick="setPillStatus('INACTIVE', this)">
                        <i class="fa-solid fa-pause me-1"></i>Tạm ngừng
                        <span class="ms-1 opacity-75">(${countInactive})</span>
                    </button>
                </div>
            </div>

            <!-- Result count -->
            <div class="d-flex align-items-center justify-content-between mb-3">
                <small id="resultCount" class="text-muted">
                    <i class="fa-solid fa-house me-1"></i>
                    Hiển thị <span id="visibleCount">${countTotal}</span> / ${countTotal} cơ sở
                    <span id="pageInfo" class="ms-1"></span>
                </small>
            </div>

            <!-- ── List rows ── -->
            <div id="hsCardGrid" class="d-flex flex-column gap-2">
                <c:choose>
                    <c:when test="${empty homestays}">
                        <div class="hs-empty-state owner-card">
                            <i class="fa-solid fa-house-circle-xmark"></i>
                            <p class="fw-semibold mb-1">Bạn chưa đăng ký cơ sở nào</p>
                            <p class="mb-3">Bắt đầu bằng cách đăng ký homestay đầu tiên của bạn.</p>
                            <a href="${pageContext.request.contextPath}/owner/homestays/new"
                               class="btn btn-primary-custom btn-sm px-4">
                                <i class="fa-solid fa-plus me-1"></i>Đăng ký ngay
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="hs" items="${homestays}">
                            <%-- Status config --%>
                            <c:choose>
                                <c:when test="${hs.status == 'ACTIVE'}">
                                    <c:set var="sIconCss" value="hs-row__icon--active"/>
                                    <c:set var="sBadge"   value="hs-status--active"/>
                                    <c:set var="sIcon"    value="fa-circle-check"/>
                                    <c:set var="sLabel"   value="Hoạt động"/>
                                </c:when>
                                <c:when test="${hs.status == 'PENDING_APPROVAL'}">
                                    <c:set var="sIconCss" value="hs-row__icon--pending"/>
                                    <c:set var="sBadge"   value="hs-status--pending"/>
                                    <c:set var="sIcon"    value="fa-clock"/>
                                    <c:set var="sLabel"   value="Chờ duyệt"/>
                                </c:when>
                                <c:when test="${hs.status == 'REJECTED'}">
                                    <c:set var="sIconCss" value="hs-row__icon--rejected"/>
                                    <c:set var="sBadge"   value="hs-status--rejected"/>
                                    <c:set var="sIcon"    value="fa-ban"/>
                                    <c:set var="sLabel"   value="Từ chối"/>
                                </c:when>
                                <c:otherwise>
                                    <c:set var="sIconCss" value="hs-row__icon--inactive"/>
                                    <c:set var="sBadge"   value="hs-status--inactive"/>
                                    <c:set var="sIcon"    value="fa-pause"/>
                                    <c:set var="sLabel"   value="Tạm ngừng"/>
                                </c:otherwise>
                            </c:choose>

                            <div class="hs-card-col"
                                 data-status="${hs.status}"
                                 data-name="${hs.name}"
                                 data-city="${hs.city}"
                                 data-district="${hs.district}"
                                 data-address="${hs.address}"
                                 data-price="${hs.minPrice != null ? hs.minPrice : 0}"
                                 data-rooms="${hs.roomCount}"
                                 data-updated="${hs.updatedAt != null ? hs.updatedAt.time : 0}">
                                <div class="hs-row">

                                    <!-- Status icon -->
                                    <div class="hs-row__icon ${sIconCss}">
                                        <i class="fa-solid ${sIcon}"></i>
                                    </div>

                                    <!-- Main info -->
                                    <div class="hs-row__info">
                                        <div class="hs-row__name" title="${hs.name}">${hs.name}</div>
                                        <div class="hs-row__sub">
                                            <span><i class="fa-solid fa-location-dot" style="color:#ef4444;"></i>
                                                ${hs.district}<c:if test="${not empty hs.district && not empty hs.city}">, </c:if>${hs.city}
                                            </span>
                                            <span><i class="fa-solid fa-bed" style="color:#6366f1;"></i> ${hs.roomCount} phòng</span>
                                            <c:if test="${hs.reviewCount > 0}">
                                                <span><i class="fa-solid fa-star" style="color:#f59e0b;"></i>
                                                    <fmt:formatNumber value="${hs.ratingAvg}" maxFractionDigits="1"/> (${hs.reviewCount})
                                                </span>
                                            </c:if>
                                            <span class="text-muted"><i class="fa-regular fa-clock"></i>
                                                <fmt:formatDate value="${hs.updatedAt}" pattern="dd/MM/yy"/>
                                            </span>
                                        </div>
                                        <c:if test="${hs.status == 'REJECTED' && not empty hs.rejectionReason}">
                                            <div class="hs-row__rejection">
                                                <i class="fa-solid fa-circle-exclamation me-1"></i>${hs.rejectionReason}
                                            </div>
                                        </c:if>
                                    </div>

                                    <!-- Status badge -->
                                    <span class="hs-status-badge ${sBadge}">
                                        <i class="fa-solid ${sIcon}" style="font-size:.6rem;"></i>${sLabel}
                                    </span>

                                    <!-- Price -->
                                    <div class="hs-row__price">
                                        <c:choose>
                                            <c:when test="${hs.minPrice != null && hs.minPrice > 0}">
                                                <fmt:formatNumber value="${hs.minPrice}" type="number" groupingUsed="true"/>₫
                                                <br><small>/đêm</small>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted" style="font-size:.75rem;font-weight:400;">Chưa cấu hình</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <!-- Actions -->
                                    <div class="hs-row__actions">
                                        <a href="${pageContext.request.contextPath}/owner/homestays/edit?id=${hs.homestayId}"
                                           class="btn btn-sm btn-outline-primary rounded-3" title="Chỉnh sửa">
                                            <i class="fa-solid fa-pen me-1"></i>Sửa
                                        </a>
                                        <c:if test="${hs.status == 'ACTIVE'}">
                                            <a href="${pageContext.request.contextPath}/owner/rooms?homestayId=${hs.homestayId}"
                                               class="btn btn-sm btn-outline-secondary rounded-3" title="Quản lý phòng">
                                                <i class="fa-solid fa-bed"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/owner/calendar?homestayId=${hs.homestayId}"
                                               class="btn btn-sm btn-outline-secondary rounded-3" title="Lịch &amp; giá">
                                                <i class="fa-regular fa-calendar-days"></i>
                                            </a>
                                        </c:if>
                                        <c:choose>
                                            <c:when test="${hs.status == 'ACTIVE'}">
                                                <form method="post" action="${pageContext.request.contextPath}/owner/homestays/toggle" style="display:contents;">
                                                    <input type="hidden" name="homestayId" value="${hs.homestayId}">
                                                    <input type="hidden" name="action" value="deactivate">
                                                    <button type="submit" class="btn btn-sm btn-outline-warning rounded-3" title="Tạm ngừng"
                                                            onclick="return confirm('Tạm ngừng cơ sở này?')">
                                                        <i class="fa-solid fa-pause"></i>
                                                    </button>
                                                </form>
                                            </c:when>
                                            <c:when test="${hs.status == 'INACTIVE'}">
                                                <form method="post" action="${pageContext.request.contextPath}/owner/homestays/toggle" style="display:contents;">
                                                    <input type="hidden" name="homestayId" value="${hs.homestayId}">
                                                    <input type="hidden" name="action" value="activate">
                                                    <button type="submit" class="btn btn-sm btn-outline-success rounded-3" title="Kích hoạt lại">
                                                        <i class="fa-solid fa-play"></i>
                                                    </button>
                                                </form>
                                            </c:when>
                                            <c:when test="${hs.status == 'REJECTED'}">
                                                <a href="${pageContext.request.contextPath}/owner/homestays/edit?id=${hs.homestayId}"
                                                   class="btn btn-sm btn-outline-danger rounded-3" title="Sửa và gửi lại">
                                                    <i class="fa-solid fa-rotate-right"></i>
                                                </a>
                                            </c:when>
                                            <c:when test="${hs.status == 'PENDING_APPROVAL'}">
                                                <span class="btn btn-sm btn-outline-secondary rounded-3 disabled"
                                                      title="Admin đang xét duyệt">
                                                    <i class="fa-solid fa-hourglass-half"></i>
                                                </span>
                                            </c:when>
                                        </c:choose>
                                        <button type="button"
                                                class="btn btn-sm btn-outline-danger rounded-3" title="Xóa cơ sở"
                                                onclick="openDeleteModal(${hs.homestayId}, '${hs.name.replace("'", "\\'")}')">
                                            <i class="fa-solid fa-trash-can"></i>
                                        </button>
                                    </div>

                                </div><%-- /.hs-row --%>
                            </div><%-- /.hs-card-col --%>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div><%-- /#hsCardGrid --%>

            <!-- Pagination -->
            <div id="hsPagination" class="hs-pagination" style="display:none;"></div>

            <!-- No-results message (hidden by default) -->
            <div id="hsNoResults" class="hs-empty-state owner-card mt-3" style="display:none;">
                <i class="fa-solid fa-filter-circle-xmark"></i>
                <p class="fw-semibold mb-1">Không tìm thấy cơ sở nào</p>
                <p class="mb-2">Thử thay đổi từ khóa tìm kiếm hoặc bộ lọc.</p>
                <button class="btn btn-sm btn-outline-secondary" onclick="resetFilters()">
                    <i class="fa-solid fa-rotate-left me-1"></i>Xóa bộ lọc
                </button>
            </div>

            <!-- Footer info -->
            <div class="mt-4 pt-3 border-top d-flex align-items-center justify-content-between flex-wrap gap-2">
                <small class="text-muted">
                    ${countActive} hoạt động · ${countPending} chờ duyệt · ${countRejected} từ chối · ${countInactive} tạm ngừng
                </small>
                <a href="${pageContext.request.contextPath}/owner/homestays/new"
                   class="btn btn-sm btn-outline-primary rounded-3">
                    <i class="fa-solid fa-plus me-1"></i>Thêm cơ sở mới
                </a>
            </div>

        </div><%-- /.owner-content --%>
    </div><%-- /.owner-main --%>
</div><%-- /.owner-shell --%>

<!-- ── Delete Confirm Modal ─────────────────────────────────── -->
<div class="owner-modal-overlay" id="deleteHomestayModal"
     onclick="if(event.target===this)closeDeleteModal()">
    <div class="owner-modal-box">
        <div class="text-center mb-3">
            <div style="width:60px;height:60px;border-radius:50%;background:#fef2f2;display:flex;align-items:center;justify-content:center;margin:0 auto .75rem;font-size:1.6rem;color:#ef4444;">
                <i class="fa-solid fa-trash-can"></i>
            </div>
            <h5 class="fw-bold mb-1">Xóa cơ sở Homestay?</h5>
            <p class="text-muted mb-0" style="font-size:.88rem;">
                Bạn đang xóa: <strong id="deleteHomestayName" class="text-dark"></strong>
            </p>
        </div>
        <div class="alert alert-danger py-2 px-3 rounded-3 mb-3" style="font-size:.82rem;">
            <i class="fa-solid fa-triangle-exclamation me-1"></i>
            <strong>Không thể hoàn tác.</strong> Tất cả ảnh, loại phòng và phòng vật lý sẽ bị xóa vĩnh viễn.
            Không thể xóa nếu còn đặt phòng đang hoạt động.
        </div>
        <form method="post"
              action="${pageContext.request.contextPath}/owner/homestays/delete"
              id="deleteHomestayForm">
            <input type="hidden" name="homestayId" id="deleteHomestayId">

            <div class="mb-3">
                <label class="form-label" style="font-size:.83rem;">
                    Nhập <strong>XÓA</strong> để xác nhận:
                </label>
                <input type="text" id="deleteConfirmInput"
                       class="form-control form-control-sm"
                       placeholder='Gõ "XÓA" để xác nhận'
                       autocomplete="off"
                       oninput="updateDeleteBtn()">
            </div>

            <div class="d-flex gap-2">
                <button type="submit" id="deleteConfirmBtn"
                        class="btn btn-danger flex-fill" disabled>
                    <i class="fa-solid fa-trash-can me-1"></i>Xóa cơ sở
                </button>
                <button type="button"
                        class="btn btn-outline-secondary flex-fill"
                        onclick="closeDeleteModal()">Hủy bỏ</button>
            </div>
        </form>
    </div>
</div>

<script>
// ══════════════════════════════════════════════════════════════════════════════
// HOMESTAY LIST — Filter + Sort + Pagination (client-side)
// ══════════════════════════════════════════════════════════════════════════════
var _activeStatus  = 'all';
var _currentPage   = 1;
var _PAGE_SIZE     = 6;        // 6 cards per page
var _filteredCols  = [];       // cols that pass current filters (in sorted order)

// ── View toggle (removed — list-only layout) ─────────────────────────────────
function setView() { /* no-op, kept for safety */ }

// ── Status pill selection ─────────────────────────────────────────────────────
function setPillStatus(status, btn) {
    document.querySelectorAll('.hs-filter-pill').forEach(function(p) { p.classList.remove('active'); });
    btn.classList.add('active');
    _activeStatus = status;
    _currentPage  = 1;
    applyFilters();
}

// ── Apply all filters → rebuild _filteredCols → go to page 1 ─────────────────
function applyFilters() {
    var keyword = (document.getElementById('hsSearch').value    || '').toLowerCase().trim();
    var city    = (document.getElementById('hsCityFilter').value || '').toLowerCase();
    var sortBy  =  document.getElementById('hsSortFilter').value;

    var allCols = Array.from(document.querySelectorAll('.hs-card-col'));

    // Step 1 – filter
    _filteredCols = allCols.filter(function(col) {
        var name     = (col.dataset.name     || '').toLowerCase();
        var colCity  = (col.dataset.city     || '').toLowerCase();
        var district = (col.dataset.district || '').toLowerCase();
        var address  = (col.dataset.address  || '').toLowerCase();
        var status   =  col.dataset.status   || '';

        var matchKw     = !keyword || name.includes(keyword) || colCity.includes(keyword)
                          || district.includes(keyword) || address.includes(keyword);
        var matchCity   = !city   || colCity === city;
        var matchStatus = _activeStatus === 'all' || status === _activeStatus;
        return matchKw && matchCity && matchStatus;
    });

    // Step 2 – sort
    _filteredCols.sort(function(a, b) {
        switch (sortBy) {
            case 'name':
                return (a.dataset.name || '').localeCompare(b.dataset.name || '', 'vi');
            case 'price_asc':
                return parseFloat(a.dataset.price || 0) - parseFloat(b.dataset.price || 0);
            case 'price_desc':
                return parseFloat(b.dataset.price || 0) - parseFloat(a.dataset.price || 0);
            case 'rooms':
                return parseInt(b.dataset.rooms || 0) - parseInt(a.dataset.rooms || 0);
            default: // newest
                return parseInt(b.dataset.updated || 0) - parseInt(a.dataset.updated || 0);
        }
    });

    // Re-append in sorted order (flex column — order follows DOM)
    var grid = document.getElementById('hsCardGrid');
    _filteredCols.forEach(function(col) { grid.appendChild(col); });

    // Hide ALL cols first; renderPage will show only the current page slice
    allCols.forEach(function(c) { c.style.display = 'none'; });

    renderPage();
}

// ── Render the current page slice ─────────────────────────────────────────────
function renderPage() {
    var total     = _filteredCols.length;
    var totalPages= Math.max(1, Math.ceil(total / _PAGE_SIZE));
    if (_currentPage > totalPages) _currentPage = totalPages;
    if (_currentPage < 1)          _currentPage = 1;

    var start  = (_currentPage - 1) * _PAGE_SIZE;
    var end    = Math.min(start + _PAGE_SIZE, total);
    var grid   = document.getElementById('hsCardGrid');

    // Hide everything first
    Array.from(document.querySelectorAll('.hs-card-col')).forEach(function(c) {
        c.style.display = 'none';
    });

    // Re-append filtered cols in sorted order (keeps DOM order = sort order)
    _filteredCols.forEach(function(col) { grid.appendChild(col); });

    // Show only this page's slice
    for (var i = start; i < end; i++) {
        _filteredCols[i].style.display = '';
    }

    // Update result count label
    var from = total === 0 ? 0 : start + 1;
    document.getElementById('visibleCount').textContent = total;
    var pageInfoEl = document.getElementById('pageInfo');
    if (pageInfoEl) {
        pageInfoEl.textContent = total > _PAGE_SIZE
            ? '· Trang ' + _currentPage + '/' + totalPages
            : '';
    }

    // No-results state
    document.getElementById('hsNoResults').style.display =
        (total === 0 && document.querySelectorAll('.hs-card-col').length > 0) ? '' : 'none';

    // Render pagination bar
    renderPagination(totalPages);
}

// ── Render pagination bar ─────────────────────────────────────────────────────
function renderPagination(totalPages) {
    var container = document.getElementById('hsPagination');
    container.innerHTML = '';

    if (totalPages <= 1) {
        container.style.display = 'none';
        return;
    }
    container.style.display = 'flex';

    // Helper: create button
    function pgBtn(label, page, isActive, disabled) {
        var btn = document.createElement('button');
        btn.className  = 'pg-btn' + (isActive ? ' active' : '');
        btn.disabled   = disabled || false;
        btn.innerHTML  = label;
        btn.type       = 'button';
        if (!disabled && !isActive) {
            btn.addEventListener('click', function() { goToPage(page); });
        }
        return btn;
    }

    // ← Prev
    container.appendChild(pgBtn('<i class="fa-solid fa-chevron-left" style="font-size:.7rem;"></i>',
        _currentPage - 1, false, _currentPage === 1));

    // Page numbers with ellipsis
    var pages = buildPageNumbers(totalPages, _currentPage);
    pages.forEach(function(p) {
        if (p === '…') {
            var span = document.createElement('span');
            span.className = 'pg-info';
            span.textContent = '…';
            container.appendChild(span);
        } else {
            container.appendChild(pgBtn(p, p, p === _currentPage, false));
        }
    });

    // → Next
    container.appendChild(pgBtn('<i class="fa-solid fa-chevron-right" style="font-size:.7rem;"></i>',
        _currentPage + 1, false, _currentPage === totalPages));
}

// Build page-number array with sliding window around current page
// e.g. total=10, current=1  → [1, 2, 3, '…', 10]
// e.g. total=10, current=5  → [1, '…', 4, 5, 6, '…', 10]
// e.g. total=10, current=10 → [1, '…', 8, 9, 10]
function buildPageNumbers(total, current) {
    if (total <= 7) {
        var arr = [];
        for (var i = 1; i <= total; i++) arr.push(i);
        return arr;
    }
    var pages = [];
    var winStart = Math.max(2, current - 1);
    var winEnd   = Math.min(total - 1, current + 1);
    pages.push(1);
    if (winStart > 2) pages.push('…');
    for (var p = winStart; p <= winEnd; p++) pages.push(p);
    if (winEnd < total - 1) pages.push('…');
    pages.push(total);
    return pages;
}

function goToPage(page) {
    _currentPage = page;
    renderPage();
    // Smooth scroll to card grid
    var grid = document.getElementById('hsCardGrid');
    if (grid) grid.scrollIntoView({ behavior: 'smooth', block: 'start' });
}

// ── Reset all filters ─────────────────────────────────────────────────────────
function resetFilters() {
    document.getElementById('hsSearch').value     = '';
    document.getElementById('hsCityFilter').value = '';
    document.getElementById('hsSortFilter').value = 'newest';
    document.querySelectorAll('.hs-filter-pill').forEach(function(p) { p.classList.remove('active'); });
    document.querySelector('.hs-filter-pill[data-status="all"]').classList.add('active');
    _activeStatus = 'all';
    _currentPage  = 1;
    applyFilters();
}

// ── Deduplicate city options ──────────────────────────────────────────────────
(function deduplicateCityOptions() {
    var sel  = document.getElementById('hsCityFilter');
    var seen = {};
    Array.from(sel.options).forEach(function(opt) {
        if (opt.value === '') return;
        if (seen[opt.value]) { sel.removeChild(opt); }
        else seen[opt.value] = true;
    });
})();

// ── Initial render ────────────────────────────────────────────────────────────
applyFilters();

// ── Delete modal ──────────────────────────────────────────────────────────────
function openDeleteModal(homestayId, homestayName) {
    document.getElementById('deleteHomestayId').value         = homestayId;
    document.getElementById('deleteHomestayName').textContent = homestayName;
    document.getElementById('deleteConfirmInput').value       = '';
    document.getElementById('deleteConfirmBtn').disabled      = true;
    document.getElementById('deleteHomestayModal').classList.add('show');
    setTimeout(function() { document.getElementById('deleteConfirmInput').focus(); }, 200);
}

function closeDeleteModal() {
    document.getElementById('deleteHomestayModal').classList.remove('show');
}

function updateDeleteBtn() {
    var val = document.getElementById('deleteConfirmInput').value.trim().toUpperCase();
    document.getElementById('deleteConfirmBtn').disabled = (val !== 'XÓA');
}

// Escape to close modal
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') closeDeleteModal();
});
</script>

<jsp:include page="../common/footer.jsp"/>
