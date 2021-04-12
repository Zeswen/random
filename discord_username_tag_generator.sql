CREATE TABLE "user" (
  id SERIAL PRIMARY KEY,
  username VARCHAR(30) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE "tag" (
  tag SMALLINT PRIMARY KEY CHECK (tag >= 1 AND tag <= 9999)
);

CREATE TABLE "user_tag" (
  id SERIAL PRIMARY KEY,
  user_id SERIAL NOT NULL UNIQUE REFERENCES "user"(id),
  username VARCHAR(30) NOT NULL,
  tag SMALLINT NOT NULL,
  UNIQUE(username, tag)
);

CREATE INDEX user_tag_username_idx ON "user_tag"(username);

INSERT INTO "tag" (tag) SELECT * FROM generate_series(1, 9999);

-- TESTS

BEGIN;

INSERT INTO "user" (id, username, email) VALUES (1, 'pepe', 'pepelol@gmail.com');
INSERT INTO "user" (id, username, email) VALUES (2, 'pepe', 'pepexd@gmail.com');
INSERT INTO "user" (id, username, email) VALUES (3, 'pepe', 'pepeomg@gmail.com');
INSERT INTO "user" (id, username, email) VALUES (4, 'pepe', 'pepewtf@gmail.com');
INSERT INTO "user" (id, username, email) VALUES (5, 'matt', 'matt@gmail.com');

INSERT INTO "user_tag" (user_id, username, tag) 
SELECT 1, 'pepe', t.tag
FROM "tag" t
WHERE t.tag  NOT IN (SELECT ut.tag FROM user_tag ut WHERE ut.username = 'pepe')
ORDER BY RANDOM()
LIMIT 1;

INSERT INTO "user_tag" (user_id, username, tag) 
SELECT 2, 'pepe', t.tag
FROM "tag" t
WHERE t.tag  NOT IN (SELECT ut.tag FROM user_tag ut WHERE ut.username = 'pepe')
ORDER BY RANDOM()
LIMIT 1;

INSERT INTO "user_tag" (user_id, username, tag) 
SELECT 3, 'pepe', t.tag
FROM "tag" t
WHERE t.tag  NOT IN (SELECT ut.tag FROM user_tag ut WHERE ut.username = 'pepe')
ORDER BY RANDOM()
LIMIT 1;

INSERT INTO "user_tag" (user_id, username, tag) 
SELECT 4, 'pepe', t.tag
FROM "tag" t
WHERE t.tag  NOT IN (SELECT ut.tag FROM user_tag ut WHERE ut.username = 'pepe')
ORDER BY RANDOM()
LIMIT 1;

INSERT INTO "user_tag" (user_id, username, tag) 
SELECT 5, 'matt', t.tag
FROM "tag" t
WHERE t.tag  NOT IN (SELECT ut.tag FROM user_tag ut WHERE ut.username = 'matt')
ORDER BY RANDOM()
LIMIT 1;

COMMIT;

-- QUERIES

SELECT u.id, u.email, u.username, LPAD(ut.tag::text, 4, '0') as tag FROM "user" u RIGHT JOIN user_tag ut ON u.id = ut.user_id;