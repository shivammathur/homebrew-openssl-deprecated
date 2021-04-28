
class ZstdAT10 < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "https://facebook.github.io/zstd/"
  url "https://github.com/facebook/zstd/archive/v1.4.8.tar.gz"
  sha256 "f176f0626cb797022fbf257c3c644d71c1c747bb74c32201f9203654da35e9fa"
  license "BSD-3-Clause"

  bottle do
    root_url "https://ghcr.io/v2/shivammathur/openssl-deprecated"
    sha256 cellar: :any, arm64_big_sur: "8ad670c1f515a62bfee0ea6f79f84f47742049f7536b9cdec954a6a923d3f85b"
    sha256 cellar: :any, catalina:      "36becf72894c8ce47baff0b27d633d67268b5431088520966fe6cca2ccaf32d5"
  end

  depends_on "shivammathur/openssl-deprecated/cmake@1.0" => :build

  uses_from_macos "zlib"

  def install
    system "make", "install", "PREFIX=#{prefix}/"

    # Build parallel version
    system "make", "-C", "contrib/pzstd", "PREFIX=#{prefix}"
    bin.install "contrib/pzstd/pzstd"
  end

  test do
    assert_equal "hello\n",
      pipe_output("#{bin}/zstd | #{bin}/zstd -d", "hello\n", 0)

    assert_equal "hello\n",
      pipe_output("#{bin}/pzstd | #{bin}/pzstd -d", "hello\n", 0)
  end
end
