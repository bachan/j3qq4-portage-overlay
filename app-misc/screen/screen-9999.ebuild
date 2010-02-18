# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOCONF="2.5"

inherit eutils flag-o-matic toolchain-funcs pam autotools git

EGIT_REPO_URI="git://git.savannah.gnu.org/screen.git"
DESCRIPTION="A full-screen window manager that multiplexes a physical terminal between several processes"
HOMEPAGE="http://www.gnu.org/software/screen/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE="debug doc nethack pam selinux multiuser"

RDEPEND=">=sys-libs/ncurses-5.2
	pam? ( virtual/pam )
	selinux? (
		sec-policy/selinux-screen
		>=sec-policy/selinux-base-policy-20050821
	)"
DEPEND="${RDEPEND}
	doc? ( sys-apps/texinfo )"

S="${WORKDIR}/${PN}"

pkg_setup() {
	# Make sure utmp group exists, as it's used later on.
	enewgroup utmp 406
}

src_unpack() {
	git_src_unpack ${A}
	cd "${S}"/src

	# Bug 31070: configure problem which affects alpha
	# (13 Jan 2004 agriffis)
	epatch "${FILESDIR}"/screen-4.0.1-vsprintf.patch

	# uclibc doesnt have sys/stropts.h
	if ! (echo '#include <sys/stropts.h>' | $(tc-getCC) -E - &>/dev/null); then
		epatch "${FILESDIR}"/4.0.2-no-pty.patch
	fi

	# Don't use utempter even if it is found on the system
	epatch "${FILESDIR}"/4.0.2-no-utempter.patch

	# Don't link against libelf even if it is found on the system
	epatch "${FILESDIR}"/9999-no-libelf.patch

	# Fix manpage.
	sed -i \
		-e "s:/usr/local/etc/screenrc:/etc/screenrc:g" \
		-e "s:/usr/local/screens:/var/run/screen:g" \
		-e "s:/local/etc/screenrc:/etc/screenrc:g" \
		-e "s:/etc/utmp:/var/run/utmp:g" \
		-e "s:/local/screens/S-:/var/run/screen/S-:g" \
		doc/screen.1 \
		|| die "sed doc/screen.1 failed"

	eautoreconf
}

src_compile() {
	cd "${S}"/src

	append-flags "-DMAXWIN=${MAX_SCREEN_WINDOWS:-100}"
	use nethack || append-flags "-DNONETHACK"
	use debug && append-flags "-DDEBUG"

	econf \
		--with-socket-dir=/var/run/screen \
		--with-sys-screenrc=/etc/screenrc \
		--with-pty-mode=0620 \
		--with-pty-group=5 \
		--enable-rxvt_osc \
		--enable-telnet \
		--enable-colors256 \
		$(use_enable pam) \
		|| die "econf failed"

	# Second try to fix bug 12683, this time without changing term.h
	# The last try seemed to break screen at run-time.
	# (16 Jan 2003 agriffis)
	LC_ALL=POSIX make term.h || die "Failed making term.h"

	emake || die "emake failed"

	if use doc; then
		cd "${S}"/src/doc/
		make info || die "make info failed"
	fi
}

src_install() {
	cd "${S}"/src
	dobin screen || die "dobin failed"
	keepdir /var/run/screen || die "keepdir failed"

	if use multiuser; then
		fperms 4755 /usr/bin/screen || die "fperms failed"
	else
		fowners root:utmp /{usr/bin,var/run}/screen || die "fowners failed"
		fperms 2755 /usr/bin/screen || die "fperms failed"
	fi

	insinto /usr/share/screen
	doins terminfo/{screencap,screeninfo.src} || die "doins failed"
	insinto /usr/share/screen/utf8encodings
	doins utf8encodings/?? || die "doins failed"
	insinto /etc
	doins "${FILESDIR}"/screenrc || die "doins failed"

	pamd_mimic_system screen auth || die "pamd_mimic_system failed"

	dodoc \
		README ChangeLog INSTALL TODO NEWS* patchlevel.h \
		doc/{FAQ,README.DOTSCREEN,fdpat.ps,window_to_display.ps} \
		|| die "dodoc failed"

	doman doc/screen.1 || die "doman failed"

	if use doc; then
		doinfo doc/screen.info || die "doinfo failed"
	fi
}

pkg_postinst() {
	if use multiuser; then
		chown root:0 "${ROOT}"/var/run/screen
		chmod 0755 "${ROOT}"/var/run/screen
	else
		chown root:utmp "${ROOT}"/var/run/screen
		chmod 0775 "${ROOT}"/var/run/screen
	fi

		elog "Some dangerous key bindings have been removed or changed to more safe values."
		elog "We enable some xterm hacks in our default screenrc, which might break some"
		elog "applications. Please check /etc/screenrc for information on these changes."
}
