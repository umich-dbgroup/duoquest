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
-- Name: _invertedcolumnindex; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _invertedcolumnindex (
    word text,
    tabname text,
    colname text
);


ALTER TABLE _invertedcolumnindex OWNER TO afariha;

--
-- Name: conductor; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE conductor (
    conductor_id integer NOT NULL,
    name text,
    age integer,
    nationality text,
    year_of_work integer
);


ALTER TABLE conductor OWNER TO afariha;

--
-- Name: orchestra; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE orchestra (
    orchestra_id integer NOT NULL,
    orchestra text,
    conductor_id integer,
    record_company text,
    year_of_founded real,
    major_record_format text
);


ALTER TABLE orchestra OWNER TO afariha;

--
-- Name: performance; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE performance (
    performance_id integer NOT NULL,
    orchestra_id integer,
    type text,
    date text,
    "Official_ratings_(millions)" real,
    weekly_rank text,
    share text
);


ALTER TABLE performance OWNER TO afariha;

--
-- Name: show; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE show (
    show_id integer NOT NULL,
    performance_id integer,
    if_first_show boolean,
    result text,
    attendance real
);


ALTER TABLE show OWNER TO afariha;

--
-- Name: _invertedcolumnindex _invertedcolumnindex_word_tabname_colname_key; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _invertedcolumnindex
    ADD CONSTRAINT _invertedcolumnindex_word_tabname_colname_key UNIQUE (word, tabname, colname);


--
-- Name: conductor conductor_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY conductor
    ADD CONSTRAINT conductor_pkey PRIMARY KEY (conductor_id);


--
-- Name: orchestra orchestra_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY orchestra
    ADD CONSTRAINT orchestra_pkey PRIMARY KEY (orchestra_id);


--
-- Name: performance performance_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY performance
    ADD CONSTRAINT performance_pkey PRIMARY KEY (performance_id);


--
-- Name: show show_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY show
    ADD CONSTRAINT show_pkey PRIMARY KEY (show_id);


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
-- Name: _invertedcolumnindex_word_idx4; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _invertedcolumnindex_word_idx4 ON _invertedcolumnindex USING btree (word);


--
-- Name: idx_44378_sqlite_autoindex_conductor_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_44378_sqlite_autoindex_conductor_1 ON conductor USING btree (conductor_id);


--
-- Name: idx_44384_sqlite_autoindex_orchestra_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_44384_sqlite_autoindex_orchestra_1 ON orchestra USING btree (orchestra_id);


--
-- Name: idx_44390_sqlite_autoindex_performance_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_44390_sqlite_autoindex_performance_1 ON performance USING btree (performance_id);


--
-- Name: orchestra orchestra_conductor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY orchestra
    ADD CONSTRAINT orchestra_conductor_id_fkey FOREIGN KEY (conductor_id) REFERENCES conductor(conductor_id);


--
-- Name: performance performance_orchestra_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY performance
    ADD CONSTRAINT performance_orchestra_id_fkey FOREIGN KEY (orchestra_id) REFERENCES orchestra(orchestra_id);


--
-- Name: show show_performance_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY show
    ADD CONSTRAINT show_performance_id_fkey FOREIGN KEY (performance_id) REFERENCES performance(performance_id);


--
-- PostgreSQL database dump complete
--

