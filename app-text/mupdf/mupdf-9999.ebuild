# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=3

DESCRIPTION="Lightweight PDF viewer and toolkit written in portable C"
HOMEPAGE="http://ccxvii.net/mupdf/"
SRC_URI="http://ccxvii.net/${PN}/download/snapshots/${PN}-latest.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="${RDEPEND}"
RDEPEND="sys-libs/zlib
	media-libs/jpeg
	>=media-libs/freetype-2
	media-libs/jbig2dec
	media-libs/openjpeg"

src_compile() {
	emake build=release
}

src_install() {
	dodoc COPYING README

	insinto /usr/include/mupdf
	doins mupdf/mupdf.h fitz/fitz*.h

	cd build/release
	dobin mupdf cmapdump fontdump pdfshow pdfdraw pdfclean pdfextract
	newbin pdfinfo pdfinfo.mupdf
	dolib libmupdf.a
}

