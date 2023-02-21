-- +++
create table if not exists publisher (
  id integer constraint publisher_key primary key
             constraint publisher_key_required not null
, creation_date timestamp constraint publisher_creation_date_required not null
                          constraint publisher_creation_date_default default current_timestamp
, update_date timestamp constraint publisher_update_date_default default current_timestamp
, name varchar(256) constraint publisher_name_required not null
)
;

comment on table publisher is 'Tabela de distribuidores ou editoras das coleções.';
comment on column publisher.name is 'Nome da distribuidora ou editora.';
-- +++

-- ---
drop table publisher;
-- ---
