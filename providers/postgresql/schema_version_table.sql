-- +++
create table if not exists schema_version (
  version       varchar(16) constraint schema_version_required not null
, patch         smallint    constraint schema_patch_required not null
, creation_date timestamp   constraint schema_creation_date_required not null
                            constraint schema_creation_date_default  default current_timestamp
, constraint schema_version_patch_unique unique(version, patch)
);
-- +++
