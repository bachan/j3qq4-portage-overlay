# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: anselpro-1.1.ebuild 1391 2009-08-04 07:02:12Z casta $

inherit bibble-plugins

DESCRIPTION="AnselPRO - Pro image edit using theory of light zones"
HOMEPAGE="http://nexi.com/ansel"
SRC_URI="AnselPRO-${PV}.zip"

KEYWORDS="~x86 ~amd64"
IUSE=""

PLUGINS=(
	"Ansel-Tabs.ui"
	"Ansel-Zones.ui"
	"Ansel.so"
)

bibble-plugins-qa

bibble-plugins-fetch "http://nexi.com/software/paid/"
