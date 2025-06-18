#!/bin/bash

# Dgraph 集群安装脚本 for ARM架构 (EulerOS/HCE/Ubuntu)
# 支持 Zero + Alpha 节点部署
# 使用 hyermodeinc/dgraph v24.1.3 版本

set -e

# 检查root权限
if [ "$(id -u)" -ne 0 ]; then
    echo "请使用root用户或sudo运行此脚本"
    exit 1
fi

# 检测系统类型
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    OS_VERSION=$VERSION_ID
elif [ -f /etc/hce-release ]; then
    OS="hce"
    OS_VERSION=$(grep -oP '(?<=release )\d' /etc/hce-release)
elif [ -f /etc/euleros-release ]; then
    OS="euleros"
    OS_VERSION=$(grep -oP '(?<=release )\d' /etc/euleros-release)
else
    echo "无法检测操作系统类型"
    exit 1
fi

# 配置参数
DGRAPH_VERSION="v24.1.3"
DGRAPH_URL="https://github.com/hypermodeinc/dgraph/releases/download/${DGRAPH_VERSION}/dgraph-linux-arm64.tar.gz"
DGRAPH_DIR="/usr/local/bin"
DGRAPH_DATA_DIR="/var/lib/dgraph"
ZERO_SERVICE_FILE="/etc/systemd/system/dgraph-zero.service"
ALPHA_SERVICE_FILE="/etc/systemd/system/dgraph-alpha.service"
ALPHA_DATA_DIR="/var/lib/dgraph/alpha"  # Alpha节点独立数据目录

# 安装依赖
echo "安装系统依赖..."
case "$OS" in
    "ubuntu")
        apt-get update
        apt-get install -y wget tar
        ;;
    "euleros"|"hce")
        yum install -y wget tar
        ;;
    *)
        echo "不支持的操作系统: $OS"
        exit 1
        ;;
esac

# 创建Dgraph用户和目录
echo "创建Dgraph用户和数据目录..."
if ! id -u dgraph >/dev/null 2>&1; then
    useradd -r -s /bin/false -d $DGRAPH_DATA_DIR -m dgraph
fi

# Zero节点目录
mkdir -p $DGRAPH_DATA_DIR/{p,w,zw}
# Alpha节点目录
mkdir -p $ALPHA_DATA_DIR
chown -R dgraph:dgraph $DGRAPH_DATA_DIR $ALPHA_DATA_DIR

# 下载并安装Dgraph
echo "下载并安装Dgraph $DGRAPH_VERSION for ARM..."
cd /tmp
if ! wget $DGRAPH_URL -O dgraph.tar.gz; then
    echo "下载Dgraph失败，请检查URL是否正确或网络连接"
    exit 1
fi

if ! tar -xzf dgraph.tar.gz; then
    echo "解压Dgraph包失败"
    exit 1
fi

# 移动二进制文件
mv dgraph $DGRAPH_DIR/dgraph
chmod +x $DGRAPH_DIR/dgraph
[ -f badger ] && mv badger $DGRAPH_DIR/badger && chmod +x $DGRAPH_DIR/badger

# 创建Zero节点服务
echo "配置Zero节点服务..."
cat > $ZERO_SERVICE_FILE <<EOF
[Unit]
Description=Dgraph Zero Service
After=network.target

[Service]
User=dgraph
Group=dgraph
Type=simple
ExecStart=$DGRAPH_DIR/dgraph zero --my=localhost:5080 \
  --replicas 1 \
  --raft "idx=1" \
  --telemetry "sentry=false;reports=false"
Restart=always
LimitNOFILE=65536
WorkingDirectory=$DGRAPH_DATA_DIR

[Install]
WantedBy=multi-user.target
EOF

# 创建Alpha节点服务
echo "配置Alpha节点服务..."
cat > $ALPHA_SERVICE_FILE <<EOF
[Unit]
Description=Dgraph Alpha Service
After=network.target dgraph-zero.service

[Service]
User=dgraph
Group=dgraph
Type=simple
ExecStart=$DGRAPH_DIR/dgraph alpha \
  --my=localhost:7080 \
  --zero=localhost:5080 \
  --postings $ALPHA_DATA_DIR/p \
  --wal $ALPHA_DATA_DIR/w \
  --telemetry "sentry=false;reports=false"
Restart=always
LimitNOFILE=65536
WorkingDirectory=$ALPHA_DATA_DIR

[Install]
WantedBy=multi-user.target
EOF

# 重载并启动服务
systemctl daemon-reload
systemctl enable dgraph-zero.service
systemctl enable dgraph-alpha.service

echo ""
echo "============================================"
echo "Dgraph $DGRAPH_VERSION 集群安装完成！"
echo "============================================"
echo "Zero 节点配置:"
echo "  - 服务文件: $ZERO_SERVICE_FILE"
echo "  - 数据目录: $DGRAPH_DATA_DIR"
echo "  - 管理端口: 6080 (HTTP)"
echo ""
echo "Alpha 节点配置:"
echo "  - 服务文件: $ALPHA_SERVICE_FILE"
echo "  - 数据目录: $ALPHA_DATA_DIR"
echo "  - 服务端口: 8080 (HTTP), 9080 (gRPC)"
echo ""
echo "管理命令:"
echo "  启动集群: systemctl start dgraph-zero dgraph-alpha"
echo "  停止集群: systemctl stop dgraph-alpha dgraph-zero"
echo "  状态检查: systemctl status dgraph-{zero,alpha}"
echo ""
echo "访问Ratel UI: http://localhost:8080"
echo "============================================"
exit 0