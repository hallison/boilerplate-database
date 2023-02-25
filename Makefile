## Datasource Toolkit
##
## _PROGRAM _VERSION (_RELEASE)
##
## prefix       : _PREFIX
## bindir       : _BINDIR
## sysconfdir   : _SYSCONFDIR
## libdir       : _LIBDIR
## datarootdir  : _DATAROOTDIR
## sharerootdir : _SHAREROOTDIR
## docdir       : _DOCDIR
## sourcedir    : _SOURCEDIR


.POSIX:
SHELL = /bin/sh

prefix       ?= /usr/local
bindir       ?= ${prefix}/bin
sysconfdir   ?= ${prefix}/etc
libdir       ?= ${prefix}/lib
datarootdir  ?= ${prefix}/share
sharerootdir ?= ${datarootdir}
docdir       ?= ${sharerootdir}/doc
sourcedir    ?= ${prefix}/src

testdir = test

pkg.name     = datasource-toolkit
pkg.version ?= $(shell git tag --list --sort=-refname | head -1 | tr -d [\n])
plg.release ?= $(shell git log ${version} --format='%cs' -1 | tr -d [\n])

source.name        = dstk
source.executables = bin/${source.name}
source.libraries   = $(shell ls lib/${source.name}/*.sh lib/${source.name}/commands/*.sh)
source.documents   = README.html README.pt-BR.html

target.executables 	= $(addprefix ${prefix}/,${source.executables})
target.libraries    = $(addprefix ${prefix}/,${source.libraries})
target.documents    = $(addprefix ${target.docdir}/,${source.documents})

target.bindir       ?= ${bindir}
target.sysconfdir   ?= ${sysconfdir}/${source.name}
target.libdir       ?= ${libdir}/${source.name}
target.datarootdir  ?= ${datarootdir}/${source.name}
target.sharerootdir ?= ${sharerootdir}/${source.name}
target.docdir       ?= ${docdir}/${source.name}
target.sourcedir    ?= ${sourcedir}/${source.name}

target.directories += ${prefix}
target.directories += ${target.bindir}
target.directories += ${target.libdir}
target.directories += ${target.sysconfdir}
target.directories += ${target.datarootdir}
target.directories += ${target.docdir}
target.directories += ${target.sourcedir}

test   ?= all
errors  = test.err

munge += m4
munge += -D_NAME="${pkg.name}"
munge += -D_VERSION="${pkg.version}"
munge += -D_RELEASE="${pkg.release}"
munge += -D_EXECUTABLE="${source.name}"
munge += -D_PREFIX="${prefix}"
munge += -D_BINDIR="${target.bindir}"
munge += -D_LIBDIR="${target.libdir}"
munge += -D_SYSCONFDIR="${target.sysconfdir}"
munge += -D_DATAROOTDIR="${target.datarootdir}"
munge += -D_SHAREROOTDIR="${target.sharerootdir}"
munge += -D_DOCDIR="${target.docdir}"
munge += -D_SOURCEDIR="${target.sourcedir}"

.SUFFIXES: .m4 .sh .err .md .html

.m4:
	${munge} ${<} > ${@}
	chmod a+x ${@}

.sh.err: 
	time -p sh -x ${<} ${test} 2> ${@}

.md.html:
	markdown ${<} > ${@}

help:
#? Show this message
	@sed -n -Ee 's/^(\w[^-].*):(.*)?/\n\1:/p' -Ee 's/^#\? (.*)/    \1/p' -Ee 's/\n//' -Ee 's/^## ?//p' Makefile | $(munge)
	@echo

check: $(errors)
#? Run tests

doc: README.html README.pt-BR.html
#? Build documentation

build:
#? Build main program

install: build --install-dirs --install-bins --install-libs --install-configs --install-docs
#? Build and install program and all resources

--install-dirs: ${directories}

--install-bins: ${executables}

--install-libs: ${libraries}

--install-configs: ${configs}

--install-docs: doc ${documents}

uninstall: --uninstall-bins --uninstall-configs --uninstall-libs --uninstall-docs
#? Uninstall program and all resources

--uninstall-bins:
	rm -f ${executables}

--uninstall-libs:
	rm -f ${libraries}

--uninstall-configs:
	rm -f ${configs}

--uninstall-docs:
	rm -f ${documents}

${executables} ${libraries} ${configs} ${documents}:
	@echo cp ${@F} ${@}

${directories}:
	@echo mkdir -p ${@}

clean:
#? Remove temporary files.
	rm -rf *.err
	rm -rf *.html
	rm -rf ${testdir}
#	rm -rf ${source.name}
