# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus, additions by Oliver Schneider. For new version look here : http://gentoo.zugaina.org/
# This ebuild is a small modification of the official beep-media-player ebuild

ECVS_SERVER="cvs.sourceforge.net:/cvsroot/beepmp"
ECVS_MODULE="bmp"
ECVS_TOP_DIR="${DISTDIR}/cvs-src/${PN}"

IUSE="nls gnome mp3 oggvorbis alsa oss esd mmx old-eq"

inherit flag-o-matic eutils libtool cvs

MY_PN="bmp"
MY_P=bmp-${PV/_/}
S=${WORKDIR}/${ECVS_MODULE}

DESCRIPTION="Beep Media Player"
DESCRIPTION_FR="Beep Media Player"
HOMEPAGE="http://www.sosdg.org/~larne/w/BMP_Homepage"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~hppa ~mips ~ppc64 ~alpha ~ia64"

RDEPEND="app-arch/unzip
	>=x11-libs/gtk+-2.4
	>=x11-libs/pango-1.2
	>=gnome-base/libglade-2.3.1
	esd? ( >=media-sound/esound-0.2.30 )
	oggvorbis? ( >=media-libs/libvorbis-1.0 )
	alsa? ( >=media-libs/alsa-lib-1.0 )
	gnome? ( >=gnome-base/gconf-2.6.0 )
	mp3? ( media-libs/id3lib )
	!media-sound/beep-media-player"

DEPEND="${RDEPEND}
	nls? ( dev-util/intltool )"

src_compile() {
	if ! useq mp3; then
		ewarn "MP3 support is now optional and you have not enabled it."
	fi

	elibtoolize
	./autogen.sh	
        # Bug #42893
	replace-flags "-Os" "-O2"

	econf \
		--with-dev-dsp=/dev/sound/dsp \
		--with-dev-mixer=/dev/sound/mixer \
		--includedir=/usr/include/beep-media-player \
		`use_with old-eq xmms-eq` \
		`use_enable mmx simd` \
		`use_enable gnome gconf` \
		`use_enable oggvorbis vorbis` \
		`use_enable esd` \
		`use_enable mp3` \
		`use_enable nls` \
		`use_enable oss` \
		`use_enable alsa` \
		|| die

	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die

	insinto /usr/share/icons/hicolor/scalable/apps
	doins icons/bmp.svg

	insinto /usr/share/pixmaps
	doins beep/beep_logo.xpm

	dosym /usr/include/beep-media-player/bmp /usr/include/beep-media-player/xmms

	# XMMS skin symlinking; bug 70697
	for SKIN in /usr/share/xmms/Skins/* ; do
		dosym "$SKIN" /usr/share/bmp/Skins/
	done

	# Plugins want beep-config, this wasn't included
	# Note that this one has a special gentoo modification
	# to work with xmms-plugin.eclass
	dobin ${FILESDIR}/beep-config

	dodoc AUTHORS FAQ NEWS README TODO
}

pkg_postinst() {
	echo
	einfo "Your XMMS skins, if any, have been symlinked."
	einfo "MP3 support is now optional, you may want to enable the mp3 USE-flag."
	echo
}
