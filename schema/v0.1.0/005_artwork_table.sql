-- +++
create table if not exists artwork (
  id int not null auto_increment
, artwork_type_id int
, collectible_id int
, creation_date timestamp not null
    default current_timestamp
, update_date timestamp
    default current_timestamp
, name varchar(256) not null
    comment 'Nome para identificação da caixa.'
, description varchar(1024)
    comment 'Descrição textual do projeto de arte.'
, download_link varchar(256) not null
    comment 'Link para download do arquivo.'
, constraint artwork_key
    primary key(id)
, constraint artwork_type_references
    foreign key(artwork_type_id)
    references artwork_type(id) on delete set null
, constraint artwork_collectible_references
    foreign key(collectible_id)
    references collectible(id) on delete set null
)
comment 'Arte gráfica das capas ou caixas relacionadas aos itens colecionáveis.'
;
-- +++
-- ---
drop table artwork;
-- ---
