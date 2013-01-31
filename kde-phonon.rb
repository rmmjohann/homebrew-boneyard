require 'formula'

class KdePhonon < Formula
  homepage 'http://phonon.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/phonon/4.5.0/src/phonon-4.5.0.tar.bz2'
  sha1 '122f7c53939a2c40c3312c2f5e59f25ca2c9ee53'

  depends_on 'cmake' => :build
  depends_on 'automoc4' => :build
  depends_on 'qt'
  depends_on 'glib' => :build

  keg_only "This package is already supplied by Qt and is only needed by KDE packages."

  def install
    inreplace 'cmake/FindPhononInternal.cmake',
        'BAD_ALLOCATOR AND NOT WIN32', 'BAD_ALLOCATOR AND NOT APPLE'
    system "cmake #{std_cmake_parameters} ."
    system "make install"
  end
end
