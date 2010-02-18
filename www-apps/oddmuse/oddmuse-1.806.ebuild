# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit webapp

DESCRIPTION="Perl-based Wiki designed for ease of use"
HOMEPAGE="http://www.oddmuse.org/"
SRC_URI="http://download.savannah.nongnu.org/releases/${PN}/${P}.tar.gz"

LICENSE="FDL-1.1 GPL-3"
KEYWORDS="~x86"

RDEPEND="dev-lang/perl
	dev-perl/libwww-perl
	dev-perl/XML-RSS
	virtual/perl-CGI
	virtual/perl-MIME-Base64
	virtual/httpd-cgi"

src_install() {
	webapp_src_preinst

	cp wiki.pl "${D}"/${MY_CGIBINDIR}
	rm -f wiki.pl

	dodoc ChangeLog
	insinto /usr/share/doc/${PF}/modules
	doins *.pl

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_src_install
}
