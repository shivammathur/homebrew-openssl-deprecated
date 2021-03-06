# typed: false
# frozen_string_literal: true

class CurlAT10 < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.haxx.se/"
  url "https://curl.haxx.se/download/curl-7.75.0.tar.bz2"
  sha256 "50552d4501c178e4cc68baaecc487f466a3d6d19bbf4e50a01869effb316d026"
  license "curl"

  livecheck do
    url "https://curl.haxx.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/shivammathur/openssl-deprecated"
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "995adf6212170ffcbad6521eac7453ee773d1fc9bf8cf13391f839a0442bc3b2"
    sha256 cellar: :any, catalina:      "85e7e043d42f927c04344861995f8625ffdb863faf8cba81940086f3bad4ece0"
  end

  head do
    url "https://github.com/curl/curl.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "libmetalink"
  depends_on "shivammathur/openssl-deprecated/brotli@1.0"
  depends_on "shivammathur/openssl-deprecated/krb5@1.0"
  depends_on "shivammathur/openssl-deprecated/libidn2@1.0"
  depends_on "shivammathur/openssl-deprecated/libssh2@1.0"
  depends_on "shivammathur/openssl-deprecated/nghttp2@1.0"
  depends_on "shivammathur/openssl-deprecated/openldap@1.0"
  depends_on "shivammathur/openssl-deprecated/openssl@1.0"
  depends_on "shivammathur/openssl-deprecated/rtmpdump@1.0"
  depends_on "shivammathur/openssl-deprecated/zstd@1.0"

  uses_from_macos "zlib"

  def install
    system "./buildconf" if build.head?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-ssl=#{Formula["openssl@1.0"].opt_prefix}
      --without-ca-bundle
      --without-ca-path
      --with-ca-fallback
      --with-secure-transport
      --with-default-ssl-backend=openssl
      --with-gssapi
      --with-libidn2
      --with-libmetalink
      --with-librtmp
      --with-libssh2
      --without-libpsl
    ]

    on_macos do
      args << "--with-gssapi"
    end

    system "./configure", *args
    system "make", "install"
    system "make", "install", "-C", "scripts"
    libexec.install "lib/mk-ca-bundle.pl"
  end

  test do
    # Fetch the curl tarball and see that the checksum matches.
    # This requires a network connection, but so does Homebrew in general.
    filename = (testpath/"test.tar.gz")
    system "#{bin}/curl", "-L", stable.url, "-o", filename
    filename.verify_checksum stable.checksum

    system libexec/"mk-ca-bundle.pl", "test.pem"
    assert_predicate testpath/"test.pem", :exist?
    assert_predicate testpath/"certdata.txt", :exist?
  end
end
