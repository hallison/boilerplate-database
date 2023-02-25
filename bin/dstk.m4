#!/bin/bash
changecom()dnl
## Datasource Toolkit
## _EXECUTABLE _VERSION (_RELEASE)
##
## SUMMARY
##
##   A set of scripts that configure the connection to the database, apply
##   data migration through versions and patches using SQL files
##
## USAGE
##
##   _EXECUTABLE <COMMAND> [OPTIONS]
##
## COMMANDS

unset CDPATH

#- Runtime environment
export DSTK_LIBDIR=_LIBDIR
export DSTK_COMMANDS_LIBDIR=_LIBDIR/commands
export DSTK_REPOSITORIES_LIBDIR=_LIBDIR/repositories
export DSTK_ENVIRONMENT=_LIBDIR/environment.sh
export DSTK_BASE=_LIBDIR/base.sh

#- Environment
source "${DSTK_ENVIRONMENT}"
source "${DSTK_BASE}"

dstk_run ${@}

# vim: filetype=sh
