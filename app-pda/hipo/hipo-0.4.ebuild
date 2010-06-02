# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit mono eutils

DESCRIPTION="Hipo is an application that allows you to manage the data of your iPod"
HOMEPAGE="http://www.gnome.org/~pvillavi/hipo/"
SRC_URI="http://ftp.gnome.org/pub/GNOME/sources/hipo/0.4/${P}.tar.bz2"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="
	>=dev-lang/mono-1.1.10
	>=dev-dotnet/gtk-sharp-2.10
	>=dev-dotnet/gnome-sharp-2.10
	>=dev-dotnet/glade-sharp-2.10
	>=dev-dotnet/ipod-sharp-0.6.2
	"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack "${A}"
}

src_compile() {
	econf $(use_enable doc docs) || die "econf failed"
	emake -j1 || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README
}
