
#!/bin/bash
set -e

echo "Running BeforeInstall..."

# Tomcat 설치 확인
if ! command -v systemctl &> /dev/null || ! systemctl list-unit-files | grep -q tomcat; then
    echo "Installing Tomcat..."
    # Amazon Linux 2023
    yum install -y tomcat10 || amazon-linux-extras install tomcat10 -y
fi

# 배포 디렉토리 준비
mkdir -p /home/ec2-user/app
chown -R ec2-user:ec2-user /home/ec2-user/app

# Tomcat webapps 디렉토리 확인
mkdir -p /usr/share/tomcat10/webapps
chown -R tomcat:tomcat /usr/share/tomcat10/webapps

# 이전 배포 백업 (선택사항)
if [ -f /usr/share/tomcat10/webapps/*.war ]; then
    echo "Backing up previous WAR file..."
    mkdir -p /home/ec2-user/backup
    cp /usr/share/tomcat10/webapps/*.war /home/ec2-user/backup/app-backup-$(date +%Y%m%d-%H%M%S).war || true
fi

echo "BeforeInstall completed"
exit 0
