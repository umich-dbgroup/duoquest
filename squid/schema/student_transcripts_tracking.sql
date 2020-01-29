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
-- Name: _aggr_aoc_addresses_to_line_2; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoc_addresses_to_line_2 (
    address_id integer,
    line_2_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoc_addresses_to_line_2 OWNER TO afariha;

--
-- Name: _aggr_aoc_course_to_description; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoc_course_to_description (
    description_id integer,
    course_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoc_course_to_description OWNER TO afariha;

--
-- Name: _aggr_aoc_department_to_description; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoc_department_to_description (
    description_id integer,
    department_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoc_department_to_description OWNER TO afariha;

--
-- Name: _aggr_aoc_section_to_description; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoc_section_to_description (
    description_id integer,
    section_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoc_section_to_description OWNER TO afariha;

--
-- Name: _aggr_aoc_student_enrolment; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoc_student_enrolment (
    semester_id bigint,
    student_id_aggr bigint[],
    count bigint
);


ALTER TABLE _aggr_aoc_student_enrolment OWNER TO afariha;

--
-- Name: _aggr_aoc_student_to_cell_mobile_number; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoc_student_to_cell_mobile_number (
    cell_mobile_number_id integer,
    student_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoc_student_to_cell_mobile_number OWNER TO afariha;

--
-- Name: _aggr_aoo_addresses_to_zip_address_idtozip_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_addresses_to_zip_address_idtozip_id (
    address_id integer,
    zip_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_addresses_to_zip_address_idtozip_id OWNER TO afariha;

--
-- Name: _aggr_aoo_addresses_to_zip_zip_idtoaddress_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_addresses_to_zip_zip_idtoaddress_id (
    zip_id integer,
    address_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_addresses_to_zip_zip_idtoaddress_id OWNER TO afariha;

--
-- Name: _degree_programstostudents; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _degree_programstostudents (
    degree_programs_degree_program_id integer NOT NULL,
    student_id integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _degree_programstostudents OWNER TO afariha;

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
-- Name: _semesterstodepartment_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _semesterstodepartment_id (
    semesters_semester_id integer NOT NULL,
    department_id integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _semesterstodepartment_id OWNER TO afariha;

--
-- Name: _semesterstostudents; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _semesterstostudents (
    semesters_semester_id integer NOT NULL,
    student_id integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _semesterstostudents OWNER TO afariha;

--
-- Name: _ziptoaddresses_line_2; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _ziptoaddresses_line_2 (
    zip_id integer NOT NULL,
    line_2_id integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _ziptoaddresses_line_2 OWNER TO afariha;

--
-- Name: _ziptocity; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _ziptocity (
    zip_id integer NOT NULL,
    city text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _ziptocity OWNER TO afariha;

--
-- Name: addresses; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE addresses (
    address_id bigint NOT NULL,
    line_1 text,
    line_3 text,
    city text,
    state_province_county text,
    country text,
    other_address_details text
);


ALTER TABLE addresses OWNER TO afariha;

--
-- Name: addresses_line_2; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE addresses_line_2 (
    id integer NOT NULL,
    line_2 text
);


ALTER TABLE addresses_line_2 OWNER TO afariha;

--
-- Name: addresses_line_2_id_seq; Type: SEQUENCE; Schema: public; Owner: afariha
--

CREATE SEQUENCE addresses_line_2_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE addresses_line_2_id_seq OWNER TO afariha;

--
-- Name: addresses_line_2_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: afariha
--

ALTER SEQUENCE addresses_line_2_id_seq OWNED BY addresses_line_2.id;


--
-- Name: addresses_to_line_2; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE addresses_to_line_2 (
    address_id integer,
    line_2_id integer
);


ALTER TABLE addresses_to_line_2 OWNER TO afariha;

--
-- Name: addresses_to_zip; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE addresses_to_zip (
    address_id integer,
    zip_id integer
);


ALTER TABLE addresses_to_zip OWNER TO afariha;

--
-- Name: course_description; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE course_description (
    id integer NOT NULL,
    description text
);


ALTER TABLE course_description OWNER TO afariha;

--
-- Name: course_description_id_seq; Type: SEQUENCE; Schema: public; Owner: afariha
--

CREATE SEQUENCE course_description_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE course_description_id_seq OWNER TO afariha;

--
-- Name: course_description_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: afariha
--

ALTER SEQUENCE course_description_id_seq OWNED BY course_description.id;


--
-- Name: course_to_description; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE course_to_description (
    course_id integer,
    description_id integer
);


ALTER TABLE course_to_description OWNER TO afariha;

--
-- Name: courses; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE courses (
    course_id bigint NOT NULL,
    course_name text,
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
-- Name: department_description; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE department_description (
    id integer NOT NULL,
    description text
);


ALTER TABLE department_description OWNER TO afariha;

--
-- Name: department_description_id_seq; Type: SEQUENCE; Schema: public; Owner: afariha
--

CREATE SEQUENCE department_description_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE department_description_id_seq OWNER TO afariha;

--
-- Name: department_description_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: afariha
--

ALTER SEQUENCE department_description_id_seq OWNED BY department_description.id;


--
-- Name: department_to_description; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE department_to_description (
    department_id integer,
    description_id integer
);


ALTER TABLE department_to_description OWNER TO afariha;

--
-- Name: departments; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE departments (
    department_id bigint NOT NULL,
    department_name text,
    other_details text
);


ALTER TABLE departments OWNER TO afariha;

--
-- Name: section_description; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE section_description (
    id integer NOT NULL,
    description text
);


ALTER TABLE section_description OWNER TO afariha;

--
-- Name: section_description_id_seq; Type: SEQUENCE; Schema: public; Owner: afariha
--

CREATE SEQUENCE section_description_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE section_description_id_seq OWNER TO afariha;

--
-- Name: section_description_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: afariha
--

ALTER SEQUENCE section_description_id_seq OWNED BY section_description.id;


--
-- Name: section_to_description; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE section_to_description (
    section_id integer,
    description_id integer
);


ALTER TABLE section_to_description OWNER TO afariha;

--
-- Name: sections; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE sections (
    section_id bigint NOT NULL,
    course_id bigint,
    section_name text,
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
-- Name: student_cell_mobile_number; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE student_cell_mobile_number (
    id integer NOT NULL,
    cell_mobile_number text
);


ALTER TABLE student_cell_mobile_number OWNER TO afariha;

--
-- Name: student_cell_mobile_number_id_seq; Type: SEQUENCE; Schema: public; Owner: afariha
--

CREATE SEQUENCE student_cell_mobile_number_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE student_cell_mobile_number_id_seq OWNER TO afariha;

--
-- Name: student_cell_mobile_number_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: afariha
--

ALTER SEQUENCE student_cell_mobile_number_id_seq OWNED BY student_cell_mobile_number.id;


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
-- Name: student_last_name; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE student_last_name (
    id integer NOT NULL,
    last_name text
);


ALTER TABLE student_last_name OWNER TO afariha;

--
-- Name: student_last_name_id_seq; Type: SEQUENCE; Schema: public; Owner: afariha
--

CREATE SEQUENCE student_last_name_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE student_last_name_id_seq OWNER TO afariha;

--
-- Name: student_last_name_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: afariha
--

ALTER SEQUENCE student_last_name_id_seq OWNED BY student_last_name.id;


--
-- Name: student_middle_name; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE student_middle_name (
    id integer NOT NULL,
    middle_name text
);


ALTER TABLE student_middle_name OWNER TO afariha;

--
-- Name: student_middle_name_id_seq; Type: SEQUENCE; Schema: public; Owner: afariha
--

CREATE SEQUENCE student_middle_name_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE student_middle_name_id_seq OWNER TO afariha;

--
-- Name: student_middle_name_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: afariha
--

ALTER SEQUENCE student_middle_name_id_seq OWNED BY student_middle_name.id;


--
-- Name: student_to_cell_mobile_number; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE student_to_cell_mobile_number (
    student_id integer,
    cell_mobile_number_id integer
);


ALTER TABLE student_to_cell_mobile_number OWNER TO afariha;

--
-- Name: student_to_last_name; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE student_to_last_name (
    student_id integer,
    last_name_id integer
);


ALTER TABLE student_to_last_name OWNER TO afariha;

--
-- Name: student_to_middle_name; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE student_to_middle_name (
    student_id integer,
    middle_name_id integer
);


ALTER TABLE student_to_middle_name OWNER TO afariha;

--
-- Name: students; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE students (
    student_id bigint NOT NULL,
    current_address_id bigint,
    permanent_address_id bigint,
    first_name text,
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
-- Name: zip; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE zip (
    id integer NOT NULL,
    zip text
);


ALTER TABLE zip OWNER TO afariha;

--
-- Name: zip_id_seq; Type: SEQUENCE; Schema: public; Owner: afariha
--

CREATE SEQUENCE zip_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zip_id_seq OWNER TO afariha;

--
-- Name: zip_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: afariha
--

ALTER SEQUENCE zip_id_seq OWNED BY zip.id;


--
-- Name: addresses_line_2 id; Type: DEFAULT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY addresses_line_2 ALTER COLUMN id SET DEFAULT nextval('addresses_line_2_id_seq'::regclass);


--
-- Name: course_description id; Type: DEFAULT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY course_description ALTER COLUMN id SET DEFAULT nextval('course_description_id_seq'::regclass);


--
-- Name: department_description id; Type: DEFAULT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY department_description ALTER COLUMN id SET DEFAULT nextval('department_description_id_seq'::regclass);


--
-- Name: section_description id; Type: DEFAULT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY section_description ALTER COLUMN id SET DEFAULT nextval('section_description_id_seq'::regclass);


--
-- Name: student_cell_mobile_number id; Type: DEFAULT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY student_cell_mobile_number ALTER COLUMN id SET DEFAULT nextval('student_cell_mobile_number_id_seq'::regclass);


--
-- Name: student_last_name id; Type: DEFAULT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY student_last_name ALTER COLUMN id SET DEFAULT nextval('student_last_name_id_seq'::regclass);


--
-- Name: student_middle_name id; Type: DEFAULT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY student_middle_name ALTER COLUMN id SET DEFAULT nextval('student_middle_name_id_seq'::regclass);


--
-- Name: zip id; Type: DEFAULT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY zip ALTER COLUMN id SET DEFAULT nextval('zip_id_seq'::regclass);


--
-- Name: _invertedcolumnindex _invertedcolumnindex_word_tabname_colname_key; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _invertedcolumnindex
    ADD CONSTRAINT _invertedcolumnindex_word_tabname_colname_key UNIQUE (word, tabname, colname);


--
-- Name: addresses_line_2 addresses_line_2_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY addresses_line_2
    ADD CONSTRAINT addresses_line_2_pkey PRIMARY KEY (id);


--
-- Name: course_description course_description_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY course_description
    ADD CONSTRAINT course_description_pkey PRIMARY KEY (id);


--
-- Name: department_description department_description_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY department_description
    ADD CONSTRAINT department_description_pkey PRIMARY KEY (id);


--
-- Name: addresses idx_76211_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT idx_76211_addresses_pkey PRIMARY KEY (address_id);


--
-- Name: courses idx_76217_courses_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY courses
    ADD CONSTRAINT idx_76217_courses_pkey PRIMARY KEY (course_id);


--
-- Name: departments idx_76223_departments_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY departments
    ADD CONSTRAINT idx_76223_departments_pkey PRIMARY KEY (department_id);


--
-- Name: degree_programs idx_76229_degree_programs_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY degree_programs
    ADD CONSTRAINT idx_76229_degree_programs_pkey PRIMARY KEY (degree_program_id);


--
-- Name: sections idx_76235_sections_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY sections
    ADD CONSTRAINT idx_76235_sections_pkey PRIMARY KEY (section_id);


--
-- Name: semesters idx_76241_semesters_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY semesters
    ADD CONSTRAINT idx_76241_semesters_pkey PRIMARY KEY (semester_id);


--
-- Name: students idx_76247_students_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY students
    ADD CONSTRAINT idx_76247_students_pkey PRIMARY KEY (student_id);


--
-- Name: student_enrolment idx_76253_student_enrolment_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY student_enrolment
    ADD CONSTRAINT idx_76253_student_enrolment_pkey PRIMARY KEY (student_enrolment_id);


--
-- Name: student_enrolment_courses idx_76259_student_enrolment_courses_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY student_enrolment_courses
    ADD CONSTRAINT idx_76259_student_enrolment_courses_pkey PRIMARY KEY (student_course_id);


--
-- Name: transcripts idx_76262_transcripts_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY transcripts
    ADD CONSTRAINT idx_76262_transcripts_pkey PRIMARY KEY (transcript_id);


--
-- Name: section_description section_description_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY section_description
    ADD CONSTRAINT section_description_pkey PRIMARY KEY (id);


--
-- Name: student_cell_mobile_number student_cell_mobile_number_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY student_cell_mobile_number
    ADD CONSTRAINT student_cell_mobile_number_pkey PRIMARY KEY (id);


--
-- Name: student_last_name student_last_name_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY student_last_name
    ADD CONSTRAINT student_last_name_pkey PRIMARY KEY (id);


--
-- Name: student_middle_name student_middle_name_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY student_middle_name
    ADD CONSTRAINT student_middle_name_pkey PRIMARY KEY (id);


--
-- Name: zip zip_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY zip
    ADD CONSTRAINT zip_pkey PRIMARY KEY (id);


--
-- Name: _aggr_aoc_addresses_to_line_2_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoc_addresses_to_line_2_idx ON _aggr_aoc_addresses_to_line_2 USING btree (address_id);


--
-- Name: _aggr_aoc_course_to_description_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoc_course_to_description_idx ON _aggr_aoc_course_to_description USING btree (description_id);


--
-- Name: _aggr_aoc_department_to_description_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoc_department_to_description_idx ON _aggr_aoc_department_to_description USING btree (description_id);


--
-- Name: _aggr_aoc_section_to_description_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoc_section_to_description_idx ON _aggr_aoc_section_to_description USING btree (description_id);


--
-- Name: _aggr_aoc_student_enrolment_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoc_student_enrolment_idx ON _aggr_aoc_student_enrolment USING btree (semester_id);


--
-- Name: _aggr_aoc_student_to_cell_mobile_number_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoc_student_to_cell_mobile_number_idx ON _aggr_aoc_student_to_cell_mobile_number USING btree (cell_mobile_number_id);


--
-- Name: _aggr_aoo_addresses_to_zip_address_idtozip_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_addresses_to_zip_address_idtozip_id_idx ON _aggr_aoo_addresses_to_zip_address_idtozip_id USING btree (address_id);


--
-- Name: _aggr_aoo_addresses_to_zip_zip_idtoaddress_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_addresses_to_zip_zip_idtoaddress_id_idx ON _aggr_aoo_addresses_to_zip_zip_idtoaddress_id USING btree (zip_id);


--
-- Name: _degree_programstostudents_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _degree_programstostudents_idx ON _degree_programstostudents USING btree (student_id, freq);

ALTER TABLE _degree_programstostudents CLUSTER ON _degree_programstostudents_idx;


--
-- Name: _degree_programstostudents_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _degree_programstostudents_idx_2 ON _degree_programstostudents USING btree (degree_programs_degree_program_id);


--
-- Name: _invertedcolumnindex_word_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _invertedcolumnindex_word_idx ON _invertedcolumnindex USING btree (word);

ALTER TABLE _invertedcolumnindex CLUSTER ON _invertedcolumnindex_word_idx;


--
-- Name: _semesterstodepartment_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _semesterstodepartment_id_idx ON _semesterstodepartment_id USING btree (department_id, freq);

ALTER TABLE _semesterstodepartment_id CLUSTER ON _semesterstodepartment_id_idx;


--
-- Name: _semesterstodepartment_id_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _semesterstodepartment_id_idx_2 ON _semesterstodepartment_id USING btree (semesters_semester_id);


--
-- Name: _semesterstostudents_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _semesterstostudents_idx ON _semesterstostudents USING btree (student_id, freq);

ALTER TABLE _semesterstostudents CLUSTER ON _semesterstostudents_idx;


--
-- Name: _semesterstostudents_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _semesterstostudents_idx_2 ON _semesterstostudents USING btree (semesters_semester_id);


--
-- Name: _ziptoaddresses_line_2_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _ziptoaddresses_line_2_idx ON _ziptoaddresses_line_2 USING btree (line_2_id, freq);

ALTER TABLE _ziptoaddresses_line_2 CLUSTER ON _ziptoaddresses_line_2_idx;


--
-- Name: _ziptoaddresses_line_2_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _ziptoaddresses_line_2_idx_2 ON _ziptoaddresses_line_2 USING btree (zip_id);


--
-- Name: _ziptocity_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _ziptocity_idx ON _ziptocity USING btree (city, freq);

ALTER TABLE _ziptocity CLUSTER ON _ziptocity_idx;


--
-- Name: _ziptocity_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _ziptocity_idx_2 ON _ziptocity USING btree (zip_id);


--
-- Name: _aggr_aoc_addresses_to_line_2 _aggr_aocaddresses_to_line_2_address_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoc_addresses_to_line_2
    ADD CONSTRAINT _aggr_aocaddresses_to_line_2_address_id_fk FOREIGN KEY (address_id) REFERENCES addresses(address_id);


--
-- Name: _aggr_aoc_course_to_description _aggr_aoccourse_to_description_description_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoc_course_to_description
    ADD CONSTRAINT _aggr_aoccourse_to_description_description_id_fk FOREIGN KEY (description_id) REFERENCES course_description(id);


--
-- Name: _aggr_aoc_department_to_description _aggr_aocdepartment_to_description_description_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoc_department_to_description
    ADD CONSTRAINT _aggr_aocdepartment_to_description_description_id_fk FOREIGN KEY (description_id) REFERENCES department_description(id);


--
-- Name: _aggr_aoc_section_to_description _aggr_aocsection_to_description_description_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoc_section_to_description
    ADD CONSTRAINT _aggr_aocsection_to_description_description_id_fk FOREIGN KEY (description_id) REFERENCES section_description(id);


--
-- Name: _aggr_aoc_student_enrolment _aggr_aocstudent_enrolment_semester_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoc_student_enrolment
    ADD CONSTRAINT _aggr_aocstudent_enrolment_semester_id_fk FOREIGN KEY (semester_id) REFERENCES semesters(semester_id);


--
-- Name: _aggr_aoc_student_to_cell_mobile_number _aggr_aocstudent_to_cell_mobile_number_cell_mobile_number_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoc_student_to_cell_mobile_number
    ADD CONSTRAINT _aggr_aocstudent_to_cell_mobile_number_cell_mobile_number_id_fk FOREIGN KEY (cell_mobile_number_id) REFERENCES student_cell_mobile_number(id);


--
-- Name: _aggr_aoo_addresses_to_zip_address_idtozip_id _aggr_aoo_addresses_to_zip_address_idtozip_id_address_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_addresses_to_zip_address_idtozip_id
    ADD CONSTRAINT _aggr_aoo_addresses_to_zip_address_idtozip_id_address_id_fk FOREIGN KEY (address_id) REFERENCES addresses(address_id);


--
-- Name: _aggr_aoo_addresses_to_zip_zip_idtoaddress_id _aggr_aoo_addresses_to_zip_zip_idtoaddress_id_zip_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_addresses_to_zip_zip_idtoaddress_id
    ADD CONSTRAINT _aggr_aoo_addresses_to_zip_zip_idtoaddress_id_zip_id_fk FOREIGN KEY (zip_id) REFERENCES zip(id);


--
-- Name: _degree_programstostudents _degree_programstostudents_degree_programs_degree_program__fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _degree_programstostudents
    ADD CONSTRAINT _degree_programstostudents_degree_programs_degree_program__fkey FOREIGN KEY (degree_programs_degree_program_id) REFERENCES degree_programs(degree_program_id);


--
-- Name: _degree_programstostudents _degree_programstostudents_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _degree_programstostudents
    ADD CONSTRAINT _degree_programstostudents_student_id_fkey FOREIGN KEY (student_id) REFERENCES students(student_id);


--
-- Name: _semesterstodepartment_id _semesterstodepartment_id_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _semesterstodepartment_id
    ADD CONSTRAINT _semesterstodepartment_id_department_id_fkey FOREIGN KEY (department_id) REFERENCES departments(department_id);


--
-- Name: _semesterstodepartment_id _semesterstodepartment_id_semesters_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _semesterstodepartment_id
    ADD CONSTRAINT _semesterstodepartment_id_semesters_semester_id_fkey FOREIGN KEY (semesters_semester_id) REFERENCES semesters(semester_id);


--
-- Name: _semesterstostudents _semesterstostudents_semesters_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _semesterstostudents
    ADD CONSTRAINT _semesterstostudents_semesters_semester_id_fkey FOREIGN KEY (semesters_semester_id) REFERENCES semesters(semester_id);


--
-- Name: _semesterstostudents _semesterstostudents_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _semesterstostudents
    ADD CONSTRAINT _semesterstostudents_student_id_fkey FOREIGN KEY (student_id) REFERENCES students(student_id);


--
-- Name: _ziptoaddresses_line_2 _ziptoaddresses_line_2_line_2_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _ziptoaddresses_line_2
    ADD CONSTRAINT _ziptoaddresses_line_2_line_2_id_fkey FOREIGN KEY (line_2_id) REFERENCES addresses_line_2(id);


--
-- Name: _ziptoaddresses_line_2 _ziptoaddresses_line_2_zip_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _ziptoaddresses_line_2
    ADD CONSTRAINT _ziptoaddresses_line_2_zip_id_fkey FOREIGN KEY (zip_id) REFERENCES zip(id);


--
-- Name: _ziptocity _ziptocity_zip_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _ziptocity
    ADD CONSTRAINT _ziptocity_zip_id_fkey FOREIGN KEY (zip_id) REFERENCES zip(id);


--
-- Name: addresses_to_line_2 addresses_to_line_2_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY addresses_to_line_2
    ADD CONSTRAINT addresses_to_line_2_address_id_fkey FOREIGN KEY (address_id) REFERENCES addresses(address_id);


--
-- Name: addresses_to_line_2 addresses_to_line_2_line_2_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY addresses_to_line_2
    ADD CONSTRAINT addresses_to_line_2_line_2_id_fkey FOREIGN KEY (line_2_id) REFERENCES addresses_line_2(id);


--
-- Name: addresses_to_zip addresses_to_zip_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY addresses_to_zip
    ADD CONSTRAINT addresses_to_zip_address_id_fkey FOREIGN KEY (address_id) REFERENCES addresses(address_id);


--
-- Name: addresses_to_zip addresses_to_zip_zip_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY addresses_to_zip
    ADD CONSTRAINT addresses_to_zip_zip_id_fkey FOREIGN KEY (zip_id) REFERENCES zip(id);


--
-- Name: course_to_description course_to_description_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY course_to_description
    ADD CONSTRAINT course_to_description_course_id_fkey FOREIGN KEY (course_id) REFERENCES courses(course_id);


--
-- Name: course_to_description course_to_description_description_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY course_to_description
    ADD CONSTRAINT course_to_description_description_id_fkey FOREIGN KEY (description_id) REFERENCES course_description(id);


--
-- Name: degree_programs degree_programs_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY degree_programs
    ADD CONSTRAINT degree_programs_department_id_fkey FOREIGN KEY (department_id) REFERENCES departments(department_id);


--
-- Name: department_to_description department_to_description_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY department_to_description
    ADD CONSTRAINT department_to_description_department_id_fkey FOREIGN KEY (department_id) REFERENCES departments(department_id);


--
-- Name: department_to_description department_to_description_description_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY department_to_description
    ADD CONSTRAINT department_to_description_description_id_fkey FOREIGN KEY (description_id) REFERENCES department_description(id);


--
-- Name: section_to_description section_to_description_description_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY section_to_description
    ADD CONSTRAINT section_to_description_description_id_fkey FOREIGN KEY (description_id) REFERENCES section_description(id);


--
-- Name: section_to_description section_to_description_section_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY section_to_description
    ADD CONSTRAINT section_to_description_section_id_fkey FOREIGN KEY (section_id) REFERENCES sections(section_id);


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
-- Name: student_to_cell_mobile_number student_to_cell_mobile_number_cell_mobile_number_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY student_to_cell_mobile_number
    ADD CONSTRAINT student_to_cell_mobile_number_cell_mobile_number_id_fkey FOREIGN KEY (cell_mobile_number_id) REFERENCES student_cell_mobile_number(id);


--
-- Name: student_to_cell_mobile_number student_to_cell_mobile_number_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY student_to_cell_mobile_number
    ADD CONSTRAINT student_to_cell_mobile_number_student_id_fkey FOREIGN KEY (student_id) REFERENCES students(student_id);


--
-- Name: student_to_last_name student_to_last_name_last_name_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY student_to_last_name
    ADD CONSTRAINT student_to_last_name_last_name_id_fkey FOREIGN KEY (last_name_id) REFERENCES student_last_name(id);


--
-- Name: student_to_last_name student_to_last_name_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY student_to_last_name
    ADD CONSTRAINT student_to_last_name_student_id_fkey FOREIGN KEY (student_id) REFERENCES students(student_id);


--
-- Name: student_to_middle_name student_to_middle_name_middle_name_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY student_to_middle_name
    ADD CONSTRAINT student_to_middle_name_middle_name_id_fkey FOREIGN KEY (middle_name_id) REFERENCES student_middle_name(id);


--
-- Name: student_to_middle_name student_to_middle_name_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY student_to_middle_name
    ADD CONSTRAINT student_to_middle_name_student_id_fkey FOREIGN KEY (student_id) REFERENCES students(student_id);


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

