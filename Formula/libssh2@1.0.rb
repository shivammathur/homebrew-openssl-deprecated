# typed: false
# frozen_string_literal: true

class Libssh2AT10 < Formula
  desc "C library implementing the SSH2 protocol"
  homepage "https://libssh2.org/"
  url "https://libssh2.org/download/libssh2-1.9.0.tar.gz"
  sha256 "d5fb8bd563305fd1074dda90bd053fb2d29fc4bce048d182f96eaa466dfadafd"
  license "BSD-3-Clause"

  livecheck do
    url "https://libssh2.org/download/"
    regex(/href=.*?libssh2[._-]v?(\d+(?:\.\d+)+)\./i)
  end

  bottle do
    root_url "https://dl.bintray.com/shivammathur/openssl-deprecated"
    sha256 cellar: :any, arm64_big_sur: "feacc14891318ca825e5ed2eaf24b303b63bf705dee917e5ee868fb36160fb3a"
    sha256 cellar: :any, catalina:      "32758f60b650ce0f6c81b36dc0b04ab40e6734d3448c552a00d9e84314f6eea5"
  end

  head do
    url "https://github.com/libssh2/libssh2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "shivammathur/openssl-deprecated/openssl@1.0"

  uses_from_macos "zlib"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-examples-build
      --with-openssl
      --with-libz
      --with-libssl-prefix=#{Formula["openssl@1.0"].opt_prefix}
    ]

    system "./buildconf" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libssh2.h>

      int main(void)
      {
      libssh2_exit();
      return 0;
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-lssh2", "-o", "test"
    system "./test"
  end
end
