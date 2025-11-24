#!/bin/bash
set -e

echo "Validating service..."

# Tomcat 서비스 상태 확인
if systemctl is-active --quiet tomcat; then
    echo "Tomcat service is active"
else
    echo "Tomcat service is not active"
    exit 1
fi

# Tomcat HTTP 응답 확인 (포트 8080)
echo "Checking Tomcat HTTP response..."
MAX_RETRIES=10
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if curl -f http://http://ljw-alb-1059952775.us-east-1.elb.amazonaws.com/app/ > /dev/null 2>&1; then
        echo "Tomcat is responding on port 8080"
        echo "Validation passed"
        exit 0
    else
        echo "Waiting for Tomcat to respond... (Attempt $((RETRY_COUNT + 1))/$MAX_RETRIES)"
        sleep 3
        RETRY_COUNT=$((RETRY_COUNT + 1))
    fi
done

echo "Tomcat is not responding after $MAX_RETRIES attempts"
exit 1

exit 0
