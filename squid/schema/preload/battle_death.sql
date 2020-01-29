CREATE TABLE date_of_battle (
  id SERIAL PRIMARY KEY,
  date TEXT
);

CREATE TABLE battle_to_date (
  battle_id INTEGER REFERENCES battle(id),
  date_id INTEGER REFERENCES date_of_battle(id)
);

INSERT INTO date_of_battle (date)
SELECT DISTINCT date FROM battle;

INSERT INTO battle_to_date (date_id, battle_id)
SELECT d.id, b.id FROM battle b JOIN date_of_battle d ON b.date = d.date;

ALTER TABLE battle DROP COLUMN date;

CREATE TABLE result_of_battle (
  id SERIAL PRIMARY KEY,
  result TEXT
);

CREATE TABLE battle_to_result (
  battle_id INTEGER REFERENCES battle(id),
  result_id INTEGER REFERENCES result_of_battle(id)
);

INSERT INTO result_of_battle (result)
SELECT DISTINCT result FROM battle;

INSERT INTO battle_to_result (result_id, battle_id)
SELECT r.id, b.id FROM battle b JOIN result_of_battle r ON b.result = r.result;

ALTER TABLE battle DROP COLUMN result;
