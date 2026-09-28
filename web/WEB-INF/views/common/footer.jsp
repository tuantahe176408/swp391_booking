<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
            <div class="col-lg-3 col-md-6">
                <h6 class="text-white mb-3">Dành cho Đối tác</h6>
                <ul class="list-unstyled">
                    <li><a href="${pageContext.request.contextPath}/owner/homestays">Đăng tin cho thuê</a></li>
                    <li><a href="${pageContext.request.contextPath}/owner/calendar">Quản lý lịch & giá</a></li>
                    <li><a href="${pageContext.request.contextPath}/reception/checkin">Giao diện Lễ tân</a></li>
                </ul>
            </div>
            <div class="col-lg-3 col-md-6">
                <h6 class="text-white mb-3">Liên hệ & Hỗ trợ</h6>
                <p><i class="fa-solid fa-location-dot me-2 text-primary"></i>FPT University, Hoa Lac Hi-tech Park, CT03</p>
                <p><i class="fa-solid fa-envelope me-2 text-primary"></i>support@smartbooking.com</p>
                <p><i class="fa-solid fa-phone me-2 text-primary"></i>(024) 7300 5588</p>
            </div>
        </div>
        <hr class="border-secondary my-4">
        <div class="text-center">
            <p class="mb-0">&copy; 2026 Smart Booking Platform. All rights reserved. (SWP391 JSP/Servlet NetBeans MVC Architecture)</p>
        </div>
    </div>
</footer>

<!-- Bootstrap 5 JS Bundle (Local & CDN Fallback) -->
<script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Global Image Fallback Handler -->
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

        // Check already rendered images on load
        document.addEventListener("DOMContentLoaded", function() {
            document.querySelectorAll("img").forEach(function(img) {
                if (img.complete && (img.naturalWidth === 0 || !img.src)) {
                    applyFallback(img);
                }
            });
        });
    })();
</script>
</body>
</html>
