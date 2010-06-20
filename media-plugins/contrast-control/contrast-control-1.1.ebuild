# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: contrast-control-1.1.ebuild 1391 2009-08-04 07:02:12Z casta $

inherit bibble-plugins

MY_PV="${PV/\./-}"
MY_PN="Contrast-Control"

DESCRIPTION="Contrast Control is a bibble plugin to do Interactive Contrast
Enhancement by Histogram Warping"
HOMEPAGE="http://www.xs4all.nl/~mmzeeman/bibble/index.html#contrast-control"
SRC_URI="http://www.xs4all.nl/~mmzeeman/bibble/${MY_PN}-${MY_PV}.zip"

KEYWORDS="~x86 ~amd64"
IUSE=""

PLUGINS=(
	"${MY_PN}-${MY_PV}/Contrast Control.ui"
	"${MY_PN}-${MY_PV}/contrast_control.so"
)

bibble-plugins-qa
