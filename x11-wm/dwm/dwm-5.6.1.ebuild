# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs savedconfig

DESCRIPTION="a dynamic window manager for X11"
HOMEPAGE="http://www.suckless.org/dwm/"
SRC_URI="http://code.suckless.org/dl/dwm/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="bstack xinerama"

DEPEND="x11-libs/libX11
	x11-misc/dmenu
	xinerama? (	x11-proto/xineramaproto
		x11-libs/libXinerama )"
RDEPEND="${DEPEND}
	x11-apps/xsetroot"

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i \
		-e "s/CFLAGS = -std=c99 -pedantic -Wall -Os/CFLAGS += -std=c99 -pedantic -Wall -g/" \
		-e "s/LDFLAGS = -s/LDFLAGS += -g/" \
		-e "s/#XINERAMALIBS =/XINERAMALIBS ?=/" \
		-e "s/#XINERAMAFLAGS =/XINERAMAFLAGS ?=/" \
		config.mk || die "sed failed"

	if use bstack; then
		epatch "${FILESDIR}"/${P}-bstack.diff
	fi

	if use savedconfig; then
		restore_config config.h
	fi
}

src_compile() {
	local msg
	use savedconfig && msg=", please check the configfile"
	if use xinerama; then
		emake CC=$(tc-getCC) || die "emake failed${msg}"
	else
		emake CC=$(tc-getCC) XINERAMAFLAGS="" XINERAMALIBS="" \
			|| die "emake failed${msg}"
	fi
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install || die "emake install failed"

	insinto /usr/share/${PN}
	newins config.h ${PF}.config.h

	insinto /usr/share/xsessions
	doins "${FILESDIR}"/${PN}.desktop

	dodoc README

	save_config config.h
}

pkg_postinst() {
	einfo "This ebuild has support for user defined configs"
	einfo "Please read this ebuild for more details and re-emerge as needed"
	einfo "if you want to add or remove functionality for ${PN}"
	einfo ""
	einfo "Since ${PN}-5.4, status info in the bar must be set like this:"
	einfo "xsetroot -name \"\`date\` \`uptime | sed 's/.*,//'\`\""
}
