#!/bin/bash
set -e

echo "Starting application..."

# Tomcat 시작
echo "Starting Tomcat..."
systemctl start tomcat

# Tomcat이 완전히 시작될 때까지 대기
sleep 10

# Tomcat 상태 확인
if systemctl is-active --quiet tomcat; then
    echo "Tomcat started successfully"
else
    echo "Failed to start Tomcat"
    exit 1
fi

echo "Application started"
exit 0
