# DDRimage for macOS

DDRimage 将免疫荧光、DNA Fiber 和单克隆形成分析整合为一个桌面程序。本仓库提供适用于 macOS 11 及以上版本、Intel 与 Apple Silicon Mac 的 Homebrew 安装方式。

## 第一次下载安装

### 1. 打开原生“终端”

打开：

```text
应用程序 → 实用工具 → 终端
```

Apple Silicon Mac 请确认“终端”的“显示简介”中没有勾选“使用 Rosetta 打开”。

### 2. 检查终端与 Homebrew 架构

运行：

```bash
echo "当前终端架构：$(arch)"
echo "Apple Silicon 标记：$(sysctl -in sysctl.optional.arm64 2>/dev/null || echo 0)"
command -v brew
brew --prefix
```

正常结果：

| Mac 类型 | `arch` | `brew --prefix` |
| --- | --- | --- |
| Apple Silicon | `arm64` | `/opt/homebrew` |
| Intel | `i386` 或 `x86_64` | `/usr/local` |

如果 Apple Silicon Mac 显示 `x86_64` 或 Homebrew 位于 `/usr/local`，说明正在使用 Rosetta/Intel 版 Homebrew。请先退出终端，在“终端”的“显示简介”中取消“使用 Rosetta 打开”，重新打开终端并安装原生 Homebrew：

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

再次检查：

```bash
arch
brew --prefix
```

Apple Silicon Mac 应分别显示 `arm64` 和 `/opt/homebrew`。不需要删除原有的 Intel Homebrew。

如果尚未安装 Homebrew，也可以直接运行上面的官方安装命令。安装过程中可能要求输入 Mac 登录密码；输入密码时终端不会显示字符，这是正常现象。

### 3. 添加 DDRimage-macos 软件源

```bash
brew tap amiba-xqq/ddrimage-macos https://github.com/amiba-xqq/DDRimage-macos
```

此步骤只需在第一次安装时执行一次。

### 4. 授予 DDRimage Formula 许可

Homebrew 6 及以上版本默认不信任第三方 tap。仅授权 DDRimage 这个 Formula：

```bash
brew trust --formula amiba-xqq/ddrimage-macos/ddrimage
```

该命令只信任 DDRimage，不会信任仓库中的其他程序。不要在命令前添加 `sudo`。

查看当前许可：

```bash
brew trust
```

### 5. 安装 DDRimage

```bash
brew install ddrimage
```

也可以使用完整名称：

```bash
brew install amiba-xqq/ddrimage-macos/ddrimage
```

首次安装会下载 Python 3.12、Qt 图形界面和图像分析依赖。建议保持网络连接，并预留至少 4 GB 磁盘空间。安装程序优先使用清华镜像，失败后会切换到官方源；根据网络速度，安装可能需要较长时间。

DDRimage 的独立 Python 环境保存在 Homebrew 安装目录内，不会修改 macOS 自带的 Python。

### 6. 确认安装版本

```bash
brew list --versions ddrimage
```

正常情况下会显示类似：

```text
ddrimage 1.0.1
```

### 7. 第一次启动

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

## macOS 27：libxcrun 架构错误

如果安装时出现以下内容：

```text
fat file, but missing compatible architecture
have 'arm64,arm64e', need 'x86_64'
CompilerSelectionError
```

这表示 Apple Silicon 系统正在运行 x86_64/Rosetta 版 Homebrew，但 Command Line Tools 是 arm64。问题不是 DDRimage 缺少 GCC，因此通常不应按照错误末尾的提示先安装 GNU GCC。

请执行：

```bash
arch
brew --prefix
```

如果分别显示 `x86_64` 和 `/usr/local`，请：

1. 退出终端。
2. 在 Finder 中找到“应用程序 → 实用工具 → 终端”。
3. 打开“显示简介”，取消“使用 Rosetta 打开”。
4. 重新打开终端。
5. 配置并使用原生 Homebrew：

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
arch
brew --prefix
brew update
brew trust --formula amiba-xqq/ddrimage-macos/ddrimage
brew install amiba-xqq/ddrimage-macos/ddrimage
```

此时 `arch` 应为 `arm64`，`brew --prefix` 应为 `/opt/homebrew`。

如果 `/opt/homebrew/bin/brew` 不存在，请先安装原生 Homebrew：

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

如果架构已经正确但 `xcrun --find clang` 仍然失败，请运行 `xcode-select --install`，或通过“系统设置 → 通用 → 软件更新”重新安装/更新 Command Line Tools，然后再次安装 DDRimage。

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
brew untrust --formula amiba-xqq/ddrimage-macos/ddrimage
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
