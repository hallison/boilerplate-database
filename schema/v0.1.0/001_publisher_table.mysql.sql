-- +++
create table if not exists publisher (
  id integer primary key not null auto_increment
, creation_date timestamp not null
    default current_timestamp
, update_date timestamp
    default current_timestamp
, name varchar(256) not null
    comment 'Nome da distribuidora ou editora.'
, constraint publisher_key
    primary key(id)
)
comment 'Tabela de distribuidores ou editoras das coleções.'
;
-- +++
-- ---
drop table publisher;
-- ---
