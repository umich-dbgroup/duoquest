ALTER TABLE people ADD PRIMARY KEY (people_id);
ALTER TABLE poker_player ADD PRIMARY KEY (Poker_Player_ID);

CREATE TABLE people_to_poker_player (
  people_id INTEGER REFERENCES people(people_id),
  poker_player_id INTEGER REFERENCES poker_player(Poker_Player_ID)
);

INSERT INTO people_to_poker_player (people_id, poker_player_id)
SELECT people_id, poker_player_id FROM poker_player;

ALTER TABLE poker_player DROP COLUMN people_id;
