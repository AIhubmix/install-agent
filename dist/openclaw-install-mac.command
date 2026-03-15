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

    # 先下载 checksums.txt 用于校验（小文件，直连即可）
    CHECKSUMS_URL="$BASE_URL/checksums.txt"
    EXPECTED_SHA=""
    if curl -fsSL --connect-timeout 10 -o checksums.txt "$CHECKSUMS_URL" 2>/dev/null; then
        EXPECTED_SHA=$(grep "$BIN" checksums.txt 2>/dev/null | awk '{print $1}')
    fi
    rm -f checksums.txt

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
            MIRROR_HOST=$(echo "$URL" | sed 's|https\?://\([^/]*\)/.*|\1|')
            echo "   尝试镜像: $MIRROR_HOST"
        fi
        if command -v curl &>/dev/null; then
            curl -fSL --connect-timeout 10 --max-time 300 --progress-bar -o "$BIN" "$URL" 2>/dev/null || { echo "   ❌ 下载失败，尝试下一个..."; rm -f "$BIN"; continue; }
        elif command -v wget &>/dev/null; then
            wget --timeout=10 --show-progress -q -O "$BIN" "$URL" 2>/dev/null || { echo "   ❌ 下载失败，尝试下一个..."; rm -f "$BIN"; continue; }
        fi
        # SHA256 校验（如果有 checksum）
        if [ -n "$EXPECTED_SHA" ]; then
            ACTUAL_SHA=$(shasum -a 256 "$BIN" 2>/dev/null | awk '{print $1}')
            if [ "$ACTUAL_SHA" != "$EXPECTED_SHA" ]; then
                echo "   ❌ 文件校验失败（可能下载不完整），尝试下一个..."
                rm -f "$BIN"
                continue
            fi
        fi
        DOWNLOADED=1
        break
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
