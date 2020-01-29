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
-- Name: _aggr_aoc_battle_to_date; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoc_battle_to_date (
    battle_id integer,
    date_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoc_battle_to_date OWNER TO afariha;

--
-- Name: _aggr_aoc_battle_to_result; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoc_battle_to_result (
    battle_id integer,
    result_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoc_battle_to_result OWNER TO afariha;

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
-- Name: battle; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE battle (
    id integer NOT NULL,
    name text,
    bulgarian_commander text,
    latin_commander text
);


ALTER TABLE battle OWNER TO afariha;

--
-- Name: battle_to_date; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE battle_to_date (
    battle_id integer,
    date_id integer
);


ALTER TABLE battle_to_date OWNER TO afariha;

--
-- Name: battle_to_result; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE battle_to_result (
    battle_id integer,
    result_id integer
);


ALTER TABLE battle_to_result OWNER TO afariha;

--
-- Name: date_of_battle; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE date_of_battle (
    id integer NOT NULL,
    date text
);


ALTER TABLE date_of_battle OWNER TO afariha;

--
-- Name: date_of_battle_id_seq; Type: SEQUENCE; Schema: public; Owner: afariha
--

CREATE SEQUENCE date_of_battle_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE date_of_battle_id_seq OWNER TO afariha;

--
-- Name: date_of_battle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: afariha
--

ALTER SEQUENCE date_of_battle_id_seq OWNED BY date_of_battle.id;


--
-- Name: death; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE death (
    caused_by_ship_id integer,
    id integer NOT NULL,
    note text,
    killed integer,
    injured integer
);


ALTER TABLE death OWNER TO afariha;

--
-- Name: result_of_battle; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE result_of_battle (
    id integer NOT NULL,
    result text
);


ALTER TABLE result_of_battle OWNER TO afariha;

--
-- Name: result_of_battle_id_seq; Type: SEQUENCE; Schema: public; Owner: afariha
--

CREATE SEQUENCE result_of_battle_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE result_of_battle_id_seq OWNER TO afariha;

--
-- Name: result_of_battle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: afariha
--

ALTER SEQUENCE result_of_battle_id_seq OWNED BY result_of_battle.id;


--
-- Name: ship; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE ship (
    lost_in_battle integer,
    id integer NOT NULL,
    name text,
    tonnage text,
    ship_type text,
    location text,
    disposition_of_ship text
);


ALTER TABLE ship OWNER TO afariha;

--
-- Name: date_of_battle id; Type: DEFAULT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY date_of_battle ALTER COLUMN id SET DEFAULT nextval('date_of_battle_id_seq'::regclass);


--
-- Name: result_of_battle id; Type: DEFAULT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY result_of_battle ALTER COLUMN id SET DEFAULT nextval('result_of_battle_id_seq'::regclass);


--
-- Name: _invertedcolumnindex _invertedcolumnindex_word_tabname_colname_key; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _invertedcolumnindex
    ADD CONSTRAINT _invertedcolumnindex_word_tabname_colname_key UNIQUE (word, tabname, colname);


--
-- Name: date_of_battle date_of_battle_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY date_of_battle
    ADD CONSTRAINT date_of_battle_pkey PRIMARY KEY (id);


--
-- Name: battle idx_68496_sqlite_autoindex_battle_1; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY battle
    ADD CONSTRAINT idx_68496_sqlite_autoindex_battle_1 PRIMARY KEY (id);


--
-- Name: ship idx_68502_sqlite_autoindex_ship_1; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY ship
    ADD CONSTRAINT idx_68502_sqlite_autoindex_ship_1 PRIMARY KEY (id);


--
-- Name: death idx_68508_sqlite_autoindex_death_1; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY death
    ADD CONSTRAINT idx_68508_sqlite_autoindex_death_1 PRIMARY KEY (id);


--
-- Name: result_of_battle result_of_battle_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY result_of_battle
    ADD CONSTRAINT result_of_battle_pkey PRIMARY KEY (id);


--
-- Name: _aggr_aoc_battle_to_date_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoc_battle_to_date_idx ON _aggr_aoc_battle_to_date USING btree (battle_id);


--
-- Name: _aggr_aoc_battle_to_result_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoc_battle_to_result_idx ON _aggr_aoc_battle_to_result USING btree (battle_id);


--
-- Name: _invertedcolumnindex_word_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _invertedcolumnindex_word_idx ON _invertedcolumnindex USING btree (word);

ALTER TABLE _invertedcolumnindex CLUSTER ON _invertedcolumnindex_word_idx;


--
-- Name: _aggr_aoc_battle_to_date _aggr_aocbattle_to_date_battle_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoc_battle_to_date
    ADD CONSTRAINT _aggr_aocbattle_to_date_battle_id_fk FOREIGN KEY (battle_id) REFERENCES battle(id);


--
-- Name: _aggr_aoc_battle_to_result _aggr_aocbattle_to_result_battle_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoc_battle_to_result
    ADD CONSTRAINT _aggr_aocbattle_to_result_battle_id_fk FOREIGN KEY (battle_id) REFERENCES battle(id);


--
-- Name: battle_to_date battle_to_date_battle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY battle_to_date
    ADD CONSTRAINT battle_to_date_battle_id_fkey FOREIGN KEY (battle_id) REFERENCES battle(id);


--
-- Name: battle_to_date battle_to_date_date_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY battle_to_date
    ADD CONSTRAINT battle_to_date_date_id_fkey FOREIGN KEY (date_id) REFERENCES date_of_battle(id);


--
-- Name: battle_to_result battle_to_result_battle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY battle_to_result
    ADD CONSTRAINT battle_to_result_battle_id_fkey FOREIGN KEY (battle_id) REFERENCES battle(id);


--
-- Name: battle_to_result battle_to_result_result_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY battle_to_result
    ADD CONSTRAINT battle_to_result_result_id_fkey FOREIGN KEY (result_id) REFERENCES result_of_battle(id);


--
-- Name: death death_caused_by_ship_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY death
    ADD CONSTRAINT death_caused_by_ship_id_fkey FOREIGN KEY (caused_by_ship_id) REFERENCES ship(id);


--
-- Name: ship ship_lost_in_battle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY ship
    ADD CONSTRAINT ship_lost_in_battle_fkey FOREIGN KEY (lost_in_battle) REFERENCES battle(id);


--
-- PostgreSQL database dump complete
--

