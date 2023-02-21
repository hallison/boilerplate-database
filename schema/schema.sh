#? schema.sh
#?
#? Usage:
#?    bash schema.sh <PROVIDER> <COMMAND> <VERSION> [PATCH]
#?    bash schema.sh help
#?
#? Commands:
#?    help      Show this message.
#?    apply     Load and run schema version applying patches.
#?    revert    Load and run schema version reverting patches.
#?

set -e

unset CDPATH

parser=$(command -v m4)

function schema-migration_table {
  provider-runfile ${PROVIDER_CONFIG} ${PROVIDER_PATH}/schema_version_table.sql

  return ${?}
}

function schema-patch {
: ${1:?Apply (+) or revert (-) patch}
: ${2:?SQL file name}

  local statement=$(sed -run "/^-- [${1}]{3,}$/,/^-- [${1}]{3,}$/p" "${2}")

  provider-runcommand ${PROVIDER_CONFIG} "${statement};"

  return ${?}
}

function schema-is_patched {
: ${1:?Patch}

  local applied=$(provider-runcommand ${PROVIDER_CONFIG} "select version, patch from schema_version where version = '${VERSION}' and patch = ${1}")

  test -n "${applied}"
}

function schema-is_unpatched {
: ${1:?Patch}

  schema-is_patched ${1} && return 1 || return 0
}

function schema-last_patch {
  test -d ${SCHEMA_VERSION_PATH} || return 1
  basename $(ls ${SCHEMA_VERSION_PATH}/*.${PROVIDER}.sql | tail -1) | cut -c1-3
}

function schema-patch_file {
: ${1:?Patch}

  echo $(printf "${SCHEMA_VERSION_PATH}/%03d*.${PROVIDER}.sql" ${1})
}

function schema-insert_version {
: ${1:?Patch}

  provider-runcommand ${PROVIDER_CONFIG} "insert into schema_version values('${VERSION}', ${1}, default)"

  return ${?}
}

function schema-delete_version {
: ${1:?Patch}

  provider-runcommand ${PROVIDER_CONFIG} "delete from schema_version where version = '${VERSION}' and patch = ${1}"

  return ${?}
}

function command-usage {
  grep '^#?' $0 | cut -c4-

  return ${?}
}

function command-config {
: # ${1:?Version}
: # ${2:?Patch}

  local version="${1}"
  local patch="1"
  local config=${SCHEMA_PATH}/schema

  test -z "${version}" && {
    echo "Select version:"
    select version in $(find ${SCHEMA_PATH} -mindepth 1 -type d | cut -d/ -f2 | sort -V); do
      break
    done
  }

  ${parser} -D_VERSION="${version#v}" -D_PATCH=${2:-1} ${config}.m4 > ${config}.mk

  return  ${?}
}

function command-apply {
# ${1:?Patch}

  local last_patch=$(schema-last_patch)
  local patches=$(seq 1 +1 ${last_patch:--1})
  local file

  for patch in ${patches}; do
    file=$(schema-patch_file ${patch})

    printf "[+++] v${VERSION}.%03d %-63s" ${patch} $(basename ${file})
    test -f "${file}" && {
      schema-is_unpatched ${patch} && {
        schema-patch + ${file} && schema-insert_version ${patch} && {
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

  command-config ${VERSION} ${patch}

  return ${?}
}

function command-revert {
# ${1:?Patch}

  local last_patch=$(schema-last_patch)
  local patches=$(seq ${last_patch:-1} -1 1)
  local file

  for patch in ${patches}; do
    file=$(schema-patch_file ${patch})

    printf "[---] v${VERSION}.%03d %-63s" ${patch} $(basename ${file})
    test -f "${file}" && {
      schema-is_patched ${patch} && {
        schema-patch - ${file} && schema-delete_version ${patch} && {
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

  schema-config ${VERSION} ${patch}

  return 0
}

function command-bootstrap {
  provider-runfile ${SCHEMA_VERSION_PATH}.sql

  return ${?}
}

test ${1:-help} == 'help' && {
  command-usage && exit 0
}

: ${1:?Provider is required. Type 'help'.}
: ${2:?Command is required. Type 'help'.}
# ${3:?Schema version}

PROVIDER=${1}
COMMAND=command-${2}
VERSION=${3:-0.1.0}

export SCHEMA_PATH=$(dirname $0)
export SCHEMA_VERSION_PATH=${SCHEMA_PATH}/v${VERSION}
export PROVIDER_PATH=${SCHEMA_PATH}/../providers/${PROVIDER}
export PROVIDER_CONFIG=${PROVIDER_PATH}/provider.rc

source ${PROVIDER_PATH}/provider.sh

schema-migration_table

shift 2

${COMMAND} ${*}

# find db/schema/ -type d -iname v* -exec basename {} \; | tr -d 'v' | tr '.' ' ' | xargs printf "%03d.%03d.%03d\n" | sort
