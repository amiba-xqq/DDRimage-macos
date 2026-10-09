# DDRimage for macOS

DDRimage 将免疫荧光、DNA Fiber 和单克隆形成分析整合为一个桌面程序。本仓库提供适用于 macOS 11 及以上版本、Intel 与 Apple Silicon Mac 的 Homebrew 安装方式。

## 第一次下载安装

### 1. 打开“终端”

在 macOS 中打开：

```text
应用程序 → 实用工具 → 终端
```

### 2. 检查 Homebrew

在终端输入：

```bash
brew --version
```

如果能够显示 Homebrew 版本号，请直接继续第 3 步。

如果提示 `command not found: brew`，请先安装 Homebrew：

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

安装过程中可能要求输入 Mac 登录密码。输入密码时终端不会显示字符，这是正常现象。安装完成后，请按照终端中 `Next steps` 的提示配置 Homebrew，然后再次运行：

```bash
brew --version
```

### 3. 添加 DDRimage-macos 软件源

```bash
brew tap amiba-xqq/ddrimage-macos https://github.com/amiba-xqq/DDRimage-macos
```

此步骤只需在第一次安装时执行一次。

### 4. 安装 DDRimage

```bash
brew install ddrimage
```

首次安装会下载 Python 3.12、Qt 图形界面和图像分析依赖。建议保持网络连接，并预留至少 4 GB 磁盘空间。安装程序优先使用清华镜像，失败后会切换到官方源；根据网络速度，安装可能需要较长时间。

DDRimage 的独立 Python 环境保存在 Homebrew 安装目录内，不会修改 macOS 自带的 Python。

### 5. 确认安装版本

```bash
brew list --versions ddrimage
```

正常情况下会显示类似：

```text
ddrimage 1.0.1
```

### 6. 第一次启动

```bash
ddrimage
```

DDRimage 会打开图形操作界面。以后启动时只需打开“终端”并输入 `ddrimage`，不需要重新安装依赖。

如果终端提示找不到 `ddrimage`，请关闭终端、重新打开后再运行。若仍无法启动，可执行：

```bash
brew reinstall amiba-xqq/ddrimage-macos/ddrimage
hash -r
ddrimage
```

## 更新

```bash
brew update
brew upgrade ddrimage
```

如果 Homebrew 没有自动替换旧版本，可执行：

```bash
brew update
brew reinstall amiba-xqq/ddrimage-macos/ddrimage
```

## 卸载

卸载程序：

```bash
brew uninstall ddrimage
brew untap amiba-xqq/ddrimage-macos
```

设置、日志和预览默认保存在：

```text
~/Library/Application Support/DDRimage
```

卸载程序不会自动删除该目录。如果希望同时删除用户设置和日志，可以在卸载后手动删除。

## 支持的工作流

1. Leica LIF 导出 TIFF
2. 细胞核内蛋白 Foci 统计与作图
3. 细胞核内相对荧光强度统计与作图
4. DNA Fiber 统计与作图
5. 单克隆形成实验统计

分析步骤可能清理所选输入子文件夹中的旧 CSV 和对应结果 TIFF。重要结果请提前备份。
