ALTER TABLE dogs ALTER COLUMN date_of_birth TYPE text;
ALTER TABLE dogs ALTER COLUMN date_arrived TYPE text;
ALTER TABLE dogs ALTER COLUMN date_adopted TYPE text;
ALTER TABLE dogs ALTER COLUMN date_departed TYPE text;
ALTER TABLE treatments ALTER COLUMN date_of_treatment TYPE text;

CREATE TABLE owners_to_dogs (
  owner_id INTEGER REFERENCES owners(owner_id),
  dog_id INTEGER REFERENCES dogs(dog_id)
);

INSERT INTO owners_to_dogs (owner_id, dog_id)
SELECT owner_id, dog_id FROM dogs;

ALTER TABLE dogs DROP COLUMN owner_id;

ALTER TABLE breeds RENAME TO old_breeds;

CREATE TABLE breeds (
  breed_id SERIAL PRIMARY KEY,
  breed_code TEXT,
  breed_name TEXT
);

INSERT INTO breeds (breed_code, breed_name)
SELECT breed_code, breed_name FROM old_breeds;

CREATE TABLE dogs_to_breeds (
  dog_id INTEGER REFERENCES dogs(dog_id),
  breed_id INTEGER REFERENCES breeds(breed_id)
);

INSERT INTO dogs_to_breeds
SELECT d.dog_id, b.breed_id
FROM dogs d JOIN breeds b ON d.breed_code = b.breed_code;

ALTER TABLE dogs DROP COLUMN breed_code;
DROP TABLE old_breeds;

ALTER TABLE sizes RENAME TO old_sizes;

CREATE TABLE sizes (
  size_id SERIAL PRIMARY KEY,
  size_code TEXT,
  size_description TEXT
);

INSERT INTO sizes (size_code, size_description)
SELECT size_code, size_description FROM old_sizes;

CREATE TABLE dogs_to_sizes (
  dog_id INTEGER REFERENCES dogs(dog_id),
  size_id INTEGER REFERENCES sizes(size_id)
);

INSERT INTO dogs_to_sizes
SELECT d.dog_id, b.size_id
FROM dogs d JOIN sizes b ON d.size_code = b.size_code;

ALTER TABLE dogs DROP COLUMN size_code;
DROP TABLE old_sizes;

ALTER TABLE treatment_types RENAME TO old_treatment_types;

CREATE TABLE treatment_types (
  treatment_type_id SERIAL PRIMARY KEY,
  treatment_type_code TEXT,
  treatment_type_description TEXT
);

INSERT INTO treatment_types (treatment_type_code, treatment_type_description)
SELECT treatment_type_code, treatment_type_description FROM old_treatment_types;

ALTER TABLE treatments ADD COLUMN treatment_type_id INTEGER REFERENCES treatment_types(treatment_type_id);
UPDATE treatments SET treatment_type_id = treatment_types.treatment_type_id
FROM treatment_types
WHERE treatments.treatment_type_code = treatment_types.treatment_type_code;


ALTER TABLE treatments DROP COLUMN treatment_type_code;
DROP TABLE old_treatment_types;
