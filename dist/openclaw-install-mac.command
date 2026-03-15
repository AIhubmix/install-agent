#!/bin/bash
# OpenClaw 安装助手 - Mac 一键启动脚本
# 双击此文件即可运行，自动下载对应版本并启动

set -e

cd "$(dirname "$0")"

# 检测芯片类型
ARCH=$(uname -m)
if [ "$ARCH" = "arm64" ]; then
    SUFFIX="darwin-arm64"
else
    SUFFIX="darwin-amd64"
fi

# 查找本地带版本号的二进制文件（如 openclaw-install-1.0.1-darwin-arm64）
BIN=$(ls openclaw-install-*-${SUFFIX} 2>/dev/null | head -1)

if [ -z "$BIN" ]; then
    # 本地没有，从 GitHub latest release 下载
    BASE_URL="https://github.com/AIhubmix/install-agent/releases/latest/download"

    # 先获取 latest release 的实际版本号（从 302 重定向 header 提取，不跟随到 CDN）
    echo ""
    echo "🐾 首次运行，正在获取最新版本信息..."
    LOCATION=$(curl -fsSI "https://github.com/AIhubmix/install-agent/releases/latest" 2>/dev/null | grep -i "^location:" | head -1)
    RELEASE_VER=$(echo "$LOCATION" | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' | head -1)
    if [ -z "$RELEASE_VER" ]; then
        echo "❌ 无法获取最新版本号，请检查网络连接。"
        echo ""
        echo "按回车键退出..."
        read
        exit 1
    fi
    # 去掉 v 前缀，二进制文件名不含 v（如 openclaw-install-1.0.2-darwin-arm64）
    VER="${RELEASE_VER#v}"
    BIN="openclaw-install-${VER}-${SUFFIX}"

    # GitHub 加速镜像列表（优先尝试镜像，最后回退直连）
    DIRECT_URL="$BASE_URL/$BIN"
    MIRRORS=(
        "https://ghfast.top/$DIRECT_URL"
        "https://gh-proxy.com/$DIRECT_URL"
        "https://github.moeyy.xyz/$DIRECT_URL"
        "$DIRECT_URL"
    )

    echo "   下载: $BIN"
    echo ""
    DOWNLOADED=0
    for URL in "${MIRRORS[@]}"; do
        if [ "$URL" = "$DIRECT_URL" ]; then
            echo "   尝试 GitHub 直连..."
        else
            # 从镜像 URL 中提取域名作为提示
            MIRROR_HOST=$(echo "$URL" | sed 's|https\?://\([^/]*\)/.*|\1|')
            echo "   尝试镜像: $MIRROR_HOST"
        fi
        if command -v curl &>/dev/null; then
            if curl -fSL --connect-timeout 10 --max-time 120 --progress-bar -o "$BIN" "$URL" 2>/dev/null; then
                DOWNLOADED=1
                break
            fi
        elif command -v wget &>/dev/null; then
            if wget --timeout=10 --show-progress -q -O "$BIN" "$URL" 2>/dev/null; then
                DOWNLOADED=1
                break
            fi
        fi
        echo "   ❌ 失败，尝试下一个..."
        rm -f "$BIN"
    done

    if [ "$DOWNLOADED" -ne 1 ]; then
        echo ""
        echo "❌ 所有下载源均失败，请检查网络连接。"
        echo "   你也可以手动下载并放到本脚本同目录："
        echo "   $DIRECT_URL"
        echo ""
        echo "按回车键退出..."
        read
        exit 1
    fi
    echo ""
    echo "✅ 下载完成！"
fi

# 自动处理权限和 macOS 安全限制
chmod +x "$BIN"
xattr -cr "$BIN" 2>/dev/null || true

echo ""
echo "🐾 正在启动 OpenClaw 安装助手..."
echo ""

# 运行
./"$BIN"

echo ""
echo "按回车键退出..."
read
