# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: bibblepro-bin-4.10.1.ebuild 1549 2010-01-25 07:33:53Z casta $

EAPI=2

inherit eutils rpm multilib versionator

# derived from http://bugs.gentoo.org/show_bug.cgi?id=147816
# with customizations and repoman fixes
DESCRIPTION="Professional photo workflow and RAW conversion software"
HOMEPAGE="http://www.bibblelabs.com"
RESTRICT="mirror strip"
MY_P="bibblepro"
RPM_VERSION="1"
MAJOR_VERSION=$(get_version_component_range 1-2)
SRC_URI="mirror://bibble/pub/${MAJOR_VERSION}/BibblePro/${MY_P}-${PV}-${RPM_VERSION}.i386.rpm"

LICENSE="bibblepro"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="andypro roypro ginapro siggypro sadiepro tonypro anselpro dinkypro foxypro
mattypro percypro shadypro sharpiepro gradpro ndgrad spectrum color-popper
contrast-control cammy"

DEPEND="app-arch/rpm2targz"
RDEPEND="virtual/libc
	media-libs/fontconfig
	media-libs/freetype
	sys-libs/zlib
	dev-libs/expat
	virtual/libstdc++:3.3
	amd64? (
		app-emulation/emul-linux-x86-baselibs
	)"
# blockers are used to help portage managing collisions
PDEPEND="andypro? ( media-plugins/andypro )
	!andypro? ( !media-plugins/andypro )
	roypro? ( media-plugins/roypro )
	!roypro? ( !media-plugins/roypro )
	ginapro? ( media-plugins/ginapro )
	!ginapro? ( !media-plugins/ginapro )
	siggypro? ( media-plugins/siggypro )
	!siggypro? ( !media-plugins/siggypro )
	sadiepro? ( media-plugins/sadiepro )
	!sadiepro? ( !media-plugins/sadiepro )
	tonypro? ( media-plugins/tonypro )
	!tonypro? ( !media-plugins/tonypro )
	anselpro? ( media-plugins/anselpro )
	dinkypro? ( media-plugins/dinkypro )
	foxypro? ( media-plugins/foxypro )
	mattypro? ( media-plugins/mattypro )
	percypro? ( media-plugins/percypro )
	shadypro? ( media-plugins/shadypro )
	sharpiepro? ( media-plugins/sharpiepro )
	gradpro? ( media-plugins/gradpro )
	ndgrad? ( !gradpro? ( media-plugins/ndgrad ) )
	spectrum? ( media-plugins/spectrum )
	color-popper? ( media-plugins/color-popper )
	contrast-control? ( media-plugins/contrast-control )
	cammy? ( media-plugins/cammy )"

# Skip some QA checks we cannot fix
QA_EXECSTACK="usr/bin/bibblepro"
QA_TEXTRELS="usr/lib/bibblelabs/bibblepro/plugins/*.so"

pkg_setup() {
	has_multilib_profile && ABI="x86"
}

src_unpack() {
	rpm_src_unpack

	# if using andypro remove the demo plugin to avoid collisions
	if use andypro; then
		rm "${WORKDIR}/usr/lib/bibblelabs/bibblepro/plugins/Andy.so"
		rm "${WORKDIR}/usr/lib/bibblelabs/bibblepro/tools/Plugins/Andy.ui"
	fi
	# if using ginapro remove the demo plugin to avoid collisions
	if use ginapro; then
		rm "${WORKDIR}/usr/lib/bibblelabs/bibblepro/plugins/Gina.so"
		rm "${WORKDIR}/usr/lib/bibblelabs/bibblepro/tools/Plugins/Gina.ui"
	fi
	# if using roypro remove the demo plugin to avoid collisions
	if use roypro; then
		rm "${WORKDIR}/usr/lib/bibblelabs/bibblepro/plugins/Roy.so"
		rm "${WORKDIR}/usr/lib/bibblelabs/bibblepro/tools/Plugins/Roy.ui"
	fi
	# if using sadiepro remove the demo plugin to avoid collisions
	if use sadiepro; then
		rm "${WORKDIR}/usr/lib/bibblelabs/bibblepro/plugins/Sadie.so"
		rm "${WORKDIR}/usr/lib/bibblelabs/bibblepro/tools/Plugins/Sadie.ui"
	fi
	# if using siggypro remove the demo plugin to avoid collisions
	if use siggypro; then
		rm "${WORKDIR}/usr/lib/bibblelabs/bibblepro/plugins/Siggy.so"
		rm "${WORKDIR}/usr/lib/bibblelabs/bibblepro/tools/Plugins/Siggy.ui"
	fi
	# if using tonypro remove the demo plugin to avoid collisions
	if use tonypro; then
		rm "${WORKDIR}/usr/lib/bibblelabs/bibblepro/plugins/Tony.so"
		rm "${WORKDIR}/usr/lib/bibblelabs/bibblepro/tools/Plugins/Tony.ui"
	fi
}

src_install() {
	cd "${WORKDIR}"

	dobin ./usr/bin/bibblepro

	dodir "/usr/lib/bibblelabs"
	insinto "/usr/lib/bibblelabs"
	doins -r ./usr/lib/bibblelabs/*

	# libs must be executable so that plugins works
	fperms 0755 /usr/lib/bibblelabs/bibblepro/libs/libkodakcms.so
	fperms 0755 /usr/lib/bibblelabs/bibblepro/libs/NoiseNinja/libnoiseninja.so.2.0.0
	use andypro || fperms 0755 /usr/lib/bibblelabs/bibblepro/plugins/Andy.so
	fperms 0755 /usr/lib/bibblelabs/bibblepro/plugins/BBlackAndWhite.so
	use ginapro || fperms 0755 /usr/lib/bibblelabs/bibblepro/plugins/Gina.so
	use roypro || fperms 0755 /usr/lib/bibblelabs/bibblepro/plugins/Roy.so
	use sadiepro || fperms 0755 /usr/lib/bibblelabs/bibblepro/plugins/Sadie.so
	use siggypro || fperms 0755 /usr/lib/bibblelabs/bibblepro/plugins/Siggy.so
	use tonypro || fperms 0755 /usr/lib/bibblelabs/bibblepro/plugins/Tony.so

	dodoc ./usr/share/doc/bibblepro/README.txt

	dodir /usr/share/pixmaps
	insinto /usr/share/pixmaps
	doins ./usr/share/pixmaps/bibblelogo.png

	# Add a fancy .desktop file
	insinto /usr/share/applications
	doins "${FILESDIR}/bibblepro.desktop"

	insinto /etc/env.d
	doins "${FILESDIR}/80bibblepro-bin"
}
