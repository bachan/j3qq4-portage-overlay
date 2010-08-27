# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: bibble5-plugins-brenda-1.0.1.ebuild 1659 2010-07-10 09:49:49Z casta $

EAPI=2

inherit bibble5-plugins

MY_PN="Brenda"

DESCRIPTION="Brenda - Colour Grading"
HOMEPAGE="http://nexi.com/brenda"
SRC_URI="http://nexi.com/b5/package/${MY_PN}-${PV}.bzplug -> ${MY_PN}-${PV}.zip"

KEYWORDS="~x86 ~amd64"
IUSE=""

bibble5-plugins-qa

#bibble5-plugins-fetch "http://nexi.com/software/paid/"
