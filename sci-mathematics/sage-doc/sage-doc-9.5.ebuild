# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="readline,sqlite"

inherit python-any-r1 multiprocessing

DESCRIPTION="Build the sage documentation"
HOMEPAGE="https://www.sagemath.org"
SRC_URI="https://github.com/sagemath/sage/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

LICENSE="GPL-2"
SLOT="0"
IUSE="doc-pdf"
L10N_USEDEP="l10n_en,"
LANGS="ca de es fr hu it ja pt ru tr"
for X in ${LANGS} ; do
	IUSE="${IUSE} l10n_${X}"
	L10N_USEDEP="${L10N_USEDEP}l10n_${X}?,"
done
L10N_USEDEP="${L10N_USEDEP%?}"

RESTRICT="mirror test"

BDEPEND="$(python_gen_any_dep "
	>=dev-python/sphinx-4.1.0[\${PYTHON_USEDEP}]
	~sci-mathematics/sage-${PV}[\${PYTHON_USEDEP},jmol]
	~sci-mathematics/sage_docbuild-${PV}[\${PYTHON_USEDEP}]
	")
	doc-pdf? ( app-text/texlive[extra,${L10N_USEDEP}] )"
RDEPEND=""

PATCHES=(
	"${FILESDIR}"/${PN}-9.5-neutering.patch
	"${FILESDIR}"/${PN}-9.5-makefile.patch
)

S="${WORKDIR}/sage-${PV}"

HTML_DOCS="${WORKDIR}/build_doc/html/*"

python_check_deps() {
	has_version ">=dev-python/sphinx-4.1.0[${PYTHON_USEDEP}]" &&
	has_version "~sci-mathematics/sage-${PV}[${PYTHON_USEDEP},jmol]" &&
	has_version "~sci-mathematics/sage_docbuild-${PV}[${PYTHON_USEDEP}]"
}

src_prepare(){
	einfo "bootstrapping the documentation - be patient"
	SAGE_ROOT="${S}" PATH="${S}/build/bin:${PATH}" src/doc/bootstrap || die "cannot bootstrap the documentation"

	# remove all the sources outside of src/doc to avoid interferences
	for object in src/* ; do
		if [ $object != "src/doc" ] ; then
			rm -rf $object || die "failed to remove $object"
		fi
	done

	default
}

src_configure(){
	export SAGE_DOC="${WORKDIR}"/build_doc
	export SAGE_DOC_SRC="${S}"/src/doc
	export SAGE_DOC_MATHJAX=yes
	export VARTEXFONTS="${T}"/fonts
	# try to fix random sphinx crash during the building of the documentation
	export MPLCONFIGDIR="${T}"/matplotlib
	# Avoid spurious message from the gtk backend by making sure it is never tried
	export MPLBACKEND=Agg
	local mylang="en "
	for lang in ${LANGS} ; do
		use l10n_$lang && mylang+="$lang "
	done
	export LANGUAGES="${mylang}"
}

src_compile(){
	cd src/doc

	# Needs to be created beforehand or it gets created as a file with the content of _static/plot_directive.css
	mkdir -p "${SAGE_DOC}"/html/en/reference/_static

	target="doc-html "

	if use doc-pdf ; then
		DOCS="${SAGE_DOC}/pdf"
		target="${target}doc-pdf"
	fi

	# Do not double quote target. We need spaces to be considered spaces and not part of a target name.
	emake ${target} PYTHON=${PYTHON}
}

src_install(){
	####################################
	# Prepare the documentation for installation
	####################################

	pushd "${WORKDIR}"
	# Prune _static folders
	cp -r build_doc/html/en/_static build_doc/html/ || die "failed to copy _static folder"
	for sdir in `find build_doc -name _static` ; do
		if [ $sdir != "build_doc/html/_static" ] ; then
			rm -rf $sdir || die "failed to remove $sdir"
			ln -rst ${sdir%_static} build_doc/html/_static
		fi
	done
	# Linking to local copy of mathjax folders rather than copying them
	for sobject in $(ls "${EPREFIX}"/usr/share/mathjax/) ; do
		rm -rf build_doc/html/_static/${sobject} \
			|| die "failed to remove mathjax object $sobject"
		ln -st build_doc/html/_static/ ../../../../mathjax/$sobject
	done
	# Work around for issue #402 until I understand where it comes from
	for pyfile in `find build_doc/html -name \*.py` ; do
		rm -rf "${pyfile}" || die "fail to to remove $pyfile"
		rm -rf "${pyfile/%.py/.pdf}" "${pyfile/%.py/.png}"
		rm -rf "${pyfile/%.py/.hires.png}" "${pyfile/%.py/.html}"
	done
	# prune .buildinfo files, those are internal to sphinx and are not used after building.
	find build_doc -name .buildinfo -delete || die "failed to prune buildinfo files"
	popd

	einstalldocs

	# Files needed for generating documentation on the fly
	docompress -x /usr/share/doc/"${PF}"/en /usr/share/doc/"${PF}"/common
	# necessary for sagedoc.py call to sphinxify.
	insinto /usr/share/doc/"${PF}"/common
	doins -r src/doc/common/themes

	dosym -r /usr/share/doc/"${PF}"/html/en /usr/share/jupyter/kernels/sagemath/doc
}
