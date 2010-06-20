# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: spectrum-1.0.ebuild 1391 2009-08-04 07:02:12Z casta $

inherit bibble-plugins

MY_PV="${PV/\./-}"
MY_PN="Spectrum"

DESCRIPTION="Spectrum bibble plugin to manipulate chroma curve"
HOMEPAGE="http://www.xs4all.nl/~mmzeeman/bibble/spectrum/download.html"
SRC_URI="http://www.xs4all.nl/~mmzeeman/bibble/spectrum/${MY_PN}-${MY_PV}.zip"

KEYWORDS="~x86 ~amd64"
IUSE=""

PLUGINS=(
	"${MY_PN}-${MY_PV}/Spectrum.ui"
	"${MY_PN}-${MY_PV}/spectrum.so"
)

bibble-plugins-qa
