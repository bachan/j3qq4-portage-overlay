# Copyright 2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: deadbeef-0.4.1.ebuild 1617 2010-06-06 15:26:21Z casta $

EAPI="3"

inherit fdo-mime

DESCRIPTION="mp3/ogg/flac/sid/mod/nsf music player based on GTK2"
HOMEPAGE="http://deadbeef.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
LICENSE="|| ( GPL-2 LGPL-2.1 )"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+gtk +alsa ffmpeg pulseaudio +mad +vorbis +flac wavpack +sndfile cdda +hotkeys
	oss lastfm adplug ffap sid nullout +supereq vtx gme dumb +dbus +artwork curl"

RDEPEND="
	media-libs/libsamplerate
	gtk? ( x11-libs/gtk+:2 )
	alsa? ( media-libs/alsa-lib )
	ffmpeg? ( media-video/ffmpeg )
	pulseaudio? ( media-sound/pulseaudio )
	mad? ( media-libs/libmad )
	vorbis? ( media-libs/libvorbis  )
	flac? ( media-libs/flac )
	wavpack? ( media-sound/wavpack )
	sndfile? ( media-libs/libsndfile )
	cdda? ( dev-libs/libcdio media-libs/libcddb )
	lastfm? ( net-misc/curl )
	artwork? ( net-misc/curl )
	curl? ( net-misc/curl )
	dbus? ( sys-apps/dbus )
	"
DEPEND="${RDEPEND}"

src_configure() {
	my_config="$(use_enable gtk gtkui) \
		$(use_enable alsa) \
		$(use_enable ffmpeg) \
		$(use_enable pulseaudio pulse) \
		$(use_enable mad) \
		$(use_enable vorbis) \
		$(use_enable flac) \
		$(use_enable wavpack) \
		$(use_enable sndfile) \
		$(use_enable cdda) \
		$(use_enable hotkeys) \
		$(use_enable oss) \
		$(use_enable lastfm lfm) \
		$(use_enable adplug) \
		$(use_enable ffap) \
		$(use_enable sid) \
		$(use_enable nullout) \
		$(use_enable supereq) \
		$(use_enable vtx) \
		$(use_enable gme) \
		$(use_enable dumb) \
		$(use_enable dbus notify)"
	if use artwork ; then
		# artwork need vfs-curl plugin, we force it
		my_config="${my_config} \
			--enable-vfs-curl \
			$(use_enable artwork)"
	else
		my_config="${my_config} \
			$(use_enable curl vfs-curl) \
			$(use_enable artwork)"
	fi
	econf ${my_config} || die
}

src_install() {
	make DESTDIR="${D}" install || die
}
