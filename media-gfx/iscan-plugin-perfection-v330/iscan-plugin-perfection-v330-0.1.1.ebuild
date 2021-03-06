# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/iscan-plugin-gt-f720/iscan-plugin-gt-f720-0.0.1.ebuild,v 1.4 2011/04/21 14:29:09 flameeyes Exp $

EAPI="2"

inherit rpm

# Revision used by upstream
SRC_REV="2"

MY_PN="esci-interpreter-perfection-v330"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Epson Perfection V330 PHOTO scanner plugin for SANE 'epkowa' backend."
HOMEPAGE="http://www.avasys.jp/english/linux_e/dl_scan.html"
SRC_URI="
	x86? ( http://linux.avasys.jp/drivers/iscan-plugins/${MY_PN}/${PV}/${MY_P}-2.i386.rpm )
	amd64? ( http://linux.avasys.jp/drivers/iscan-plugins/${MY_PN}/${PV}/${MY_P}-2.x86_64.rpm )"

LICENSE="AVASYS"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE=""
IUSE_LINGUAS="ja"

for X in ${IUSE_LINGUAS}; do IUSE="${IUSE} linguas_${X}"; done

DEPEND=">=media-gfx/iscan-2.21.0"
RDEPEND="${DEPEND}"

src_install() {
	local MY_LIB="/usr/$(get_libdir)"

	# install scanner firmware
	insinto /usr/share/esci
	doins "${WORKDIR}/usr/share/esci/"*

	# install docs
	if use linguas_ja; then
		dodoc "usr/share/doc/${MY_P}/AVASYSPL.ja.txt"
	 else
		dodoc "usr/share/doc/${MY_P}/AVASYSPL.en.txt"
	fi

	# install scanner plugins
	insinto "${MY_LIB}/esci"
	INSOPTIONS="-m0755"
	doins "${WORKDIR}/usr/$(get_libdir)/esci/"*
}

pkg_postinst() {
	local MY_LIB="/usr/$(get_libdir)"

	# Needed for scaner to work properly.
	iscan-registry --add interpreter usb 0x04b8 0x0142 "${MY_LIB}/esci/libesci-interpreter-perfection-v330 /usr/share/esci/esfwad.bin"
	elog
	elog "Firmware file esfwad.bin for Epson Perfection V330 PHOTO"
	elog "has been installed in /usr/share/esci and registered for use."
	elog
}

pkg_prerm() {
	local MY_LIB="/usr/$(get_libdir)"

	iscan-registry --remove interpreter usb 0x04b8 0x0142 "${MY_LIB}/esci/libesci-interpreter-perfection-v330 /usr/share/esci/esfwad.bin"
}
