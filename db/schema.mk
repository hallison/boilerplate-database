included: .DEFAULT

## Configuration
##
## This configuration will be assign to db.configuration the file with all
## values to connect database
db.adapter    ?= mysql
db.host       ?= localhost
db.port       ?= 3306
db.name       ?= ${name}
db.user       ?= user
db.password   ?= password
db.connection ?=

parse ?= m4
parse += -D_DB_ADAPTER='${db.adapter}'
parse += -D_DB_USER='${db.user}'
parse += -D_DB_PASSWORD='${db.password}'
parse += -D_DB_HOST='${db.host}'
parse += -D_DB_PORT='${db.port}'
parse += -D_DB_NAME='${db.name}'

include db/schema.${db.adapter}.mk

#? Database console
#? $ make db.console
db.console: ${db.connection}
	$(db.cli)

#? Database schema patch migration
#? $ make db.schema [version=VERSION]
db.schema: db.schema.apply

#? $ make db.schema.<apply|revert> [version=VERSION] [patch=PATCH]
db.schema.apply db.schema.revert: ${db.connection}
	$(SHELL) db/schema.sh ${db.adapter} $(@:db.schema.%=%) ${version} ${patch}

#? $ make db.schema.bootstrap [version=VERSION]
db.schema.bootstrap: db.schema.apply
	$(SHELL) db/schema.sh ${db.adapter} $(@:db.schema.%=%) ${version}

#? Clean database resources
#? $ make db.schema.clean
db.clean: ${db.connection}
	rm -rf $(<)

db.help:
	@grep '^#?' db/schema.mk | cut -c4-
