# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: argyllcms-1.1.1.ebuild 1608 2010-05-13 18:35:13Z casta $

MY_P="Argyll_V${PV}"
DESCRIPTION="Open source, ICC compatible color management system"
HOMEPAGE="http://www.argyllcms.com/"
SRC_URI="http://www.argyllcms.com/${MY_P}_src.zip"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="media-libs/tiff
	media-libs/jpeg
	sys-libs/zlib"
DEPEND="${RDEPEND}
	app-arch/unzip
	x11-libs/libX11
	x11-libs/libXScrnSaver
	dev-util/ftjam"

S="${WORKDIR}/${MY_P}"

src_install() {
	emake install || die

	rm bin/License.txt || die
	dobin bin/* || die

	if use doc; then
		dohtml doc/* || die
	fi

	dodoc log.txt Readme.txt ttbd.txt notes.txt || die

	insinto /usr/share/${PN}/ref
	doins   ref/*  || die
}

pkg_postinst() {
	elog
	elog "If you have a Spyder2 you need to extract the firmware"
	elog "from the spyder2_setup.exe (ColorVision CD)"
	elog "and store it as /usr/bin/spyd2PLD.bin"
	elog
	elog "For further info on setting up instrument access read"
	elog "http://www.argyllcms.com/doc/Installing_Linux.html"
	elog
}
