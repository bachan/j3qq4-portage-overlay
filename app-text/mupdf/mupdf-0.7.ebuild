# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils flag-o-matic multilib toolchain-funcs

DESCRIPTION="a lightweight PDF viewer and toolkit written in portable C"
HOMEPAGE="http://mupdf.com/"
SRC_URI="http://mupdf.com/download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X debug +native"

S=${WORKDIR}/${PN}

RDEPEND="media-libs/freetype:2
	media-libs/jbig2dec
	media-libs/jpeg
	media-libs/openjpeg
	X? ( x11-libs/libX11
		x11-libs/libXext )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	mv "${P}" "${PN}"
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-buildsystem.patch
}

src_compile() {
	use x86	  && append-cflags -DARCH_X86
	use amd64 && append-cflags -DARCH_X86_64

	use X && my_mupdf= || my_mupdf="PDFVIEW_EXE="
	use native && my_build=native || my_build=release
	use debug && my_build=debug

	emake build=${my_build} ${my_mupdf} CC="$(tc-getCC)" || die "emake"
}

src_install() {
	emake build=${my_build} ${my_mupdf} prefix="${D}/usr" libprefix="${D}/usr/$(get_libdir)" install || die "emake install"

	insinto /usr/$(get_libdir)/pkgconfig
	doins debian/mupdf.pc || die

	if use X ; then
		domenu debian/mupdf.desktop || die
		doicon debian/mupdf.xpm		|| die
		doman  debian/mupdf.1		|| die
	fi

	doman debian/pdf{clean,draw,show}.1 || die
	dodoc README || die

	mv "${D}"/usr/bin/pdfinfo "${D}"/usr/bin/mupdf_pdfinfo || die "mupdf_pdfinfo"
}

pkg_postinst() {
	elog "Note, that pdfinfo was renamed to mupdf_pdfinfo to avoid collisions"
	elog "with app-text/poppler-utils package."
	elog ""
}
