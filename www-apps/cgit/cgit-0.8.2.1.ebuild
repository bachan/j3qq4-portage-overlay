# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils webapp

use dataonly || GIT_V="$(git --version | cut -d ' ' -f 3)"

DESCRIPTION="a fast web-interface for git repositories"
HOMEPAGE="http://hjemli.net/git/cgit/about/"
SRC_URI="!dataonly? ( mirror://kernel/software/scm/git/git-${GIT_V}.tar.bz2 )
		http://hjemli.net/git/cgit/snapshot/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

IUSE="standalone dataonly"

# This is remote installation, so we don't need any depends
use standalone || need_httpd_cgi

RDEPEND="!dataonly? ( dev-util/git )
			sys-libs/zlib
			dev-libs/openssl"

DEPEND="${RDEPEND}"

S="${WORKDIR}/cgit-${PV}"

pkg_setup() {
	if use standalone; then
		use dataonly && die "standalone and dataonly are conflicting USE-flags"
		use vhosts && ewarn "vhosts flag is useless with standalone installation"

		# We're into fast-cgi environment, so we need user to operate on
		enewuser cgit
		enewgroup cgit
	else
		webapp_pkg_setup
	fi
}

src_unpack() {
	unpack ${A}

	cd "${S}"

	if ! use dataonly; then
		rmdir git

		mv "${WORKDIR}/git-${GIT_V}" git
	fi
}

src_compile() {
	# Skip compilation if this is dataonly build
	use dataonly && return 0

	emake || die "emake failed"
}

src_install() {
	if ! use dataonly; then
		mv cgit cgit.cgi

		insinto /etc
		doins "${FILESDIR}"/cgitrc

		local cache_dir=/var/cache/cgit

		dodir "${cache_dir}"
		keepdir "${cache_dir}"

		use standalone && fowners cgit:cgit "${cache_dir}"

		dodoc cgitrc.5.txt
	fi

	if use standalone; then
		dobin cgit.cgi
	else
		webapp_src_preinst

		insinto "${MY_HTDOCSDIR}"
		doins cgit.css cgit.png

		if ! use dataonly; then
			exeinto "${MY_CGIBINDIR}"
			doexe cgit.cgi

			insinto "${MY_APPDIR}"/conf
			doins "${FILESDIR}"/cgitrc
			webapp_configfile "${MY_APPDIR}"/conf/cgitrc
		fi

		webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt

		webapp_src_install
	fi
}

pkg_postinst() {
	# We don't want to use webapp if this is standalone setup
	use standalone || webapp_pkg_postinst
}

pkg_prerm() {
	# Same idea
	use standalone || webapp_pkg_prerm
}
