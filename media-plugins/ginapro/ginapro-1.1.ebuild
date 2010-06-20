# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: ginapro-1.1.ebuild 1391 2009-08-04 07:02:12Z casta $

inherit bibble-plugins

DESCRIPTION="GinaPRO - Pro correction and enhancement of skin tones"
HOMEPAGE="http://nexi.com/gina"
SRC_URI="GinaPRO-${PV}.zip"

KEYWORDS="~x86 ~amd64"
IUSE=""

PLUGINS=(
	"Gina.ui"
	"Gina.so"
)

bibble-plugins-qa

bibble-plugins-fetch "http://nexi.com/software/paid/"

pkg_setup() {
	bibble-plugins-block ginapro
	has_multilib_profile && ABI="x86"
}
