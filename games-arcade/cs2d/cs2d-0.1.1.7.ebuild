# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games

A_WIN32="${PN}_0117_win.zip"
A_LINUX="${PN}_0117_linux.zip"

DESCRIPTION="More than just a freeware clone of the well known game Counter-Strike"
HOMEPAGE="http://www.cs2d.com/download.php"
SRC_URI="${A_LINUX} ${A_WIN32}"

LICENSE="CS2D-EULA"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RESTRICT="strip mirror fetch"
DEPEND="app-arch/unzip"
RDEPEND=""

# http://www.unrealsoftware.de/get.php?get=cd2d_0117_win.zip
# http://www.unrealsoftware.de/get.php?get=cs2d_0117_linux.zip
# http://www.unrealsoftware.de/get.php?get=cs2d_dedicated_linux.zip
dir="${GAMES_PREFIX_OPT}/${PN}"

pkg_nofetch() {
	einfo "Go to ${HOMEPAGE} and download ${A}."
	einfo "Then put both into ${DISTDIR} directory."
}

src_unpack() {
	unzip -d data "${DISTDIR}/${A_WIN32}"
	unzip "${DISTDIR}/${A_LINUX}"
}

src_prepare() {
	rm -f data/*.{bat,exe}
	mv -f Linux\ Info.txt data/readme_linux.txt
}

src_install() {
	insinto "${dir}"
	exeinto "${dir}"

	doins -r data/*
	doexe CounterStrike2D Launcher.sh

	exeinto "${GAMES_PREFIX}/bin"
	doexe "${FILESDIR}/${PN}"

	doicon "${FILESDIR}/${PN}.png"
	make_desktop_entry ${PN} "${PN}" "${PN}"

	prepgamesdirs
}

