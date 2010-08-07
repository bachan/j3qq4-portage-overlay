# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games

# TODO: make cs2d_dedicated init.d/conf.d files
# TODO: make cs2d_dedicated use-flaggable

# http://www.unrealsoftware.de/get.php?get=cd2d_0117_win.zip
# http://www.unrealsoftware.de/get.php?get=cs2d_0117_linux.zip
# http://www.unrealsoftware.de/get.php?get=cs2d_dedicated_linux.zip

A_LINUX="${PN}_0117_linux.zip"
A_DEDIC="${PN}_dedicated_linux.zip"
A_WIN32="${PN}_0117_win.zip"

DESCRIPTION="More than just a freeware clone of the well known game Counter-Strike"
HOMEPAGE="http://www.cs2d.com/download.php"
SRC_URI="${A_LINUX} ${A_DEDIC} ${A_WIN32}"

LICENSE="CS2D-EULA"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RESTRICT="strip mirror fetch"
DEPEND="app-arch/unzip"
RDEPEND=""

dir="${GAMES_PREFIX_OPT}/${PN}"

pkg_nofetch() {
	einfo "Go to ${HOMEPAGE} and download ${A_LINUX}, ${A_DEDIC} and ${A_WIN32}."
	einfo "Then put all of them into ${DISTDIR} directory."
}

src_unpack() {
	unzip "${DISTDIR}/${A_LINUX}"
	unzip "${DISTDIR}/${A_DEDIC}"
	unzip -d data "${DISTDIR}/${A_WIN32}"
}

src_prepare() {
	rm -f data/*.{bat,exe}
	mv -f Linux\ Info.txt data/readme_linux.txt
	mv -f Dedicated\ Readme.txt data/readme_linux_dedicated.txt
}

src_install() {
	insinto "${dir}"
	exeinto "${dir}"

	doins -r data/*
	doexe CounterStrike2D Launcher.sh
	doexe cs2d_dedicated

	exeinto "${GAMES_PREFIX}/bin"
	doexe "${FILESDIR}/${PN}"

	doicon "${FILESDIR}/${PN}.png"
	make_desktop_entry ${PN} "${PN}" "${PN}"

	prepgamesdirs
}

