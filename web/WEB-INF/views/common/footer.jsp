<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<footer>
    <div class="container">
        <div class="row gy-4">
            <div class="col-lg-4 col-md-6">
                <h5 class="text-white mb-3"><i class="fa-solid fa-hotel me-2 text-primary"></i>Smart Booking</h5>
                <p>Nền tảng đặt phòng Homestay & Hotel thông minh hàng đầu. Tích hợp AI khuyến nghị, thanh toán cổng trực tuyến và quản lý check-in OCR nhanh chóng.</p>
            </div>
            <div class="col-lg-2 col-md-6">
                <h6 class="text-white mb-3">Dành cho Khách hàng</h6>
                <ul class="list-unstyled">
                    <li><a href="${pageContext.request.contextPath}/search">Tìm kiếm homestay</a></li>
                    <li><a href="${pageContext.request.contextPath}/customer/bookings">Quản lý đơn đặt</a></li>
                    <li><a href="${pageContext.request.contextPath}/customer/wishlist">Yêu thích đã lưu</a></li>
                    <li><a href="${pageContext.request.contextPath}/about">Về chúng tôi</a></li>
                    <li><a href="${pageContext.request.contextPath}/contact">Liên hệ hỗ trợ</a></li>
                </ul>
            </div>

            <%-- Cột "Dành cho Đối tác": hiển thị link theo role, tránh 403 --%>
            <div class="col-lg-3 col-md-6">
                <h6 class="text-white mb-3">Dành cho Đối tác</h6>
                <ul class="list-unstyled">

                    <%-- OWNER: quản lý homestay, lịch & giá, đơn đặt, phân tích --%>
                    <c:if test="${sessionScope.currentUser.role == 'OWNER' or sessionScope.currentUser.role == 'ADMIN'}">
                        <li><a href="${pageContext.request.contextPath}/owner/homestays">Quản lý Homestay</a></li>
                        <li><a href="${pageContext.request.contextPath}/owner/calendar">Lịch &amp; Giá</a></li>
                        <li><a href="${pageContext.request.contextPath}/owner/bookings">Đơn đặt phòng</a></li>
                        <li><a href="${pageContext.request.contextPath}/owner/analytics">Doanh thu &amp; Thống kê</a></li>
                    </c:if>

                    <%-- RECEPTIONIST: giao diện lễ tân, ma trận phòng --%>
                    <c:if test="${sessionScope.currentUser.role == 'RECEPTIONIST' or sessionScope.currentUser.role == 'ADMIN'}">
                        <li><a href="${pageContext.request.contextPath}/reception/checkin">Giao diện Lễ tân</a></li>
                        <li><a href="${pageContext.request.contextPath}/reception/room-matrix">Ma trận phòng</a></li>
                    </c:if>

                    <%-- ADMIN: quản trị hệ thống --%>
                    <c:if test="${sessionScope.currentUser.role == 'ADMIN'}">
                        <li><a href="${pageContext.request.contextPath}/admin/users">Quản trị hệ thống</a></li>
                    </c:if>

                    <%-- Khách hàng / chưa đăng nhập: CTA trở thành đối tác --%>
                    <c:if test="${empty sessionScope.currentUser or sessionScope.currentUser.role == 'CUSTOMER'}">
                        <li class="mb-2" style="opacity:.75; font-size:.85rem;">Bạn muốn đăng tin cho thuê?</li>
                        <li><a href="${pageContext.request.contextPath}/contact">Liên hệ trở thành Đối tác</a></li>
                    </c:if>

                </ul>
            </div>

            <div class="col-lg-3 col-md-6">
                <h6 class="text-white mb-3">Liên hệ & Hỗ trợ</h6>
                <p><i class="fa-solid fa-location-dot me-2 text-primary"></i>FPT University, Hoa Lac Hi-tech Park, CT03</p>
                <p><i class="fa-solid fa-envelope me-2 text-primary"></i>smartbookingg@gmail.com</p>
                <p><i class="fa-solid fa-phone me-2 text-primary"></i>(024) 7300 5588</p>
            </div>
        </div>
        <hr class="border-secondary my-4">
        <div class="text-center">
            <p class="mb-0">&copy; 2026 Smart Booking Platform. All rights reserved.</p>
        </div>
    </div>
