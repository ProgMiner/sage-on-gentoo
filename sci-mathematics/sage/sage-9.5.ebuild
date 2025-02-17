# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="readline,sqlite"
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit desktop distutils-r1 flag-o-matic multiprocessing prefix toolchain-funcs

MY_PN="sagemath-standard"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Math software for abstract and numerical computations"
HOMEPAGE="https://www.sagemath.org"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
KEYWORDS="~amd64 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

LICENSE="GPL-2"
SLOT="0"
SAGE_USE="bliss meataxe"
IUSE="debug +doc jmol latex testsuite X ${SAGE_USE}"

RESTRICT="test"

DEPEND="
	~dev-gap/gap-recommended-4.11.1
	dev-libs/gmp:0=
	>=dev-libs/mpc-1.1.0
	>=dev-libs/mpfr-4.0.0
	>=dev-libs/ntl-11.4.3:=
	>=dev-libs/ppl-1.1
	~dev-lisp/ecls-21.2.1
	~dev-python/cypari2-2.1.2[${PYTHON_USEDEP}]
	>=dev-python/cysignals-1.11.2[${PYTHON_USEDEP}]
	>=dev-python/cython-0.29.24[${PYTHON_USEDEP}]
	>=dev-python/docutils-0.12[${PYTHON_USEDEP}]
	dev-python/future[${PYTHON_USEDEP}]
	>=dev-python/gmpy-2.1.0_beta5[${PYTHON_USEDEP}]
	>=dev-python/ipykernel-4.6.0[${PYTHON_USEDEP}]
	>=dev-python/ipython-7.0.0[notebook,${PYTHON_USEDEP}]
	=dev-python/ipywidgets-7*[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.8[${PYTHON_USEDEP}]
	dev-python/jupyter_core[${PYTHON_USEDEP}]
	dev-python/jupyter_jsmol[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-3.3.1[${PYTHON_USEDEP}]
	dev-python/memory_allocator[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.16.1[${PYTHON_USEDEP}]
	>=dev-python/pkgconfig-1.2.2[${PYTHON_USEDEP}]
	~dev-python/pplpy-0.8.7:=[doc,${PYTHON_USEDEP}]
	dev-python/primecountpy[${PYTHON_USEDEP}]
	>=dev-python/psutil-4.4.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.11.0[${PYTHON_USEDEP}]
	>=dev-python/sphinx-4.0.2[${PYTHON_USEDEP}]
	=media-gfx/threejs-sage-extension-122-r1
	media-libs/gd[jpeg,png]
	media-libs/libpng:0=
	=sci-mathematics/arb-2.19*
	sci-mathematics/cliquer
	~sci-mathematics/eclib-20210625[flint]
	=sci-mathematics/flint-2.7*:=[ntl]
	~sci-mathematics/gap-4.11.1
	|| ( =sci-mathematics/giac-1.6.0* =sci-mathematics/giac-1.7.0* )
	>=sci-mathematics/glpk-5.0:0=[gmp]
	~sci-mathematics/gmp-ecm-7.0.4[-openmp]
	=sci-mathematics/lcalc-2.0*
	~sci-mathematics/lrcalc-1.2
	=sci-mathematics/pari-2.13*
	=sci-mathematics/planarity-3.0*
	>=sci-mathematics/ratpoints-2.1.3
	>=sci-mathematics/rw-0.7
	~sci-mathematics/sage_setup-${PV}[${PYTHON_USEDEP}]
	~sci-mathematics/singular-4.2.1_p3[readline]
	>=sci-libs/brial-1.2.5
	~sci-libs/givaro-4.1.1
	>=sci-libs/gsl-2.3
	>=sci-libs/iml-1.0.4
	sci-libs/libbraiding
	>=sci-libs/libhomfly-1.0.1
	>=sci-libs/linbox-1.6.3
	sci-libs/m4ri
	sci-libs/m4rie
	>=sci-libs/mpfi-1.5.2
	>=sci-libs/symmetrica-2.0-r3
	>=sci-libs/zn_poly-0.9
	>=sys-libs/readline-6.2
	sys-libs/zlib
	virtual/cblas
	www-misc/thebe

	bliss? ( >=sci-libs/bliss-0.73 )
	meataxe? ( sci-mathematics/shared_meataxe )
"
BDEPEND="app-portage/gentoolkit"

RDEPEND="
	${DEPEND}
	>=dev-lang/R-4.0.4
	>=dev-python/cvxopt-1.2.6[glpk,${PYTHON_USEDEP}]
	>=dev-python/fpylll-0.5.4[${PYTHON_USEDEP}]
	>=dev-python/mpmath-1.2.1[${PYTHON_USEDEP}]
	>=dev-python/networkx-2.6[${PYTHON_USEDEP}]
	>=dev-python/pexpect-4.2.1[${PYTHON_USEDEP}]
	>=dev-python/rpy-2.8.6[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.1.0[${PYTHON_USEDEP}]
	=dev-python/sympy-1.9*[${PYTHON_USEDEP}]
	media-gfx/tachyon[png]
	>=sci-libs/cddlib-094m[tools]
	>=sci-mathematics/cu2-20060223
	>=sci-mathematics/cubex-20060128
	>=sci-mathematics/dikcube-20070912
	>=sci-mathematics/ExportSageNB-3.3
	sci-mathematics/flintqs
	~sci-mathematics/gfan-0.6.2
	>=sci-mathematics/maxima-5.45.1-r3[ecls]
	>=sci-mathematics/mcube-20051209
	>=sci-mathematics/nauty-2.6.1
	>=sci-mathematics/optimal-20040603
	>=sci-mathematics/palp-2.1
	~sci-mathematics/sage-data-combinatorial_designs-20140630
	~sci-mathematics/sage-data-conway_polynomials-0.5
	~sci-mathematics/sage-data-elliptic_curves-0.8
	~sci-mathematics/sage-data-graphs-20210214
	~sci-mathematics/sage-data-polytopes_db-20170220
	!sci-mathematics/sage-notebook
	>=sci-mathematics/sympow-1.018.1
	www-servers/tornado

	jmol? ( sci-chemistry/sage-jmol-bin )
	latex? (
		~dev-tex/sagetex-3.5
		|| ( app-text/dvipng[truetype] media-gfx/imagemagick[png] )
	)
"

PDEPEND="doc? ( ~sci-mathematics/sage-doc-${PV} )"

CHECKREQS_DISK_BUILD="8G"

REQUIRED_USE="doc? ( jmol )
	testsuite? ( jmol )"

PATCHES=(
	"${FILESDIR}"/sphinx-4.3.patch
	"${FILESDIR}"/${PN}-9.2-env.patch
	"${FILESDIR}"/sage_exec-9.3.patch
	"${FILESDIR}"/${PN}-9.3-jupyter.patch
	"${FILESDIR}"/${PN}-9.3-forcejavatmp.patch
	"${FILESDIR}"/${PN}-9.5-neutering.patch
	"${FILESDIR}"/${PN}-9.5-distutils.patch
	"${FILESDIR}"/trac31626.patch
)

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	# needed since Ticket #14460
	tc-export CC
}

python_prepare_all() {
	distutils-r1_python_prepare_all

	# Turn on debugging capability if required
	if use debug ; then
		sed -i "s:SAGE_DEBUG=\"no\":SAGE_DEBUG=\"yes\":" bin/sage
	fi

	# sage is getting its own system to have scripts that can use either python2 or 3
	# This is of course dangerous and incompatible with Gentoo
	sed -e "s:sage-python:python:g" \
		-e "s:sage-system-python:python:" \
		-i bin/* \
			sage/ext_data/nbconvert/postprocess.py

	# Remove sage's package management system, git capabilities and associated tests.
	cp -f "${FILESDIR}"/${PN}-7.3-package.py sage/misc/package.py
	rm -f sage/misc/dist.py
	rm -rf sage/dev

	############################################################################
	# sage's configuration variables for Gentoo
	############################################################################

	# sage on gentoo environment variables
	cp -f "${FILESDIR}"/sage_conf.py-9.5 sage/sage_conf.py
	eprefixify sage/sage_conf.py
	# set the documentation location to the externally provided sage-doc package
	sed -i "s:@GENTOO_PORTAGE_PF@:sage-doc-${PV}:" sage/sage_conf.py
		# Fix finding pplpy documentation with intersphinx
	local pplpyver=`equery -q l -F '$name-$fullversion' pplpy:0`
	sed -i "s:@PPLY_DOC_VERS@:${pplpyver}:" sage/sage_conf.py
	# getting sage_conf from the right spot
	sed -i "s:sage_conf:sage.sage_conf:g" sage/env.py

	# Because lib doesn´t always point to lib64 the following line in cython.py
	# cause very verbose message from the linker in turn triggering doctest failures.
	sed -i "s:SAGE_LOCAL, \"lib\":SAGE_LOCAL, \"$(get_libdir)\":" \
		sage/misc/cython.py
}

python_configure_all() {
	export SAGE_VERSION=${PV}
	export SAGE_NUM_THREADS=$(makeopts_jobs)
}

python_configure() {
	# files are not built unless they are touched
	find sage -name "*pyx" -exec touch '{}' \; \
		|| die "failed to touch *pyx files"
}

python_install() {
	# Install cython debugging files if requested
	# They are now produced by default
	if ! use debug; then
		rm -rf build/lib/sage/cython_debug || \
			die "failed to remove cython debugging information."
	fi

	distutils-r1_python_install

	# Optimize lone postprocess.py script
	python_optimize "${D}/$(python_get_sitedir)/sage/ext_data/nbconvert"
}

python_install_all() {
	distutils-r1_python_install_all

	# install env files under /etc
	insinto /etc
	newins VERSION.txt sage-version.txt

	if use X ; then
		doicon "${S}"/sage/ext_data/notebook-ipython/logo.svg
		newmenu - sage-sage.desktop <<-EOF
			[Desktop Entry]
			Name=Sage Shell
			Type=Application
			Comment=Math software for abstract and numerical computations
			Exec=sage
			TryExec=sage
			Icon=sage
			Categories=Education;Science;Math;
			Terminal=true
		EOF
	fi

	insinto /usr/share/doc/"${PF}"
	newins LICENSE.txt COPYING.txt

	# install links for the jupyter kernel
	# We have to be careful of removing prefix if present
	PYTHON_SITEDIR=$(python_get_sitedir)
	dosym ../../../../../"${PYTHON_SITEDIR#${EPREFIX}}"/sage/ext_data/notebook-ipython/logo-64x64.png \
		/usr/share/jupyter/kernels/sagemath/logo-64x64.png
	dosym ../../../../../"${PYTHON_SITEDIR#${EPREFIX}}"/sage/ext_data/notebook-ipython/logo.svg \
		/usr/share/jupyter/kernels/sagemath/logo.svg
}

pkg_preinst() {
	# remove old sage source folder if present
	[[ -d "${ROOT}/usr/share/sage/src/sage" ]] \
		&& rm -rf "${ROOT}/usr/share/sage/src/sage"
	# remove old links if present
	rm -rf "${EROOT}"/usr/share/jupyter/kernels/sagemath/*
}

pkg_postinst() {
	einfo "If you use Sage's browser interface ('Sage Notebook') and experience"
	einfo "an 'Internal Server Error' you should append the following line to"
	einfo "your ~/.bashrc (replace firefox with your favorite browser and note"
	einfo "that in your case it WILL NOT WORK with xdg-open):"
	einfo ""
	einfo "  export SAGE_BROWSER=/usr/bin/firefox"
	einfo ""

	einfo "Vanilla Sage comes with the 'Standard' set of Sage Packages, i.e."
	einfo "those listed at: https://sagemath.org/packages/standard/ which are"
	einfo "installed now."
	einfo "There are also some packages of the 'Optional' set (which consists"
	einfo "of the these: https://sagemath.org/packages/optional/) available"
	einfo "which may be installed with portage as usual."

	einfo ""
	einfo "* Displaying plots *"
	einfo "if you want sage to display plots while working from a terminal,"
	einfo "you should make sure that matplotlib is installed with at least"
	einfo "one graphical backend such as gtk3 or qt5."

	if use testsuite ; then

	einfo ""
	einfo "To test Sage with 4 parallel processes run the following command:"
	einfo ""
	einfo "  sage -tp 4 --all"
	einfo ""
	einfo "Note that testing Sage may take more than an hour depending on your"
	einfo "processor(s). You _will_ see failures but many of them are harmless"
	einfo "such as version mismatches and numerical noise. Since Sage is"
	einfo "changing constantly we do not maintain an up-to-date list of known"
	einfo "failures."

	fi

	if ! use doc ; then
		ewarn "You haven't requested the documentation."
		ewarn "The html version of the sage manual won't be available in the sage notebook."
		ewarn "It can still be installed by building sage-doc[html] separately."
	fi

	einfo ""
	einfo "IF YOU EXPERIENCE PROBLEMS and wish to report them please use the"
	einfo "overlay's issue tracker at"
	einfo ""
	einfo "  https://github.com/cschwan/sage-on-gentoo/issues"
	einfo ""
	einfo "There we can react faster than on bugs.gentoo.org where bugs first"
	einfo "need to be assigned to the right person. Thank you!"
}
