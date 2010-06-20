# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: sadiepro-1.2.ebuild 1391 2009-08-04 07:02:12Z casta $

inherit bibble-plugins

DESCRIPTION="SadiePRO - Pro adjusting image saturation, the intensity of colour"
HOMEPAGE="http://nexi.com/sadie"
SRC_URI="SadiePRO-${PV}.zip"

KEYWORDS="~x86 ~amd64"
IUSE=""

PLUGINS=(
	"Sadie.ui"
	"Sadie.so"
)

bibble-plugins-qa

bibble-plugins-fetch "http://nexi.com/software/paid/"

pkg_setup() {
	bibble-plugins-block sadiepro
	has_multilib_profile && ABI="x86"
}
