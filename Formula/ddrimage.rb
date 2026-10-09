class Ddrimage < Formula
  desc "Desktop workflows for immunofluorescence and DNA-fiber image analysis"
  homepage "https://github.com/amiba-xqq/DDRimage-macos"
  url "https://raw.githubusercontent.com/amiba-xqq/DDRimage-macos/main/dist/ddrimage-source-v1.0.1.zip"
  version "1.0.1"
  sha256 "8f3f6e2ab3fff05211c71819b42e58d6df0915d6604154b82c6ab831e4ddf750"

  on_arm do
    resource "miniforge" do
      url "https://mirrors.tuna.tsinghua.edu.cn/github-release/conda-forge/miniforge/LatestRelease/Miniforge3-26.7.2-0-MacOSX-arm64.sh"
      sha256 "d70bfa2e97afcda96927c9b9ca0e2316cb7750e4ce651c94388267cbe9588711"
    end
  end

  on_intel do
    resource "miniforge" do
      url "https://mirrors.tuna.tsinghua.edu.cn/github-release/conda-forge/miniforge/LatestRelease/Miniforge3-26.7.2-0-MacOSX-x86_64.sh"
      sha256 "b00e7798658f92721a3ae2f6b9832695ffc6baf07758894d726268055359f6c5"
    end
  end

  def install
    libexec.install "app", "assets", "homebrew-install.sh",
                    "requirements-macos-conda.txt", "requirements-macos-pip.txt"

    miniforge_root = libexec/"miniforge"
    environment_root = libexec/"environment"
    system "/bin/bash", resource("miniforge").cached_download,
           "-b", "-p", miniforge_root
    chmod 0755, libexec/"homebrew-install.sh"
    system "/bin/bash", libexec/"homebrew-install.sh",
           environment_root, miniforge_root/"bin/conda"

    (bin/"ddrimage").write <<~SH
      #!/bin/bash
      set -e
      data_root="$HOME/Library/Application Support/DDRimage"
      mkdir -p "$data_root/matplotlib"
      export DDRIMAGE_DATA_DIR="$data_root"
      export MPLCONFIGDIR="$data_root/matplotlib"
      export PYTHONUTF8=1
      unset QT_PLUGIN_PATH QML2_IMPORT_PATH QML_IMPORT_PATH QT_QPA_PLATFORMTHEME
      pyside_root="#{environment_root}/lib/python3.12/site-packages/PySide6"
      export QT_QPA_PLATFORM=cocoa
      export QT_PLUGIN_PATH="$pyside_root/Qt/plugins"
      export QT_QPA_PLATFORM_PLUGIN_PATH="$pyside_root/Qt/plugins/platforms"
      exec "#{environment_root}/bin/python" "#{libexec}/app/main.py" "$@"
    SH
    chmod 0755, bin/"ddrimage"
  end

  def caveats
    <<~EOS
      Run the graphical application with:
        ddrimage

      Settings, previews, and logs are stored in:
        ~/Library/Application Support/DDRimage
    EOS
  end

  test do
    python = libexec/"environment/bin/python"
    assert_match "DDRimage runtime OK", shell_output(
      "#{python} -c \"import PySide6,numpy,scipy,pandas,matplotlib,PIL,tifffile,skimage,cv2,liffile; print('DDRimage runtime OK')\"",
    )
    pyside_root = libexec/"environment/lib/python3.12/site-packages/PySide6"
    ENV.delete "QT_PLUGIN_PATH"
    ENV.delete "QML2_IMPORT_PATH"
    ENV.delete "QML_IMPORT_PATH"
    ENV["QT_QPA_PLATFORM"] = "cocoa"
    ENV["QT_PLUGIN_PATH"] = pyside_root/"Qt/plugins"
    ENV["QT_QPA_PLATFORM_PLUGIN_PATH"] = pyside_root/"Qt/plugins/platforms"
    assert_match "Qt Cocoa OK", shell_output(
      "#{python} -c \"from PySide6.QtWidgets import QApplication; app=QApplication([]); print('Qt Cocoa OK')\"",
    )
  end
end

