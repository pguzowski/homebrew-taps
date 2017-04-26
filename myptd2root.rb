# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Myptd2root < Formula
  desc "Falaise plugin to convert BRIO reconstruction output to ROOT"
  homepage "https://github.com/pguzowski/MyPTD2Root"
  url "https://github.com/pguzowski/MyPTD2Root/archive/v0.1.1.tar.gz"
  version "0.1.1"
  sha256 "235259cac7483fb66d7b3f34e1ae22775d49c960cab27dfdab976a8216e79c51"
  revision 1

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
index ec86146..ad37939 100755
--- a/myana.py
+++ b/myana.py
@@ -55,9 +55,9 @@ def convert(inf, outf):
     ng = array.array('i',[0])
     t.SetBranchAddress('particle.nofparticles',np)
     t.SetBranchAddress('particle.nofgammaonly',ng)
-    tvx = array.array('f',[0.]) # true vertex x
-    tvy = array.array('f',[0.]) # true vertex y
-    tvz = array.array('f',[0.]) # true vertex z
+    tvx = array.array('d',[0.]) # true vertex x
+    tvy = array.array('d',[0.]) # true vertex y
+    tvz = array.array('d',[0.]) # true vertex z
     t.SetBranchAddress('truth.vertex_x',tvx)
     t.SetBranchAddress('truth.vertex_y',tvy)
     t.SetBranchAddress('truth.vertex_z',tvz)
@@ -118,9 +118,9 @@ def convert(inf, outf):
     tout.Branch('q1',fout_q1,'q1/I')
     tout.Branch('q2',fout_q2,'q2/I')
     tout.Branch('qsum',fout_qsum,'qsum/I')
-    tout.Branch('tvx',tvx,'tvx/F')
-    tout.Branch('tvy',tvy,'tvy/F')
-    tout.Branch('tvz',tvz,'tvz/F')
+    tout.Branch('tvx',tvx,'tvx/D')
+    tout.Branch('tvy',tvy,'tvy/D')
+    tout.Branch('tvz',tvz,'tvz/D')
     
     for e in entries:
         t.GetEntry(e)
