# DDRimage Homebrew Tap

DDRimage 将免疫荧光、DNA Fiber 和单克隆形成分析整合为一个桌面程序。本仓库提供适用于 macOS 11 及以上版本、Intel 与 Apple Silicon Mac 的 Homebrew 安装方式。

## 安装

由于本仓库名称为 `DDRimage`，首次添加 Tap 时需要同时提供仓库地址：

```bash
brew tap amiba-xqq/ddrimage https://github.com/amiba-xqq/DDRimage
brew install ddrimage
```

启动图形界面：

```bash
ddrimage
```

首次安装需要下载 Python 3.12 与图像分析依赖，建议预留至少 4 GB 磁盘空间。安装程序优先使用清华镜像，失败后切换至官方源。运行环境由 Homebrew 保存在 DDRimage 的安装目录内，不会修改系统 Python。

从 1.0.1 版开始，安装程序会按 macOS 版本选择兼容的 Qt/PySide6，并在启动时固定使用 DDRimage 自带的 Cocoa 平台插件，以避免系统或其他 Python 环境中的 Qt 设置发生冲突。

## 更新与卸载

```bash
brew update
brew upgrade ddrimage
```

若曾安装 1.0.0 且 Homebrew 没有自动重装，可执行：

```bash
brew update
brew reinstall ddrimage
```

卸载程序：

```bash
brew uninstall ddrimage
brew untap amiba-xqq/ddrimage
```

设置、日志和预览保存在：

```text
~/Library/Application Support/DDRimage
```

如果希望同时删除这些用户数据，可在卸载后手动删除该目录。

## 支持的工作流

1. Leica LIF 导出 TIFF
2. 细胞核内蛋白 Foci 统计与作图
3. 细胞核内相对荧光强度统计与作图
4. DNA Fiber 统计与作图
5. 单克隆形成实验统计

分析步骤可能清理所选输入子文件夹中的旧 CSV 和对应结果 TIFF。重要结果请提前备份。

