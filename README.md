Datasource Toolkit
==================

This project is a set of tools that helps to create database schemas and
migrations.

Basically, it is a set of scripts that configure the connection to the
database, apply and/or revert data migration through versions and patches using
SQL files with markups that will indicate should be what applied or removed.

## Installation

Considering the directory of local installation to local applications
(`/usr/local`), just run the command:

```sh
$ make install
```

For installation in another directory:

```sh
$ make install prefix=/my/directory
```

## Database Supported

- PostgreSQL
- MySQL/MariaDB

## Common Workflow

**Initialization**
: Basic setup for datasources settings.

**Configuration**
: Configuration of one or more datasources and respective repositories.

**Migration**
: After configuration, data migration control.
