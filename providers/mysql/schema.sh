cli=$(command -v mysql)

function schema__run_command {
  ${cli} --defaults-extra-file=${SCHEMA_PROVIDER_CONFIG} -s -e "${*}"

  return ${?}
}

function schema__run_file {
  : ${1:?SQL file}

  ${myql} --defaults-extra-file=${SCHEMA_PROVIDER_CONFIG} -s < "${1}"

  return ${?}
}
