# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git webapp

EGIT_REPO_URI="git://hjemli.net/pub/git/cgit"

GIT_V="$(git --version | cut -d ' ' -f 3)"

DESCRIPTION="a fast web-interface for git repositories"
HOMEPAGE="http://hjemli.net/git/cgit/about/"
SRC_URI="mirror://kernel/software/scm/git/git-${GIT_V}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-util/git
		sys-libs/zlib
		dev-libs/openssl"
DEPEND="${RDEPEND}"

S=${WORKDIR}

extract_cgit(){
	git_src_unpack
}

extract_git(){
	# Extract the git release
	unpack ${A}
}

src_unpack() {
	extract_cgit
	extract_git
	
	cd "${S}"
	
	sed -i \
		-e "s:#css=/cgit/cgit.css:css=/cgit/cgit.css:" \
		-e "s:#logo=/cgit/git-logo.png:logo=/cgit/cgit.png:" \
		-e "s:#cache-root=/var/cache/cgit:cache-root=/var/cache/cgit:" \
		cgitrc || die "patching cgitrc failed"
}

src_install() {
	webapp_src_preinst

	insinto ${MY_HTDOCSDIR}
	mv cgit cgit.cgi
	doins ${FILESDIR}/.htaccess cgit.cgi cgit.css cgit.png

	insinto /etc
	doins cgitrc

	dodir /var/cache/cgit
	keepdir /var/cache/cgit

	dobin "${D}${MY_HTDOCSDIR}"/*.cgi

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	

	webapp_src_install
}
