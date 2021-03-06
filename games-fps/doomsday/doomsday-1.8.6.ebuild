# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/doomsday/Attic/doomsday-1.8.6.ebuild,v 1.3 2006/05/31 23:27:27 wolf31o2 dead $

inherit eutils games

DESCRIPTION="A modern gaming engine for Doom, Heretic, and Hexen"
HOMEPAGE="http://www.doomsdayhq.com/"
SRC_URI="mirror://sourceforge/deng/deng-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc x86"
IUSE="openal"

DEPEND="virtual/opengl
    virtual/glu
    media-libs/libsdl
    media-libs/sdl-mixer
    media-libs/sdl-net
    media-libs/libpng
    || ( x11-libs/libXext virtual/x11 )
    openal? ( media-libs/openal )"

S=${WORKDIR}/deng-${PV}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	rmdir "${D}/${GAMES_PREFIX}/include"
	mv "${D}/${GAMES_DATADIR}/"{deng/Data/jDoom,doom-data}
	dosym "${GAMES_DATADIR}"/doom-data "${GAMES_DATADIR}"/deng/Data/jDoom

	local game
	for game in jdoom jheretic jhexen; do
		newgamesbin "${FILESDIR}/wrapper" ${game}
		sed -i -e "s:GAME:${game}:" "${D}"/${GAMES_BINDIR}/${game} || die "sed ${GAMES_BINDIR}/${game} failed"
	done

	dodoc Doc/*.txt Doc/*/*.txt README
	prepgamesdirs
}

