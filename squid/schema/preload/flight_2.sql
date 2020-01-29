ALTER TABLE airports ADD COLUMN airport_id SERIAL PRIMARY KEY;
ALTER TABLE flights ADD CONSTRAINT flights_airline_fk FOREIGN KEY (airline) REFERENCES airlines(uid);

UPDATE flights SET sourceairport = TRIM(sourceairport);
ALTER TABLE flights ADD COLUMN sourceairport_id INTEGER;
UPDATE flights AS f SET sourceairport_id = (SELECT a.airport_id FROM airports AS a WHERE a.airportcode = f.sourceairport);
ALTER TABLE flights DROP COLUMN sourceairport;
ALTER TABLE flights ADD CONSTRAINT flights_source_airport_fk FOREIGN KEY (sourceairport_id) REFERENCES airports(airport_id);

UPDATE flights SET destairport = TRIM(destairport);
ALTER TABLE flights ADD COLUMN destairport_id INTEGER;
UPDATE flights AS f SET destairport_id = (SELECT a.airport_id FROM airports AS a WHERE a.airportcode = f.destairport);
ALTER TABLE flights DROP COLUMN destairport;
ALTER TABLE flights ADD CONSTRAINT flights_dest_airport_fk FOREIGN KEY (destairport_id) REFERENCES airports(airport_id);

CREATE TABLE airline_country (
    id SERIAL PRIMARY KEY,
    name TEXT
);

CREATE TABLE airline_to_country (
    airline_id INTEGER REFERENCES airlines(uid),
    country_id INTEGER REFERENCES airline_country(id)
);

INSERT INTO airline_country (name)
SELECT DISTINCT country FROM airlines;

INSERT INTO airline_to_country (airline_id, country_id)
SELECT a.uid, c.id
FROM airlines a JOIN airline_country c ON a.country = c.name;

ALTER TABLE airlines DROP COLUMN country;

CREATE TABLE airline_abbrev (
  id SERIAL PRIMARY KEY,
  abbrev TEXT
);

CREATE TABLE airline_to_abbrev (
    airline_id INTEGER REFERENCES airlines(uid),
    abbrev_id INTEGER REFERENCES airline_abbrev(id)
);

INSERT INTO airline_abbrev (abbrev)
SELECT DISTINCT abbreviation FROM airlines;

INSERT INTO airline_to_abbrev (airline_id, abbrev_id)
SELECT a.uid, b.id
FROM airlines a JOIN airline_abbrev b ON a.abbreviation = b.abbrev;

ALTER TABLE airlines DROP COLUMN abbreviation;
