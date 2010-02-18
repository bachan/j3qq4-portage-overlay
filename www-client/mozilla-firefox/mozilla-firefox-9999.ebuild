# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
WANT_AUTOCONF="2.1"

inherit flag-o-matic toolchain-funcs eutils mozconfig-3 makeedit multilib fdo-mime autotools mercurial

DESKTOP_PV="3.7pre"
EHG_REPO_URI="http://hg.mozilla.org/mozilla-central"

DESCRIPTION="Firefox Web Browser"
HOMEPAGE="http://www.mozilla.com/firefox"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
SLOT="0"
LICENSE="|| ( MPL-1.1 GPL-2 LGPL-2.1 )"

IUSE_INTERNAL="+pgo internal_cairo +internal_lcms +internal_nspr +internal_nss +internal_sqlite"
IUSE="${IUSE_INTERNAL} alsa bindist iceweasel java mozdevelop nosafebrowsing spell libnotify"

SRC_URI="iceweasel? ( mirror://gentoo/iceweasel-icons-3.0.tar.bz2 )"

RDEPEND=">=sys-devel/binutils-2.16.1
	x11-libs/pango[X]
	alsa? ( media-libs/alsa-lib )
	java? ( virtual/jre )
	spell? ( >=app-text/hunspell-1.2.6 )
	!internal_cairo? ( >=x11-libs/cairo-1.8.8[X] )
	!internal_lcms? ( >=media-libs/lcms-1.18 )
	!internal_nss? ( >=dev-libs/nss-3.12.3 )
	!internal_nspr? ( >=dev-libs/nspr-4.8 )
	!internal_sqlite? ( >=dev-db/sqlite-3.6.12 )
	!!www-client/${PN}-bin"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	libnotify? ( x11-libs/libnotify )
	java? ( dev-java/java-config )"

S="${WORKDIR}/mozilla-central"

# Needed by src_compile() and src_install().
# Would do in pkg_setup but that loses the export attribute, they
# become pure shell variables.
export BUILD_OFFICIAL=1
export MOZILLA_OFFICIAL=1

pkg_setup() {
	if ! use bindist && ! use iceweasel; then
		elog "You are enabling official branding. You may not redistribute this build"
		elog "to any users on your network or the internet. Doing so puts yourself into"
		elog "a legal problem with Mozilla Foundation"
		elog "You can disable it by emerging ${PN} _with_ the bindist USE-flag"
		echo ""
	fi

	if ! use internal_nss && ! use internal_nspr; then
		elog "You have disabled internal_nss and internal_nspr USE-flags,"
		elog "if you have not set this on puropse, note that USE=\"-*\" in your"
		elog "make.conf/use.conf is evil and removes all IUSE defaults. Get rid of it!"
		echo ""
	fi

	elog "If you should experience parallel build issues, please"
	elog "export DO_NOT_WANT_MP=true and try again before posting in our"
	elog "forums.gentoo.org support thread (the URL is shown during pkg_postinst)."
}

src_unpack() {
	mercurial_src_unpack

	if use iceweasel; then
		unpack iceweasel-icons-3.0.tar.bz2
		cp -r iceweaselicons/browser "${WORKDIR}"
	fi
}

src_prepare() {
	EPATCH_SUFFIX="patch" \
	EPATCH_FORCE="yes" \
	epatch "${FILESDIR}"/patches

	if use iceweasel; then
		# FIXME
		sed -i -e "s|Minefield|Iceweasel|" browser/locales/en-US/chrome/branding/brand.* \
			browser/branding/nightly/configure.sh
	fi

	eautoreconf

	cd js/src
	eautoreconf
}

