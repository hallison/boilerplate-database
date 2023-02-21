-- +++
create table if not exists collection (
  id int not null auto_increment
, publisher_id int
, creation_date timestamp not null
    default current_timestamp
, update_date timestamp
    default current_timestamp
, title varchar(256) not null
    comment 'Título da coleção.'
, year year(4) not null
    comment 'Ano de lançamento da coleção.'
, constraint collection_key
    primary key(id)
, constraint collection_publisher_references
    foreign key(publisher_id)
    references publisher(id) on delete set null
)
comment 'Tabela de coleções para agregar itens colecionáveis.'
;
-- +++
-- ---
drop table collection;
-- ---
