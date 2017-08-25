# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Myptd2root < Formula
  desc "Falaise plugin to convert BRIO reconstruction output to ROOT"
  homepage "https://github.com/pguzowski/MyPTD2Root"
  url "https://github.com/pguzowski/MyPTD2Root/archive/v0.1.2.tar.gz"
  version "0.1.2"
  sha256 "b64c80d27fa0ab6008322d2f5193e6289924f84b2d431c17e1f23e47faae16d5"

  depends_on "cmake" => :build
  depends_on "supernemo-dbd/cadfael/falaise"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test PTD2Root`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "flmyptd2root.py --help"
  end
end
