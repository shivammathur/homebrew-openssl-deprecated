# typed: false
# frozen_string_literal: true

class AprUtilAT10 < Formula
  desc "Companion library to apr, the Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=apr/apr-util-1.6.1.tar.bz2"
  mirror "https://archive.apache.org/dist/apr/apr-util-1.6.1.tar.bz2"
  sha256 "d3e12f7b6ad12687572a3a39475545a072608f4ba03a6ce8a3778f607dd0035b"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    root_url "https://dl.bintray.com/shivammathur/openssl-deprecated"
    sha256 arm64_big_sur: "83d34084f695ed36005204db6f5205d027d4c5b5eb10f023404d93813397e683"
    sha256 catalina:      "11b47ae6381a73bad3b2d5fc10755d7b5b5c6bcd0c756f5a3c2c3142f816c218"
  end

  keg_only :shadowed_by_macos, "Apple's CLT provides apr (but not apr-util)"

  depends_on "apr"
  depends_on "shivammathur/openssl-deprecated/openssl@1.0"

  uses_from_macos "expat"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "mawk"
    depends_on "unixodbc"
  end

  def install
    # Install in libexec otherwise it pollutes lib with a .exp file.
    system "./configure", "--prefix=#{libexec}",
                          "--with-apr=#{Formula["apr"].opt_prefix}",
                          "--with-crypto",
                          "--with-openssl=#{Formula["openssl@1.0"].opt_prefix}",
                          "--without-pgsql"

    system "make"
    system "make", "install"
    bin.install_symlink Dir["#{libexec}/bin/*"]

    rm Dir[libexec/"lib/*.la"]
    rm Dir[libexec/"lib/apr-util-1/*.la"]

    # No need for this to point to the versioned path.
    inreplace libexec/"bin/apu-1-config", libexec, opt_libexec
  end

  test do
    assert_match opt_libexec.to_s, shell_output("#{bin}/apu-1-config --prefix")
  end
end
