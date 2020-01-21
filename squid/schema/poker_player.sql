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
-- Name: people; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE people (
    people_id integer NOT NULL,
    nationality text,
    name text,
    birth_date text,
    height real
);


ALTER TABLE people OWNER TO afariha;

--
-- Name: poker_player; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE poker_player (
    poker_player_id integer NOT NULL,
    people_id integer,
    final_table_made real,
    best_finish real,
    money_rank real,
    earnings real
);


ALTER TABLE poker_player OWNER TO afariha;

--
-- Name: _invertedcolumnindex _invertedcolumnindex_word_tabname_colname_key; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _invertedcolumnindex
    ADD CONSTRAINT _invertedcolumnindex_word_tabname_colname_key UNIQUE (word, tabname, colname);


--
-- Name: people people_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY people
    ADD CONSTRAINT people_pkey PRIMARY KEY (people_id);


--
-- Name: poker_player poker_player_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY poker_player
    ADD CONSTRAINT poker_player_pkey PRIMARY KEY (poker_player_id);


--
-- Name: _invertedcolumnindex_word_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _invertedcolumnindex_word_idx ON _invertedcolumnindex USING btree (word);

ALTER TABLE _invertedcolumnindex CLUSTER ON _invertedcolumnindex_word_idx;


--
-- Name: idx_44355_sqlite_autoindex_poker_player_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_44355_sqlite_autoindex_poker_player_1 ON poker_player USING btree (poker_player_id);


--
-- Name: idx_44358_sqlite_autoindex_people_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_44358_sqlite_autoindex_people_1 ON people USING btree (people_id);


--
-- Name: poker_player poker_player_people_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY poker_player
    ADD CONSTRAINT poker_player_people_id_fkey FOREIGN KEY (people_id) REFERENCES people(people_id);


--
-- PostgreSQL database dump complete
--

