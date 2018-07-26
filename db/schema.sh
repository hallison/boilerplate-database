#? db/schema.sh
#?
#? Usage:
#?    bash db/schema.sh <COMMAND> <VERSION> [PATCH]
#?
#? Commands:
#?    help      Show this message.
#?    apply     Load and run schema version applying patches.
#?    revert    Load and run schema version reverting patches.
#?

set -e

unset CDPATH

COMMAND=${1:?Command is required. Type 'help'.}
VERSION=${2:?Schema version}

export DATABASE_PATH=$(dirname $0)
export SCHEMA_PATH=${DATABASE_PATH}/schema
export SCHEMA_VERSION_PATH=${SCHEMA_PATH}/v${VERSION}

function schema__run_command {
  mysql --defaults-extra-file=${DATABASE_PATH}/connection.ini -s -e "${*}"

  return ${?}
}

function schema__run_file {
  : ${1:?SQL file}

  mysql --defaults-extra-file=${DATABASE_PATH}/connection.ini -s < "${1}"

  return ${?}
}

function schema__migration_table {
  schema__run_file ${SCHEMA_PATH}/version_table.sql

  return ${?}
}

function schema__patch {
  : ${1:?Apply (+) or revert (-) patch}
  : ${2:?SQL file name}
  local statement=$(sed -run "/^-- [${1}]{3,}$/,/^-- [${1}]{3,}$/p" "${2}")

  schema__run_command "${statement};"

  return ${?}
}

function schema__is_patched {
  : ${1:?Patch}
  local applied=$(schema__run_command "select version, patch from schema_version where version = '${VERSION}' and patch = ${1}")

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

function help {
  grep '^#?' $0 | cut -c4-
}

function apply {
  # ${1:?Patch}
  local last_patch=$(basename $(ls ${SCHEMA_VERSION_PATH}/*.sql | tail -1) | cut -c1-3)
  local patches=$(seq 1 +1 ${1:-${last_patch:-1}})
  local file

  for patch in ${patches}; do
    file=$(echo $(printf "${SCHEMA_VERSION_PATH}/%03d*.sql" ${patch}))

    printf "Applying v${VERSION}.%03d %s ... " ${patch} ${file}
    test -f "${file}" && {
      schema__is_unpatched ${patch} && {
        schema__patch + ${file} && schema__insert_version ${patch} && {
          echo done
        } || {
          echo fail
        }
      } || {
        echo skipped
      }
    } || {
      echo not found
    }
  done

  return 0
}

function revert {
  # ${1:?Patch}
  local last_patch=$(basename $(ls ${SCHEMA_VERSION_PATH}/*.sql | tail -1) | cut -c1-3)
  local patches=$(seq ${last_patch} -1 ${1:-1})
  local file

  for patch in ${patches}; do
    file=$(echo $(printf "${SCHEMA_VERSION_PATH}/%03d*.sql" ${patch}))

    printf "Reverting v${VERSION}.%03d %s ... " ${patch} $file
    test -f "${file}" && {
      schema__is_patched ${patch} && {
        schema__patch - ${file} && schema__delete_version ${patch} && {
          echo done
        } || {
          echo fail
        }
      } || {
        echo skipped
      }
    } || {
      echo not found
    }
  done

  return 0
}

schema__migration_table

shift 2

${COMMAND} ${*}
