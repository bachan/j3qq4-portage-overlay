# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Filtering HTTP/HTTPS proxy server with IPv6 and transparent operation support"
HOMEPAGE="http://faith.eu.org/programs.html#ffproxy"
SRC_URI="http://faith.eu.org/ffproxy/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86"
IUSE=""

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc BUGS ChangeLog README TODO
}
