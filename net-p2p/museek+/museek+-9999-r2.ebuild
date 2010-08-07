# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit qt4 cmake-utils subversion

DESCRIPTION="A split daemon and QT/curses client for the Soulseek network"
HOMEPAGE="http://www.museek-plus.org/"
ESVN_REPO_URI="http://www.museek-plus.org/svn/museek+/trunk/sources"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="client debug extras +fam gtk mucipher ncurses python +qt4 +server"

RDEPEND="
	dev-cpp/libxmlpp
	dev-lang/swig
	media-libs/libogg 
	media-libs/libvorbis
	fam?		( virtual/fam )
	qt4?		( x11-libs/qt-gui:4 )
	python?		( dev-lang/python )
	client?		( dev-lang/python )
	ncurses?	( dev-lang/python sys-libs/ncurses )
	extras?		( dev-python/pygtk dev-python/PyQt4 )
	gtk?		( dev-python/pygtk !mucipher? ( dev-python/pycrypto ) )
	"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.6
	"

pkg_setup() {
	if use client && ! use python; then
		eerror "USE-flag [python] is required for [client] to work"
		die "Please enable the python USE-flag"
	fi
}

src_unpack() {
	subversion_src_unpack
	cd "${S}"
}

src_compile() {
	# mycmakeargs="${mycmakeargs} -DMANDIR=share/man"
	# use remote && mycmakeargs="${mycmakeargs} -DNO_MUSEEKD=1"
	# use qt4 || mycmakeargs="${mycmakeargs} -DNO_MUSEEQ=1"
	# use gtk && mycmakeargs="${mycmakeargs} -DMURMUR=1"
	# use python && mycmakeargs="${mycmakeargs} -DBINDINGS=1"
	# use python || mycmakeargs="${mycmakeargs} -DNO_PYMUCIPHER=1 -DMURMUR=0"
	# use ncurses && mycmakeargs="${mycmakeargs} -DMUCOUS=1"

	mycmakeargs="${mycmakeargs} -DMANDIR=share/man"
	use server   || mycmakeargs="${mycmakeargs} -DNO_MUSEEKD=1"
	use qt4	     || mycmakeargs="${mycmakeargs} -DNO_MUSEEQ=1"
	use fam	     || mycmakeargs="${mycmakeargs} -DNO_MUSCAN=1"
	use extras   || mycmakeargs="${mycmakeargs} -DNO_SETUP=1"
	use gtk	     && mycmakeargs="${mycmakeargs} -DMURMUR=1"
	use mucipher || mycmakeargs="${mycmakeargs} -DNO_MUCIPHER=1"
	use python   && mycmakeargs="${mycmakeargs} -DBINDINGS=1"
	use ncurses  && mycmakeargs="${mycmakeargs} -DMUCOUS=1"
	use client   && mycmakeargs="${mycmakeargs} -DCLIENTS=1"
	use debug    && CMAKE_BUILD_TYPE="Debug"

	cmake-utils_src_compile
}

DOCS="INSTALL CREDITS README TODO"