</footer>

<!-- Bootstrap 5 JS Bundle (Local & CDN Fallback) -->
<script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Global Image Fallback Handler & Date Picker Constraints -->
<script>
    (function() {
        const defaultHomestay = "${pageContext.request.contextPath}/assets/images/default-homestay.svg";
        const defaultAvatar = "${pageContext.request.contextPath}/assets/images/default-avatar.svg";

        function applyFallback(img) {
            if (!img || img.dataset.fallbackApplied) return;
            img.dataset.fallbackApplied = "true";
            const isAvatar = img.classList.contains("rounded-circle") || 
                             (img.alt && img.alt.toLowerCase().includes("avatar")) || 
                             (img.src && img.src.toLowerCase().includes("avatar"));
            img.src = isAvatar ? defaultAvatar : defaultHomestay;
        }

        // Catch error events on any img element during capture phase
        window.addEventListener("error", function(e) {
            if (e.target && e.target.tagName === "IMG") {
                applyFallback(e.target);
            }
        }, true);

        // Global Date Picker Constraints: Không cho chọn ngày quá khứ & tự động sync checkin/checkout
        function applyDateRestrictions() {
            const now = new Date();

            // Nếu đã qua giờ check-in (14:00) thì không cho chọn hôm nay nữa → min = ngày mai
            // Lấy giờ check-in từ data-checkin-hour trên input (nếu có), mặc định 14
            function getMinCheckinDate(inputEl) {
                var checkinHour = parseInt(inputEl.dataset.checkinHour || '14', 10);
                var minDate = new Date();
                if (now.getHours() >= checkinHour) {
                    minDate.setDate(minDate.getDate() + 1); // đã qua giờ check-in → sang ngày mai
                }
                return minDate.toISOString().split('T')[0];
            }

            const todayStr = now.toISOString().split('T')[0];
            const tomorrowStr = (function() {
                var d = new Date(); d.setDate(d.getDate() + 1);
                return d.toISOString().split('T')[0];
            })();
            
            // Giới hạn tất cả input date không được chọn quá khứ
            document.querySelectorAll('input[type="date"]').forEach(function(input) {
                if (!input.dataset.allowPast && !input.getAttribute('min')) {
                    input.setAttribute('min', todayStr);
                }
            });

            // Đồng bộ cặp checkin và checkout
            const checkins = document.querySelectorAll('input[name="checkin"], #checkinInput, #searchCheckin, #homeCheckin');
            checkins.forEach(function(ci) {
                var minCheckin = getMinCheckinDate(ci);
                ci.setAttribute('min', minCheckin);

                // Nếu giá trị hiện tại nhỏ hơn min → reset về min
                if (!ci.value || ci.value < minCheckin) {
                    ci.value = minCheckin;
                }
                
                const form = ci.closest('form');
                const co = form ? form.querySelector('input[name="checkout"], #checkoutInput, #searchCheckout, #homeCheckout') : null;
                if (co) {
                    function syncCheckout() {
                        const curVal = ci.value || todayStr;
                        const d = new Date(curVal);
                        if (!isNaN(d.getTime())) {
                            d.setDate(d.getDate() + 1);
                            const nextDay = d.toISOString().split('T')[0];
                            co.setAttribute('min', nextDay);
                            if (co.value && co.value <= curVal) {
                                co.value = nextDay;
                            }
                        }
                    }

                    ci.addEventListener('change', syncCheckout);
                    if (ci.value) {
                        syncCheckout();
                    } else {
                        const tmr = new Date();
                        tmr.setDate(tmr.getDate() + 1);
                        co.setAttribute('min', tmr.toISOString().split('T')[0]);
                    }
                }
            });
        }

        // Check already rendered images and inputs on load
        document.addEventListener("DOMContentLoaded", function() {
            document.querySelectorAll("img").forEach(function(img) {
                if (img.complete && (img.naturalWidth === 0 || !img.src)) {
                    applyFallback(img);
                }
            });
            applyDateRestrictions();
        });
    })();
</script>
</body>
</html>
