ALTER TABLE singer ADD PRIMARY KEY (singer_id);
ALTER TABLE song ADD PRIMARY KEY (song_id);

CREATE TABLE singer_to_song (
  singer_id INTEGER REFERENCES singer(singer_id),
  song_id INTEGER REFERENCES song(song_id)
);

INSERT INTO singer_to_song (singer_id, song_id)
SELECT singer_id, song_id FROM song;

ALTER TABLE song DROP COLUMN singer_id;
