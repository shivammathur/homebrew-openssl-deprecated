class TclTkAT10 < Formula
  desc "Tool Command Language"
  homepage "https://www.tcl-lang.org"
  url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.11/tcl8.6.11-src.tar.gz"
  mirror "https://fossies.org/linux/misc/tcl8.6.11-src.tar.gz"
  sha256 "8c0486668586672c5693d7d95817cb05a18c5ecca2f40e2836b9578064088258"
  license "TCL"

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:tcl|tk).?v?(\d+(?:\.\d+)+)[._-]src\.t}i)
  end

  bottle do
    root_url "https://dl.bintray.com/shivammathur/openssl-deprecated"
    sha256 arm64_big_sur: "7e9fae3b42d07042daa7fc6931c84bbdbe6bfcc3d0c37543164b79e274b89140"
    sha256 catalina:      "02f9eb900c6ba0f94a04b89854ee587d2873f5ad39063cad79238663afa6072c"
  end

  keg_only :versioned_formula

  depends_on "shivammathur/openssl-deprecated/openssl@1.0"

  uses_from_macos "zlib"

  resource "critcl" do
    url "https://github.com/andreas-kupries/critcl/archive/3.1.18.1.tar.gz"
    sha256 "51bc4b099ecf59ba3bada874fc8e1611279dfd30ad4d4074257084763c49fd86"
  end

  resource "tcllib" do
    url "https://downloads.sourceforge.net/project/tcllib/tcllib/1.20/tcllib-1.20.tar.xz"
    sha256 "199e8ec7ee26220e8463bc84dd55c44965fc8ef4d4ac6e4684b2b1c03b1bd5b9"
  end

  resource "tcltls" do
    url "https://core.tcl-lang.org/tcltls/uv/tcltls-1.7.22.tar.gz"
    sha256 "e84e2b7a275ec82c4aaa9d1b1f9786dbe4358c815e917539ffe7f667ff4bc3b4"
  end

  resource "tk" do
    url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.11/tk8.6.11-src.tar.gz"
    mirror "https://fossies.org/linux/misc/tk8.6.11-src.tar.gz"
    sha256 "5228a8187a7f70fa0791ef0f975270f068ba9557f57456f51eb02d9d4ea31282"
  end

  resource "itk4" do
    url "https://downloads.sourceforge.net/project/incrtcl/%5Bincr%20Tcl_Tk%5D-4-source/itk%204.1.0/itk4.1.0.tar.gz"
    sha256 "da646199222efdc4d8c99593863c8d287442ea5a8687f95460d6e9e72431c9c7"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --enable-threads
      --enable-64bit
    ]

    cd "unix" do
      system "./configure", *args
      system "make"
      system "make", "install"
      system "make", "install-private-headers"
      ln_s bin/"tclsh#{version.to_f}", bin/"tclsh"
    end

    # Let tk finds our new tclsh
    ENV.prepend_path "PATH", bin

    resource("tk").stage do
      cd "unix" do
        on_macos do
          args << "--enable-aqua=yes"
        end
        system "./configure", *args, "--without-x", "--with-tcl=#{lib}"
        system "make"
        system "make", "install"
        system "make", "install-private-headers"
        ln_s bin/"wish#{version.to_f}", bin/"wish"
      end
    end

    resource("critcl").stage do
      system bin/"tclsh", "build.tcl", "install"
    end

    resource("tcllib").stage do
      system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
      system "make", "install"
      on_macos do
        ENV["SDKROOT"] = MacOS.sdk_path
      end
      system "make", "critcl"
      cp_r "modules/tcllibc", "#{lib}/"
      on_macos do
        ln_s "#{lib}/tcllibc/macosx-x86_64-clang", "#{lib}/tcllibc/macosx-x86_64"
      end
    end

    resource("tcltls").stage do
      system "./configure", "--with-ssl=openssl",
                            "--with-openssl-dir=#{Formula["openssl@1.0"].opt_prefix}",
                            "--prefix=#{prefix}",
                            "--mandir=#{man}"
      system "make", "install"
    end

    resource("itk4").stage do
      itcl_dir = Pathname.glob(lib/"itcl*").last
      args = %W[
        --prefix=#{prefix}
        --exec-prefix=#{prefix}
        --with-tcl=#{lib}
        --with-tk=#{lib}
        --with-itcl=#{itcl_dir}
      ]
      system "./configure", *args
      system "make"
      system "make", "install"
    end

    # Conflicts with perl
    mv man/"man3/Thread.3", man/"man3/ThreadTclTk.3"
  end

  test do
    assert_equal "honk", pipe_output("#{bin}/tclsh", "puts honk\n").chomp

    test_itk = <<~EOS
      # Check that Itcl and Itk load, and that we can define, instantiate,
      # and query the properties of a widget.


      # If anything errors, just exit
      catch {
          package require Itcl
          package require Itk

          # Define class
          itcl::class TestClass {
              inherit itk::Toplevel
              constructor {args} {
                  itk_component add bye {
                      button $itk_interior.bye -text "Bye"
                  }
                  eval itk_initialize $args
              }
          }

          # Create an instance
          set testobj [TestClass .#auto]

          # Check the widget has a bye component with text property "Bye"
          if {[[$testobj component bye] cget -text]=="Bye"} {
              puts "OK"
          }
      }
      exit
    EOS
    assert_equal "OK\n", pipe_output("#{bin}/wish", test_itk), "Itk test failed"
  end
end
