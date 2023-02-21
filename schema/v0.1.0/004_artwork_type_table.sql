-- +++
create table if not exists artwork_type (
  id int not null auto_increment
, creation_date timestamp not null
    default current_timestamp
, update_date timestamp
    default current_timestamp
, name varchar(256) not null
    comment 'Nome do tipo de projeto de arte.'
, description varchar(1024)
    comment 'Descrição textual do tipo de projeto de arte.'
, constraint artwork_type_key
    primary key(id)
)
comment 'Tabela de tipos de projetos de arte.'
;

insert into artwork_type values
  (default, default, default, 'Sobrecapa (Overlay)', 'Folha que se usa para proteger a capa de um livro, e na qual vêm impressos o nome do autor, o título etc.')
, (default, default, default, 'Caixa (Bookbox)', 'Caixa...')
, (default, default, default, 'Luva (Slipcase)', 'Caixa com 4 ou 5 laterais com abertura lateral.')
, (default, default, default, 'Suporte (Holder)', 'Porta revistas, suporte para revistas.')
;
-- +++
-- ---
drop table artwork_type;
-- ---
