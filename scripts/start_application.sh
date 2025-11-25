#!/bin/bash
set -e

echo "Starting Tomcat10..."

# Tomcat 상태 확인
if systemctl is-active --quiet tomcat10; then
    echo "✅ Tomcat10 service is active"
else
    echo "⚠️ Tomcat10 service not active, checking process..."
    if pgrep -f tomcat > /dev/null; then
        echo "✅ Tomcat process is running"
    else
        echo "❌ Tomcat is not running"
        tail -50 /var/log/tomcat10/catalina.out
        exit 1
    fi
fi

# 포트 8080 확인 (최대 30초 대기)
echo "Checking port 8080..."
for i in {1..15}; do
    if netstat -tuln | grep -q ":8080 "; then
        echo "✅ Tomcat10 is listening on port 8080"
        break
    else
        echo "Waiting for port 8080... ($i/15)"
        sleep 2
    fi
done

# 최종 포트 확인
if ! netstat -tuln | grep -q ":8080 "; then
    echo "❌ Tomcat10 is not listening on port 8080 after 30 seconds"
    echo "=== Tomcat logs ==="
    tail -50 /var/log/tomcat10/catalina.out || echo "No logs found"
    exit 1
fi

echo "✅ Tomcat10 started successfully"
exit 0
