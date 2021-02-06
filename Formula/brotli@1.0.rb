# typed: false
# frozen_string_literal: true

class BrotliAT10 < Formula
  desc "Generic-purpose lossless compression algorithm by Google"
  homepage "https://github.com/google/brotli"
  url "https://github.com/google/brotli/archive/v1.0.9.tar.gz"
  sha256 "f9e8d81d0405ba66d181529af42a3354f838c939095ff99930da6aa9cdf6fe46"
  license "MIT"
  head "https://github.com/google/brotli.git"

  bottle do
    root_url "https://dl.bintray.com/shivammathur/openssl-deprecated"
    sha256 cellar: :any, arm64_big_sur: "ab701c0fcb6c39fe1fcf75ab9e5350c5ac8b40e2a54a55f60fc346d3fb891c0d"
    sha256 cellar: :any, catalina:      "fcb555bc3c6bf970802f15fdedc51bf8400ca7748021d448b623bc030ac05453"
  end

  depends_on "shivammathur/openssl-deprecated/cmake@1.0" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "VERBOSE=1"
    system "ctest", "-V"
    system "make", "install"
  end

  test do
    (testpath/"file.txt").write("Hello, World!")
    system "#{bin}/brotli", "file.txt", "file.txt.br"
    system "#{bin}/brotli", "file.txt.br", "--output=out.txt", "--decompress"
    assert_equal (testpath/"file.txt").read, (testpath/"out.txt").read
  end
end
