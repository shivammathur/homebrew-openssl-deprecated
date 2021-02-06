# typed: false
# frozen_string_literal: true

class Nghttp2AT10 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.43.0/nghttp2-1.43.0.tar.xz"
  sha256 "f7d54fa6f8aed29f695ca44612136fa2359013547394d5dffeffca9e01a26b0f"
  license "MIT"

  bottle do
    root_url "https://dl.bintray.com/shivammathur/openssl-deprecated"
    sha256 arm64_big_sur: "e8e17d144252b5ec2975395b9a03158508dee027f04e040b5fc24a9dbf15348a"
    sha256 catalina:      "9d93add5163fb283e553484b13d72b5dedafe384fa5d56cd806533d517439149"
  end

  head do
    url "https://github.com/nghttp2/nghttp2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "c-ares"
  depends_on "jemalloc"
  depends_on "libev"
  depends_on "shivammathur/openssl-deprecated/libxml2@1.0"
  depends_on "shivammathur/openssl-deprecated/openssl@1.0"

  uses_from_macos "zlib"

  on_linux do
    # Fix: shrpx_api_downstream_connection.cc:57:3: error:
    # array must be initialized with a brace-enclosed initializer
    # https://github.com/nghttp2/nghttp2/pull/1269
    patch do
      url "https://github.com/nghttp2/nghttp2/commit/829258e7038fe7eff849677f1ccaeca3e704eb67.patch?full_index=1"
      sha256 "c4bcf5cf73d5305fc479206676027533bb06d4ff2840eb672f6265ba3239031e"
    end
  end

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
