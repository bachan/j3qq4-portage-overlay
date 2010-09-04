# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="3"

inherit eutils games

DESCRIPTION="Scourge of Armagon mission pack for Quake 1"
HOMEPAGE="http://www.idsoftware.com/games/quake/quake-mp1/"
SRC_URI="lights? ( http://icculus.org/twilight/darkplaces/files/romirtlights_soa.pk3 )"

# See manual.txt
LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 amd64"
IUSE="X lights"

DEPEND="lights? ( app-arch/unzip )"
RDEPEND="X? ( || (
		games-fps/darkplaces
		games-fps/joequake
		games-fps/tenebrae
		games-fps/ezquake-bin
		games-fps/fuhquake-bin ) )"

S=${WORKDIR}

src_unpack() {
	if use lights; then
		unzip -qo "${DISTDIR}"/romirtlights_soa.pk3 || die "unzip romirtlights_soa.pk3 failed"
	fi
}

src_install() {
	insinto "${GAMES_DATADIR}"/quake1/hipnotic
	newins "${CDROM_ROOT}/${CDROM_MATCH}" pak0.pak || die "Error installing pak0.pak."

	dodoc "${CDROM_ROOT}"/*.txt || die "Error installing documentation files."

	if use lights; then
		doins -r "${WORKDIR}/"maps || die "doins maps failed"
	fi

	prepgamesdirs
}
