# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/tinycc/tinycc-0.9.25.ebuild,v 1.1 2009/07/10 21:44:58 truedfx Exp $

inherit eutils

IUSE=""
DESCRIPTION="A very small C compiler for ix86/amd64"
SRC_URI="http://overlay.j3qq4.org/distfiles/${P}.tar.gz"
HOMEPAGE="http://bellard.org/tcc/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="app-text/texi2html"
RDEPEND=""

# Testsuite is broken, relies on gcc to compile
# invalid C code that it no longer accepts
RESTRICT="test"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Don't strip
	sed -i -e 's|$(INSTALL) -s|$(INSTALL)|' Makefile

	# Fix examples
	sed -i -e '1{
		i#! /usr/bin/tinycc -run
		/^#!/d
	}' examples/ex*.c
	sed -i -e '1s/$/ -lX11/' examples/ex4.c
}

src_compile() {
	local myopts
	use x86 && myopts="--cpu=x86"
	use amd64 && myopts="--cpu=x86-64"
	econf ${myopts}
	emake || die "make failed"
}

src_install() {
	emake \
		bindir="${D}"/usr/bin \
		libdir="${D}"/usr/lib \
		tinyccdir="${D}"/usr/lib/tinycc \
		includedir="${D}"/usr/include \
		docdir="${D}"/usr/share/doc/${PF} \
		mandir="${D}"/usr/share/man install || die "make install failed"
	dodoc Changelog README TODO VERSION
	dohtml tinycc-doc.html
	exeinto /usr/share/doc/${PF}/examples
	doexe examples/ex*.c
}
