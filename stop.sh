#!/bin/bash
# =============================================================================
# stop.sh - Dừng ứng dụng swp391_booking (Tomcat + MySQL)
# Cách dùng: sudo bash stop.sh
# =============================================================================
set -eo pipefail

GREEN='\033[0;32m'; BLUE='\033[0;34m'; NC='\033[0m'
info(){ echo -e "${BLUE}[INFO]${NC} $1"; }
ok(){   echo -e "${GREEN}[OK]${NC}   $1"; }

TOMCAT_DIR="/opt/tomcat9"
MYSQL_SOCK="/var/lib/mysql/mysql.sock"
APP_URL="http://localhost:8080/swp391_booking/home"
tomcat_up(){ [ "$(curl -s -o /dev/null -w '%{http_code}' "$APP_URL" 2>/dev/null)" != "000" ]; }

if [ "$EUID" -ne 0 ]; then echo "Cần quyền root: sudo bash stop.sh"; exit 1; fi
export JAVA_HOME="$(dirname "$(dirname "$(readlink -f "$(command -v java)")")")"

# --- Dừng Tomcat ---
if tomcat_up || pgrep -f "catalina.home=${TOMCAT_DIR}" >/dev/null 2>&1; then
    info "Dừng Tomcat..."
    "$TOMCAT_DIR/bin/shutdown.sh" 2>/dev/null || true
    for i in $(seq 1 15); do tomcat_up || break; sleep 1; done
    # Nếu còn treo, kill đúng tiến trình Tomcat này
    if pgrep -f "catalina.home=${TOMCAT_DIR}" >/dev/null 2>&1; then
        pkill -f "catalina.home=${TOMCAT_DIR}" 2>/dev/null || true
        sleep 2
    fi
    ok "Đã dừng Tomcat."
else
    ok "Tomcat không chạy."
fi

# --- Dừng MySQL ---
if pgrep -x mysqld >/dev/null 2>&1; then
    info "Dừng MySQL..."
    mysqladmin --socket="$MYSQL_SOCK" -u root -p'root@2024' shutdown 2>/dev/null || pkill -x mysqld || true
    for i in $(seq 1 15); do pgrep -x mysqld >/dev/null 2>&1 || break; sleep 1; done
    ok "Đã dừng MySQL."
else
    ok "MySQL không chạy."
fi

echo ""
ok "Đã dừng toàn bộ ứng dụng."
