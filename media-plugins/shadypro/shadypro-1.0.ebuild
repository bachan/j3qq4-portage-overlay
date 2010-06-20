# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: shadypro-1.0.ebuild 1391 2009-08-04 07:02:12Z casta $

inherit bibble-plugins

DESCRIPTION="ShadyPRO - Pro recover shadow detail minimizing effect of noise"
HOMEPAGE="http://nexi.com/shady"
SRC_URI="ShadyPRO-${PV}.zip"

KEYWORDS="~x86 ~amd64"
IUSE=""

PLUGINS=(
	"Shady-Exposure.ui"
	"Shady-Highlights.ui"
	"Shady.so"
)

bibble-plugins-qa

bibble-plugins-fetch "http://nexi.com/software/paid/"
