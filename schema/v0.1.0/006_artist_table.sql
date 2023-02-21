-- +++
create table if not exists artist (
  id int not null auto_increment
, creation_date timestamp not null
    default current_timestamp
, update_date timestamp
    default current_timestamp
, name varchar(256) not null
    comment 'Nome do artista.'
, birth_date date
    comment 'Data de nascimento do artista.'
, death_date date
    comment 'Data de falecimento/óbito do artista.'
, website_url varchar(256) not null
    comment 'URL do website do artista.'
, constraint artist_key
    primary key(id)
)
comment 'Tabelas dos artistas originais das artes usadas nos projetos de arte das capas e caixas.'
;
-- +++
-- ---
drop table artist;
-- ---
