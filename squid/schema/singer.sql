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
-- Name: singer; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE singer (
    singer_id integer NOT NULL,
    name text,
    birth_year real,
    net_worth_millions real,
    citizenship text
);


ALTER TABLE singer OWNER TO afariha;

--
-- Name: song; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE song (
    song_id integer NOT NULL,
    title text,
    singer_id integer,
    sales real,
    highest_position real
);


ALTER TABLE song OWNER TO afariha;

--
-- Name: singer singer_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY singer
    ADD CONSTRAINT singer_pkey PRIMARY KEY (singer_id);


--
-- Name: song song_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY song
    ADD CONSTRAINT song_pkey PRIMARY KEY (song_id);


--
-- Name: idx_45161_sqlite_autoindex_singer_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_45161_sqlite_autoindex_singer_1 ON singer USING btree (singer_id);


--
-- Name: idx_45167_sqlite_autoindex_song_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_45167_sqlite_autoindex_song_1 ON song USING btree (song_id);


--
-- Name: song song_singer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY song
    ADD CONSTRAINT song_singer_id_fkey FOREIGN KEY (singer_id) REFERENCES singer(singer_id);


--
-- PostgreSQL database dump complete
--

