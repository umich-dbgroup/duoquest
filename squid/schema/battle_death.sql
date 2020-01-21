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
-- Name: battle; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE battle (
    id integer NOT NULL,
    name text,
    date text,
    bulgarian_commander text,
    latin_commander text,
    result text
);


ALTER TABLE battle OWNER TO afariha;

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
-- Name: battle idx_37099_sqlite_autoindex_battle_1; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY battle
    ADD CONSTRAINT idx_37099_sqlite_autoindex_battle_1 PRIMARY KEY (id);


--
-- Name: ship idx_37105_sqlite_autoindex_ship_1; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY ship
    ADD CONSTRAINT idx_37105_sqlite_autoindex_ship_1 PRIMARY KEY (id);


--
-- Name: death idx_37111_sqlite_autoindex_death_1; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY death
    ADD CONSTRAINT idx_37111_sqlite_autoindex_death_1 PRIMARY KEY (id);


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

