# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/quake3-rally/quake3-rally-1.33.ebuild,v 1.5 2010/05/23 18:52:36 pacho Exp $

EAPI=2

MOD_DESC="Total conversion car racing mod"
MOD_NAME="Rally"
MOD_DIR="q3rally"

inherit games games-mods

HOMEPAGE="http://www.q3rally.com/"
SRC_URI="q3rally_v133.zip"

LICENSE="as-is"
KEYWORDS="amd64 ~ppc x86"
IUSE="dedicated opengl"

