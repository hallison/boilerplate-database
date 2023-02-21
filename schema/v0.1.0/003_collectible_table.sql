-- +++
create table if not exists collectible (
  id int not null auto_increment
, collection_id int
, creation_date timestamp not null
    default current_timestamp
, update_date timestamp
    default current_timestamp
, title varchar(256) not null
    comment 'Título do colecionável.'
, width numeric(5,2) not null
    comment 'Largura da dimensão do colecionável.'
, height numeric(5,2) not null
    comment 'Altura da dimensão do colecionável.'
, depth numeric(5,2) not null
    comment 'Profundidade da dimensão do colecionável.'
, constraint collectible_key
    primary key(id)
, constraint collectible_collection_references
    foreign key(collection_id)
    references collection(id) on delete set null
)
comment 'Tabela de colecionáveis.'
;
-- +++
-- ---
drop table collectible;
-- ---
