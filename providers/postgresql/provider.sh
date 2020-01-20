# Defaults

name=postgresql
host=localhost
port=5432
schema=public
user=${USER}
password=PASSWORD
cli=$(command -v psql)

function provider-console {
: = ${1:?Configurarion file}

  source ${1} && ${cli}

  return ${?}
}

function provider-runcommand {
: = ${1:?Configurarion file}
: = ${2:?SQL statement}

  source ${1} && ${cli} -Anqt -c "${2}"

  return ${?}
}

function provider-runfile {
: = ${1:?Configuration file}
: = ${2:?SQL file}

  source ${1} && ${cli} -Anqt -f "${2}"

  return ${?}
}
