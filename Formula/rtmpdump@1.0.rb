# typed: false
# frozen_string_literal: true

class RtmpdumpAT10 < Formula
  desc "Tool for downloading RTMP streaming media"
  homepage "https://rtmpdump.mplayerhq.hu/"
  url "https://deb.debian.org/debian/pool/main/r/rtmpdump/rtmpdump_2.4+20151223.gitfa8646d.1.orig.tar.gz"
  version "2.4+20151223"
  sha256 "5c032f5c8cc2937eb55a81a94effdfed3b0a0304b6376147b86f951e225e3ab5"
  license "GPL-2.0-or-later"
  head "https://git.ffmpeg.org/rtmpdump.git", shallow: false

  livecheck do
    url "https://cdn-aws.deb.debian.org/debian/pool/main/r/rtmpdump/"
    regex(/href=.*?rtmpdump[._-]v?(\d.\d\+\d*).*.orig\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/shivammathur/openssl-deprecated"
    sha256 cellar: :any, arm64_big_sur: "26366ff881eb7788147f201c4a151e600d97a134b8b454b2965a08bf6bb84d83"
    sha256 cellar: :any, catalina:      "49fc09ad3fd08d55a0c185404e80e95fec9f8c97021051a6e5a8b5ab609be412"
  end

  depends_on "shivammathur/openssl-deprecated/openssl@1.0"

  uses_from_macos "zlib"

  def install
    ENV.deparallelize
    system "make", "CC=#{ENV.cc}",
                   "XCFLAGS=#{ENV.cflags}",
                   "XLDFLAGS=#{ENV.ldflags}",
                   "MANDIR=#{man}",
                   "SYS=darwin",
                   "prefix=#{prefix}",
                   "sbindir=#{bin}",
                   "install"
  end

  test do
    system "#{bin}/rtmpdump", "-h"
  end
end
