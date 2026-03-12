# OpenClaw 安装助手

帮你一键安装 OpenClaw，全程有 AI 小助手引导，跟着走就行。

下载一个文件，双击（或在终端运行）就能用，不需要提前装任何东西。

---

## 第一步：下载

👉 **[点这里去下载页面](https://github.com/AIhubmix/install-agent/releases/latest)**

在下载页面找到你电脑对应的文件，点击即可下载：

**Mac 电脑**
- 如果你的 Mac 是 2020 年以后买的 → 下载 [`openclaw-install-darwin-arm64`](https://github.com/AIhubmix/install-agent/releases/latest/download/openclaw-install-darwin-arm64)
- 如果你的 Mac 比较老（Intel 处理器）→ 下载 [`openclaw-install-darwin-amd64`](https://github.com/AIhubmix/install-agent/releases/latest/download/openclaw-install-darwin-amd64)

> 怎么看？点击屏幕左上角的  → **关于本机**，如果看到「Apple M1/M2/M3/M4」就选第一个，看到「Intel」就选第二个。

**Windows 电脑**
- 下载 [`openclaw-install-windows-amd64.exe`](https://github.com/AIhubmix/install-agent/releases/latest/download/openclaw-install-windows-amd64.exe)

**Linux**
- 下载 [`openclaw-install-linux-amd64`](https://github.com/AIhubmix/install-agent/releases/latest/download/openclaw-install-linux-amd64)（大多数服务器选这个）

---

## 第二步：运行

### Mac

1. 打开「终端」应用（在启动台搜索"终端"或"Terminal"）
2. 把下载的文件拖进终端窗口，你会看到一个路径，**先别按回车**
3. 回到终端，依次输入以下两行命令（把路径换成你的文件位置）：

```
chmod +x ~/Downloads/openclaw-install-darwin-arm64
~/Downloads/openclaw-install-darwin-arm64
```

4. 浏览器会自动打开安装页面，跟着提示操作就行

> **如果 Mac 弹窗说「无法打开」或「无法验证开发者」：**
> 打开 **系统设置 → 隐私与安全性**，往下翻，找到提示信息，点「仍要打开」，然后重新运行上面的命令。
>
> **如果提示「已损坏」：** 在终端执行下面这行，然后重新运行：
> ```
> xattr -cr ~/Downloads/openclaw-install-darwin-arm64
> ```

### Windows

双击下载的 `.exe` 文件就能运行。浏览器会自动打开安装页面。

> 如果 Windows 弹出安全警告，点「更多信息」→「仍要运行」。

### Linux

```
chmod +x openclaw-install-linux-amd64
./openclaw-install-linux-amd64
```

---

## 运行成功是什么样？

程序启动后，你会在终端看到类似这样的提示：

```
🐾 OpenClaw 安装助手 (Web UI)
   浏览器访问: http://localhost:12345
   按 Ctrl+C 退出
```

浏览器会自动弹出一个安装页面，AI 小助手「小爪」会一步步带你完成安装。

如果浏览器没有自动打开，手动复制终端里的地址（`http://localhost:xxxxx`），粘贴到浏览器地址栏打开就行。

---

## 想用终端界面？

如果你更喜欢在终端里操作（不打开浏览器），可以加个参数：

```
./openclaw-install-darwin-arm64 --ui tui
```

---

## 遇到问题？

| 问题 | 解决办法 |
|------|---------|
| Mac 弹窗「无法验证开发者」 | 系统设置 → 隐私与安全性 → 仍要打开 |
| Mac 提示「已损坏」 | 终端执行 `xattr -cr 文件路径` |
| Windows 安全警告 | 点「更多信息」→「仍要运行」 |
| 浏览器没自动打开 | 手动复制终端里的 `http://localhost:xxxxx` 地址到浏览器 |
| 想退出程序 | 在终端按 `Ctrl+C` |
