create sequence status_sequencer
  increment by 1 start with 100;

create table if not exists status (
  id numeric(8,0)
    constraint status_key primary key
    default nextval('status_sequencer')
, parent_id numeric(8,0)
    constraint status_belongs_to_parent_status references status(id) on delete set null
, positive_id numeric(8,0)
    constraint status_belongs_to_positive_status references status(id) on delete set null
, negative_id numeric(8,0)
    constraint status_belongs_to_negative_status references status(id) on delete set null
, label varchar(64)
, name varchar(64)
    constraint status_name_required not null
, description varchar(256)
);

alter sequence status_sequencer owned by status.id;

comment on table status is 'Tabela de situações de processos.';
comment on column status.label is 'Rótulo de chamada/início da situação.';
comment on column status.nome is 'Nome da situação, quando necessário.';
comment on column status.description is 'Texto descritivo da situação, quando necessário.';
-- +++

-- ---
drop table status;
-- ---
