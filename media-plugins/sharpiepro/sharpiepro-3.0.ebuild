# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: sharpiepro-3.0.ebuild 1391 2009-08-04 07:02:12Z casta $

inherit bibble-plugins

DESCRIPTION="SharpiePRO - Pro sharpen/blur for capture sharpening and applying
contrast effects"
HOMEPAGE="http://nexi.com/sharpie"
SRC_URI="SharpiePRO-${PV}.zip"

KEYWORDS="~x86 ~amd64"
IUSE=""

PLUGINS=(
	"Sharpie.ui"
	"Sharpie-Effects.ui"
	"Sharpie-Master.ui"
	"Sharpie.so"
)

bibble-plugins-qa

bibble-plugins-fetch "http://nexi.com/software/paid/"
