# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Myptd2root < Formula
  desc "Falaise plugin to convert BRIO reconstruction output to ROOT"
  homepage "https://github.com/pguzowski/MyPTD2Root"
  url "https://github.com/pguzowski/MyPTD2Root/archive/v0.1.0.tar.gz"
  version "0.1.0"
  sha256 "f67576d382a85ad550e2dfb739a824b066513ef29f5818a9b44d818d3783b648"
  revision 2

  patch :DATA

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
__END__
diff --git a/myana.py b/myana.py
--- a/myana.py
+++ b/myana.py
@@ -1,4 +1,4 @@
-#!/bin/env python
+#!/usr/bin/env python
 
 try:
     import ROOT
diff --git a/flmyptd2root.py b/flmyptd2root.py
index f0c0e9f..fc3aff6 100755
--- a/flmyptd2root.py
+++ b/flmyptd2root.py
@@ -2,6 +2,17 @@
 import os
 import argparse
 import subprocess
+from contextlib import contextmanager
+import shutil
+import tempfile
+
+@contextmanager
+def tmpdir():
+    temp_dir = tempfile.mkdtemp()
+    try:
+        yield temp_dir
+    finally:
+        shutil.rmtree(temp_dir)
 
 def getConversionScript():
     """ derive path to conversion script from this
@@ -18,15 +29,20 @@ def flbrio2root():
     parser.add_argument("-o", type=str, metavar="<outfile>", required=True, help="output ROOT file")
     args = parser.parse_args()
 
-    try:
-        subprocess.call(["flreconstruct", "-i", args.i, "-p", getConversionScript()])
-        os.rename("testptd.root", args.o)
-    except OSError as e:
-        if e.errno == os.errno.ENOENT:
-            print("error: could not locate flreconstruct program")
-        else:
-            # Something else went wrong while trying to run `flreconstruct`
-            raise
+    fullinpath = os.path.realpath(args.i)
+    fulloutpath = os.path.realpath(args.o)
+
+    with tmpdir() as temp_dir:
+
+        try:
+            subprocess.call(["flreconstruct", "-i", fullinpath, "-p", getConversionScript()],cwd=temp_dir)
+            shutil.move(temp_dir+'/testptd.root', fulloutpath)
+        except OSError as e:
+            if e.errno == os.errno.ENOENT:
+                print("error: could not locate flreconstruct program")
+            else:
+                # Something else went wrong while trying to run `flreconstruct`
+                raise
 
 
 if __name__ == '__main__':
