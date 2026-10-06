#!/bin/bash
# =============================================================================
# rebuild.sh - Clean + Build + Deploy + Restart trong 1 lệnh
# Dùng mỗi khi thay đổi code. Môi trường WSL2 Fedora (không systemd).
# Cách dùng: sudo bash rebuild.sh
# =============================================================================

set -eo pipefail

GREEN='\033[0;32m'; BLUE='\033[0;34m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; CYAN='\033[0;36m'; NC='\033[0m'
info(){ echo -e "${BLUE}[INFO]${NC} $1"; }
ok(){   echo -e "${GREEN}[OK]${NC}   $1"; }
warn(){ echo -e "${YELLOW}[WARN]${NC} $1"; }
err(){  echo -e "${RED}[ERROR]${NC} $1"; exit 1; }
step(){ echo -e "\n${CYAN}>>> $1${NC}"; }

# --- Lấy IP thật của WSL (không cần hostname/ip/ifconfig) ---
wsl_ip(){ awk 'NR==2{printf "%d.%d.%d.%d\n", strtonum("0x"substr($2,7,2)), strtonum("0x"substr($2,5,2)), strtonum("0x"substr($2,3,2)), strtonum("0x"substr($2,1,2))}' /proc/net/tcp 2>/dev/null; }

# --- Cấu hình ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR"
TOMCAT_DIR="/opt/tomcat9"
APP_NAME="swp391_booking"
WAR_FILE="$PROJECT_DIR/dist/${APP_NAME}.war"
WEBAPPS_DIR="$TOMCAT_DIR/webapps"
MYSQL_DATADIR="/var/lib/mysql"
MYSQL_SOCK="/var/lib/mysql/mysql.sock"
MYSQL_PID="/var/run/mysqld/mysqld.pid"
APP_URL="http://localhost:8080/${APP_NAME}/home"

# --- Hàm tiện ích ---
http_code(){ curl -s -o /dev/null -w "%{http_code}" "$APP_URL" 2>/dev/null; return 0; }
mysql_ready(){ mysqladmin --socket="$MYSQL_SOCK" -u root -p'root@2024' ping 2>/dev/null | grep -q "alive"; }

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
    echo -e "${CYAN}>>> Log khởi động & scheduler của app (gần nhất):${NC}"
    grep -E "com\.project\.|AppStartupListener|BookingExpiryJob" "$catalina" 2>/dev/null | tail -n 15 || true
    echo "----------------------------------------------"

    echo -e "${BLUE}[INFO]${NC} Theo dõi log realtime (Ctrl+C để thoát, Tomcat vẫn chạy nền)..."
    for f in "${logs[@]}"; do echo "  - $f"; done
    echo "----------------------------------------------"
    exec tail -n 40 -F --retry "${logs[@]}"
}

# --- Cần quyền root ---
[ "$EUID" -ne 0 ] && err "Cần quyền root. Chạy: sudo bash rebuild.sh"

# --- JAVA_HOME động ---
JAVA_BIN="$(command -v java || true)"
[ -z "$JAVA_BIN" ] && err "Không tìm thấy Java. Hãy chạy setup_fedora.sh trước."
export JAVA_HOME="$(dirname "$(dirname "$(readlink -f "$JAVA_BIN")")")"

cd "$PROJECT_DIR"
[ -f "$PROJECT_DIR/build-deploy.xml" ] || err "Không thấy build-deploy.xml tại $PROJECT_DIR"

echo ""
echo "=============================================="
echo "  REBUILD - SWP391 Booking"
echo "=============================================="

# =============================================================================
# 1) Dừng Tomcat (để giải phóng WAR đang deploy)
# =============================================================================
step "Dừng Tomcat (nếu đang chạy)..."
if [ "$(http_code)" != "000" ] || pgrep -f "catalina.home=${TOMCAT_DIR}" >/dev/null 2>&1; then
    "$TOMCAT_DIR/bin/shutdown.sh" 2>/dev/null || true
    for i in $(seq 1 15); do [ "$(http_code)" = "000" ] && break; sleep 1; done
    pgrep -f "catalina.home=${TOMCAT_DIR}" >/dev/null 2>&1 && { pkill -f "catalina.home=${TOMCAT_DIR}" 2>/dev/null || true; sleep 2; }
    ok "Đã dừng Tomcat."
else
    ok "Tomcat không chạy."
fi

# =============================================================================
# 2) Clean + Build WAR bằng Ant
# =============================================================================
step "Clean + Build WAR..."
ant -f build-deploy.xml clean dist -Dj2ee.server.home="$TOMCAT_DIR" 2>&1 | tail -15
[ -f "$WAR_FILE" ] || err "Build thất bại! Không thấy WAR tại $WAR_FILE"
ok "Build xong: $(du -h "$WAR_FILE" | cut -f1)"

# =============================================================================
# 3) Deploy WAR mới (xóa bản cũ để Tomcat unpack lại)
# =============================================================================
step "Deploy WAR mới..."
rm -rf "$WEBAPPS_DIR/${APP_NAME}" "$WEBAPPS_DIR/${APP_NAME}.war"
cp "$WAR_FILE" "$WEBAPPS_DIR/"
chown tomcat:tomcat "$WEBAPPS_DIR/${APP_NAME}.war" 2>/dev/null || true
ok "Đã copy WAR vào $WEBAPPS_DIR."

# =============================================================================
# 4) Đảm bảo MySQL đang chạy
# =============================================================================
step "Kiểm tra MySQL..."
if pgrep -x mysqld >/dev/null 2>&1 && mysql_ready; then
    ok "MySQL đang chạy."
else
    info "Khởi động MySQL..."
    mkdir -p /var/run/mysqld /var/log/mysql
    chown mysql:mysql /var/run/mysqld 2>/dev/null || true
    if ! pgrep -x mysqld >/dev/null 2>&1; then
        nohup mysqld --user=mysql --datadir="$MYSQL_DATADIR" \
                     --socket="$MYSQL_SOCK" --pid-file="$MYSQL_PID" \
                     > /var/log/mysql/manual-start.log 2>&1 &
    fi
    for i in $(seq 1 40); do mysql_ready && break; sleep 1; done
    mysql_ready || err "MySQL không khởi động được. Xem /var/log/mysql/manual-start.log"
    ok "MySQL sẵn sàng."
fi

# =============================================================================
# 5) Khởi động Tomcat & chờ ứng dụng
# =============================================================================
step "Khởi động Tomcat..."
"$TOMCAT_DIR/bin/startup.sh" >/dev/null 2>&1
info "Chờ ứng dụng phản hồi..."
CODE=000
for i in $(seq 1 60); do
    CODE=$(http_code)
    [ "$CODE" = "200" ] && break
    sleep 1
done

echo ""
if [ "$CODE" = "200" ]; then
    WSL_IP="$(wsl_ip)"
    echo "=============================================="
    echo -e "${GREEN}  REBUILD & DEPLOY THÀNH CÔNG (HTTP $CODE)${NC}"
    echo "=============================================="
    echo ""
    echo "  Truy cập:  $APP_URL"
    if [ -n "$WSL_IP" ] && [ "$WSL_IP" != "127.0.0.1" ]; then
    echo -e "  ${YELLOW}Nếu localhost không vào được (đổi mạng):${NC}"
    echo -e "  ${YELLOW}  http://${WSL_IP}:8080/${APP_NAME}/home${NC}"
    fi
    echo "  Đăng nhập: http://localhost:8080/${APP_NAME}/login"
    echo ""
    # --- Stream log realtime của Tomcat + app ---
    step "Theo dõi log realtime..."
    follow_logs
else
    warn "Ứng dụng chưa phản hồi (HTTP $CODE). Xem log:"
    echo "  sudo tail -60 $TOMCAT_DIR/logs/catalina.out"
fi
