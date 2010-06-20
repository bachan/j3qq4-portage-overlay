# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: color-popper-0.9.ebuild 1391 2009-08-04 07:02:12Z casta $

inherit bibble-plugins

MY_PV="${PV/\./-}"
MY_PN="Color-Popper"

DESCRIPTION="Color Popper bibble plugin to change color levels without
altering exposure and contrast."
HOMEPAGE="http://www.xs4all.nl/~mmzeeman/bibble/index.html#color-popper"
SRC_URI="http://www.xs4all.nl/~mmzeeman/bibble/${MY_PN}-${MY_PV}.zip"

KEYWORDS="~x86 ~amd64"
IUSE=""

PLUGINS=(
	"${MY_PN}-${MY_PV}/Pop Colors.ui"
	"${MY_PN}-${MY_PV}/pop_colors.so"
)

bibble-plugins-qa
