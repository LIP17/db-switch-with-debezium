-- check publication
SELECT * FROM pg_publication;

-- check replication slot
SELECT * FROM pg_replication_slots;

-- create publication
CREATE PUBLICATION dbz_publication FOR ALL TABLES;

-- create replication slot
SELECT pg_create_logical_replication_slot('$SLOT_NAME', 'pgoutput');

-- check WAL level lagging
SELECT redo_lsn, slot_name,restart_lsn, round((redo_lsn-restart_lsn) / 1024 / 1024 / 1024, 2) AS GB_behind FROM pg_control_checkpoint(),pg_replication_slots;

-- create subscription
CREATE SUBSCRIPTION sub1 CONNECTION 'host=postgres-old port=5432 dbname=postgres password=postgres' PUBLICATION repl_subscription;

-- create users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL
);

-- insert X users
DO $$
DECLARE
  i INT;
  random_username TEXT;
BEGIN
  FOR i IN 1..200000 LOOP
    SELECT string_agg(chr((random()*(122-97)+97)::int), '') INTO random_username
    FROM generate_series(1, 10);

    INSERT INTO users (username) VALUES (random_username);
  END LOOP;
END $$;




