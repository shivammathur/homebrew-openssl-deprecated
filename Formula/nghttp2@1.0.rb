# typed: false
# frozen_string_literal: true

class Nghttp2AT10 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.43.0/nghttp2-1.43.0.tar.xz"
  sha256 "f7d54fa6f8aed29f695ca44612136fa2359013547394d5dffeffca9e01a26b0f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/shivammathur/openssl-deprecated"
    rebuild 1
    sha256 arm64_big_sur: "e09b4b90dd366e1a29519055fb038914d52a1f8c044342430b06925863c02759"
    sha256 catalina:      "d829a06851811440248b80207a7bd1dcc0a614bb7429dc0542df49d7a485ec6a"
  end

  head do
    url "https://github.com/nghttp2/nghttp2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "jemalloc"
  depends_on "libev"
  depends_on "shivammathur/openssl-deprecated/c-ares@1.0"
  depends_on "shivammathur/openssl-deprecated/libxml2@1.0"
  depends_on "shivammathur/openssl-deprecated/openssl@1.0"

  uses_from_macos "zlib"

  def install
    # fix for clang not following C++14 behaviour
    # https://github.com/macports/macports-ports/commit/54d83cca9fc0f2ed6d3f873282b6dd3198635891
    inreplace "src/shrpx_client_handler.cc", "return dconn;", "return std::move(dconn);"

    args = %W[
      --prefix=#{prefix}
      --disable-silent-rules
      --enable-app
      --disable-examples
      --disable-hpack-tools
      --disable-python-bindings
      --without-systemd
    ]

    system "autoreconf", "-ivf" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"nghttp", "-nv", "https://nghttp2.org"
  end
end
