ALTER TABLE cars_data ADD COLUMN model TEXT;
ALTER TABLE cars_data ADD COLUMN make TEXT;

UPDATE cars_data SET model = car_names.make, make = car_names.model
FROM car_names WHERE cars_data.id = car_names.makeid;

ALTER TABLE cars_data DROP CONSTRAINT cars_data_id_fkey;
DROP TABLE car_names;

CREATE TABLE maker_to_model (
  maker_id INTEGER REFERENCES car_makers(id),
  model_id INTEGER REFERENCES model_list(modelid)
);

DELETE FROM model_list WHERE maker NOT IN (SELECT id FROM car_makers);

INSERT INTO maker_to_model (maker_id, model_id)
SELECT maker, modelid FROM model_list;

ALTER TABLE model_list DROP COLUMN maker;

CREATE TABLE maker_to_car (
  maker_id INTEGER REFERENCES car_makers(id),
  car_id INTEGER REFERENCES cars_data(id)
);

INSERT INTO maker_to_car (maker_id, car_id)
SELECT m.id, d.id
FROM car_makers m JOIN cars_data d ON m.maker = d.make;

ALTER TABLE cars_data DROP COLUMN make;

CREATE TABLE maker_to_country (
  maker_id INTEGER REFERENCES car_makers(id),
  country_id INTEGER REFERENCES countries(countryid)
);

INSERT INTO maker_to_country
SELECT m.id, c.countryid
FROM car_makers m JOIN countries c ON m.country = c.countryname;

ALTER TABLE car_makers DROP COLUMN country;
