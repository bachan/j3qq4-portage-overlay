# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ESVN_REPO_URI="http://${PN}.googlecode.com/svn/trunk/"

inherit subversion toolchain-funcs

DESCRIPTION="tool that helps you find what software is using the most power"
HOMEPAGE="http://www.lesswatts.org/projects/powertop/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~sparc ~x86"
IUSE="unicode"

DEPEND="sys-libs/ncurses"
RDEPEND="${DEPEND}"

src_unpack() {
	subversion_src_unpack
	sed -i '/${CFLAGS}/s:$: ${LDFLAGS}:' Makefile
	use unicode || sed -i 's:-lncursesw:-lncurses:' Makefile
}

src_compile() {
	tc-export CC
	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc Changelog README
	gunzip "${D}"/usr/share/man/man1/powertop.1.gz
}

pkg_postinst() {
	einfo "For PowerTOP to work best, use a Linux kernel with the"
	einfo "tickless idle (NO_HZ) feature enabled (version 2.6.21 or later)"
}
