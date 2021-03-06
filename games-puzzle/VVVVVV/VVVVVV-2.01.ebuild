# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit games

DESCRIPTION="VVVVVV is a 2D puzzle platform video game, where the player is able to control the direction of gravity."
HOMEPAGE="http://thelettervsixtim.es/"
SRC_URI="${PN}_${PV}_Linux.tar.gz"

LICENSE="${PN}"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/sdl-image
	media-libs/sdl-mixer"

RESTRICT="fetch"

S=${WORKDIR}/${PN}
QA_PRESTRIPPED="/opt/VVVVVV/VVVVVV_32
	/opt/VVVVVV/VVVVVV_64"

pkg_nofetch() {
	einfo "Go to ${HOMEPAGE} and buy the game."
	einfo "Then put ${SRC_URI} into ${DISTDIR} directory."
}

src_prepare() {
	if use amd64 ; then
		MY_BIN=${PN}_64
		rm ${PN}_32 || die
	fi
	if use x86 ; then
		MY_BIN=${PN}_32
		rm ${PN}_64 || die
	fi
}

src_install() {
	local my_dest=/opt/${PN}
	insinto "${my_dest}"
	doins -r . || die
	fperms ug+x "${my_dest}"/VVVVVV || die
	fperms ug+x "${my_dest}"/${MY_BIN} || die

	games_make_wrapper ${PN} ./VVVVVV "${my_dest}"
	make_desktop_entry "${GAMES_BINDIR}"/${PN} ${PN} "${my_dest}"/data/icons/32_2.png Game
	prepgamesdirs "${my_dest}"
}
