# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="Tablature software for guitar and other fretted instruments, equipped with a powerful audio engine."
HOMEPAGE="http://www.guitar-pro.com/"
SRC_URI="${PN}-rev${PV}.deb"

LICENSE="Arobas-EULA"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RESTRICT="strip mirror fetch"

DEPEND="" # XXX
RDEPEND="${DEPEND}
	media-libs/portaudio
	media-sound/pulseaudio"

src_unpack() {
	# XXX
}

src_install() {
	# XXX
}

pkg_nofetch() {
	elog "Please goto ${HOMEPAGE}"
	elog "and download ${A} into ${DISTDIR}"
}
