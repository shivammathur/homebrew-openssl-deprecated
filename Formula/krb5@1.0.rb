# typed: false
# frozen_string_literal: true

class Krb5AT10 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://kerberos.org/dist/krb5/1.19/krb5-1.19.tar.gz"
  sha256 "bc7862dd1342c04e1c17c984a268d50f29c0a658a59a22bd308ffa007d532a2e"
  license :cannot_represent

  livecheck do
    url :homepage
    regex(/Current release: .*?>krb5[._-]v?(\d+(?:\.\d+)+)</i)
  end

  bottle do
    root_url "https://ghcr.io/v2/shivammathur/openssl-deprecated"
    sha256 arm64_big_sur: "63aec955aad49d2bd049b0fe24be25e65f304dc2988b94be987d48c9c74c8eda"
    sha256 catalina:      "e4ccfad21819eaf768baf6bf97270b31e601023b2c0ba2a48a5b4e9adb542dfd"
  end

  keg_only :versioned_formula

  depends_on "shivammathur/openssl-deprecated/openssl@1.0"

  uses_from_macos "bison"

  def install
    cd "src" do
      # Newer versions of clang are very picky about missing includes.
      # One configure test fails because it doesn't #include the header needed
      # for some functions used in the rest. The test isn't actually testing
      # those functions, just using them for the feature they're
      # actually testing. Adding the include fixes this.
      # https://krbdev.mit.edu/rt/Ticket/Display.html?id=8928
      inreplace "configure", "void foo1() __attribute__((constructor));",
                             "#include <unistd.h>\nvoid foo1() __attribute__((constructor));"

      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{prefix}",
                            "--without-system-verto",
                            "--without-keyutils"
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/krb5-config", "--version"
    assert_match include.to_s,
      shell_output("#{bin}/krb5-config --cflags")
  end
end
