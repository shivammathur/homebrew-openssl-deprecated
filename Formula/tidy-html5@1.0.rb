# typed: false
# frozen_string_literal: true

class TidyHtml5AT10 < Formula
  desc "Granddaddy of HTML tools, with support for modern standards"
  homepage "https://www.html-tidy.org/"
  url "https://github.com/htacg/tidy-html5/archive/5.6.0.tar.gz"
  sha256 "08a63bba3d9e7618d1570b4ecd6a7daa83c8e18a41c82455b6308bc11fe34958"
  license "Zlib"
  head "https://github.com/htacg/tidy-html5.git", branch: "next"

  livecheck do
    url :stable
    regex(/^v?(\d+\.\d*?[02468](?:\.\d+)*)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/shivammathur/openssl-deprecated"
    sha256 cellar: :any, arm64_big_sur: "d312348072486539f128d2843550b01d54adb6d0295f4fd3606740e4c1021dc2"
    sha256 cellar: :any, catalina:      "390fb4a52d8fb00979fcba4768923bf51aea362e92fe279455010806e790b4a4"
  end

  depends_on "shivammathur/openssl-deprecated/cmake@1.0" => :build

  def install
    cd "build/cmake"
    system "cmake", "../..", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    output = pipe_output(bin/"tidy -q", "<!doctype html><title></title>")
    assert_match /^<!DOCTYPE html>/, output
    assert_match /HTML Tidy for HTML5/, output
  end
end
