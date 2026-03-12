# OpenClaw 安装助手

一键安装 OpenClaw 的交互式助手，下载即用，无需安装任何依赖。

## 下载

根据你的系统选择对应文件：

| 系统 | 文件 |
|------|------|
| macOS (Apple 芯片 M1/M2/M3/M4) | `openclaw-install-darwin-arm64` |
| macOS (Intel) | `openclaw-install-darwin-amd64` |
| Linux (x86_64) | `openclaw-install-linux-amd64` |
| Linux (ARM64) | `openclaw-install-linux-arm64` |
| Windows | `openclaw-install-windows-amd64.exe` |

> 不确定自己的芯片？macOS 点击左上角  → 关于本机，看到 "Apple M" 开头选 arm64，看到 "Intel" 选 amd64。

## 使用方法

### macOS / Linux

```bash
# 1. 赋予执行权限（只需一次）
chmod +x openclaw-install-darwin-arm64

# 2. 运行
./openclaw-install-darwin-arm64
```

> macOS 首次运行可能提示"无法验证开发者"，请前往 **系统设置 → 隐私与安全性**，点击"仍要打开"。

### Windows

双击 `openclaw-install-windows-amd64.exe` 即可运行。

## 启动选项

程序默认以 **Web 界面** 启动（自动打开浏览器）。

```bash
# 默认 Web 界面
./openclaw-install-darwin-arm64

# 使用终端界面
./openclaw-install-darwin-arm64 --ui tui

# 查看版本
./openclaw-install-darwin-arm64 --version
```

## 常见问题

**Q: 运行后浏览器没有自动打开？**
A: 查看终端输出的地址（如 `http://localhost:12345`），手动在浏览器中打开。

**Q: macOS 提示"已损坏，无法打开"？**
A: 在终端执行：
```bash
xattr -cr ./openclaw-install-darwin-arm64
```

**Q: 如何退出？**
A: Web 模式下按 `Ctrl+C`；终端模式下按 `Ctrl+C`。
