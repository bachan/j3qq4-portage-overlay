# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

DESCRIPTION="A split daemon and QT/curses client for the Soulseek network"
HOMEPAGE="http://thegraveyard.org/daelstorm/museek.php#museek+"

ESVN_REPO_URI="http://www.museek-plus.org/svn/museek+/trunk/sources"
ESVN_MODULE="museek+"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-*"
IUSE="debug gtk ncurses qsa qt vorbis"

DEPEND="dev-cpp/libxmlpp
	qt? ( >=x11-libs/qt-3.3.5 )
	dev-lang/swig
	dev-lang/python
	vorbis? ( media-libs/libogg 
				media-libs/libvorbis )
	qsa? ( >=dev-libs/qsa-1.1 )
	ncurses? ( sys-libs/ncurses 
				dev-lang/python )"
S="${WORKDIR}/${PN}"

src_compile() {
	local myconf=""
	use debug || myconf="${myconf} RELEASE=yes MULOG=debug"
	use qt || myconf="${myconf} MUSEEQ=no"
	use qsa	|| myconf="${myconf} QSA=no"
	use vorbis || myconf"${myconf} VORBIS=no"
	use gtk || myconf="${myconf} MUSETUPGTK=no"
	use ncurses || myconf="${myconf} MUCOUS=no"
	use ncurses && myconf="${myconf} PYMUCIPHER=yes" # mucous needs pymucipher
	
	scons ${myconf} FLAGS="${CXXFLAGS} -fPIC -Wall" PREFIX=/usr DESTDIR="${D}" \
	|| die "compile failed"
}

src_install() {

	scons DESTDIR="${D}" install || die "install failed"
	
	dobin "${FILESDIR}"/museek-launcher
	if use qt; then
		insinto /usr/share/applications 
		doins "${S}"/museeq.desktop
		newicon "icons/museek_icon_blue.png" "museeq.png"
		make_desktop_entry museeq "Museeq" museeq "Network;P2P"
	fi
	dodoc CHANGELOG FILES CREDITS TODO
	
	# install the conf.d and init.d scripts by SeeSchloss
	# those still need to be commented and need to have sane defaults
	exeinto /etc/init.d
	#newexe "${FILESDIR}"/mulog.init mulog
	newexe "${FILESDIR}"/museekd.init museekd
	
	insinto /etc/conf.d
	#newins "${FILESDIR}"/mulog.conf mulog
	newins "${FILESDIR}"/museekd.conf museekd
}
