# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: foxypro-1.2a.ebuild 1391 2009-08-04 07:02:12Z casta $

inherit bibble-plugins

DESCRIPTION="FoxyPRO - Pro collection of special effects"
HOMEPAGE="http://nexi.com/foxy"
SRC_URI="FoxyPRO-${PV}.zip"

KEYWORDS="~x86 ~amd64"
IUSE=""

PLUGINS=(
	"Foxy-Blur.ui"
	"Foxy-Vignette.ui"
	"Foxy.so"
)

bibble-plugins-qa

bibble-plugins-fetch "http://nexi.com/software/paid/"
