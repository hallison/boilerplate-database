SHELL = /bin/bash

.SUFFIXES:

## Informations
name         = project
version     ?= 0.1.0
release     ?= $$(date +%F)
environment ?= development
debug       ?= true

## Macros
parse ?= m4
parse += -D_ENVIRONMENT='${environment}'
parse += -D_DEBUG='${debug}'

.SUFFIXES: .m4 .sh .ini .sql
.DEFAULT: help

## Includes
include db/schema.mk

.m4.sql .m4.rb:
	@$(parse) $(<) > $(@)

%.ini %.sh: %.m4
	@$(parse) $(<) > $(@)

#? Clean sources
#? $ make clean
clean: db.clean

help: db.help
	@grep '^#?' Makefile | cut -c4-
