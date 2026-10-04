#!/bin/bash
# =============================================================================
# run-mac.sh - Script build & chạy Smart Booking Platform trên macOS
# Tự động nhận diện JDK 17, Tomcat 9, MySQL qua Homebrew
# Cách dùng:
#   ./run-mac.sh         : Build WAR + Deploy lên Tomcat 9 + Khởi động
#   ./run-mac.sh build   : Chỉ build WAR
#   ./run-mac.sh restart : Khởi động lại Tomcat
#   ./run-mac.sh logs    : Xem log realtime
#   ./run-mac.sh stop    : Dừng Tomcat
# =============================================================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

info(){ echo -e "${BLUE}[INFO]${NC} $1"; }
ok(){   echo -e "${GREEN}[OK]${NC}   $1"; }
warn(){ echo -e "${YELLOW}[WARN]${NC} $1"; }
err(){  echo -e "${RED}[ERROR]${NC} $1"; exit 1; }
step(){ echo -e "\n${CYAN}>>> $1${NC}"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# 1. Xác định Java 17
if [ -d "/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home" ]; then
    export JAVA_HOME="/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home"
elif /usr/libexec/java_home -v 17 &>/dev/null; then
    export JAVA_HOME="$(/usr/libexec/java_home -v 17)"
fi

[ -z "$JAVA_HOME" ] && err "Không tìm thấy JDK 17. Hãy kiểm tra cài đặt JDK 17."
export PATH="$JAVA_HOME/bin:/opt/homebrew/bin:$PATH"

# 2. Xác định Tomcat 9
TOMCAT_DIR="/opt/homebrew/opt/tomcat@9/libexec"
if [ ! -d "$TOMCAT_DIR" ]; then
    TOMCAT_DIR="$(brew --prefix tomcat@9 2>/dev/null)/libexec"
fi
[ -d "$TOMCAT_DIR" ] || err "Không tìm thấy Tomcat 9 tại $TOMCAT_DIR."

APP_NAME="swp391_booking"
WAR_FILE="$SCRIPT_DIR/dist/${APP_NAME}.war"
WEBAPPS_DIR="$TOMCAT_DIR/webapps"
APP_URL="http://localhost:8080/${APP_NAME}/home"

http_code(){
    curl -s -o /dev/null -w "%{http_code}" "$APP_URL" 2>/dev/null || echo "000"
}

build_war(){
    step "Clean & Build WAR bằng Apache Ant..."
    ant -f build-deploy.xml clean dist -Dj2ee.server.home="$TOMCAT_DIR"
    [ -f "$WAR_FILE" ] || err "Build thất bại! Không tìm thấy file $WAR_FILE"
    ok "Build thành công: $(du -h "$WAR_FILE" | cut -f1)"
}

deploy_war(){
    step "Deploy WAR vào Tomcat 9..."
    rm -rf "$WEBAPPS_DIR/${APP_NAME}" "$WEBAPPS_DIR/${APP_NAME}.war"
    cp "$WAR_FILE" "$WEBAPPS_DIR/"
    ok "Đã copy $WAR_FILE -> $WEBAPPS_DIR/"
}

restart_tomcat(){
    step "Khởi động lại Tomcat 9..."
    brew services restart tomcat@9 >/dev/null 2>&1
    info "Đang chờ ứng dụng khởi động..."
    
    CODE="000"
    for i in $(seq 1 30); do
        CODE=$(http_code)
        if [ "$CODE" = "200" ]; then
            break
        fi
        sleep 1
    done

    if [ "$CODE" = "200" ]; then
        echo ""
        echo "=============================================="
        echo -e "${GREEN}  DEPLOY & KHỞI ĐỘNG THÀNH CÔNG (HTTP $CODE)${NC}"
        echo "=============================================="
        echo ""
        echo "  🌐 URL Trang chủ:  $APP_URL"
        echo "  🔑 URL Đăng nhập:  http://localhost:8080/${APP_NAME}/login"
        echo ""
    else
        warn "Ứng dụng trả về mã HTTP $CODE sau 30s. Kiểm tra log:"
        echo "  tail -50 $TOMCAT_DIR/logs/catalina.$(date +%F).log"
    fi
}

show_logs(){
    step "Xem log realtime (Ctrl+C để thoát)..."
    local today; today="$(date +%F)"
    tail -n 50 -f "$TOMCAT_DIR/logs/catalina.${today}.log"
}

case "$1" in
    build)
        build_war
        ;;
    deploy)
        deploy_war
        restart_tomcat
        ;;
    restart)
        restart_tomcat
        ;;
    stop)
        step "Dừng Tomcat 9..."
        brew services stop tomcat@9
        ok "Đã dừng Tomcat."
        ;;
    logs)
        show_logs
        ;;
    *)
        echo "=============================================="
        echo "  SWP391 Booking Platform - macOS Runner"
        echo "=============================================="
        build_war
        deploy_war
        restart_tomcat
        ;;
esac
