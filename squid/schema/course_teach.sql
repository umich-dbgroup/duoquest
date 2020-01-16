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
-- Name: _invertedcolumnindex; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _invertedcolumnindex (
    word text,
    tabname text,
    colname text
);


ALTER TABLE _invertedcolumnindex OWNER TO afariha;

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
    age text,
    hometown text
);


ALTER TABLE teacher OWNER TO afariha;

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
-- Name: _invertedcolumnindex_word_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _invertedcolumnindex_word_idx ON _invertedcolumnindex USING btree (word);

ALTER TABLE _invertedcolumnindex CLUSTER ON _invertedcolumnindex_word_idx;


--
-- Name: _invertedcolumnindex_word_idx1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _invertedcolumnindex_word_idx1 ON _invertedcolumnindex USING btree (word);


--
-- Name: _invertedcolumnindex_word_idx2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _invertedcolumnindex_word_idx2 ON _invertedcolumnindex USING btree (word);


--
-- Name: _invertedcolumnindex_word_idx3; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _invertedcolumnindex_word_idx3 ON _invertedcolumnindex USING btree (word);


--
-- Name: idx_44591_sqlite_autoindex_course_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_44591_sqlite_autoindex_course_1 ON course USING btree (course_id);


--
-- Name: idx_44597_sqlite_autoindex_teacher_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_44597_sqlite_autoindex_teacher_1 ON teacher USING btree (teacher_id);


--
-- Name: idx_44603_sqlite_autoindex_course_arrange_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_44603_sqlite_autoindex_course_arrange_1 ON course_arrange USING btree (course_id, teacher_id, grade);


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
-- PostgreSQL database dump complete
--

