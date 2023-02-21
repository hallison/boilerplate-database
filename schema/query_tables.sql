select tableowner
     , tablename
  from pg_tables
  inner join pg_database on pg_database.datname = pg_tables.tableowner
  where (tableowner = :database);
