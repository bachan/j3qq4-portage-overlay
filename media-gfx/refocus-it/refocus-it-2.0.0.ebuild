# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

inherit eutils

DESCRIPTION="Iterative refocus GIMP plug-in."
HOMEPAGE="http://refocus-it.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~mips"
IUSE=""
RESTRICT="nomirror"
DEPEND=">=x11-libs/gtk+-2.4.4
	>=media-gfx/gimp-2.2.0"


src_install() {
    make install DESTDIR=${D} || die
}
