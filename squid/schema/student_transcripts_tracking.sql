--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.16
-- Dumped by pg_dump version 9.6.16

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: _aggr_aoo_student_enrolment_degree_program_idtosemester_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_student_enrolment_degree_program_idtosemester_id (
    degree_program_id bigint,
    semester_id_aggr bigint[],
    count bigint
);


ALTER TABLE _aggr_aoo_student_enrolment_degree_program_idtosemester_id OWNER TO afariha;

--
-- Name: _aggr_aoo_student_enrolment_degree_program_idtostudent_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_student_enrolment_degree_program_idtostudent_id (
    degree_program_id bigint,
    student_id_aggr bigint[],
    count bigint
);


ALTER TABLE _aggr_aoo_student_enrolment_degree_program_idtostudent_id OWNER TO afariha;

--
-- Name: _aggr_aoo_student_enrolment_semester_idtodegree_program_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_student_enrolment_semester_idtodegree_program_id (
    semester_id bigint,
    degree_program_id_aggr bigint[],
    count bigint
);


ALTER TABLE _aggr_aoo_student_enrolment_semester_idtodegree_program_id OWNER TO afariha;

--
-- Name: _aggr_aoo_student_enrolment_semester_idtostudent_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_student_enrolment_semester_idtostudent_id (
    semester_id bigint,
    student_id_aggr bigint[],
    count bigint
);


ALTER TABLE _aggr_aoo_student_enrolment_semester_idtostudent_id OWNER TO afariha;

--
-- Name: _aggr_aoo_student_enrolment_student_idtodegree_program_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_student_enrolment_student_idtodegree_program_id (
    student_id bigint,
    degree_program_id_aggr bigint[],
    count bigint
);


ALTER TABLE _aggr_aoo_student_enrolment_student_idtodegree_program_id OWNER TO afariha;

--
-- Name: _aggr_aoo_student_enrolment_student_idtosemester_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_student_enrolment_student_idtosemester_id (
    student_id bigint,
    semester_id_aggr bigint[],
    count bigint
);


ALTER TABLE _aggr_aoo_student_enrolment_student_idtosemester_id OWNER TO afariha;

