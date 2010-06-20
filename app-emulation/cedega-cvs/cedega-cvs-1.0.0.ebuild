# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header:
#
# 26/09/2004	Ycarus
#		This ebuild was made from the winex B.I. Holcomb ebuild 
#		and gentoo wine ebuild
#
# For new version of this ebuild check : http://gentoo.zugaina.org/

IUSE="cups opengl nptl"

ECVS_SERVER="cvs.transgaming.org:/cvsroot"
ECVS_MODULE="winex"
ECVS_USER="cvs"
ECVS_PASS="cvs"
ECVS_TOP_DIR="${DISTDIR}/cvs-src/${PN}"

inherit cvs eutils

S=${WORKDIR}/${ECVS_MODULE}


DESCRIPTION="Cedega is a distribution of Wine with enhanced DirectX for gaming.  (CVS version)"
HOMEPAGE="http://www.transgaming.com/"

SLOT="0"
KEYWORDS="~x86"
LICENSE="Aladdin"

DEPEND="sys-devel/gcc
	sys-devel/flex
	dev-util/yacc
	>=sys-libs/ncurses-5.2
	>=media-libs/freetype-2.0.0
	X? ( 	x11-base/xorg-x11
		dev-lang/tcl 
		dev-lang/tk ) 
	opengl? ( virtual/opengl )
	cups? ( net-print/cups )"

pkg_setup() {
	einfo "You MUST disable ccache if you want cedega-cvs to compile"
	einfo "FEATURES=\"-ccache\" emerge cedega-cvs"
}

src_compile() {
	unset CFLAGS CXXFLAGS LDFLAGS
	cd ${S}/programs
	epatch ${FILESDIR}/cedega-cvs-makefile.patch

	cd ${S}
	local myconf

	use opengl && myconf="--enable-opengl" || myconf="--disable-opengl"
	[ -z $DEBUG ] && myconf="$myconf --disable-trace --disable-debug" || myconf="$myconf --enable-trace --enable-debug"

	# for nptl threads
	use nptl && myconf="$myconf --enable-pthreads"
	
	./configure \
		--prefix=/usr/lib/cedega-cvs \
		--sysconfdir=/etc/cedega-cvs \
		--host=${CHOST} \
		--enable-curses \
		--with-x \
		${myconf} || die "configure failed"

	# Fixes a winetest issue
	cd ${S}/programs/winetest
	sed -i 's:wine.pm:include/wine.pm:' Makefile

	# This persuades wineshelllink that "cedega" is a better loader:)
	cd ${S}/tools
	cp wineshelllink 1
	sed -e 's/\(WINE_LOADER=\)\(\${WINE_LOADER:-wine}\)/\1cedega-cvs/' 1 > wineshelllink
	
	cd ${S}	
	make depend all || die "make depend all failed"
	cd programs && make || die "emake died"
}

src_install () {
	local CEDEGACVSMAKEOPTS="prefix=${D}/usr/lib/cedega-cvs"
	
	# Installs winex to /usr/lib/winex-cvs
	cd ${S}
	make ${CEDEGACVSMAKEOPTS} install || die "make install failed"
	cd ${S}/programs
	make ${CEDEGACVSMAKEOPTS} install || die "make install failed"
	
	
	# Setting up fake_windows
	dodir /usr/lib/cedega-cvs/.data
	cd ${D}/usr/lib/cedega-cvs/.data
	tar jxvf ${FILESDIR}/${PN}-fake_windows.tar.bz2 
	chown root:root fake_windows/ -R
	
	#Miscellaneous files
	tar jxvf ${FILESDIR}/${PN}-misc.tar.bz2 ||die
	chown root:root config
	
	insinto /usr/bin
	dobin regedit-cedega-cvs cedega-cvs cedega-cvsdbg cedega-cvs-pthread regedit

	# Copying the winedefault.reg into .data
	cd ${S}
	dodir /usr/lib/cedega-cvs/.data
	insinto /usr/lib/cedega-cvs/.data
	doins winedefault.reg
	insinto /usr/lib/wine/.data/fake_windows/Windows/System
	doins winedefault.reg
	insinto /usr/lib/wine/.data/fake_windows/Windows/Inf
	doins winedefault.reg
	
	
	dosym /usr/bin/cedega-cvs /usr/bin/cedega
	cd ${S}

	# Take care of the other stuff
	dodoc ANNOUNCE AUTHORS AUTHORS.wine BUGS ChangeLog DEVELOPERS-HINTS LICENSE LICENSE.LGPL LICENSE.ReWind LICENSE.Wine README README.transgaming

	# Manpage setup
	cp ${S}/documentation/wine.man ${D}/usr/lib/${PN}/man/man1/${PN}.1
	doman ${D}/usr/lib/${PN}/man/man1/${PN}.1
	cp ${S}/documentation/wine.conf.man ${D}/usr/lib/${PN}/man/man5/${PN}.conf.5
	doman ${D}/usr/lib/${PN}/man/man5/${PN}.conf.5

	# Remove the executable flag from those libraries.
	cd ${D}/usr/lib/cedega-cvs/bin
	chmod a-x *.so
		
}

pkg_postinst() {
	einfo "Use /usr/bin/cedega-cvs or /usr/bin/cedega to start cedega."
	einfo "This is a wrapper-script which will take care of everything"
	einfo "else."
	einfo ""
	einfo "Manpages have been installed to the system."
	einfo "\"man cedega-cvs and man cedega-cvs.conf\" should show them."
}
