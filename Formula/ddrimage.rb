class Ddrimage < Formula
  desc "Desktop workflows for immunofluorescence and DNA-fiber image analysis"
  homepage "https://github.com/amiba-xqq/DDRimage"
  url "https://raw.githubusercontent.com/amiba-xqq/DDRimage/main/dist/ddrimage-source-v1.0.0.zip"
  version "1.0.0"
  sha256 "dfe33f259853f76a8264e885aa6d55860fd1200a50e3cd56c40e53b618fae15f"

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
  end
end