--
-- Name: _degree_programstocell_mobile_number; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _degree_programstocell_mobile_number (
    degree_programs_degree_program_id integer NOT NULL,
    cell_mobile_number text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _degree_programstocell_mobile_number OWNER TO afariha;

--
-- Name: _degree_programstodate_first_registered; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _degree_programstodate_first_registered (
    degree_programs_degree_program_id integer NOT NULL,
    date_first_registered integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _degree_programstodate_first_registered OWNER TO afariha;

--
-- Name: _degree_programstodate_left; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _degree_programstodate_left (
    degree_programs_degree_program_id integer NOT NULL,
    date_left integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _degree_programstodate_left OWNER TO afariha;

--
-- Name: _degree_programstoemail_address; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _degree_programstoemail_address (
    degree_programs_degree_program_id integer NOT NULL,
    email_address text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _degree_programstoemail_address OWNER TO afariha;

--
-- Name: _degree_programstolast_name; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _degree_programstolast_name (
    degree_programs_degree_program_id integer NOT NULL,
    last_name text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _degree_programstolast_name OWNER TO afariha;

--
-- Name: _degree_programstomiddle_name; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _degree_programstomiddle_name (
    degree_programs_degree_program_id integer NOT NULL,
    middle_name text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _degree_programstomiddle_name OWNER TO afariha;

--
-- Name: _degree_programstoother_details; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _degree_programstoother_details (
    degree_programs_degree_program_id integer NOT NULL,
    other_details text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _degree_programstoother_details OWNER TO afariha;

--
-- Name: _degree_programstoother_student_details; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _degree_programstoother_student_details (
    degree_programs_degree_program_id integer NOT NULL,
    other_student_details text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _degree_programstoother_student_details OWNER TO afariha;

--
-- Name: _degree_programstosemester_description; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _degree_programstosemester_description (
    degree_programs_degree_program_id integer NOT NULL,
    semester_description text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _degree_programstosemester_description OWNER TO afariha;

--
-- Name: _degree_programstossn; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _degree_programstossn (
    degree_programs_degree_program_id integer NOT NULL,
    ssn text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _degree_programstossn OWNER TO afariha;

--
-- Name: _invertedcolumnindex; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _invertedcolumnindex (
    word text,
    tabname text,
    colname text
);


ALTER TABLE _invertedcolumnindex OWNER TO afariha;

--
-- Name: _semesterstocell_mobile_number; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _semesterstocell_mobile_number (
    semesters_semester_id integer NOT NULL,
    cell_mobile_number text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _semesterstocell_mobile_number OWNER TO afariha;

--
-- Name: _semesterstodate_first_registered; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _semesterstodate_first_registered (
    semesters_semester_id integer NOT NULL,
    date_first_registered integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _semesterstodate_first_registered OWNER TO afariha;

--
-- Name: _semesterstodate_left; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _semesterstodate_left (
    semesters_semester_id integer NOT NULL,
    date_left integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _semesterstodate_left OWNER TO afariha;

--
-- Name: _semesterstodegree_summary_description; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _semesterstodegree_summary_description (
    semesters_semester_id integer NOT NULL,
    degree_summary_description text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _semesterstodegree_summary_description OWNER TO afariha;

--
-- Name: _semesterstoemail_address; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _semesterstoemail_address (
    semesters_semester_id integer NOT NULL,
    email_address text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _semesterstoemail_address OWNER TO afariha;

--
-- Name: _semesterstolast_name; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _semesterstolast_name (
    semesters_semester_id integer NOT NULL,
    last_name text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _semesterstolast_name OWNER TO afariha;

--
-- Name: _semesterstomiddle_name; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _semesterstomiddle_name (
    semesters_semester_id integer NOT NULL,
    middle_name text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _semesterstomiddle_name OWNER TO afariha;

--
-- Name: _semesterstoother_details; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _semesterstoother_details (
    semesters_semester_id integer NOT NULL,
    other_details text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _semesterstoother_details OWNER TO afariha;

--
-- Name: _semesterstoother_student_details; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _semesterstoother_student_details (
    semesters_semester_id integer NOT NULL,
    other_student_details text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _semesterstoother_student_details OWNER TO afariha;

--
-- Name: _semesterstossn; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _semesterstossn (
    semesters_semester_id integer NOT NULL,
    ssn text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _semesterstossn OWNER TO afariha;

--
-- Name: _studentstodegree_summary_description; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _studentstodegree_summary_description (
    students_student_id integer NOT NULL,
    degree_summary_description text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _studentstodegree_summary_description OWNER TO afariha;

--
-- Name: _studentstoother_details; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _studentstoother_details (
    students_student_id integer NOT NULL,
    other_details text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _studentstoother_details OWNER TO afariha;

--
-- Name: _studentstosemester_description; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _studentstosemester_description (
    students_student_id integer NOT NULL,
    semester_description text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _studentstosemester_description OWNER TO afariha;

--
-- Name: addresses; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE addresses (
    address_id bigint NOT NULL,
    line_1 text,
    line_2 text,
    line_3 text,
    city text,
    zip_postcode text,
    state_province_county text,
    country text,
    other_address_details text
);


ALTER TABLE addresses OWNER TO afariha;

--
-- Name: courses; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE courses (
    course_id bigint NOT NULL,
    course_name text,
    course_description text,
    other_details text
);


ALTER TABLE courses OWNER TO afariha;

--
-- Name: degree_programs; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE degree_programs (
    degree_program_id bigint NOT NULL,
    department_id bigint,
    degree_summary_name text,
    degree_summary_description text,
    other_details text
);


ALTER TABLE degree_programs OWNER TO afariha;

--
-- Name: departments; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE departments (
    department_id bigint NOT NULL,
    department_name text,
    department_description text,
    other_details text
);


ALTER TABLE departments OWNER TO afariha;

--
-- Name: sections; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE sections (
    section_id bigint NOT NULL,
    course_id bigint,
    section_name text,
    section_description text,
    other_details text
);


ALTER TABLE sections OWNER TO afariha;

--
-- Name: semesters; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE semesters (
    semester_id bigint NOT NULL,
    semester_name text,
    semester_description text,
    other_details text
);


ALTER TABLE semesters OWNER TO afariha;

--
-- Name: student_enrolment; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE student_enrolment (
    student_enrolment_id bigint NOT NULL,
    degree_program_id bigint,
    semester_id bigint,
    student_id bigint,
    other_details text
);


ALTER TABLE student_enrolment OWNER TO afariha;

--
-- Name: student_enrolment_courses; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE student_enrolment_courses (
    student_course_id bigint NOT NULL,
    course_id bigint,
    student_enrolment_id bigint
);


ALTER TABLE student_enrolment_courses OWNER TO afariha;

--
-- Name: students; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE students (
    student_id bigint NOT NULL,
    current_address_id bigint,
    permanent_address_id bigint,
    first_name text,
    middle_name text,
    last_name text,
    cell_mobile_number text,
    email_address text,
    ssn text,
    date_first_registered text,
    date_left text,
    other_student_details text
);


ALTER TABLE students OWNER TO afariha;

--
-- Name: transcript_contents; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE transcript_contents (
    student_course_id bigint,
    transcript_id bigint
);


ALTER TABLE transcript_contents OWNER TO afariha;

--
-- Name: transcripts; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE transcripts (
    transcript_id bigint NOT NULL,
    transcript_date text,
    other_details text
);


ALTER TABLE transcripts OWNER TO afariha;

--
-- Name: _invertedcolumnindex _invertedcolumnindex_word_tabname_colname_key; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _invertedcolumnindex
    ADD CONSTRAINT _invertedcolumnindex_word_tabname_colname_key UNIQUE (word, tabname, colname);


--
-- Name: addresses idx_44432_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT idx_44432_addresses_pkey PRIMARY KEY (address_id);


--
-- Name: courses idx_44438_courses_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY courses
    ADD CONSTRAINT idx_44438_courses_pkey PRIMARY KEY (course_id);


--
-- Name: departments idx_44444_departments_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY departments
    ADD CONSTRAINT idx_44444_departments_pkey PRIMARY KEY (department_id);


--
-- Name: degree_programs idx_44450_degree_programs_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY degree_programs
    ADD CONSTRAINT idx_44450_degree_programs_pkey PRIMARY KEY (degree_program_id);


--
-- Name: sections idx_44456_sections_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY sections
    ADD CONSTRAINT idx_44456_sections_pkey PRIMARY KEY (section_id);


--
-- Name: semesters idx_44462_semesters_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY semesters
    ADD CONSTRAINT idx_44462_semesters_pkey PRIMARY KEY (semester_id);


--
-- Name: students idx_44468_students_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY students
    ADD CONSTRAINT idx_44468_students_pkey PRIMARY KEY (student_id);


--
-- Name: student_enrolment idx_44474_student_enrolment_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY student_enrolment
    ADD CONSTRAINT idx_44474_student_enrolment_pkey PRIMARY KEY (student_enrolment_id);


--
-- Name: student_enrolment_courses idx_44480_student_enrolment_courses_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY student_enrolment_courses
    ADD CONSTRAINT idx_44480_student_enrolment_courses_pkey PRIMARY KEY (student_course_id);


--
-- Name: transcripts idx_44483_transcripts_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY transcripts
    ADD CONSTRAINT idx_44483_transcripts_pkey PRIMARY KEY (transcript_id);


--
-- Name: _aggr_aoo_student_enrolment_degree_program_idtosemester_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_student_enrolment_degree_program_idtosemester_id_idx ON _aggr_aoo_student_enrolment_degree_program_idtosemester_id USING btree (degree_program_id);


--
-- Name: _aggr_aoo_student_enrolment_degree_program_idtostudent_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_student_enrolment_degree_program_idtostudent_id_idx ON _aggr_aoo_student_enrolment_degree_program_idtostudent_id USING btree (degree_program_id);


--
-- Name: _aggr_aoo_student_enrolment_semester_idtodegree_program_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_student_enrolment_semester_idtodegree_program_id_idx ON _aggr_aoo_student_enrolment_semester_idtodegree_program_id USING btree (semester_id);


--
-- Name: _aggr_aoo_student_enrolment_semester_idtostudent_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_student_enrolment_semester_idtostudent_id_idx ON _aggr_aoo_student_enrolment_semester_idtostudent_id USING btree (semester_id);


--
-- Name: _aggr_aoo_student_enrolment_student_idtodegree_program_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_student_enrolment_student_idtodegree_program_id_idx ON _aggr_aoo_student_enrolment_student_idtodegree_program_id USING btree (student_id);


--
-- Name: _aggr_aoo_student_enrolment_student_idtosemester_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_student_enrolment_student_idtosemester_id_idx ON _aggr_aoo_student_enrolment_student_idtosemester_id USING btree (student_id);


--
-- Name: _degree_programstocell_mobile_number_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _degree_programstocell_mobile_number_idx ON _degree_programstocell_mobile_number USING btree (cell_mobile_number, freq);

ALTER TABLE _degree_programstocell_mobile_number CLUSTER ON _degree_programstocell_mobile_number_idx;


--
-- Name: _degree_programstocell_mobile_number_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _degree_programstocell_mobile_number_idx_2 ON _degree_programstocell_mobile_number USING btree (degree_programs_degree_program_id);


--
-- Name: _degree_programstodate_first_registered_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _degree_programstodate_first_registered_idx ON _degree_programstodate_first_registered USING btree (date_first_registered, freq);

ALTER TABLE _degree_programstodate_first_registered CLUSTER ON _degree_programstodate_first_registered_idx;


--
-- Name: _degree_programstodate_first_registered_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _degree_programstodate_first_registered_idx_2 ON _degree_programstodate_first_registered USING btree (degree_programs_degree_program_id);


--
-- Name: _degree_programstodate_left_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _degree_programstodate_left_idx ON _degree_programstodate_left USING btree (date_left, freq);

ALTER TABLE _degree_programstodate_left CLUSTER ON _degree_programstodate_left_idx;


--
-- Name: _degree_programstodate_left_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _degree_programstodate_left_idx_2 ON _degree_programstodate_left USING btree (degree_programs_degree_program_id);


--
-- Name: _degree_programstoemail_address_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _degree_programstoemail_address_idx ON _degree_programstoemail_address USING btree (email_address, freq);

ALTER TABLE _degree_programstoemail_address CLUSTER ON _degree_programstoemail_address_idx;


--
-- Name: _degree_programstoemail_address_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _degree_programstoemail_address_idx_2 ON _degree_programstoemail_address USING btree (degree_programs_degree_program_id);


--
-- Name: _degree_programstolast_name_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _degree_programstolast_name_idx ON _degree_programstolast_name USING btree (last_name, freq);

ALTER TABLE _degree_programstolast_name CLUSTER ON _degree_programstolast_name_idx;


--
-- Name: _degree_programstolast_name_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _degree_programstolast_name_idx_2 ON _degree_programstolast_name USING btree (degree_programs_degree_program_id);


--
-- Name: _degree_programstomiddle_name_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _degree_programstomiddle_name_idx ON _degree_programstomiddle_name USING btree (middle_name, freq);

ALTER TABLE _degree_programstomiddle_name CLUSTER ON _degree_programstomiddle_name_idx;


--
-- Name: _degree_programstomiddle_name_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _degree_programstomiddle_name_idx_2 ON _degree_programstomiddle_name USING btree (degree_programs_degree_program_id);


--
-- Name: _degree_programstoother_details_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _degree_programstoother_details_idx ON _degree_programstoother_details USING btree (other_details, freq);

ALTER TABLE _degree_programstoother_details CLUSTER ON _degree_programstoother_details_idx;


--
-- Name: _degree_programstoother_details_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _degree_programstoother_details_idx_2 ON _degree_programstoother_details USING btree (degree_programs_degree_program_id);


--
-- Name: _degree_programstoother_student_details_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _degree_programstoother_student_details_idx ON _degree_programstoother_student_details USING btree (other_student_details, freq);

ALTER TABLE _degree_programstoother_student_details CLUSTER ON _degree_programstoother_student_details_idx;


--
-- Name: _degree_programstoother_student_details_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _degree_programstoother_student_details_idx_2 ON _degree_programstoother_student_details USING btree (degree_programs_degree_program_id);


--
-- Name: _degree_programstosemester_description_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _degree_programstosemester_description_idx ON _degree_programstosemester_description USING btree (semester_description, freq);

ALTER TABLE _degree_programstosemester_description CLUSTER ON _degree_programstosemester_description_idx;


--
-- Name: _degree_programstosemester_description_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _degree_programstosemester_description_idx_2 ON _degree_programstosemester_description USING btree (degree_programs_degree_program_id);


--
-- Name: _degree_programstossn_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _degree_programstossn_idx ON _degree_programstossn USING btree (ssn, freq);

ALTER TABLE _degree_programstossn CLUSTER ON _degree_programstossn_idx;


--
-- Name: _degree_programstossn_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _degree_programstossn_idx_2 ON _degree_programstossn USING btree (degree_programs_degree_program_id);


--
-- Name: _invertedcolumnindex_word_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _invertedcolumnindex_word_idx ON _invertedcolumnindex USING btree (word);

ALTER TABLE _invertedcolumnindex CLUSTER ON _invertedcolumnindex_word_idx;


--
-- Name: _semesterstocell_mobile_number_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _semesterstocell_mobile_number_idx ON _semesterstocell_mobile_number USING btree (cell_mobile_number, freq);

ALTER TABLE _semesterstocell_mobile_number CLUSTER ON _semesterstocell_mobile_number_idx;


--
-- Name: _semesterstocell_mobile_number_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _semesterstocell_mobile_number_idx_2 ON _semesterstocell_mobile_number USING btree (semesters_semester_id);


--
-- Name: _semesterstodate_first_registered_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _semesterstodate_first_registered_idx ON _semesterstodate_first_registered USING btree (date_first_registered, freq);

ALTER TABLE _semesterstodate_first_registered CLUSTER ON _semesterstodate_first_registered_idx;


--
-- Name: _semesterstodate_first_registered_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _semesterstodate_first_registered_idx_2 ON _semesterstodate_first_registered USING btree (semesters_semester_id);


--
-- Name: _semesterstodate_left_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _semesterstodate_left_idx ON _semesterstodate_left USING btree (date_left, freq);

ALTER TABLE _semesterstodate_left CLUSTER ON _semesterstodate_left_idx;


--
-- Name: _semesterstodate_left_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _semesterstodate_left_idx_2 ON _semesterstodate_left USING btree (semesters_semester_id);


--
-- Name: _semesterstodegree_summary_description_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _semesterstodegree_summary_description_idx ON _semesterstodegree_summary_description USING btree (degree_summary_description, freq);

ALTER TABLE _semesterstodegree_summary_description CLUSTER ON _semesterstodegree_summary_description_idx;


--
-- Name: _semesterstodegree_summary_description_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _semesterstodegree_summary_description_idx_2 ON _semesterstodegree_summary_description USING btree (semesters_semester_id);


--
-- Name: _semesterstoemail_address_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _semesterstoemail_address_idx ON _semesterstoemail_address USING btree (email_address, freq);

ALTER TABLE _semesterstoemail_address CLUSTER ON _semesterstoemail_address_idx;


--
-- Name: _semesterstoemail_address_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _semesterstoemail_address_idx_2 ON _semesterstoemail_address USING btree (semesters_semester_id);


--
-- Name: _semesterstolast_name_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _semesterstolast_name_idx ON _semesterstolast_name USING btree (last_name, freq);

ALTER TABLE _semesterstolast_name CLUSTER ON _semesterstolast_name_idx;


--
-- Name: _semesterstolast_name_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _semesterstolast_name_idx_2 ON _semesterstolast_name USING btree (semesters_semester_id);


--
-- Name: _semesterstomiddle_name_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _semesterstomiddle_name_idx ON _semesterstomiddle_name USING btree (middle_name, freq);

ALTER TABLE _semesterstomiddle_name CLUSTER ON _semesterstomiddle_name_idx;


--
-- Name: _semesterstomiddle_name_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _semesterstomiddle_name_idx_2 ON _semesterstomiddle_name USING btree (semesters_semester_id);


--
-- Name: _semesterstoother_details_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _semesterstoother_details_idx ON _semesterstoother_details USING btree (other_details, freq);

ALTER TABLE _semesterstoother_details CLUSTER ON _semesterstoother_details_idx;


--
-- Name: _semesterstoother_details_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _semesterstoother_details_idx_2 ON _semesterstoother_details USING btree (semesters_semester_id);


--
-- Name: _semesterstoother_student_details_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _semesterstoother_student_details_idx ON _semesterstoother_student_details USING btree (other_student_details, freq);

ALTER TABLE _semesterstoother_student_details CLUSTER ON _semesterstoother_student_details_idx;


--
-- Name: _semesterstoother_student_details_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _semesterstoother_student_details_idx_2 ON _semesterstoother_student_details USING btree (semesters_semester_id);


--
-- Name: _semesterstossn_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _semesterstossn_idx ON _semesterstossn USING btree (ssn, freq);

ALTER TABLE _semesterstossn CLUSTER ON _semesterstossn_idx;


--
-- Name: _semesterstossn_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _semesterstossn_idx_2 ON _semesterstossn USING btree (semesters_semester_id);


--
-- Name: _studentstodegree_summary_description_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _studentstodegree_summary_description_idx ON _studentstodegree_summary_description USING btree (degree_summary_description, freq);

ALTER TABLE _studentstodegree_summary_description CLUSTER ON _studentstodegree_summary_description_idx;


--
-- Name: _studentstodegree_summary_description_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _studentstodegree_summary_description_idx_2 ON _studentstodegree_summary_description USING btree (students_student_id);


--
-- Name: _studentstoother_details_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _studentstoother_details_idx ON _studentstoother_details USING btree (other_details, freq);

ALTER TABLE _studentstoother_details CLUSTER ON _studentstoother_details_idx;


--
-- Name: _studentstoother_details_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _studentstoother_details_idx_2 ON _studentstoother_details USING btree (students_student_id);


--
-- Name: _studentstosemester_description_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _studentstosemester_description_idx ON _studentstosemester_description USING btree (semester_description, freq);

ALTER TABLE _studentstosemester_description CLUSTER ON _studentstosemester_description_idx;


--
-- Name: _studentstosemester_description_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _studentstosemester_description_idx_2 ON _studentstosemester_description USING btree (students_student_id);


--
-- Name: degree_programs degree_programs_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY degree_programs
    ADD CONSTRAINT degree_programs_department_id_fkey FOREIGN KEY (department_id) REFERENCES departments(department_id);


--
-- Name: sections sections_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY sections
    ADD CONSTRAINT sections_course_id_fkey FOREIGN KEY (course_id) REFERENCES courses(course_id);


--
-- Name: student_enrolment_courses student_enrolment_courses_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY student_enrolment_courses
    ADD CONSTRAINT student_enrolment_courses_course_id_fkey FOREIGN KEY (course_id) REFERENCES courses(course_id);


--
-- Name: student_enrolment_courses student_enrolment_courses_student_enrolment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY student_enrolment_courses
    ADD CONSTRAINT student_enrolment_courses_student_enrolment_id_fkey FOREIGN KEY (student_enrolment_id) REFERENCES student_enrolment(student_enrolment_id);


--
-- Name: student_enrolment student_enrolment_degree_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY student_enrolment
    ADD CONSTRAINT student_enrolment_degree_program_id_fkey FOREIGN KEY (degree_program_id) REFERENCES degree_programs(degree_program_id);


--
-- Name: student_enrolment student_enrolment_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY student_enrolment
    ADD CONSTRAINT student_enrolment_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES semesters(semester_id);


--
-- Name: student_enrolment student_enrolment_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY student_enrolment
    ADD CONSTRAINT student_enrolment_student_id_fkey FOREIGN KEY (student_id) REFERENCES students(student_id);


--
-- Name: students students_current_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY students
    ADD CONSTRAINT students_current_address_id_fkey FOREIGN KEY (current_address_id) REFERENCES addresses(address_id);


--
-- Name: students students_permanent_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY students
    ADD CONSTRAINT students_permanent_address_id_fkey FOREIGN KEY (permanent_address_id) REFERENCES addresses(address_id);


--
-- Name: transcript_contents transcript_contents_student_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY transcript_contents
    ADD CONSTRAINT transcript_contents_student_course_id_fkey FOREIGN KEY (student_course_id) REFERENCES student_enrolment_courses(student_course_id);


--
-- Name: transcript_contents transcript_contents_transcript_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY transcript_contents
    ADD CONSTRAINT transcript_contents_transcript_id_fkey FOREIGN KEY (transcript_id) REFERENCES transcripts(transcript_id);


--
-- PostgreSQL database dump complete
--

