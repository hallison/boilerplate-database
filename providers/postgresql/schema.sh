cli=$(command -v psql)

function schema__run_command {
  source ${SCHEMA_PROVIDER_CONFIG} && ${cli} -Anqt -c "${1}"

  return ${?}
}

function schema__run_file {
  : ${1:?SQL file}

  source ${SCHEMA_PROVIDER_CONFIG} && ${cli} -Anqt -f "${1}"

  return ${?}
}
