# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils games

DESCRIPTION="Dissolution of Eternity mission pack for Quake 1"
HOMEPAGE="http://www.idsoftware.com/games/quake/quake-mp1/"
SRC_URI=""

# See manual.txt
LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="X"

DEPEND=""
RDEPEND="X? ( || (
		games-fps/darkplaces
		games-fps/joequake
		games-fps/tenebrae
		games-fps/ezquake-bin
		games-fps/fuhquake-bin ) )"

S=${WORKDIR}

src_install() {
	insinto "${GAMES_DATADIR}"/quake1/rogue
	newins "${CDROM_ROOT}/${CDROM_MATCH}" pak0.pak || die "Error installing pak0.pak."

	dodoc "${CDROM_ROOT}"/*.txt || die "Error installing documentation files."

	prepgamesdirs
}
