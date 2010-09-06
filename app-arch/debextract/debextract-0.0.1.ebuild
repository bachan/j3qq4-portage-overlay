# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="This shouldn't even exist, but deb2targz can't handle 300M."
HOMEPAGE="http://www.j3qq4.org/src/portage-overlay-distfiles/"
SRC_URI="http://www.j3qq4.org/src/portage-overlay-distfiles/${P}.tar.gz"

LICENSE="AS-IS"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
}

src_compile() {
	cd "${S}"
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
}

