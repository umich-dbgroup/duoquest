CREATE TABLE state (
  id SERIAL PRIMARY KEY,
  state TEXT
);

INSERT INTO state (state)
SELECT DISTINCT state FROM area_code_state;

CREATE TABLE area_code_to_state (
  area_code_id INTEGER REFERENCES area_code_state(area_code),
  state_id INTEGER REFERENCES state(id)
);

INSERT INTO area_code_to_state (area_code_id, state_id)
SELECT a.area_code, s.id FROM area_code_state a
  JOIN state s ON a.state = s.state;

ALTER TABLE area_code_state DROP COLUMN state;

-- ALTER TABLE area_code_state ADD COLUMN area_code_value INTEGER;
--
-- UPDATE area_code_state
-- SET area_code_value = area_code;

CREATE TABLE votes_to_state (
  vote_id INTEGER REFERENCES votes(vote_id),
  state_id INTEGER REFERENCES state(id)
);

INSERT INTO votes_to_state (vote_id, state_id)
SELECT v.vote_id, s.id FROM votes v
  JOIN state s ON v.state = s.state;

ALTER TABLE votes DROP COLUMN state;
