# typed: false
# frozen_string_literal: true

class CAresAT10 < Formula
  desc "Asynchronous DNS library"
  homepage "https://c-ares.haxx.se/"
  url "https://c-ares.haxx.se/download/c-ares-1.17.1.tar.gz"
  sha256 "d73dd0f6de824afd407ce10750ea081af47eba52b8a6cb307d220131ad93fc40"
  license "MIT"
  head "https://github.com/c-ares/c-ares.git"

  livecheck do
    url :homepage
    regex(/href=.*?c-ares[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://dl.bintray.com/shivammathur/openssl-deprecated"
    sha256 cellar: :any, arm64_big_sur: "dcf007a6b30fbe36efbb8751fcb85c6477dee3892e6bcedfc78dd722e2b5940f"
    sha256 cellar: :any, catalina:      "eda0cfc58affaa69e860c2820fca74dd2687205edbb9ccd94b5d58c32483b7f0"
  end

  depends_on "shivammathur/openssl-deprecated/cmake@1.0" => :build
  depends_on "shivammathur/openssl-deprecated/ninja@1.0" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-GNinja", *std_cmake_args
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <ares.h>

      int main()
      {
        ares_library_init(ARES_LIB_INIT_ALL);
        ares_library_cleanup();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lcares", "-o", "test"
    system "./test"
  end
end
