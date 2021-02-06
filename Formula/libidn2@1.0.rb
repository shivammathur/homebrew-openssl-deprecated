# typed: false
# frozen_string_literal: true

class Libidn2AT10 < Formula
  desc "International domain name library (IDNA2008, Punycode and TR46)"
  homepage "https://www.gnu.org/software/libidn/#libidn2"
  url "https://ftp.gnu.org/gnu/libidn/libidn2-2.3.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/libidn/libidn2-2.3.0.tar.gz"
  sha256 "e1cb1db3d2e249a6a3eb6f0946777c2e892d5c5dc7bd91c74394fc3a01cab8b5"
  license "GPL-2.0"

  livecheck do
    url :stable
    regex(/href=.*?libidn2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://dl.bintray.com/shivammathur/openssl-deprecated"
    sha256 arm64_big_sur: "614d03fbfc94cee5258cb4c53ea7a3a56c02936ec3d54e589cc2f9f4e81f8a22"
    sha256 catalina:      "ac98b14bb654c60d909d829d257d0bf36dd6007372e55e4f116e23670e72aa70"
  end

  head do
    url "https://gitlab.com/libidn/libidn2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gengetopt" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libunistring"
  depends_on "shivammathur/openssl-deprecated/gettext@1.0"

  def install
    if build.head?
      ENV["GEM_HOME"] = buildpath/"gem_home"
      system "gem", "install", "ronn"
      ENV.prepend_path "PATH", buildpath/"gem_home/bin"
      system "./bootstrap"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-libintl-prefix=#{Formula["gettext@1.0"].opt_prefix}",
                          "--with-packager=Homebrew"
    system "make", "install"
  end

  test do
    ENV.delete("LC_CTYPE")
    ENV["CHARSET"] = "UTF-8"
    output = shell_output("#{bin}/idn2 räksmörgås.se")
    assert_equal "xn--rksmrgs-5wao1o.se", output.chomp
    output = shell_output("#{bin}/idn2 blåbærgrød.no")
    assert_equal "xn--blbrgrd-fxak7p.no", output.chomp
  end
end
