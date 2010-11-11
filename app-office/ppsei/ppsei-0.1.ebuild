# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="extract images from PowerPoint (.pps, .ppt) files"
HOMEPAGE="http://sourceforge.net/projects/ppsei/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

S=${WORKDIR}/${PN}

src_install() {
	dobin ppsei
	dodoc README README.dev
}
