function dstk-init { #: [PATH]
  #? Initialize Datasource Toolkit configurations.
  #? This command creates the ".dstkrc" file that will contain the variables
  #? that will be used by the "dstk" command.
  : ${1:-datasource}

  dstk_check_configuration && {
    echo "Datasource Toolkit has been initialized in directory '${DSTK_PATH}'."
    return 1
  }

  test -n "${1}" && {
    export DSTK_PATH="${1}"
    source "${DSTK_ENVIRONMENT}"
    echo "DSTK_PATH=${DSTK_PATH}" > "${DSTK_RC}"
  }

  printf "Directory ${DSTK_DATASOURCES_PATH} ... "
  mkdir -p "${DSTK_DATASOURCES_PATH}" && echo done

  printf "Directory ${DSTK_SCHEMA_PATH} ... "
  mkdir -p "${DSTK_SCHEMA_PATH}" && echo done

  echo "Datasource Toolkit has been initialized in directory '${DSTK_PATH}'."
  echo "To configure a datasource, run command 'config'."

  return 0
}
