# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: roypro-1.1a.ebuild 1391 2009-08-04 07:02:12Z casta $

inherit bibble-plugins

DESCRIPTION="RoyPRO - Pro colour correction/adjustment that allows spot colour to be corrected"
HOMEPAGE="http://nexi.com/roy"
SRC_URI="RoyPRO-${PV}.zip"

KEYWORDS="~x86 ~amd64"
IUSE=""

PLUGINS=(
	"Roy.ui"
	"Roy.so"
)

bibble-plugins-qa

bibble-plugins-fetch "http://nexi.com/software/paid/"

pkg_setup() {
	bibble-plugins-block roypro
	has_multilib_profile && ABI="x86"
}
