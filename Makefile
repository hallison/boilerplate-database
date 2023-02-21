## Datasource Toolkit
## -------------------------------------------------------------------------------- 
## A set of scripts that configure the connection to the database, apply and/or
## revert data migration through versions and patches using SQL files
## with markups that will indicate should be what applied or removed
## -------------------------------------------------------------------------------- 

SHELL = /bin/bash

-include providers/provider.mk
-include schema/schema.mk

.DEFAULT: help

version ?= ${schema.version}
patch   ?= ${schema.patch}

default:: help
#?

provider: provider.config
#? Configure or alternate the provider connection

provider.config:
#? Configure provider connection
	$(SHELL) providers/provider.sh $(@:provider.%=%) ${provider.name}

provider.console:
#? Open onsole
	$(SHELL) providers/provider.sh $(@:provider.%=%) ${provider.name}

schema: provider schema.config
#? Configure or alternate the database schema patch migration

schema.config:
#? Configure provider connection
	$(SHELL) schema/schema.sh ${provider.name} $(@:schema.%=%)

schema.apply schema.revert: ${provider.config}
#? Apply or revert a schema version and/or patch
#? Arguments: [version=<VERSION>] [patch=<PATCH>]
	$(SHELL) schema/schema.sh ${provider.name} $(@:schema.%=%) ${version} ${patch}

schema.bootstrap: schema.apply
#? Bootstrap schema
#? Arguments: [version=<VERSION>]
	$(SHELL) schema/schema.sh ${provider.name} $(@:schema.%=%) ${version}

clean:
#? Clean database resources
	rm -rf providers/*/provider.rc
	rm -rf providers/provider.mk

help:
#? Show this message
	@sed -n -Ee 's/^(\w.*):(.*)?/\n\1:/p' -Ee 's/^#\? (.*)/\t\1/p' -Ee 's/\n//' -Ee 's/^## ?//p' Makefile
	@echo
