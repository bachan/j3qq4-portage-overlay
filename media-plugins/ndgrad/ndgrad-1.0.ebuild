# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: ndgrad-1.0.ebuild 1391 2009-08-04 07:02:12Z casta $

inherit bibble-plugins

DESCRIPTION="ND Grad simulates a graduated neutral density filter."
HOMEPAGE="http://digitalarts.mindsocket.com.au/bibble/ndgrad/ndgrad.html"
SRC_URI="http://digitalarts.mindsocket.com.au/bibble/ndgrad/NDGrad-${PV}.zip"

KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="!media-plugins/gradpro"

PLUGINS=(
	"NDGrad/ND Grad.ui"
	"NDGrad/NDGrad.so"
)

bibble-plugins-qa
