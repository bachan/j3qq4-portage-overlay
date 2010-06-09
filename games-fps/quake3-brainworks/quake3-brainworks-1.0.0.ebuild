# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

MOD_DESC="Enhanced AI for the Quake III Bots"
MOD_NAME="Brainworks"
MOD_DIR="brainworks"

inherit games games-mods

HOMEPAGE="http://code.google.com/p/quake3-brainworks/"
SRC_URI="brainworks-1-0-0.zip"

LICENSE="freedist"
KEYWORDS="amd64 ~ppc x86"
IUSE="dedicated opengl"
RESTRICT="strip mirror fetch"

pkg_nofetch() {
	einfo "Go to http://quake3-brainworks.googlecode.com/svn/trunk/ and"
	einfo "download ${A}, then put it into ${DISTDIR}."
}
