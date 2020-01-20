-- +++
create table if not exists schema_version (
  version       varchar(16) not null
, patch         smallint    not null
, creation_date timestamp   not null default current_timestamp
, constraint    schema_version_patch_unique unique(version, patch)
);
-- +++
