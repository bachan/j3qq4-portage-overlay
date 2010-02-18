# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit webapp depend.php

DESCRIPTION="A tinydns administration tool written in PHP allowing easy administration of DNS records through a web browser."
HOMEPAGE="http://www.vegadns.org"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1 BSD PHP"
KEYWORDS="~x86"
IUSE=""

RDEPEND="net-misc/wget
	net-dns/djbdns
	net-misc/whois
	sys-apps/ucspi-tcp
	sys-process/daemontools
	virtual/cron
	virtual/httpd-cgi"

need_php_httpd

pkg_setup() {
	require_php_with_use mysql session
	webapp_pkg_setup
}

src_install() {
	webapp_src_preinst

	local docs="CHANGELOG CREDITS INSTALL README* TODO UPGRADE"
	dodoc ${docs}
	rm -f ${docs} COPYING GPL

	einfo "Copying main files"
	cp -r . "${D}"/${MY_HTDOCSDIR}
	cd "${D}"/${MY_HTDOCSDIR}

	dodir ${MY_HOSTROOTDIR}/${PF}
	cd "${D}"/${MY_HOSTROOTDIR}/${PF}

	local dir="templates_c configs cache sessions"
	for i in ${dir}; do
		keepdir ${MY_HOSTROOTDIR}/${PF}/${i}
	done

	for j in $(find ./ -type d -print); do
		webapp_serverowned ${MY_HOSTROOTDIR}/${PF}/${j}
	done

	webapp_hook_script "${FILESDIR}"/reconfig
	webapp_configfile ${MY_HTDOCSDIR}/src/config.php
	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_src_install
}
