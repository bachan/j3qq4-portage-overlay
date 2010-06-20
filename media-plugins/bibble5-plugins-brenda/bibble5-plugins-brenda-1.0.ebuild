# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: bibble5-plugins-brenda-1.0.ebuild 1573 2010-02-11 07:55:19Z casta $

EAPI=2

inherit bibble5-plugins

DESCRIPTION="Brenda - Colour Grading"
HOMEPAGE="http://nexi.com/brenda"
SRC_URI="http://nexi.com/b5/package/Brenda-${PV}.zip"

KEYWORDS="~x86 ~amd64"
IUSE=""

PLUGINS=(
	"Brenda.ui"
	"Brenda.so"
)

bibble5-plugins-qa

#bibble5-plugins-fetch "http://nexi.com/software/paid/"
