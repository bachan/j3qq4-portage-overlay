# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: mattypro-2.01.ebuild 1391 2009-08-04 07:02:12Z casta $

inherit bibble-plugins

DESCRIPTION="MattyPRO - Pro create borders/frames/mats"
HOMEPAGE="http://nexi.com/matty"
SRC_URI="MattyPRO-${PV}.zip"

KEYWORDS="~x86 ~amd64"
IUSE=""

PLUGINS=(
	"Matty.ui"
	"MattyFW.ui"
	"Matty-Edge.ui"
	"Marky.ui"
	"Matty.so"
)

bibble-plugins-qa

bibble-plugins-fetch "http://nexi.com/software/paid/"
