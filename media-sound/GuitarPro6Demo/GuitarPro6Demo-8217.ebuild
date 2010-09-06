# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="Tablature software for guitar and other fretted instruments, equipped with a powerful audio engine."
HOMEPAGE="http://www.guitar-pro.com/"
SRC_URI="${PN}-rev${PV}.deb"

LICENSE="Arobas-EULA"
SLOT="6"
KEYWORDS="~x86"
IUSE=""
RESTRICT="strip mirror fetch"

DEPEND="app-arch/debextract"
RDEPEND="media-libs/portaudio
	media-sound/pulseaudio"

pkg_nofetch() {
	elog "Please download ${A} from ${HOMEPAGE}"
	elog "and put it into ${DISTDIR} folder."
}

src_unpack() {
	debextract "${DISTDIR}"/${A}
	unpack ./data.tar.gz
	rm -f control.tar.gz data.tar.gz debian-binary
}

src_install() {
	rm opt/GuitarPro6/libz.so.1
	mv opt usr "${D}"
}
