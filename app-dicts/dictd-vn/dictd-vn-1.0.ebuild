# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit unpacker

DESCRIPTION="Vi/En dictionary for dict"
HOMEPAGE="http://lingvo.ru/"
SRC_URI="${P}.tar.gz"

LICENSE="AS-IS"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"

DEPEND=">=app-text/dictd-1.5.5"

S=${WORKDIR}

src_install() {
	insinto /usr/lib/dict
	doins ${P}/*
}
