#!/bin/bash
set -e

echo "Running AfterInstall..."

# 파일 권한 설정
chown -R ec2-user:ec2-user /home/ec2-user/app
chmod -R 755 /home/ec2-user/app

# 환경 설정 파일 생성 (필요 시)
# cat > /home/ec2-user/app/.env <<EOF
# NODE_ENV=production
# PORT=3000
# EOF

# Tomcat 설정 (WAR 파일 배포)
# WAR 파일을 Tomcat webapps 디렉토리로 복사
if [ -f /home/ec2-user/app/*.war ]; then
    echo "Deploying WAR file to Tomcat..."
    cp /home/ec2-user/app/*.war /usr/share/tomcat/webapps/
    chown tomcat:tomcat /usr/share/tomcat/webapps/*.war
fi

# 또는 디렉토리 구조 그대로 배포하는 경우
# cp -r /home/ec2-user/app/* /usr/share/tomcat/webapps/ROOT/

echo "AfterInstall completed"
exit 0
