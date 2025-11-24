#!/bin/bash
set -e

echo "Validating service..."

# 애플리케이션이 실행 중인지 확인
# 예시 1: 프로세스 확인
# if pgrep -f "ljw-app" > /dev/null; then
#     echo "Application is running"
# else
#     echo "Application is not running"
#     exit 1
# fi

# 예시 2: HTTP 응답 확인
# if curl -f http://http://ljw-alb-1059952775.us-east-1.elb.amazonaws.com/app/ > /dev/null 2>&1; then
#     echo "Application is responding"
# else
#     echo "Application is not responding"
#     exit 1
# fi

# 예시 3: systemd 서비스 상태 확인
# if systemctl is-active --quiet httpd; then
#     echo "Service is active"
# else
#     echo "Service is not active"
#     exit 1
# fi

# 간단한 검증: 파일이 제대로 배포되었는지 확인
if [ -d "/home/ec2-user/app" ]; then
    echo "Deployment directory exists"
    echo "Validation passed"
else
    echo "Deployment directory not found"
    exit 1
fi

exit 0
