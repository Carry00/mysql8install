#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

# 检查是否能访问互联网
echo "Checking internet connectivity..."
http_code=$(curl -s -o /dev/null -w "%{http_code}" http://mirrorlist.centos.org)
if [ "$http_code" -ne 200 ]; then
    echo "This script must be run with internet,pls export http_proxy=http://x.x.x.x:xx;export https_porxy=https://x.x.x.x:xx"
    exit 1
fi

# 打印欢迎信息
echo "Welcome to the installation script for our services! Please select the service you wish to install:"
# 列出可用的服务选项
options=("MySQL" "Kafka" "Redis" "Elasticsearch" "Filebeat" "Logstash" "Node_exporter")

# 打印可用选项
for i in "${!options[@]}"; do
    echo "$i. ${options[$i]}"
done

# 提示用户选择服务
echo -n "Please enter the service number(s) you wish to install, separated by spaces (e.g., 0 1 2):"
read -r choices

# 检查选择的服务并执行相应安装
for choice in $choices; do
    case $choice in

    0) # 安装MySQL

        if [ ! -f "/opt/greatsql-mysql-router-8.0.32-24.1.el7.x86_64.rpm" ]; then
            echo "Downloading greatsql-mysql-router-8.0.32-24.1.el7.x86_64.rpm"
            wget https://product.greatdb.com/GreatSQL-8.0.32-24/greatsql-mysql-router-8.0.32-24.1.el7.x86_64.rpm -cP /opt/
            yum localinstall -y /opt/greatsql-mysql-router-8.0.32-24.1.el7.x86_64.rpm
            systemctl enable mysql-router

        fi

        if [ ! -f "/opt/mysql-shell-8.0.34-1.el7.x86_64.rpm" ]; then
            echo "Downloading mysql-shell-8.0.34-1.el7.x86_64.rpm"
            wget https://yum.oracle.com/repo/OracleLinux/OL7/MySQL80/tools/community/x86_64/getPackage/mysql-shell-8.0.34-1.el7.x86_64.rpm -cP /opt/
            yum localinstall -y /opt/mysql-shell-8.0.34-1.el7.x86_64.rpm

        fi
        if [ ! -f "/opt/GreatSQL-8.0.32-24-Linux-glibc2.17-x86_64.tar.xz" ]; then
            echo "Downloading GreatSQL-8.0.32-24-Linux-glibc2.17-x86_64.tar.xz"
            wget https://product.greatdb.com/GreatSQL-8.0.32-24/GreatSQL-8.0.32-24-Linux-glibc2.17-x86_64.tar.xz -cP /opt/
        fi

        if [ ! -f "/opt/MySQL8install.py" ]; then
            echo "Downloading MySQL8install.py"
            wget https://raw.githubusercontent.com/Carry00/mysql8install/main/MySQL8install.py -cP /opt/
        fi
        if [ ! -f "/opt/MySQL8install.py" ]; then
            echo "Downloading MySQL8install.py"
            wget https://raw.githubusercontent.com/Carry00/mysql8install/main/MySQL8install.py -cP /opt/
        fi
        if [ ! -f "/opt/my.cnf" ]; then
            echo "Downloading MySQL8install.py"
            wget https://raw.githubusercontent.com/Carry00/mysql8install/main/my.cnf -cP /opt/
        fi
        if [ ! -f "/opt/mysql" ]; then
            echo "Downloading mysql"
            wget https://raw.githubusercontent.com/Carry00/mysql8install/main/mysql -cP /opt/
        fi
        # 询问端口号
        echo -n "Please enter the MySQL port number (default is 3366):"
        read -r mysql_port
        mysql_port=${mysql_port:-3366}

        # 询问innodb buffer pool大小
        default_buffer=$(free -g | awk 'NR==2 {print int($2/2)}')
        echo -n "Please enter the InnoDB buffer pool size (e.g. "$default_buffer"G default:$default_buffer""G,half of the total system memory）："
        read -r buffer_pool
        buffer_pool=${buffer_pool:-$default_buffer'G'}
        echo "Installing MySQL..."
        cd /opt/

        python2.7 MySQL8install.py install --instance-ports="$mysql_port" --innodb-buffer-pool-size="$buffer_pool"

        ;;

    \
        1) # 安装Kafka
        echo "Installing Kafka..."
        ;;
    2) # 安装Redis
        echo "Installing Redis..."
        ;;
    3) # 安装Elasticsearch
        echo "Installing Elasticsearch..."
        ;;
    4) # 安装Filebeat
        echo "Installing Filebeat..."
        ;;
    5) # 安装Logstash
        echo "Installing Logstash..."
        ;;
    6) # 安装Node_exporter
        echo "Installing Node_exporter..."

        ;;
    *) # 无效选择
        echo "Error: Invalid service number $choice"
        ;;
    esac
done

echo "Installation completed!"
