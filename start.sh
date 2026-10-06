#!/bin/bash
# =============================================================================
# start.sh - Khởi động toàn bộ ứng dụng swp391_booking bằng 1 file duy nhất
# Môi trường: WSL2 Fedora (KHÔNG có systemd) -> chạy MySQL & Tomcat thủ công
# Cách dùng: sudo bash start.sh
# =============================================================================

set -eo pipefail

GREEN='\033[0;32m'; BLUE='\033[0;34m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
info(){ echo -e "${BLUE}[INFO]${NC} $1"; }
ok(){   echo -e "${GREEN}[OK]${NC}   $1"; }
warn(){ echo -e "${YELLOW}[WARN]${NC} $1"; }
err(){  echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# --- Cấu hình ---
TOMCAT_DIR="/opt/tomcat9"
APP_NAME="swp391_booking"
MYSQL_DATADIR="/var/lib/mysql"
MYSQL_SOCK="/var/lib/mysql/mysql.sock"
MYSQL_PID="/var/run/mysqld/mysqld.pid"
APP_URL="http://localhost:8080/${APP_NAME}/home"

# --- Hàm tiện ích: kiểm tra cổng đang lắng nghe ---
port_listening(){ ss -tln 2>/dev/null | grep -q ":$1 "; }
# --- Kiểm tra MySQL thực sự nhận kết nối (đáng tin hơn ss trong WSL) ---
mysql_ready(){ mysqladmin --socket="$MYSQL_SOCK" -u root -p'root@2024' ping 2>/dev/null | grep -q "alive"; }
# --- Lấy IP thật của WSL (không cần hostname/ip/ifconfig) ---
wsl_ip(){ awk 'NR==2{printf "%d.%d.%d.%d\n", strtonum("0x"substr($2,7,2)), strtonum("0x"substr($2,5,2)), strtonum("0x"substr($2,3,2)), strtonum("0x"substr($2,1,2))}' /proc/net/tcp 2>/dev/null; }

# --- Theo dõi log realtime: catalina.out + localhost (log app/JUL) + access log ---
# - Log startup/scheduler (AppStartupListener, BookingExpiryJob) -> catalina.out & catalina.<date>.log
# - Log lỗi app khi xử lý request (JUL)                          -> localhost.<date>.log
# - Mỗi HTTP request khi trỏ trang                               -> localhost_access_log.<date>.txt
# Dùng -F --retry phòng khi file ngày mới chưa tạo.
follow_logs(){
    local today; today="$(date +%F)"
    local catalina="$TOMCAT_DIR/logs/catalina.out"
    local logs=(
        "$catalina"
        "$TOMCAT_DIR/logs/localhost.${today}.log"
        "$TOMCAT_DIR/logs/localhost_access_log.${today}.txt"
    )

    # In tóm tắt các log startup/scheduler của app vừa phát sinh (đảm bảo không bỏ sót
    # dù chúng đã trôi khỏi vùng tail realtime do xảy ra lúc khởi động).
    echo "=== Log khởi động & scheduler của app (gần nhất) ==="
    grep -E "com\.project\.|AppStartupListener|BookingExpiryJob" "$catalina" 2>/dev/null | tail -n 15 || true
    echo "----------------------------------------------"

    echo -e "${BLUE}[INFO]${NC} Theo dõi log realtime (Ctrl+C để thoát, Tomcat vẫn chạy nền)..."
    for f in "${logs[@]}"; do echo "  - $f"; done
    echo "----------------------------------------------"
    exec tail -n 40 -F --retry "${logs[@]}"
}

# --- Cần quyền root ---
if [ "$EUID" -ne 0 ]; then
    err "Cần quyền root. Chạy: sudo bash start.sh"
fi

# Xác định JAVA_HOME động
JAVA_BIN="$(command -v java || true)"
[ -z "$JAVA_BIN" ] && err "Không tìm thấy Java. Hãy chạy setup_fedora.sh trước."
export JAVA_HOME="$(dirname "$(dirname "$(readlink -f "$JAVA_BIN")")")"

echo ""
echo "=============================================="
echo "  Khởi động SWP391 Booking"
echo "=============================================="

# =============================================================================
# 1) MySQL  (nhận diện bằng tiến trình mysqld + cổng 3306)
# =============================================================================
if pgrep -x mysqld >/dev/null 2>&1 && mysql_ready; then
    ok "MySQL đã chạy sẵn."
else
    info "Khởi động MySQL..."
    mkdir -p /var/run/mysqld /var/log/mysql
    chown mysql:mysql /var/run/mysqld 2>/dev/null || true
    if ! pgrep -x mysqld >/dev/null 2>&1; then
        nohup mysqld --user=mysql \
                     --datadir="$MYSQL_DATADIR" \
                     --socket="$MYSQL_SOCK" \
                     --pid-file="$MYSQL_PID" \
                     > /var/log/mysql/manual-start.log 2>&1 &
    fi
    # Chờ MySQL nhận kết nối
    for i in $(seq 1 40); do
        if mysql_ready; then ok "MySQL sẵn sàng sau ${i}s."; break; fi
        sleep 1
    done
    mysql_ready || err "MySQL không khởi động được. Xem /var/log/mysql/manual-start.log"
fi

# =============================================================================
# 2) Tomcat  (nhận diện qua HTTP probe - đáng tin trong WSL)
# =============================================================================
http_code(){ curl -s -o /dev/null -w "%{http_code}" "$APP_URL" 2>/dev/null; return 0; }

if [ "$(http_code)" != "000" ]; then
    ok "Tomcat đã chạy sẵn."
else
    info "Khởi động Tomcat..."
    [ -d "$TOMCAT_DIR" ] || err "Không tìm thấy Tomcat tại $TOMCAT_DIR. Hãy chạy setup_fedora.sh trước."
    "$TOMCAT_DIR/bin/startup.sh" >/dev/null 2>&1
    info "Chờ Tomcat khởi động..."
    for i in $(seq 1 40); do
        [ "$(http_code)" != "000" ] && { ok "Tomcat đã phản hồi sau ${i}s."; break; }
        sleep 1
    done
fi

# =============================================================================
# 3) Chờ ứng dụng phản hồi & báo kết quả
# =============================================================================
info "Chờ ứng dụng phản hồi..."
CODE=000
for i in $(seq 1 40); do
    CODE=$(curl -s -o /dev/null -w "%{http_code}" "$APP_URL" 2>/dev/null)
    [ "$CODE" = "200" ] && break
    sleep 1
done

echo ""
if [ "$CODE" = "200" ]; then
    WSL_IP="$(wsl_ip)"
    echo "=============================================="
    echo -e "${GREEN}  ỨNG DỤNG ĐANG CHẠY (HTTP $CODE)${NC}"
    echo "=============================================="
    echo ""
    echo "  Truy cập:  $APP_URL"
    if [ -n "$WSL_IP" ] && [ "$WSL_IP" != "127.0.0.1" ]; then
    echo -e "  ${YELLOW}Nếu localhost không vào được (đổi mạng):${NC}"
    echo -e "  ${YELLOW}  http://${WSL_IP}:8080/${APP_NAME}/home${NC}"
    fi
    echo "  Đăng nhập: http://localhost:8080/${APP_NAME}/login"
    echo ""
    echo "  Dừng ứng dụng:  sudo bash stop.sh"
    echo ""
    # --- Stream log realtime của Tomcat + app ---
    follow_logs
else
    warn "Ứng dụng chưa phản hồi (HTTP $CODE). Xem log:"
    echo "  sudo tail -50 $TOMCAT_DIR/logs/catalina.out"
fi
