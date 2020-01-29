ALTER TABLE students ALTER COLUMN date_first_registered TYPE text;
ALTER TABLE students ALTER COLUMN date_left TYPE text;
ALTER TABLE transcripts ALTER COLUMN transcript_date TYPE text;

CREATE TABLE addresses_line_2 (
  id SERIAL PRIMARY KEY,
  line_2 TEXT
);

CREATE TABLE addresses_to_line_2 (
  address_id INTEGER REFERENCES addresses(address_id),
  line_2_id INTEGER REFERENCES addresses_line_2(id)
);

INSERT INTO addresses_line_2 (line_2)
SELECT DISTINCT a.line_2 FROM addresses a;

INSERT INTO addresses_to_line_2 (address_id, line_2_id)
SELECT a.address_id, l.id
FROM addresses a JOIN addresses_line_2 l ON a.line_2 = l.line_2;

ALTER TABLE addresses DROP COLUMN line_2;

CREATE TABLE zip (
  id SERIAL PRIMARY KEY,
  zip TEXT
);

CREATE TABLE addresses_to_zip (
  address_id INTEGER REFERENCES addresses(address_id),
  zip_id INTEGER REFERENCES zip(id)
);

INSERT INTO zip (zip)
SELECT DISTINCT a.zip_postcode FROM addresses a;

INSERT INTO addresses_to_zip (address_id, zip_id)
SELECT a.address_id, z.id
FROM addresses a JOIN zip z ON a.zip_postcode = z.zip;

ALTER TABLE addresses DROP COLUMN zip_postcode;

CREATE TABLE course_description (
  id SERIAL PRIMARY KEY,
  description TEXT
);

CREATE TABLE course_to_description (
  course_id INTEGER REFERENCES courses(course_id),
  description_id INTEGER REFERENCES course_description(id)
);

INSERT INTO course_description (description)
SELECT DISTINCT course_description FROM courses;

INSERT INTO course_to_description (course_id, description_id)
SELECT s.course_id, d.id
FROM courses s JOIN course_description d
  ON s.course_description = d.description;

ALTER TABLE courses DROP COLUMN course_description;

CREATE TABLE section_description (
  id SERIAL PRIMARY KEY,
  description TEXT
);

CREATE TABLE section_to_description (
  section_id INTEGER REFERENCES sections(section_id),
  description_id INTEGER REFERENCES section_description(id)
);

INSERT INTO section_description (description)
SELECT DISTINCT section_description FROM sections;

INSERT INTO section_to_description (section_id, description_id)
SELECT s.section_id, d.id
FROM sections s JOIN section_description d
  ON s.section_description = d.description;

ALTER TABLE sections DROP COLUMN section_description;

CREATE TABLE department_description (
  id SERIAL PRIMARY KEY,
  description TEXT
);

CREATE TABLE department_to_description (
  department_id INTEGER REFERENCES departments(department_id),
  description_id INTEGER REFERENCES department_description(id)
);

INSERT INTO department_description (description)
SELECT DISTINCT department_description FROM departments;

INSERT INTO department_to_description (department_id, description_id)
SELECT p.department_id, d.id
FROM departments p JOIN department_description d
  ON p.department_description = d.description;

ALTER TABLE departments DROP COLUMN department_description;

CREATE TABLE student_last_name (
  id SERIAL PRIMARY KEY,
  last_name TEXT
);

CREATE TABLE student_to_last_name (
  student_id INTEGER REFERENCES students(student_id),
  last_name_id INTEGER REFERENCES student_last_name(id)
);

INSERT INTO student_last_name (last_name)
SELECT DISTINCT last_name FROM students;

INSERT INTO student_to_last_name (student_id, last_name_id)
SELECT s.student_id, n.id
FROM students s JOIN student_last_name n
  ON s.last_name = n.last_name;

ALTER TABLE students DROP COLUMN last_name;

CREATE TABLE student_middle_name (
  id SERIAL PRIMARY KEY,
  middle_name TEXT
);

CREATE TABLE student_to_middle_name (
  student_id INTEGER REFERENCES students(student_id),
  middle_name_id INTEGER REFERENCES student_middle_name(id)
);

INSERT INTO student_middle_name (middle_name)
SELECT DISTINCT middle_name FROM students;

INSERT INTO student_to_middle_name (student_id, middle_name_id)
SELECT s.student_id, n.id
FROM students s JOIN student_middle_name n
  ON s.middle_name = n.middle_name;

ALTER TABLE students DROP COLUMN middle_name;

CREATE TABLE student_cell_mobile_number (
  id SERIAL PRIMARY KEY,
  cell_mobile_number TEXT
);

CREATE TABLE student_to_cell_mobile_number (
  student_id INTEGER REFERENCES students(student_id),
  cell_mobile_number_id INTEGER REFERENCES student_cell_mobile_number(id)
);

INSERT INTO student_cell_mobile_number (cell_mobile_number)
SELECT DISTINCT cell_mobile_number FROM students;

INSERT INTO student_to_cell_mobile_number (student_id, cell_mobile_number_id)
SELECT s.student_id, n.id
FROM students s JOIN student_cell_mobile_number n
  ON s.cell_mobile_number = n.cell_mobile_number;

ALTER TABLE students DROP COLUMN cell_mobile_number;
