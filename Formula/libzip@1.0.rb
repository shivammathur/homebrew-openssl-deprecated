# typed: false
# frozen_string_literal: true

class LibzipAT10 < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "https://libzip.org/"
  url "https://libzip.org/download/libzip-1.7.3.tar.xz"
  sha256 "a60473ffdb7b4260c08bfa19c2ccea0438edac11193c3afbbb1f17fbcf6c6132"
  license "BSD-3-Clause"

  livecheck do
    url "https://libzip.org/download/"
    regex(/href=.*?libzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/shivammathur/openssl-deprecated"
    sha256 arm64_big_sur: "6547cbfc4c52f7b54738edd5a30546712417a8b254984b073a3d80ff1ef861be"
    sha256 catalina:      "ab7c3debce385b59a40330c6f687e5be54697a68cbcb66247dbaebdf5b58b524"
  end

  depends_on "shivammathur/openssl-deprecated/cmake@1.0" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  conflicts_with "libtcod", "minizip2",
    because: "libtcod, libzip and minizip2 install a `zip.h` header"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    touch "file1"
    system "zip", "file1.zip", "file1"
    touch "file2"
    system "zip", "file2.zip", "file1", "file2"
    assert_match /\+.*file2/, shell_output("#{bin}/zipcmp -v file1.zip file2.zip", 1)
  end
end
