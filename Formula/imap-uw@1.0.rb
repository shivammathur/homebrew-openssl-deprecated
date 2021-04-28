# typed: false
# frozen_string_literal: true

class ImapUwAT10 < Formula
  desc "University of Washington IMAP toolkit"
  homepage "https://web.archive.org/web/20191028114408/https://www.washington.edu/imap/"
  url "https://mirrorservice.org/sites/ftp.cac.washington.edu/imap/imap-2007f.tar.gz"
  mirror "https://fossies.org/linux/misc/old/imap-2007f.tar.gz"
  sha256 "53e15a2b5c1bc80161d42e9f69792a3fa18332b7b771910131004eb520004a28"

  bottle do
    root_url "https://ghcr.io/v2/shivammathur/openssl-deprecated"
    sha256 cellar: :any, arm64_big_sur: "3dde374d4fcca4f83a5b9a8e77e7366a2095ce5b264eff687d32cd346ffb7413"
    sha256 cellar: :any, catalina:      "1b3bccc1c7cc463ecf8898827c5e9f9dc03ead34e6b55d471fc01758c2e73091"
  end

  depends_on "shivammathur/openssl-deprecated/openssl@1.0"

  def install
    ENV.deparallelize
    inreplace "Makefile" do |s|
      s.gsub! "SSLINCLUDE=/usr/include/openssl",
              "SSLINCLUDE=#{Formula["openssl@1.0"].opt_include}/openssl"
      s.gsub! "SSLLIB=/usr/lib",
              "SSLLIB=#{Formula["openssl@1.0"].opt_lib}"
      s.gsub! "-DMAC_OSX_KLUDGE=1", ""
    end
    inreplace "src/osdep/unix/ssl_unix.c", "#include <x509v3.h>\n#include <ssl.h>",
                                           "#include <ssl.h>\n#include <x509v3.h>"
    system "make", "oxp"

    # email servers:
    sbin.install "imapd/imapd", "ipopd/ipop2d", "ipopd/ipop3d"

    # mail utilities:
    bin.install "dmail/dmail", "mailutil/mailutil", "tmail/tmail"

    # c-client library:
    #   Note: Installing the headers from the root c-client directory is not
    #   possible because they are symlinks and homebrew dutifully copies them
    #   as such. Pulling from within the src dir achieves the desired result.
    doc.install Dir["docs/*"]
    lib.install "c-client/c-client.a" => "libc-client.a"
    (include + "imap").install "c-client/osdep.h", "c-client/linkage.h"
    (include + "imap").install Dir["src/c-client/*.h", "src/osdep/unix/*.h"]
  end
end
