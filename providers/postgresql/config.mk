provider.name      = postgresql
provider.host     ?= localhost
provider.port     ?= 5432
provider.schema   ?= public
provider.user     ?= ${USER}
provider.password ?= PASSWORD
provider.cli       = $$(command -v psql)
provider.console   = PGPASSWORD=${password} $(provider.cli) --host=${host} --port=${port} --dbname=${schema} --username=${user}
