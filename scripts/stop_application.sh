#!/bin/bash
set -e

echo "Stopping Tomcat..."

# Tomcat 중지
systemctl stop tomcat10 || true

# Tomcat 프로세스 완전히 종료될 때까지 대기
sleep 5

# 혹시 남아있는 프로세스 강제 종료
pkill -9 -f tomcat10 || true

# 이전 WAR 파일 삭제 (선택사항)
# rm -f /usr/share/tomcat10/webapps/*.war
# rm -rf /usr/share/tomcat10/webapps/ROOT/*

echo "Tomcat stopped"

exit 0
