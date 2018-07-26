SHELL = /bin/bash

include Buildfile

name = project
version ?= 0.1.0
release ?= $$(date +%F)
environment ?= development
debug ?= true

database_host ?= localhost
database_port ?= 3306
database_name ?= $(name)

munge  = m4
munge += -D_NAME='$(name)'
munge += -D_VERSION='$(version)'
munge += -D_RELEASE='$(release)'
munge += -D_ENVIRONMENT='$(environment)'
munge += -D_DATABASE_USER='$(database_user)'
munge += -D_DATABASE_PASSWORD='$(database_password)'
munge += -D_DATABASE_HOST='$(database_host)'
munge += -D_DATABASE_PORT='$(database_port)'
munge += -D_DATABASE_NAME='$(database_name)'
munge += -D_DEBUG='$(debug)'

.SUFFIXES: .m4 .ini .sql .rb

.m4.ini .m4.sql .m4.rb:
	@$(munge) $(<) > $(@)

all:: help

install: db.schema

#?
#? Database migration
#? $ make db.schema version=[VERSION]
db.schema: db.version.apply

#? $ make db.version.[apply|revert] patch=[PATCH]
db.version.apply db.version.revert: db/connection.ini
	$(SHELL) db/schema.sh $(@:db.version.%=%) $(version) $(patch)

#?
#? Clean sources
#? $ make clean
clean: db/connection.ini
	rm -rf $(<)

help:
	@grep '^#?' Makefile | cut -c4-
