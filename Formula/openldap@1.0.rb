# typed: false
# frozen_string_literal: true

class OpenldapAT10 < Formula
  desc "Open source suite of directory software"
  homepage "https://www.openldap.org/software/"
  url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.4.57.tgz"
  sha256 "c7ba47e1e6ecb5b436f3d43281df57abeffa99262141aec822628bc220f6b45a"
  license "OLDAP-2.8"

  livecheck do
    url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/"
    regex(/href=.*?openldap[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    root_url "https://dl.bintray.com/shivammathur/openssl-deprecated"
    sha256 arm64_big_sur: "362878022dcda1b9b4bfbc3b2c5972e0bc27d2210dc8a59cc3358b548cb43798"
    sha256 catalina:      "34c92b96ae87e100e99be511fecef7e43a79ef1c509c26976637435dc20e9b5a"
  end

  keg_only :versioned_formula

  depends_on "shivammathur/openssl-deprecated/openssl@1.0"

  on_linux do
    depends_on "groff" => :build
    depends_on "util-linux"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --enable-accesslog
      --enable-auditlog
      --enable-bdb=no
      --enable-constraint
      --enable-dds
      --enable-deref
      --enable-dyngroup
      --enable-dynlist
      --enable-hdb=no
      --enable-memberof
      --enable-ppolicy
      --enable-proxycache
      --enable-refint
      --enable-retcode
      --enable-seqmod
      --enable-translucent
      --enable-unique
      --enable-valsort
    ]

    system "./configure", *args
    system "make", "install"
    (var/"run").mkpath

    # https://github.com/Homebrew/homebrew-dupes/pull/452
    chmod 0755, Dir[etc/"openldap/*"]
    chmod 0755, Dir[etc/"openldap/schema/*"]
  end

  test do
    system sbin/"slappasswd", "-s", "test"
  end
end
