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
-- Name: _aggr_aoo_course_arrange_course_idtoteacher_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_course_arrange_course_idtoteacher_id (
    course_id integer,
    teacher_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_course_arrange_course_idtoteacher_id OWNER TO afariha;

--
-- Name: _aggr_aoo_course_arrange_teacher_idtocourse_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_course_arrange_teacher_idtocourse_id (
    teacher_id integer,
    course_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_course_arrange_teacher_idtocourse_id OWNER TO afariha;

--
-- Name: _coursetoage_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _coursetoage_id (
    course_course_id integer NOT NULL,
    age_id integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _coursetoage_id OWNER TO afariha;

--
-- Name: _coursetohometown_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _coursetohometown_id (
    course_course_id integer NOT NULL,
    hometown_id integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _coursetohometown_id OWNER TO afariha;

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
-- Name: _teachertostaring_date; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _teachertostaring_date (
    teacher_teacher_id integer NOT NULL,
    staring_date text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _teachertostaring_date OWNER TO afariha;

--
-- Name: course; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE course (
    course_id integer NOT NULL,
    staring_date text,
    course text
);


ALTER TABLE course OWNER TO afariha;

--
-- Name: course_arrange; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE course_arrange (
    course_id integer,
    teacher_id integer,
    grade integer
);


ALTER TABLE course_arrange OWNER TO afariha;

--
-- Name: teacher; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE teacher (
    teacher_id integer NOT NULL,
    name text,
    age_id integer,
    hometown_id integer
);


ALTER TABLE teacher OWNER TO afariha;

--
-- Name: teacher_age; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE teacher_age (
    id integer NOT NULL,
    age text
);


ALTER TABLE teacher_age OWNER TO afariha;

--
-- Name: teacher_age_id_seq; Type: SEQUENCE; Schema: public; Owner: afariha
--

CREATE SEQUENCE teacher_age_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE teacher_age_id_seq OWNER TO afariha;

--
-- Name: teacher_age_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: afariha
--

ALTER SEQUENCE teacher_age_id_seq OWNED BY teacher_age.id;


--
-- Name: teacher_hometown; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE teacher_hometown (
    id integer NOT NULL,
    hometown text
);


ALTER TABLE teacher_hometown OWNER TO afariha;

--
-- Name: teacher_hometown_id_seq; Type: SEQUENCE; Schema: public; Owner: afariha
--

CREATE SEQUENCE teacher_hometown_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE teacher_hometown_id_seq OWNER TO afariha;

--
-- Name: teacher_hometown_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: afariha
--

ALTER SEQUENCE teacher_hometown_id_seq OWNED BY teacher_hometown.id;


--
-- Name: teacher_age id; Type: DEFAULT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY teacher_age ALTER COLUMN id SET DEFAULT nextval('teacher_age_id_seq'::regclass);


--
-- Name: teacher_hometown id; Type: DEFAULT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY teacher_hometown ALTER COLUMN id SET DEFAULT nextval('teacher_hometown_id_seq'::regclass);


--
-- Name: _invertedcolumnindex _invertedcolumnindex_word_tabname_colname_key; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _invertedcolumnindex
    ADD CONSTRAINT _invertedcolumnindex_word_tabname_colname_key UNIQUE (word, tabname, colname);


--
-- Name: course course_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY course
    ADD CONSTRAINT course_pkey PRIMARY KEY (course_id);


--
-- Name: teacher_age teacher_age_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY teacher_age
    ADD CONSTRAINT teacher_age_pkey PRIMARY KEY (id);


--
-- Name: teacher_hometown teacher_hometown_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY teacher_hometown
    ADD CONSTRAINT teacher_hometown_pkey PRIMARY KEY (id);


--
-- Name: teacher teacher_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY teacher
    ADD CONSTRAINT teacher_pkey PRIMARY KEY (teacher_id);


--
-- Name: _aggr_aoo_course_arrange_course_idtoteacher_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_course_arrange_course_idtoteacher_id_idx ON _aggr_aoo_course_arrange_course_idtoteacher_id USING btree (course_id);


--
-- Name: _aggr_aoo_course_arrange_teacher_idtocourse_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_course_arrange_teacher_idtocourse_id_idx ON _aggr_aoo_course_arrange_teacher_idtocourse_id USING btree (teacher_id);


--
-- Name: _coursetoage_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _coursetoage_id_idx ON _coursetoage_id USING btree (age_id, freq);

ALTER TABLE _coursetoage_id CLUSTER ON _coursetoage_id_idx;


--
-- Name: _coursetoage_id_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _coursetoage_id_idx_2 ON _coursetoage_id USING btree (course_course_id);


--
-- Name: _coursetohometown_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _coursetohometown_id_idx ON _coursetohometown_id USING btree (hometown_id, freq);

ALTER TABLE _coursetohometown_id CLUSTER ON _coursetohometown_id_idx;


--
-- Name: _coursetohometown_id_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _coursetohometown_id_idx_2 ON _coursetohometown_id USING btree (course_course_id);


--
-- Name: _invertedcolumnindex_word_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _invertedcolumnindex_word_idx ON _invertedcolumnindex USING btree (word);

ALTER TABLE _invertedcolumnindex CLUSTER ON _invertedcolumnindex_word_idx;


--
-- Name: _teachertostaring_date_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _teachertostaring_date_idx ON _teachertostaring_date USING btree (staring_date, freq);

ALTER TABLE _teachertostaring_date CLUSTER ON _teachertostaring_date_idx;


--
-- Name: _teachertostaring_date_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _teachertostaring_date_idx_2 ON _teachertostaring_date USING btree (teacher_teacher_id);


--
-- Name: idx_60174_sqlite_autoindex_course_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_60174_sqlite_autoindex_course_1 ON course USING btree (course_id);


--
-- Name: idx_60180_sqlite_autoindex_teacher_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_60180_sqlite_autoindex_teacher_1 ON teacher USING btree (teacher_id);


--
-- Name: idx_60186_sqlite_autoindex_course_arrange_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_60186_sqlite_autoindex_course_arrange_1 ON course_arrange USING btree (course_id, teacher_id, grade);


--
-- Name: _aggr_aoo_course_arrange_course_idtoteacher_id _aggr_aoo_course_arrange_course_idtoteacher_id_course_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_course_arrange_course_idtoteacher_id
    ADD CONSTRAINT _aggr_aoo_course_arrange_course_idtoteacher_id_course_id_fk FOREIGN KEY (course_id) REFERENCES course(course_id);


--
-- Name: _aggr_aoo_course_arrange_teacher_idtocourse_id _aggr_aoo_course_arrange_teacher_idtocourse_id_teacher_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_course_arrange_teacher_idtocourse_id
    ADD CONSTRAINT _aggr_aoo_course_arrange_teacher_idtocourse_id_teacher_id_fk FOREIGN KEY (teacher_id) REFERENCES teacher(teacher_id);


--
-- Name: _coursetoage_id _coursetoage_id_age_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _coursetoage_id
    ADD CONSTRAINT _coursetoage_id_age_id_fkey FOREIGN KEY (age_id) REFERENCES teacher_age(id);


--
-- Name: _coursetoage_id _coursetoage_id_course_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _coursetoage_id
    ADD CONSTRAINT _coursetoage_id_course_course_id_fkey FOREIGN KEY (course_course_id) REFERENCES course(course_id);


--
-- Name: _coursetohometown_id _coursetohometown_id_course_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _coursetohometown_id
    ADD CONSTRAINT _coursetohometown_id_course_course_id_fkey FOREIGN KEY (course_course_id) REFERENCES course(course_id);


--
-- Name: _coursetohometown_id _coursetohometown_id_hometown_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _coursetohometown_id
    ADD CONSTRAINT _coursetohometown_id_hometown_id_fkey FOREIGN KEY (hometown_id) REFERENCES teacher_hometown(id);


--
-- Name: _teachertostaring_date _teachertostaring_date_teacher_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _teachertostaring_date
    ADD CONSTRAINT _teachertostaring_date_teacher_teacher_id_fkey FOREIGN KEY (teacher_teacher_id) REFERENCES teacher(teacher_id);


--
-- Name: course_arrange course_arrange_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY course_arrange
    ADD CONSTRAINT course_arrange_course_id_fkey FOREIGN KEY (course_id) REFERENCES course(course_id);


--
-- Name: course_arrange course_arrange_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY course_arrange
    ADD CONSTRAINT course_arrange_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES teacher(teacher_id);


--
-- Name: teacher teacher_age_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY teacher
    ADD CONSTRAINT teacher_age_id_fkey FOREIGN KEY (age_id) REFERENCES teacher_age(id);


--
-- Name: teacher teacher_hometown_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY teacher
    ADD CONSTRAINT teacher_hometown_id_fkey FOREIGN KEY (hometown_id) REFERENCES teacher_hometown(id);


--
-- PostgreSQL database dump complete
--

