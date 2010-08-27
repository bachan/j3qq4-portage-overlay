# Copyright 2005 Portage-reloaded (Jedrzej Lisowski)

EAPI=2

MOD_DESC="Western Quake 3 Mod"
MOD_NAME="Western Quake 3"
MOD_DIR="westernq3"

inherit games games-mods

HOMEPAGE="http://www.westernquake3.net/"
SRC_URI="wq3_b22_full.zip"

LICENSE="Q3AEULA"
KEYWORDS="amd64 ~ppc x86"
IUSE="dedicated opengl"
