# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit webapp eutils autotools confutils

DESCRIPTION="Web search engine software for intranet and internet servers."
HOMEPAGE="http://www.mnogosearch.org/"
SRC_URI="http://www.mnogosearch.org/Download/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
WEBAPP_MANUAL_SLOT="yes"
SLOT="0"

CONFUTILS_MISSING_DEPS="db2 interbase oci8 sapdb solid sybase"

DBFLAGS="db2 firebird freetds interbase iodbc mysql oci8 odbc postgres sapdb solid sqlite sqlite3 sybase"
EXPERIMENTAL_FLAGS="mysqlfulltext"
IUSE="${DBFLAGS} chasen cjk doc indexer mecab msoffice pdf readline ssl unicode zlib"

COMMON_DEPEND="chasen? ( app-text/chasen )
	firebird? ( dev-db/firebird )
	freetds? ( dev-db/freetds )
	iodbc? ( dev-db/libiodbc dev-db/unixODBC )
	mecab?  ( app-text/mecab )
	mysql? ( virtual/mysql )
	odbc? ( dev-db/unixODBC )
	postgres? ( dev-db/libpq )
	readline? ( sys-libs/readline )
	sqlite? ( =dev-db/sqlite-2* )
	sqlite3? ( =dev-db/sqlite-3* )
	ssl? ( dev-libs/openssl )
	zlib? ( sys-libs/zlib )"
	# mysqlfulltext ( >=virtual/mysql-5.1 )

DEPEND="${COMMON_DEPEND}
	doc? ( app-text/openjade app-text/docbook-sgml-utils )"

RDEPEND="${COMMON_DEPEND}
	msoffice? ( app-text/catdoc )
	pdf? ( virtual/ghostscript )
	virtual/httpd-cgi"

pkg_setup() {
	confutils_warn_about_missing_deps

	# only die on missing DB support if user actually requires indexing
	for i in ${DBFLAGS} ; do
		use ${i} && dbs_enabled="${dbs_enabled} ${i}"
	done

	if [[ -z ${dbs_enabled} ]] ; then
		if use indexer ; then
			confutils_require_any ${DBFLAGS}
		else
			ewarn
			ewarn "No database selected - indexing part will not be compiled!"
			ewarn "Add one or more of ${DBFLAGS} to your USE if you want this feature."
			ewarn
			ebeep
			epause 3
		fi
	fi

	webapp_pkg_setup
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-indexer.conf.patch

	# fix the documentation install path
	sed -i -e "s@/doc/@/share/doc/${PF}/html/@" doc/Makefile.{am,in} \
			|| die "sed failed on Makefile.{am,in}"

	# modify search.cgi to support vhosts
	sed -i -e 's@UdmStrdup(UDM_CONF_DIR)@UdmStrdup("../mnogosearch/")@' src/search.c \
		|| die "sed failed on search.c"

	# modify conf.c to support vhosts
	sed -i -e 's@UDM_CONF_DIR@"../mnogosearch/"@' src/conf.c \
		|| die "sed failed on conf.c"

	# enable external parser for MS Office Word and Excel documents
	if use msoffice ; then
		sed -i -e "s@^#Mime application/msword@Mime application/msword@" \
			-e "s@^#Mime application/vnd.ms-excel@Mime application/vnd.ms-excel@" \
			etc/indexer.conf-dist || die "sed failed on indexer.conf-dist"
	fi

	if use unicode ; then
		# modify indexer.conf for proper utf-8 display and indexing support
		sed -i -e '/^#Mime text\/x-postscript/s@text/plain@"text/plain; charset=utf-8"@' \
			-e '/^#Mime application\/pdf/s@text/plain@"text/plain; charset=utf-8"@' \
			-e "s@^#LocalCharset UTF-8@LocalCharset UTF-8@" \
			etc/indexer.conf-dist || die "sed failed on indexer.conf-dist"

		# modify search.htm for proper utf-8 display
		sed -i -e "/^LocalCharset/s@iso-8859-1@UTF-8@" \
			-e "/^BrowserCharset/s@iso-8859-1@UTF-8@" \
			etc/search.htm-dist || die "sed failed on search.htm-dist"
	fi

	# enable external parser for pdf and ps documents
	if use pdf ; then
		sed -i -e "s@^#Mime text/x-postscript@Mime text/x-postscript@" \
			-e "s@^#Mime application/pdf@Mime application/pdf@" \
			etc/indexer.conf-dist || die "sed failed on indexer.conf-dist"
	fi

	# rename the config files to provide a working default installation
	find "${S}/etc" -name 'Makefile.??' -exec sed -i -e "s@-dist@@" {} \; || die "sed -dist failed"
	for i in etc/*-dist ; do
		mv ${i} ${i/-dist/} || die "moving ${i} failed"
	done

	# and finally reconfigure now
	AT_M4DIR="build/m4" eautoreconf
}

src_compile() {
	econf \
		$(use_with chasen chasen /usr) \
		$(use_with cjk extra-charsets all) \
		$(use_with db2) \
		$(use_with doc docs) \
		$(use_with firebird ibase /opt) \
		$(use_with freetds freetds /usr) \
		$(use_with interbase ibase /opt) \
		$(use_with iodbc iodbc /usr) \
		$(use_with mecab) \
		$(use_with mysql) \
		$(use_with oci8 oracle8 ${ORACLE_HOME}) \
		$(use_with odbc unixODBC /usr) \
		$(use_with postgres pgsql /usr) \
		$(use_with readline) \
		$(use_with sapdb) \
		$(use_with solid) \
		$(use_with sqlite) \
		$(use_with sqlite3) \
		$(use_with sybase ctlib /opt) \
		$(use_with ssl openssl) \
		$(use_with zlib) \
		--datadir=/usr/share/${PN} \
		--sysconfdir=${MY_HOSTROOTDIR}/${PN} \
		--libdir=/usr/$(get_libdir)/${PN} \
		--includedir=/usr/include/${PN}

		# $(use_with mysqlfulltext mysql-fulltext-plugin ) \

	emake || die "compilation failed"
}

src_install() {
	webapp_src_preinst

	emake DESTDIR="${D}" install
	mv "${D}"/usr/bin/search.cgi ${D}/${MY_CGIBINDIR}

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt

	for CFG in $(find "${D}"/${MY_HOSTROOTDIR}/mnogosearch/*) ; do
		local configfile=${CFG/${D}/}
		webapp_configfile ${configfile}
	done

	webapp_src_install
}
