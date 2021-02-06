# typed: false
# frozen_string_literal: true

class MesonAT10 < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.56.2/meson-0.56.2.tar.gz"
  sha256 "3cb8bdb91383f7f8da642f916e4c44066a29262caa499341e2880f010edb87f4"
  license "Apache-2.0"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    root_url "https://dl.bintray.com/shivammathur/openssl-deprecated"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "48bdf17986a783a0b6cdf82788623b104257c9345544f94feacf1f50a73287ac"
    sha256 cellar: :any_skip_relocation, catalina:      "52e353f346277abbe36cbb048491827cbced318e6caa8c262ef2f4af35e506f5"
  end

  depends_on "shivammathur/openssl-deprecated/ninja@1.0"
  depends_on "shivammathur/openssl-deprecated/python@1.0"

  def install
    version = Language::Python.major_minor_version Formula["python@1.0"].bin/"python3"
    ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"

    system Formula["python@1.0"].bin/"python3", *Language::Python.setup_install_args(prefix)

    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    (testpath/"helloworld.c").write <<~EOS
      main() {
        puts("hi");
        return 0;
      }
    EOS
    (testpath/"meson.build").write <<~EOS
      project('hello', 'c')
      executable('hello', 'helloworld.c')
    EOS

    mkdir testpath/"build" do
      system "#{bin}/meson", ".."
      assert_predicate testpath/"build/build.ninja", :exist?
    end
  end
end
