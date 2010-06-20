# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/
# This ebuild come with modification from Beber

EGIT_REPO_URI="rsync://git.xmms.se/xmms2/xmms2-devel.git/"
EGIT_PROJECT="xmms2-devel.git"

inherit eutils git

DESCRIPTION="X(cross)platform Music Multiplexing System. The new generation of the XMMS player."
HOMEPAGE="http://xmms2.xmms.org"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 amd64 sparc"
IUSE="mp3 vorbis sid python jack aac ruby musepack speex curl alsa flac modplug samba phonehome java mdns gnome oss ecore"

DEPEND=">=dev-lang/python-2.2.1
	>=dev-util/scons-0.96.1
	>=dev-libs/glib-2.6.0
	alsa? ( media-libs/alsa-lib )
	ecore? ( x11-libs/ecore )
	flac? ( media-libs/flac )
	mp3? ( media-sound/madplay )
	modplug? ( media-libs/libmodplug )
	>=dev-db/sqlite-3.2.6
	curl? ( >=net-misc/curl-7.11.2 )
	vorbis? ( media-libs/libvorbis )
	sid? ( media-sound/sidplay
		media-libs/resid )
	python? ( >=dev-python/pyrex-0.9.3.1
		    >=dev-lang/python-2.2.1 )
	jack? ( >=media-sound/jack-audio-connection-kit-0.100.0 )
	ruby? ( >=dev-lang/ruby-1.8 )
	aac? ( >=media-libs/faad2-2.0 )
	speex? ( media-libs/speex )
	musepack? ( media-libs/libmpcdec )
	samba? ( net-fs/samba )
	java? ( virtual/jdk )
	mdns? ( net-dns/avahi )
	gnome? ( gnome-base/gnome-vfs )"

src_compile() {
	local my_exc="dns_sd" # mdns with mDNSResponder make compilation fail on my computer
	use phonehome || my_exc="${my_exc} et"
	use ecore || my_exc="${my_exc} xmmsclient-ecore"
	use ruby || my_exc="${my_exc} ruby"
	use python || my_exc="${my_exc} python"
	use java || my_exc="${my_exc} java"
	use mdns || my_exc="${my_exc} mdns"
	use alsa || my_exc="${my_exc} alsa"
	use curl || my_exc="${my_exc} curl"
	use aac || my_exc="${my_exc} faad"
	use flac || my_exc="${my_exc} flac"
	use gnome || my_exc="${my_exc} gnomevfs"
	use vorbis || my_exc="${my_exc} ices"
	use jack || my_exc="${my_exc} jack"
	use mp3 || my_exc="${my_exc} mad"
	use modplug || my_exc="${my_exc} modplug"
	use musepack || my_exc="${my_exc} musepack"
	use oss || my_exc="${my_exc} oss"
	use samba || my_exc="${my_exc} samba"
	use sid || my_exc="${my_exc} sid"
	use speex || my_exc="${my_exc} speex"
	use vorbis || my_exc="${my_exc} vorbis"
	
	scons INSTALLDIR=${D} CONFIG=1 EXCLUDE="${my_exc}" PREFIX="/usr" ${MAKEOPTS} SYSCONFDIR="/etc" || die
}

src_install() {
	scons INSTALLDIR=${D} PREFIX="/usr" ${MAKEOPTS} SYSCONFDIR="/etc" install || die
	dodoc AUTHORS COPYING TODO README
}

