-- +++
create table if not exists artwork_artist (
  artwork_id int not null
, artist_id int not null
, constraint artwork_artist_references
    foreign key(artwork_id)
    references artwork(id) on delete cascade
, constraint artist_artwork_references
    foreign key(artist_id)
    references artist(id) on delete cascade
)
comment 'Tabela de relacionamento entre os projetos de arte das capas e caixas e seus os artistas originais.'
;
-- +++
-- ---
drop table artwork_artist;
-- ---
