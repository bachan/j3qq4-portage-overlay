# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Decoder implementation of the JBIG2 image compression format"
HOMEPAGE="http://jbig2dec.sourceforge.net/"
SRC_URI="http://ghostscript.com/~giles/jbig2/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc CHANGES LICENSE README
}

