# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/
# This ebuild come with modification from Beber

EGIT_REPO_URI="rsync://git.xmms.se/xmms2/xmms2.git/"

inherit eutils git

MY_P="${PN}-snapshot-20${PV}"
DESCRIPTION="X(cross)platform Music Multiplexing System. The new generation of the XMMS player."
HOMEPAGE="http://xmms2.xmms.org"
#SRC_URI="http://git.xmms.se/snapshots/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 amd64 sparc"
IUSE="ogg sid python ruby"

RESTRICT="nomirror"

DEPEND=">=dev-lang/python-2.2.1
	>=dev-util/scons-0.94
	>=dev-libs/glib-2.2.0
	media-libs/libmad
	>=dev-db/sqlite-3.2
	>=net-misc/curl-7.11.2
	ogg? ( media-libs/libvorbis )
	sid? ( media-sound/sidplay
			media-libs/resid )
	python? ( dev-python/pyrex )
	!python? ( !dev-python/pyrex )
	ruby? ( >=dev-lang/ruby-1.8 )"

S=${WORKDIR}/${MY_P}

src_compile() {
	# The only way I found to install the ebuild with scons...
	PYTHON_V=`python-config | tr ' ' '\n' | grep -E -- '-lpython' | cut -c 3-`
	addpredict "/usr/lib"
	addpredict "/usr/include/glib-2.0"
	addpredict "/usr/include/glib-2.0/glib"
	use python && \
		addpredict "/usr/include/${PYTHON_V}"
	addpredict "/usr/include"
	scons
	scons PREFIX="/usr" ${MAKEOPTS} SYSCONFDIR="/etc" || die
}

src_install() {
	
	dodir /usr/bin /usr/lib/xmms2 /usr/include/xmms2 /usr/include/internal
	
	if `use python` ; then
		PYTHON_VER=`python-config | tr ' ' '\n' | grep -E -- '-lpython' | cut -c 3-`
		dodir /usr/lib/${PYTHON_VER}/site-packages

		insinto /usr/lib/${PYTHON_VER}/site-packages
		doins src/clients/lib/python/xmmsclient.so
	fi

	if `use ruby`; then
		RUBY_VER=`ruby --version | cut -c 6-8`
		RUBY_ARCH=`ruby --version | cut -d '[' -f 2 | cut -f ']' -f 1`
		insinto /usr/lib/ruby/site_ruby/${RUBY_VER}/${RUBY_ARCH}
		doins src/clients/lib/ruby/xmmsclient*.so
	fi
	
	exeinto /usr/bin
	doexe src/clients/cli/xmms2
	doexe src/xmms/xmms2d
	
	insinto /usr/lib
	doins src/clients/lib/xmmsclient/*.so
	doins src/clients/lib/xmmsclient-ecore/*.so
	doins src/clients/lib/xmmsclient-glib/*.so

	insinto /usr/lib/xmms2
	doins src/plugins/*/libxmms*.so
	
	insinto /usr/include/xmms2/xmms
	doins src/include/xmms/*.h
	insinto /usr/include/xmms2/xmmsclient
	doins src/include/xmmsclient/*.h
	insinto /usr/include/xmms2/xmmsc
	doins src/include/xmmsc/*.h
	
	
	dodoc AUTHORS COPYING TODO README
}

