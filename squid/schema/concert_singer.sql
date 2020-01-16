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
-- Name: concert; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE concert (
    concert_id integer NOT NULL,
    concert_name text,
    theme text,
    stadium_id integer,
    year text
);


ALTER TABLE concert OWNER TO afariha;

--
-- Name: singer; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE singer (
    singer_id integer NOT NULL,
    name text,
    country text,
    song_name text,
    song_release_year text,
    age integer,
    is_male text
);


ALTER TABLE singer OWNER TO afariha;

--
-- Name: singer_in_concert; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE singer_in_concert (
    concert_id integer,
    singer_id integer
);


ALTER TABLE singer_in_concert OWNER TO afariha;

--
-- Name: stadium; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE stadium (
    stadium_id integer NOT NULL,
    location text,
    name text,
    capacity integer,
    highest integer,
    lowest integer,
    average integer
);


ALTER TABLE stadium OWNER TO afariha;

--
-- Name: _invertedcolumnindex _invertedcolumnindex_word_tabname_colname_key; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _invertedcolumnindex
    ADD CONSTRAINT _invertedcolumnindex_word_tabname_colname_key UNIQUE (word, tabname, colname);


--
-- Name: concert concert_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY concert
    ADD CONSTRAINT concert_pkey PRIMARY KEY (concert_id);


--
-- Name: singer singer_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY singer
    ADD CONSTRAINT singer_pkey PRIMARY KEY (singer_id);


--
-- Name: stadium stadium_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY stadium
    ADD CONSTRAINT stadium_pkey PRIMARY KEY (stadium_id);


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
-- Name: idx_45087_sqlite_autoindex_stadium_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_45087_sqlite_autoindex_stadium_1 ON stadium USING btree (stadium_id);


--
-- Name: idx_45093_sqlite_autoindex_singer_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_45093_sqlite_autoindex_singer_1 ON singer USING btree (singer_id);


--
-- Name: idx_45099_sqlite_autoindex_concert_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_45099_sqlite_autoindex_concert_1 ON concert USING btree (concert_id);


--
-- Name: idx_45105_sqlite_autoindex_singer_in_concert_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_45105_sqlite_autoindex_singer_in_concert_1 ON singer_in_concert USING btree (concert_id, singer_id);


--
-- Name: concert concert_stadium_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY concert
    ADD CONSTRAINT concert_stadium_id_fkey FOREIGN KEY (stadium_id) REFERENCES stadium(stadium_id);


--
-- Name: singer_in_concert singer_in_concert_concert_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY singer_in_concert
    ADD CONSTRAINT singer_in_concert_concert_id_fkey FOREIGN KEY (concert_id) REFERENCES concert(concert_id);


--
-- Name: singer_in_concert singer_in_concert_singer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY singer_in_concert
    ADD CONSTRAINT singer_in_concert_singer_id_fkey FOREIGN KEY (singer_id) REFERENCES singer(singer_id);


--
-- PostgreSQL database dump complete
--

