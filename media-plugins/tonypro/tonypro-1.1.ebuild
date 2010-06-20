# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: tonypro-1.1.ebuild 1391 2009-08-04 07:02:12Z casta $

inherit bibble-plugins

DESCRIPTION="TonyPRO - Pro colour tints and tones"
HOMEPAGE="http://nexi.com/tony"
SRC_URI="TonyPRO-${PV}.zip"

KEYWORDS="~x86 ~amd64"
IUSE=""

PLUGINS=(
	"Tony.ui"
	"Tony.so"
)

bibble-plugins-qa

bibble-plugins-fetch "http://nexi.com/software/paid/"

pkg_setup() {
	bibble-plugins-block tonypro
	has_multilib_profile && ABI="x86"
}
