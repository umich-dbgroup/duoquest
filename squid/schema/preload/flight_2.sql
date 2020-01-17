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
