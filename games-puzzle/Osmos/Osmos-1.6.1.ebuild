# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit games

DESCRIPTION="Simple, ambient, nice-looking growing game"
HOMEPAGE="http://www.hemispheregames.com/osmos/"
SRC_URI="${PN}_${PV}.tar.gz"

LICENSE="${PN}"
SLOT="0"
KEYWORDS="~amd64 ~x86 -*"
IUSE=""

RDEPEND="media-libs/freetype
	media-libs/libvorbis
	media-libs/openal
	x11-libs/libX11
	virtual/opengl"

RESTRICT="fetch"

S=${WORKDIR}/${PN}
QA_PRESTRIPPED="/opt/Osmos/Osmos.bin32
	/opt/Osmos/Osmos.bin64"

pkg_nofetch() {
	einfo "Go to ${HOMEPAGE} and buy the game."
	einfo "Then put ${SRC_URI} into ${DISTDIR} directory."
}

src_prepare() {
	rm eula.txt Osmos || die
	if use amd64 ; then
		MY_BIN=${PN}.bin64
		rm ${PN}.bin32 || die
	fi
	if use x86 ; then
		MY_BIN=${PN}.bin32
		rm ${PN}.bin64 || die
	fi
}

src_install() {
	local my_dest=/opt/${PN}
	insinto "${my_dest}"
	doins -r . || die
	fperms ug+x "${my_dest}"/${MY_BIN} || die

	games_make_wrapper ${PN} ./${MY_BIN} "${my_dest}"
	make_desktop_entry "${GAMES_BINDIR}"/${PN} ${PN} "${my_dest}"/Icons/128x128.png Game
	prepgamesdirs "${my_dest}"
}
