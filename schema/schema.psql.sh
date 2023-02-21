export DATABASE_CONNECTION_FILE=${DATABASE_PATH}/connection.sh

function schema__run_command {
  source ${DATABASE_CONNECTION_FILE} && psql -Anqt -c "${1}"

  return ${?}
}

function schema__run_file {
  : ${1:?SQL file}

  source ${DATABASE_CONNECTION_FILE} && psql -Anqt -f "${1}"

  return ${?}
}

function schema__migration_table {
  schema__run_file ${SCHEMA_PATH}/schema_version_table.sql

  return ${?}
}

function schema__patch {
  : ${1:?Apply (+) or revert (-) patch}
  : ${2:?SQL file name}
  local statement="$(sed -run "/^-- [${1}]{3,}$/,/^-- [${1}]{3,}$/p" "${2}")"

  schema__run_command "${statement};"

  return ${?}
}

function schema__is_patched {
  : ${1:?Patch}
  local applied=$(schema__run_command $"select version, patch from schema_version where version = '${VERSION}' and patch = ${1}")

  test -n "${applied}"
}

function schema__is_unpatched {
  : ${1:?Patch}

  schema__is_patched ${1} && return 1 || return 0
}

function schema__insert_version {
  : ${1:?Patch}

  schema__run_command "insert into schema_version values('${VERSION}', ${1}, default)"

  return ${?}
}

function schema__delete_version {
  : ${1:?Patch}

  schema__run_command "delete from schema_version where version = '${VERSION}' and patch = ${1}"

  return ${?}
}
