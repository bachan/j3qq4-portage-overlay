# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: siggypro-1.2.ebuild 1423 2009-09-20 23:29:52Z casta $

inherit bibble-plugins

DESCRIPTION="SiggyPro - Pro exposure adjustment"
HOMEPAGE="http://nexi.com/siggy"
SRC_URI="SiggyPRO-${PV}.zip"

KEYWORDS="~x86 ~amd64"
IUSE=""

PLUGINS=(
	"Siggy.ui"
	"Siggy.so"
)

bibble-plugins-qa

bibble-plugins-fetch "http://nexi.com/software/paid/"

pkg_setup() {
	bibble-plugins-block siggypro
	has_multilib_profile && ABI="x86"
}
