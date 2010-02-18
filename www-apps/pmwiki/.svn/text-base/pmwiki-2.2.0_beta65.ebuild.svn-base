# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Source: http://bugs.gentoo.org/show_bug.cgi?id=96284
# Submitted-By: Rene Zbinden
# Reviewed-By: rl03 2005-12-18
# Reviewed-By: bathym 2006-04-12

inherit webapp depend.php

MY_PV=${PV/_beta/-beta}
DESCRIPTION="A wiki-based system for collaborative creation and maintenance of websites"
HOMEPAGE="http://www.pmwiki.org"
SRC_URI="http://www.pmwiki.org/pub/${PN}/${PN}-${MY_PV}.tgz"

LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE=""

RDEPEND="virtual/httpd-cgi"

need_php_httpd

S=${WORKDIR}/${PN}-${MY_PV}

src_unpack() {
	unpack ${A}
	cd "${S}"
	echo "<?php include('pmwiki.php');" > index.php
	cp docs/sample-config.php local/config.php
	rm -f docs/{.htaccess,COPYING.txt}
}

src_install () {
	webapp_src_preinst

	dodoc README.txt docs/*
	rm -rf README.txt docs/

	cp -R . "${D}"/${MY_HTDOCSDIR}

	for x in wiki.d uploads ; do
		keepdir ${MY_HTDOCSDIR}/${x}
		webapp_serverowned ${MY_HTDOCSDIR}/${x}
	done

	webapp_configfile ${MY_HTDOCSDIR}/local/config.php
	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt

	webapp_src_install
}
