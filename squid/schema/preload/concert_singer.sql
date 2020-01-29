ALTER TABLE stadium ADD PRIMARY KEY (stadium_id);

ALTER TABLE singer ADD PRIMARY KEY (singer_id);
ALTER TABLE singer ALTER COLUMN is_male TYPE text;

ALTER TABLE concert ADD PRIMARY KEY (concert_id);
ALTER TABLE concert ALTER COLUMN stadium_id TYPE INTEGER USING stadium_id::integer;
ALTER TABLE ONLY concert ADD CONSTRAINT concert_stadium_id_fkey FOREIGN KEY (stadium_id) REFERENCES stadium(stadium_id);

ALTER TABLE singer_in_concert ALTER COLUMN singer_id TYPE INTEGER USING singer_id::integer;
ALTER TABLE ONLY singer_in_concert ADD CONSTRAINT singer_in_concert_singer_id_fkey FOREIGN KEY (singer_id) REFERENCES singer(singer_id);

CREATE TABLE country (
  id SERIAL PRIMARY KEY,
  name TEXT
);

CREATE TABLE singer_to_country (
  country_id INTEGER REFERENCES country(id),
  singer_id INTEGER REFERENCES singer(singer_id)
);

INSERT INTO country (name)
SELECT DISTINCT country FROM singer;

INSERT INTO singer_to_country (country_id, singer_id)
SELECT c.id, s.singer_id FROM country c JOIN singer s ON c.name = s.country;

ALTER TABLE singer DROP COLUMN country;
