# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: dinkypro-0.96.ebuild 1391 2009-08-04 07:02:12Z casta $

inherit bibble-plugins

DESCRIPTION="DinkyPRO - Pro selectively modifying areas of an image"
HOMEPAGE="http://nexi.com/dinky"
SRC_URI="DinkyPRO-${PV}.zip"

KEYWORDS="~x86 ~amd64"
IUSE=""

PLUGINS=(
	"DinkyPRO.ui"
	"Dinky.so"
)

bibble-plugins-qa

bibble-plugins-fetch "http://nexi.com/software/paid/"
