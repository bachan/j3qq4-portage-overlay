# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: bibble5-5.1.0f.ebuild 1657 2010-07-10 09:48:50Z casta $

EAPI=2

inherit eutils multilib versionator

DESCRIPTION="Professional photo workflow and RAW conversion software"
HOMEPAGE="http://www.bibblelabs.com"
RESTRICT="mirror strip"
BUILD="${PV//\./}-20100701"
SRC_URI="http://edge.bibblelabs.com/${BUILD}/${P}_i386.deb"

LICENSE="bibblepro"
SLOT="5"
KEYWORDS="~x86 ~amd64"
IUSE="brenda"

DEPEND="sys-apps/debianutils"
RDEPEND="virtual/libc
	media-libs/fontconfig
	media-libs/freetype
	sys-libs/zlib
	dev-libs/expat
	dev-libs/glib:2
	x86? (
		media-libs/libpng:1.2
	)
	amd64? (
		app-emulation/emul-linux-x86-baselibs
		app-emulation/emul-linux-x86-xlibs
	)"

PDEPEND="brenda? ( media-plugins/bibble5-plugins-brenda )"

# Skip some QA checks we cannot fix
QA_EXECSTACK="opt/bibble5/bin/bibble5
opt/bibble5/lib/libkodakcms.so"
QA_TEXTRELS="opt/bibble5/lib/libkodakcms.so
opt/bibble5/supportfiles/plugins/BBlackAndWhite.bplugin/lib/BBlackAndWhite.so
opt/bibble5/supportfiles/plugins/Andrea.bplugin/lib/Andrea.so"

src_unpack() {
	unpack ${A}
	unpack ./data.tar.gz
	rm -f control.tar.gz data.tar.gz debian-binary
}

pkg_setup() {
	has_multilib_profile && ABI="x86"
}

src_install() {
	dodir /opt/bibble5

	# bibble binary
	dodir /opt/bibble5/bin
	exeinto /opt/bibble5/bin
	doexe opt/bibble5/bin/bibble5
	exeinto /usr/bin
	doexe usr/bin/bibble5

	# bibble data files
	insinto /opt/bibble5
	doins -r opt/bibble5/supportfiles

	# bibble libs
	# We use cp -pPR to preserve files (libs) permissions without listing all files
	cp -pPR opt/bibble5/lib "${D}/opt/bibble5/" || die "failed to copy"

	# bibble icon
	dodir /usr/share/pixmaps
	insinto /usr/share/pixmaps
	doins usr/share/pixmaps/bibble5pro.png

	# .desktop file
	insinto /usr/share/applications
	doins usr/share/applications/bibblelabs-bibble5.desktop
}
