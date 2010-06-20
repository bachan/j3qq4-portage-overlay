# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: bibble5-plugins.eclass 1619 2010-06-08 10:59:17Z casta $

#
# Original Author: Guillaume Castagnino <casta@xwing.info>
# Purpose: Manage dependancy and install for bibble plugins
#

inherit eutils multilib
EXPORT_FUNCTIONS pkg_nofetch pkg_setup src_install

LICENSE="bibblepro"
SLOT="0"

DEPEND="app-arch/unzip"
case ${EAPI:-0} in
	2|3|4)
		RDEPEND="|| (
			media-gfx/bibble5
			media-gfx/bibblepro-bin:5
		)"
		;;
	0|1)
		RDEPEND="|| (
			media-gfx/bibble5
			=media-gfx/bibblepro-bin-5*
		)"
		;;
esac

RESTRICT="strip"

QA_TEXTRELS=""

# @ECLASS-VARIABLE: PLUGINS
# @DESCRIPTION:
# This var must contain all the files to install

# @ECLASS-VARIABLE: MY_DOWNLOAD_URI
# @DESCRIPTION:
# This internal variable contains the fetch URI for the fetch-restricted plugins

# Private vars

# @ECLASS-VARIABLE: PLUGIN_SO_DIR
# @DESCRIPTION:
# This internal variable contains the path for all bibble plugins .so files
# Warning : must NOT contain the initial /
PLUGIN_SO_DIR=opt/bibble5pro/supportfiles/plugins/

# @ECLASS-VARIABLE: PLUGIN_UI_DIR
# @DESCRIPTION:
# This internal variable contains the path for all bibble plugins .ui files
# Warning : must NOT contain the initial /
PLUGIN_UI_DIR=opt/bibble5pro/supportfiles/tools/Plugins/

# Exported functions

# @FUNCTION: bibble5-plugins_pkg_nofetch
# @DESCRIPTION:
# This function is the default pkg_nofetch
bibble5-plugins_pkg_nofetch() {
	debug-print-function ${FUNCNAME} $*

	elog "Please first purchase and download ${PN} plugin from the site:"
	elog "${MY_DOWNLOAD_URI}"
	elog "then put the ${A} file in ${DISTDIR}"
}

# @FUNCTION: bibble5-plugins_pkg_setup
# @DESCRIPTION:
# Default pkg_setup function
bibble5-plugins_pkg_setup() {
	debug-print-function ${FUNCNAME} $*

	has_multilib_profile && ABI="x86"
}

# @FUNCTION: bibble5-plugins_src_install
# @DESCRIPTION:
# This function install the plugins refering to the files set into PLUGINS var
bibble5-plugins_src_install() {
	debug-print-function ${FUNCNAME} $*

	cd "${WORKDIR}"
	# list all plugins and install
	if [[ ${#PLUGINS[@]} -gt 1 ]]; then
		for x in "${PLUGINS[@]}"; do
			bibble5-plugins-install "${x}"
		done
	elif [[ -n "${PLUGINS}" ]]; then
		bibble5-plugins-install "${x}"
	else
		eerror "No plugin to install !"
	fi
}

# Other functions

# @FUNCTION: bibble5-plugins-fetch
# @USAGE: < Download URI >
# @DESCRIPTION:
# This function enable fetch restriction for bibble plugin
bibble5-plugins-fetch() {
	debug-print-function ${FUNCNAME} $*

	MY_DOWNLOAD_URI="$1"
	RESTRICT="${RESTRICT} fetch"
}

# @FUNCTION: bibble5-plugins-qa
# @DESCRIPTION:
# This function add the good QA_TEXTRELS to avoid warnings that can't be fixed
# due to non-PIC code (binary plugins, no source here)
# PLUGINS var must be set before calling this function
bibble5-plugins-qa() {
	debug-print-function ${FUNCNAME} $*
	
	# list all plugins and install
	if [[ ${#PLUGINS[@]} -gt 1 ]]; then
		for x in "${PLUGINS[@]}"; do
			if [ "${x##*.}" = "so" ]
			then
				SONAME=`basename "${x}"`
				QA_TEXTRELS="${QA_TEXTRELS} \
				${PLUGIN_SO_DIR}${SONAME}"
			fi
		done
	elif [[ -n "${PLUGINS}" ]]; then
		if [ "${PLUGINS##*.}" = "so" ]
		then
			SONAME=`basename "${PLUGINS}"`
			QA_TEXTRELS="${QA_TEXTRELS} \
			${PLUGIN_SO_DIR}${SONAME}"
		fi
	fi
}

# @FUNCTION: bibble5-plugins-block
# @USAGE: < USE flag >
# @DESCRIPTION:
# This function check if bibble is built with the specified USE flag and die if
# not with a standard notice
bibble5-plugins-block() {
	debug-print-function ${FUNCNAME} $*

	BLOCK_USE="$1"

	if ! has_version media-gfx/bibblepro-bin[${BLOCK_USE}]; then
		eerror "Please add '${BLOCK_USE}' to your USE flags, and re-emerge bibblepro-bin."
		die "bibblepro-bin needs ${BLOCK_USE} USE flag to avoid collisions"
	fi
}

# @FUNCTION: bibble5-plugins-install
# @USAGE: < list of .ui and .so files >
# @DESCRIPTION:
# This function installs all the provided .ui and .so files at the right
# location with the correct permissions
bibble5-plugins-install() {
	debug-print-function ${FUNCNAME} $*

	for fileName in "$@"
	do
		if [ "${fileName##*.}" = "ui" ]
		then
			insinto "${ROOT}/${PLUGIN_UI_DIR}"
			doins "${fileName}"
		elif [ "${fileName##*.}" = "so" ]
		then
			insinto "${ROOT}/${PLUGIN_SO_DIR}"
			# libs must be executable so that plugins works
			insopts -m0755
			doins "${fileName}"
		fi
	done
}

