ALTER TABLE show ALTER COLUMN if_first_show TYPE TEXT;

ALTER TABLE conductor ADD PRIMARY KEY (conductor_id);
ALTER TABLE orchestra ADD PRIMARY KEY (orchestra_id);
ALTER TABLE performance ADD PRIMARY KEY (performance_id);
ALTER TABLE show ADD PRIMARY KEY (show_id);

CREATE TABLE orchestra_to_conductor (
  orchestra_id INTEGER REFERENCES orchestra(orchestra_id),
  conductor_id INTEGER REFERENCES conductor(conductor_id)
);

INSERT INTO orchestra_to_conductor (orchestra_id, conductor_id)
SELECT orchestra_id, conductor_id FROM orchestra;

ALTER TABLE orchestra DROP COLUMN conductor_id;
