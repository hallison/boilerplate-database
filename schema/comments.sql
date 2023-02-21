select columns.table_schema as schema
     , columns.table_name as table
     , columns.column_name as column
     , comments.description
  from pg_catalog.pg_statio_all_tables as tables
  inner join pg_catalog.pg_description as comments on (comments.objoid = tables.relid)
  inner join information_schema.columns columns on (columns.objsubid = columns.ordinal_position and columns.table_schema = tables.schemaname and columns.table_name=tables.relname)
;
