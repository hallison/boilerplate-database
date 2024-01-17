function dstk_doc_header {
  : ${1:?source}
  grep -e '^##' $@ | cut -c4-
}

function dstk_doc_markup {
  : ${1:?source}
  # To show header, use -Ee 's/^## ?//p'
  sed -n -Ee 's/^function dstk-(.*) \{( #:(.*))?/\n  \1\3/p' -Ee 's/^[ ]{0,}#\? ?(.*)/    \1/p' $@
}

function dstk_check_usage {
  : ${1:?command}

  test -n $1 && {
    printf "%s\n\n" "Command '${1#dstk-*}' not recognize"
  } || {
    dstk-help
  }
}

function dstk_check_configuration {
  test -z "${DATASOURCE_RC}" && return 1
  test -f "${DATASOURCE_RC}"
}

function dstk_check_datasource_enabled {
  test -z "${DATASOURCE_ENABLED}" && return 1
  test -f "${DATASOURCE_ENABLED}"
}

function dstk_set_datasource {
  : ${1:?datasource}

  dstk_check_datasource_enabled || return 1
  
  echo "${1} ${DSTK_REPOSITORY}" > "${DATASOURCE_ENABLED}"

  return 0
}

function dstk_all_repositories {
  test -z "${DSTK_REPOSITORIES_LIBDIR}" && return 1

  find ${DSTK_REPOSITORIES_LIBDIR} -mindepth 1 -type d | sed -nE 's/.*\/(.*)$/\1/p' | sort
}

function dstk_check_datasources_path {
  test -z "${DATASOURCE_PATH}" && return 1
  test -d "${DATASOURCE_PATH}"
}

function dstk_check_datasource {
  : ${1:-datasource}

  dstk_check_datasources_path && test -d "${DATASOURCE_PATH}/${1}"
}

function dstk_run {
  : ${1:-command}

  #- User configuration
  dstk_check_configuration && {
    source "${DATASOURCE_RC}"
    source "${DSTK_ENVIRONMENT}"
  }

  dstk_check_datasource_enabled && {
    read DSTK_DATASOURCE DSTK_REPOSITORY <"${DATASOURCE_ENABLED}"
  }

  local command_name="dstk-${1:-help}"
  local command_source="${DSTK_COMMANDS_LIBDIR}/${1:-help}.sh"

  shift 1

  test -f "${command_source}" && source "${command_source}"

  set -e

  command -v "${command_name}" > /dev/null && {
    ${command_name} $@
    return ${?}
  } || {
    dstk_check_usage "${command_name}"
    return 1
  }
}
