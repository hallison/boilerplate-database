# Defaults

name=mysql
host=localhost
port=3306
schema=${USER}
user=${USER}
password=PASSWORD
cli=$(command -v mysql)

function provider-console {
: = ${1:?Configurarion file}

  ${cli} --defaults-extra-file=${1}

  return ${?}
}

function provider-runcommand {
: = ${1:?Configurarion file}
: = ${2:?SQL statement}

  ${cli} --defaults-extra-file=${1} -s -e "${2}"

  return ${?}
}

function provider-runfile {
: = ${1:?Configuration file}
: = ${2:?SQL file}

  ${cli} --defaults-extra-file=${1} -s < "${2}"

  return ${?}
}
