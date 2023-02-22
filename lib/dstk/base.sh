function dstk_doc_header {
  grep -e '^##' $@ | cut -c4-
}

function dstk_doc_markup {
  # To show header, use -Ee 's/^## ?//p'
  sed -n -Ee 's/^function dstk-(.*) \{( #:(.*))?/\n  \1\3/p' -Ee 's/^[ ]{0,}#\? (.*)/\t\1/p' $@
}

function dstk_check_usage {
  : ${1:?command name}

  test -n $1 && {
    printf "%s\n\n" "Command '${1#dstk-*}' not recognize"
  } || {
    dstk-help
  }
}

function dstk_set_datasource {
  : ${1:?datasource}
  : ${2:?repository}

  echo "${1} ${2}" > .datasourcerc
}

function dstk_repositories_from {
  : ${1:?path to repositories}

  find ${1} -mindepth 1 -type d | sed -nE 's/.*\/(.*)$/\1/p' | sort
}

