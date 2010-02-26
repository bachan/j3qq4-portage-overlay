# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="a PDF Viewer which behaviors like Vim"
HOMEPAGE="http://code.google.com/p/apvlv/"
SRC_URI="http://apvlv.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug"

RDEPEND=">=x11-libs/gtk+-2.6
	>=app-text/poppler-0.5.4"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9.0"

src_prepare() {
	eautoreconf
}

src_configure() {
	LD="$(tc-getLD)" econf \
		$(useq debug && echo --enable-debug) \
		--with-docdir="/usr/share/doc/${P}" \
		--disable-dependency-tracking
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS NEWS README THANKS
}

