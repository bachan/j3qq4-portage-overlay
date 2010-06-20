# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: bibble5-plugins-andrea-1.0a.ebuild 1561 2010-01-28 20:51:03Z casta $

EAPI=2

inherit bibble5-plugins

DESCRIPTION="Andrea - B&W Film Simulation"
HOMEPAGE="http://nexi.com/andrea"
SRC_URI="http://nexi.com/b5/package/Andrea-${PV}.zip"

KEYWORDS="~x86 ~amd64"
IUSE=""

PLUGINS=(
	"Andrea.ui"
	"Andrea.so"
)

bibble5-plugins-qa

#bibble5-plugins-fetch "http://nexi.com/software/paid/"

pkg_setup() {
	bibble5-plugins-block andrea
	has_multilib_profile && ABI="x86"
}
