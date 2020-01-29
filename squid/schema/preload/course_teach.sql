ALTER TABLE course ADD PRIMARY KEY (course_id);
ALTER TABLE teacher ADD PRIMARY KEY (teacher_id);

CREATE TABLE teacher_age (
  id SERIAL PRIMARY KEY,
  age TEXT
);

INSERT INTO teacher_age (age)
SELECT DISTINCT age FROM teacher;

ALTER TABLE teacher ADD COLUMN age_id INTEGER REFERENCES teacher_age(id);

UPDATE teacher
SET age_id = teacher_age.id
FROM teacher_age
WHERE teacher.age = teacher_age.age;

ALTER TABLE teacher DROP COLUMN age;

CREATE TABLE teacher_hometown (
  id SERIAL PRIMARY KEY,
  hometown TEXT
);

INSERT INTO teacher_hometown (hometown)
SELECT DISTINCT hometown FROM teacher;

ALTER TABLE teacher ADD COLUMN hometown_id INTEGER REFERENCES teacher_hometown(id);

UPDATE teacher
SET hometown_id = teacher_hometown.id
FROM teacher_hometown
WHERE teacher.hometown = teacher_hometown.hometown;

ALTER TABLE teacher DROP COLUMN hometown;
