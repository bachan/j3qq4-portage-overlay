# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: percypro-1.3.ebuild 1166 2008-08-08 15:10:04Z casta $

inherit bibble-plugins

DESCRIPTION="Cammy - Camera/Exposure Info"
HOMEPAGE="http://nexi.com/cammy"
SRC_URI="Cammy-${PV}.zip"

KEYWORDS="~x86 ~amd64"
IUSE=""

PLUGINS=(
	"Cammy-2-Lines.ui"
	"Cammy-3-Lines.ui"
	"Cammy.so"
)

bibble-plugins-qa

bibble-plugins-fetch "http://nexi.com/software/paid/"
