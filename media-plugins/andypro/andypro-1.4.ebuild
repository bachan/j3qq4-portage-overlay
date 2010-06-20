# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: andypro-1.4.ebuild 1391 2009-08-04 07:02:12Z casta $

inherit bibble-plugins

DESCRIPTION="AndyPRO - Pro B&W Film Simulation"
HOMEPAGE="http://nexi.com/andy"
SRC_URI="AndyPRO-${PV}.zip"

KEYWORDS="~x86 ~amd64"
IUSE=""

PLUGINS=(
	"Andy.ui"
	"Andy-Tweaks.ui"
	"Andy.so"
)

bibble-plugins-qa

bibble-plugins-fetch "http://nexi.com/software/paid/"

pkg_setup() {
	bibble-plugins-block andypro
	has_multilib_profile && ABI="x86"
}
