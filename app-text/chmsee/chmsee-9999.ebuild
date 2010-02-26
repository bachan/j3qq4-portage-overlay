# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils git

DESCRIPTION="HTML Help viewer for Unix/Linux"
HOMEPAGE="http://chmsee.googlecode.com"
SRC_URI=""
EGIT_REPO_URI="git://github.com/lidaobing/chmsee.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=">=dev-libs/glib-2.8:2
	dev-libs/libxml2
	>=gnome-base/libglade-2.4:2.0
	>=x11-libs/gtk+-2.8:2
	dev-libs/chmlib
	dev-libs/libgcrypt
	>=net-libs/xulrunner-1.9.1"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.37"

RESTRICT="mirror"
DOCS="NEWS* README* AUTHORS ChangeLog*"
