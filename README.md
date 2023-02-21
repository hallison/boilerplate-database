Datasource Toolkit
==================

This project is a set of tools that helps to create database schemas and
migrations.

Basically, it is a set of scripts that configure the connection to the database, apply
and/or revert data migration migration through versions and patches using SQL files
with markups that will indicate should be what applied or removed.

## Installation

Considering the directory of local installation to local applications
(`/usr/local`), just run the command:

```sh
$ make install
```

## Database Supported

- PostegreSQL
- MySQL/MariaDB
