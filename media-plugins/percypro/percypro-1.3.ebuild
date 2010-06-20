# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: percypro-1.3.ebuild 1391 2009-08-04 07:02:12Z casta $

inherit bibble-plugins

DESCRIPTION="PercyPRO - Pro manipulate and distort your images"
HOMEPAGE="http://nexi.com/percy"
SRC_URI="PercyPRO-${PV}.zip"

KEYWORDS="~x86 ~amd64"
IUSE=""

PLUGINS=(
	"Percy.ui"
	"Percy.so"
)

bibble-plugins-qa

bibble-plugins-fetch "http://nexi.com/software/paid/"
