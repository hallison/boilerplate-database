#? provider.sh
#?
#? Usage:
#?    bash provider.sh <COMMAND>
#?
#? Commands:
#?    help      Show this message.
#?    config    Configure provider connection.
#?    console   Execute CLI to use console.
#?

set -e

unset CDPATH

export PROVIDERS_PATH=$(dirname $0)

parser=$(command -v m4)

function command-usage {
  grep '^#?' $0 | cut -c4-

  return ${?}
}

function command-config {
: # ${1:?Provider name to configure connection}

  local provider="${1}"
  local path=""
  local config="${PROVIDERS_PATH}/provider"

  test -z "${provider}" && {
    echo "Select provider:"
    select provider in $(find ${PROVIDERS_PATH} -mindepth 1 -type d | cut -d/ -f2); do
      break
    done
  }

  path=${PROVIDERS_PATH}/${provider}/provider

  test -f ${path}.rc || {
    source ${path}.sh

    read -erp "Host: "   -i ${host}   host
    read -erp "Port: "   -i ${port}   port
    read -erp "Schema: " -i ${schema} schema
    read -erp "User: "   -i ${user}   user
    read -esp "Password: " password
    echo

    ${parser} -D_HOST="${host}" -D_PORT="${port}" -D_SCHEMA="${schema}" -D_USER="${user}" -D_PASSWORD="${password}" ${path}.m4 > ${path}.rc
  }

  ${parser} -D_PROVIDER="${provider}" -D_RESOURCE="${path}.rc" ${config}.m4 > ${config}.mk

  return ${?}
}

function command-console {
: = ${1:?Provider name to connection}

  local provider=${PROVIDERS_PATH}/${1}/provider

  test -f ${provider}.rc || config ${1}

  source ${provider}.sh

  provider-console ${provider}.rc

  return ${?}
}

test ${1:-help} == 'help' && {
  command-usage && exit 0
}

: = ${1:?Command is required. Type 'help'.}

COMMAND=command-${1}

shift 1

${COMMAND} ${*}
