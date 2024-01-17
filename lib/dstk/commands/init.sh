function dstk-init { #: [PATH]
  #? Initialize Datasource Toolkit configurations.
  #? This command creates the ".dstkrc" file that will contain the variables
  #? that will be used by the "dstk" command.
  : ${1:-datasource}

  dstk_check_configuration && {
    echo "Datasource Toolkit has been initialized in directory '${DATASOURCE_ROOT}'."
    return 1
  }

  test -n "${1}" && {
    export DATASOURCE_ROOT="${1}"
    source "${DSTK_ENVIRONMENT}"
    echo "DATASOURCE_ROOT=${DATASOURCE_ROOT}" > "${DATASOURCE_RC}"
  }

  printf "Directory ${DATASOURCE_PATH} ... "
  mkdir -p "${DATASOURCE_PATH}" && echo done

  printf "Directory ${DATASOURCE_SCHEMA_PATH} ... "
  mkdir -p "${DATASOURCE_SCHEMA_PATH}" && echo done

  echo "Datasource Toolkit has been initialized in directory '${DATASOURCE_ROOT}'."
  echo "To configure a datasource, run command 'config'."

  return 0
}
