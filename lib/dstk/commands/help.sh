## dstk help
##
## SUMMARY
##   Show command message usage.
##
## USAGE
##   dstk help [COMMAND]

function dstk-help {
  #? Show usage message
  dstk_doc_header $0

  for command_file in ${DSTK_COMMANDS_LIBDIR}/*.sh; do
    dstk_doc_markup $command_file
  done
}

