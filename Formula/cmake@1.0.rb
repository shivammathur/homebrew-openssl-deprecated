# typed: false
# frozen_string_literal: true

class CmakeAT10 < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.19.4/cmake-3.19.4.tar.gz"
  sha256 "7d0232b9f1c57e8de81f38071ef8203e6820fe7eec8ae46a1df125d88dbcc2e1"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/shivammathur/openssl-deprecated"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f33cbd98ea6a12b6a3002276403e934eedfd5d03b267545092ae2678d427ae7b"
    sha256 cellar: :any_skip_relocation, catalina:      "fe8292077972cdb9d53d72d770af7d3b2ccd92a9245867d6e3285fc8e431abfe"
  end

  depends_on "shivammathur/openssl-deprecated/sphinx-doc@1.0" => :build

  uses_from_macos "ncurses"

  # The completions were removed because of problems with system bash

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use `brew install --cask cmake`.

  def install
    args = %W[
      --prefix=#{prefix}
      --no-system-libs
      --parallel=#{ENV.make_jobs}
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
      --sphinx-build=#{Formula["sphinx-doc@1.0"].opt_bin}/sphinx-build
      --sphinx-html
      --sphinx-man
    ]
    on_macos do
      args += %w[
        --system-zlib
        --system-bzip2
        --system-curl
      ]
    end

    system "./bootstrap", *args, "--", *std_cmake_args,
                                       "-DCMake_INSTALL_EMACS_DIR=#{elisp}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."
  end
end
