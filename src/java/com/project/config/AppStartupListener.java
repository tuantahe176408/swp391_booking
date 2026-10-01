package com.project.config;

import com.project.service.BookingExpiryJob;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Application lifecycle listener — khởi động và dừng các scheduled jobs khi app start/stop.
 *
 * <p>Jobs hiện tại:
 * <ul>
 *   <li>{@link BookingExpiryJob} — chạy mỗi 5 phút,
 *       tự động huỷ các đơn PENDING đã hết thời gian giữ chỗ ({@code hold_expires_at < NOW()})</li>
 * </ul>
 *
 * <p>Dùng {@code @WebListener} — không cần đăng ký trong {@code web.xml}.
 *
 * Package: com.project.config
 */
@WebListener
public class AppStartupListener implements ServletContextListener {

    private static final Logger LOGGER = Logger.getLogger(AppStartupListener.class.getName());

    /** Chu kỳ chạy job huỷ đơn hết hạn (phút). */
    private static final long EXPIRY_JOB_INTERVAL_MINUTES = 1L;

    private ScheduledExecutorService scheduler;

    // ── Khởi động khi ứng dụng start ─────────────────────────────────────────

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Dùng daemon thread để JVM tắt được sạch ngay cả khi scheduler chưa shutdown xong
        scheduler = Executors.newSingleThreadScheduledExecutor(runnable -> {
            Thread t = new Thread(runnable, "booking-expiry-cleaner");
            t.setDaemon(true);
            return t;
        });

        // Chạy ngay lúc startup (delay=0), sau đó lặp lại mỗi 5 phút
        scheduler.scheduleAtFixedRate(
                new BookingExpiryJob(),
                0L,
                EXPIRY_JOB_INTERVAL_MINUTES,
                TimeUnit.MINUTES
        );

        LOGGER.info("[AppStartupListener] BookingExpiryJob scheduled: runs every "
                + EXPIRY_JOB_INTERVAL_MINUTES + " minute(s).");
    }

    // ── Dừng khi ứng dụng stop / redeploy ───────────────────────────────────

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (scheduler != null && !scheduler.isShutdown()) {
            scheduler.shutdown();
            try {
                // Chờ tối đa 30 giây cho task đang chạy hoàn thành
                if (!scheduler.awaitTermination(30L, TimeUnit.SECONDS)) {
                    scheduler.shutdownNow();
                    LOGGER.warning("[AppStartupListener] Scheduler force-stopped after 30s timeout.");
                } else {
                    LOGGER.info("[AppStartupListener] Scheduler stopped gracefully.");
                }
            } catch (InterruptedException e) {
                scheduler.shutdownNow();
                Thread.currentThread().interrupt();
                LOGGER.log(Level.WARNING, "[AppStartupListener] Interrupted during shutdown.", e);
            }
        }
    }
}
