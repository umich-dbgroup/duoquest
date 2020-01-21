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
-- Name: matches; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE matches (
    best_of integer,
    draw_size integer,
    loser_age double precision,
    loser_entry text,
    loser_hand text,
    loser_ht integer,
    loser_id integer,
    loser_ioc text,
    loser_name text,
    loser_rank integer,
    loser_rank_points integer,
    loser_seed integer,
    match_num integer,
    minutes integer,
    round text,
    score text,
    surface text,
    tourney_date text,
    tourney_id text,
    tourney_level text,
    tourney_name text,
    winner_age double precision,
    winner_entry text,
    winner_hand text,
    winner_ht integer,
    winner_id integer,
    winner_ioc text,
    winner_name text,
    winner_rank integer,
    winner_rank_points integer,
    winner_seed integer,
    year integer,
    match_id integer NOT NULL
);


ALTER TABLE matches OWNER TO afariha;

--
-- Name: matches_match_id_seq; Type: SEQUENCE; Schema: public; Owner: afariha
--

CREATE SEQUENCE matches_match_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE matches_match_id_seq OWNER TO afariha;

--
-- Name: matches_match_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: afariha
--

ALTER SEQUENCE matches_match_id_seq OWNED BY matches.match_id;


--
-- Name: players; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE players (
    player_id integer NOT NULL,
    first_name text,
    last_name text,
    hand text,
    birth_date date,
    country_code text
);


ALTER TABLE players OWNER TO afariha;

--
-- Name: rankings; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE rankings (
    ranking_date date,
    ranking integer,
    player_id integer,
    ranking_points integer,
    tours integer
);


ALTER TABLE rankings OWNER TO afariha;

--
-- Name: matches match_id; Type: DEFAULT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY matches ALTER COLUMN match_id SET DEFAULT nextval('matches_match_id_seq'::regclass);


--
-- Name: _invertedcolumnindex _invertedcolumnindex_word_tabname_colname_key; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _invertedcolumnindex
    ADD CONSTRAINT _invertedcolumnindex_word_tabname_colname_key UNIQUE (word, tabname, colname);


--
-- Name: players idx_45600_sqlite_autoindex_players_1; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY players
    ADD CONSTRAINT idx_45600_sqlite_autoindex_players_1 PRIMARY KEY (player_id);


--
-- Name: matches matches_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY matches
    ADD CONSTRAINT matches_pkey PRIMARY KEY (match_id);


--
-- Name: _invertedcolumnindex_word_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _invertedcolumnindex_word_idx ON _invertedcolumnindex USING btree (word);

ALTER TABLE _invertedcolumnindex CLUSTER ON _invertedcolumnindex_word_idx;


--
-- Name: rankings rankings_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY rankings
    ADD CONSTRAINT rankings_player_id_fkey FOREIGN KEY (player_id) REFERENCES players(player_id);


--
-- PostgreSQL database dump complete
--

