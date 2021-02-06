# typed: false
# frozen_string_literal: true

class NinjaAT10 < Formula
  desc "Small build system for use with gyp or CMake"
  homepage "https://ninja-build.org/"
  url "https://github.com/ninja-build/ninja/archive/v1.10.2.tar.gz"
  sha256 "ce35865411f0490368a8fc383f29071de6690cbadc27704734978221f25e2bed"
  license "Apache-2.0"
  head "https://github.com/ninja-build/ninja.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://dl.bintray.com/shivammathur/openssl-deprecated"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6f872ccc3d6d115b4f5bb164151f3112fcd1fe360c725f3c2d73273b2507480c"
    sha256 cellar: :any_skip_relocation, catalina:      "d613e7dc185791107f48441e2717458bcd25d053bd601c2a439a74194d0e72f7"
  end

  depends_on "shivammathur/openssl-deprecated/python@1.0"

  def install
    py = Formula["python@1.0"].opt_bin/"python3"
    system py, "./configure.py", "--bootstrap", "--verbose", "--with-python=#{py}"

    bin.install "ninja"
    bash_completion.install "misc/bash-completion" => "ninja-completion.sh"
    zsh_completion.install "misc/zsh-completion" => "_ninja"
  end

  test do
    (testpath/"build.ninja").write <<~EOS
      cflags = -Wall

      rule cc
        command = gcc $cflags -c $in -o $out

      build foo.o: cc foo.c
    EOS
    system bin/"ninja", "-t", "targets"
    port = free_port
    fork do
      exec bin/"ninja", "-t", "browse", "--port=#{port}", "--no-browser", "foo.o"
    end
    sleep 2
    assert_match "foo.c", shell_output("curl -s http://localhost:#{port}?foo.o")
  end
end
