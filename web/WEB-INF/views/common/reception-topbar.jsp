<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<header class="owner-topbar">
    <div class="owner-topbar__left">
        <nav class="owner-topbar__breadcrumb" aria-label="breadcrumb">
            <span class="owner-topbar__breadcrumb-root">
                <i class="fa-solid fa-concierge-bell me-1"></i>Bàn Lễ Tân
            </span>
            <c:if test="${not empty pageBreadcrumb}">
                <i class="fa-solid fa-chevron-right owner-topbar__breadcrumb-sep"></i>
                <span class="owner-topbar__breadcrumb-group">${pageBreadcrumb}</span>
            </c:if>
            <c:if test="${not empty pageTitle}">
                <i class="fa-solid fa-chevron-right owner-topbar__breadcrumb-sep"></i>
                <span class="owner-topbar__breadcrumb-current" style="color:#0891b2;">${pageTitle}</span>
            </c:if>
        </nav>
        <h1 class="owner-topbar__heading">
            <c:choose>
                <c:when test="${not empty pageTitle}">${pageTitle}</c:when>
                <c:otherwise>Bàn Lễ Tân</c:otherwise>
            </c:choose>
        </h1>
    </div>

    <div class="owner-topbar__right">
        <div class="owner-topbar__user-menu dropdown">
            <button class="owner-topbar__user-btn dropdown-toggle" type="button"
                    id="receptionTopbarUser" data-bs-toggle="dropdown" aria-expanded="false">
                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser.avatarUrl}">
                        <img src="${sessionScope.currentUser.avatarUrl}"
                             class="owner-topbar__user-avatar" alt="Avatar"
                             onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/images/default-avatar.svg';">
                    </c:when>
                    <c:otherwise>
                        <div class="owner-topbar__user-initial" style="background:#0891b2;">
                            ${not empty sessionScope.currentUser ? sessionScope.currentUser.fullName.substring(0,1).toUpperCase() : 'R'}
                        </div>
                    </c:otherwise>
                </c:choose>
                <span class="owner-topbar__user-name">
                    ${not empty sessionScope.currentUser ? sessionScope.currentUser.fullName : 'Lễ Tân'}
                </span>
            </button>
            <ul class="dropdown-menu dropdown-menu-end shadow-sm owner-topbar__dropdown" aria-labelledby="receptionTopbarUser">
                <li class="owner-topbar__dropdown-header">
                    <span class="d-block fw-semibold">${not empty sessionScope.currentUser ? sessionScope.currentUser.fullName : ''}</span>
                    <span class="text-muted" style="font-size:.82rem;">${not empty sessionScope.currentUser ? sessionScope.currentUser.email : ''}</span>
                </li>
                <li><hr class="dropdown-divider my-1"></li>
                <li>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/customer/profile">
                        <i class="fa-regular fa-user me-2 text-muted"></i>Hồ sơ cá nhân
                    </a>
                </li>
                <li><hr class="dropdown-divider my-1"></li>
                <li>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/home">
                        <i class="fa-solid fa-compass me-2 text-success"></i>Khám phá Homestay
                    </a>
                </li>
                <li><hr class="dropdown-divider my-1"></li>
                <li>
                    <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
                        <i class="fa-solid fa-right-from-bracket me-2"></i>Đăng xuất
                    </a>
                </li>
            </ul>
        </div>
    </div>
</header>

<script>
(function () {
    function initDropdowns() {
        document.addEventListener('click', function (e) {
            var toggleBtn = e.target.closest('[data-bs-toggle="dropdown"]');
            if (toggleBtn) {
                e.preventDefault(); e.stopPropagation();
                var menu = toggleBtn.closest('.dropdown').querySelector('.dropdown-menu');
                if (menu) {
                    var shown = menu.classList.contains('show');
                    document.querySelectorAll('.dropdown-menu.show').forEach(function(m){ m.classList.remove('show'); });
                    if (!shown) menu.classList.add('show');
                }
            } else if (!e.target.closest('.dropdown-menu')) {
                document.querySelectorAll('.dropdown-menu.show').forEach(function(m){ m.classList.remove('show'); });
            }
        });
    }
    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', initDropdowns);
    else initDropdowns();
    document.documentElement.classList.add('owner-page');
    document.addEventListener('DOMContentLoaded', function(){ document.body.classList.add('owner-page'); });
}());
</script>