src_configure() {
	MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"
	MEXTENSIONS="default"

	mozconfig_init
	mozconfig_config

	# It doesn't compile on alpha without this LDFLAGS
	use alpha && append-ldflags "-Wl,--no-relax"

	# --as-needed breaks us
	filter-ldflags "-Wl,--as-needed" "--as-needed"

	mozconfig_annotate '' --enable-extensions="${MEXTENSIONS}"
	mozconfig_annotate '' --disable-mailnews
	mozconfig_annotate '' --disable-necko-wifi
	mozconfig_annotate 'broken' --disable-crashreporter
	mozconfig_annotate '' --enable-image-encoder=all
	mozconfig_annotate '' --enable-canvas
	mozconfig_annotate '' --enable-oji --enable-mathml
	mozconfig_annotate 'places' --enable-storage --enable-places

	mozconfig_annotate '' --with-default-mozilla-five-home="${MOZILLA_FIVE_HOME}"

	# Use flags for internal parts
	if ! use internal_sqlite; then
		mozconfig_annotate '' --enable-system-sqlite
	else
		mozconfig_annotate '' --disable-system-sqlite
	fi

	if ! use internal_nspr; then
		mozconfig_annotate '' --with-system-nspr
	else
		mozconfig_annotate '' --without-system-nspr
	fi

	if ! use internal_nss; then
		mozconfig_annotate '' --with-system-nss
	else
		mozconfig_annotate '' --without-system-nss
	fi

	if ! use internal_lcms; then
		mozconfig_annotate '' --enable-system-lcms
	else
		mozconfig_annotate '' --disable-system-lcms
	fi

	if ! use internal_cairo; then
		mozconfig_annotate '' --enable-system-cairo
	else
		mozconfig_annotate '' --disable-system-cairo
	fi

	# General use flags
	if ! use bindist && ! use iceweasel; then
		mozconfig_annotate '' --enable-official-branding
	elif use bindist && ! use iceweasel; then
		mozconfig_annotate 'bindist' --with-branding=browser/branding/unofficial
	fi

	if use pgo; then
		mozconfig_annotate '' --enable-profile-guided-optimization
	else
		mozconfig_annotate '' --disable-profile-guided-optimization
	fi

	if use spell; then
		mozconfig_annotate '' --enable-system-hunspell
	else
		mozconfig_annotate '' --disable-system-hunspell
	fi

	if use nosafebrowsing; then
		mozconfig_annotate '' --disable-safe-browsing
	else
		mozconfig_annotate '' --enable-safe-browsing
	fi

	if use libnotify; then
		mozconfig_annotate '' --enable-libnotify
	else
		mozconfig_annotate '' --disable-libnotify
	fi

	if use alsa; then
		mozconfig_annotate '' --enable-wave --enable-ogg
	else
		mozconfig_annotate '' --disable-wave --disable-ogg
	fi

	# Finalize and report settings
	mozconfig_final

	if [[ $(gcc-major-version) -lt 4 ]]; then
		append-cxxflags -fno-stack-protector
	fi

	CC="$(tc-getCC)" CXX="$(tc-getCXX)" LD="$(tc-getLD)" \
	econf || die "econf failed"
}

src_compile() {
	[ "${DO_NOT_WANT_MP}" = "true" ] && jobs=-j1 || jobs=${MAKEOPTS}
	emake ${jobs} || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	rm "${D}"/usr/bin/${PN}

	cp "${FILESDIR}"/gentoo-default-prefs.js "${D}"${MOZILLA_FIVE_HOME}/defaults/pref/all-gentoo.js

	# Install icon and .desktop for menu entry
	if use iceweasel; then
		newicon "${S}"/browser/base/branding/icon48.png iceweasel-icon.png
		newmenu "${FILESDIR}"/icon/iceweasel.desktop \
			${PN}-${DESKTOP_PV}.desktop
	elif ! use bindist; then
		newicon "${S}"/other-licenses/branding/${PN}/content/icon48.png ${PN}-icon.png
		newmenu "${FILESDIR}"/icon/${PN}.desktop \
			${PN}-${DESKTOP_PV}.desktop
	else
		newicon "${S}"/browser/branding/unofficial/icon48.png ${PN}-icon-unbranded.png
		newmenu "${FILESDIR}"/icon/${PN}-unbranded.desktop \
			${PN}-${DESKTOP_PV}.desktop
	fi

	# Add StartupNotify=true bug 237317
	if use startup-notification; then
		echo "StartupNotify=true" >> "${D}"/usr/share/applications/${PN}-${DESKTOP_PV}.desktop
	fi

	# Create /usr/bin/firefox
	make_wrapper ${PN} "${MOZILLA_FIVE_HOME}/${PN}"

	# Plugins dir
	ln -s "${D}/usr/$(get_libdir)/{nsbrowser,${PN}}/plugins" \

	echo "MOZ_PLUGIN_PATH=/usr/$(get_libdir)/nsbrowser/plugins" > 66${PN}
	doenvd 66${PN}
}

pkg_postinst() {
	# Update mimedb for the new .desktop file
	fdo-mime_desktop_database_update

	echo
	elog "DO NOT report bugs to Gentoo's bugzilla"
	elog "See https://forums.gentoo.org/viewtopic-t-732395.html for support topic on Gentoo forums."
	echo
}
