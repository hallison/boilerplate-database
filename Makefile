SHELL = /bin/bash

-include providers/provider.mk

.DEFAULT: help

default:: help

#? Configure or alternate the provider connection
#? $ make provider
provider: provider.config

#? Configure provider connection
#? $ make provider.config
provider.config:
	$(SHELL) providers/provider.sh $(@:provider.%=%)

#? Database console
#? $ make provider.console
provider.console:
	$(SHELL) providers/provider.sh $(@:provider.%=%) ${provider.name}

#? Database schema patch migration
#? $ make schema [version=VERSION]
schema: schema.apply

#? $ make schema.<apply|revert> [version=VERSION] [patch=PATCH]
schema.apply schema.revert: ${provider.config}
	$(SHELL) schema/schema.sh ${provider.name} $(@:schema.%=%) ${version} ${patch}

#? $ make schema.bootstrap [version=VERSION]
schema.bootstrap: schema.apply
	$(SHELL) schema/schema.sh ${provider.name} $(@:schema.%=%) ${version}

#? Clean database resources
#? $ make schema.clean
clean:
	rm -rf providers/*/provider.rc

help:
	@grep '^#?' Makefile | cut -c4-
