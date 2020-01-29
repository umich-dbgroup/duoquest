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
-- Name: _aggr_aoo_singer_to_song_singer_idtosong_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_singer_to_song_singer_idtosong_id (
    singer_id integer,
    song_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_singer_to_song_singer_idtosong_id OWNER TO afariha;

--
-- Name: _aggr_aoo_singer_to_song_song_idtosinger_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_singer_to_song_song_idtosinger_id (
    song_id integer,
    singer_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_singer_to_song_song_idtosinger_id OWNER TO afariha;

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
-- Name: _singertohighest_position; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _singertohighest_position (
    singer_singer_id integer NOT NULL,
    highest_position integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _singertohighest_position OWNER TO afariha;

--
-- Name: _singertosales; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _singertosales (
    singer_singer_id integer NOT NULL,
    sales integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _singertosales OWNER TO afariha;

--
-- Name: _songtobirth_year; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _songtobirth_year (
    song_song_id integer NOT NULL,
    birth_year integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _songtobirth_year OWNER TO afariha;

--
-- Name: _songtocitizenship; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _songtocitizenship (
    song_song_id integer NOT NULL,
    citizenship text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _songtocitizenship OWNER TO afariha;

--
-- Name: _songtonet_worth_millions; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _songtonet_worth_millions (
    song_song_id integer NOT NULL,
    net_worth_millions integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _songtonet_worth_millions OWNER TO afariha;

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
-- Name: singer_to_song; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE singer_to_song (
    singer_id integer,
    song_id integer
);


ALTER TABLE singer_to_song OWNER TO afariha;

--
-- Name: song; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE song (
    song_id integer NOT NULL,
    title text,
    sales real,
    highest_position real
);


ALTER TABLE song OWNER TO afariha;

--
-- Name: _invertedcolumnindex _invertedcolumnindex_word_tabname_colname_key; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _invertedcolumnindex
    ADD CONSTRAINT _invertedcolumnindex_word_tabname_colname_key UNIQUE (word, tabname, colname);


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
-- Name: _aggr_aoo_singer_to_song_singer_idtosong_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_singer_to_song_singer_idtosong_id_idx ON _aggr_aoo_singer_to_song_singer_idtosong_id USING btree (singer_id);


--
-- Name: _aggr_aoo_singer_to_song_song_idtosinger_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_singer_to_song_song_idtosinger_id_idx ON _aggr_aoo_singer_to_song_song_idtosinger_id USING btree (song_id);


--
-- Name: _invertedcolumnindex_word_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _invertedcolumnindex_word_idx ON _invertedcolumnindex USING btree (word);

ALTER TABLE _invertedcolumnindex CLUSTER ON _invertedcolumnindex_word_idx;


--
-- Name: _singertohighest_position_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _singertohighest_position_idx ON _singertohighest_position USING btree (highest_position, freq);

ALTER TABLE _singertohighest_position CLUSTER ON _singertohighest_position_idx;


--
-- Name: _singertohighest_position_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _singertohighest_position_idx_2 ON _singertohighest_position USING btree (singer_singer_id);


--
-- Name: _singertosales_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _singertosales_idx ON _singertosales USING btree (sales, freq);

ALTER TABLE _singertosales CLUSTER ON _singertosales_idx;


--
-- Name: _singertosales_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _singertosales_idx_2 ON _singertosales USING btree (singer_singer_id);


--
-- Name: _songtobirth_year_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _songtobirth_year_idx ON _songtobirth_year USING btree (birth_year, freq);

ALTER TABLE _songtobirth_year CLUSTER ON _songtobirth_year_idx;


--
-- Name: _songtobirth_year_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _songtobirth_year_idx_2 ON _songtobirth_year USING btree (song_song_id);


--
-- Name: _songtocitizenship_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _songtocitizenship_idx ON _songtocitizenship USING btree (citizenship, freq);

ALTER TABLE _songtocitizenship CLUSTER ON _songtocitizenship_idx;


--
-- Name: _songtocitizenship_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _songtocitizenship_idx_2 ON _songtocitizenship USING btree (song_song_id);


--
-- Name: _songtonet_worth_millions_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _songtonet_worth_millions_idx ON _songtonet_worth_millions USING btree (net_worth_millions, freq);

ALTER TABLE _songtonet_worth_millions CLUSTER ON _songtonet_worth_millions_idx;


--
-- Name: _songtonet_worth_millions_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _songtonet_worth_millions_idx_2 ON _songtonet_worth_millions USING btree (song_song_id);


--
-- Name: idx_88874_sqlite_autoindex_singer_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_88874_sqlite_autoindex_singer_1 ON singer USING btree (singer_id);


--
-- Name: idx_88880_sqlite_autoindex_song_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_88880_sqlite_autoindex_song_1 ON song USING btree (song_id);


--
-- Name: _aggr_aoo_singer_to_song_singer_idtosong_id _aggr_aoo_singer_to_song_singer_idtosong_id_singer_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_singer_to_song_singer_idtosong_id
    ADD CONSTRAINT _aggr_aoo_singer_to_song_singer_idtosong_id_singer_id_fk FOREIGN KEY (singer_id) REFERENCES singer(singer_id);


--
-- Name: _aggr_aoo_singer_to_song_song_idtosinger_id _aggr_aoo_singer_to_song_song_idtosinger_id_song_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_singer_to_song_song_idtosinger_id
    ADD CONSTRAINT _aggr_aoo_singer_to_song_song_idtosinger_id_song_id_fk FOREIGN KEY (song_id) REFERENCES song(song_id);


--
-- Name: _singertohighest_position _singertohighest_position_singer_singer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _singertohighest_position
    ADD CONSTRAINT _singertohighest_position_singer_singer_id_fkey FOREIGN KEY (singer_singer_id) REFERENCES singer(singer_id);


--
-- Name: _singertosales _singertosales_singer_singer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _singertosales
    ADD CONSTRAINT _singertosales_singer_singer_id_fkey FOREIGN KEY (singer_singer_id) REFERENCES singer(singer_id);


--
-- Name: _songtobirth_year _songtobirth_year_song_song_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _songtobirth_year
    ADD CONSTRAINT _songtobirth_year_song_song_id_fkey FOREIGN KEY (song_song_id) REFERENCES song(song_id);


--
-- Name: _songtocitizenship _songtocitizenship_song_song_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _songtocitizenship
    ADD CONSTRAINT _songtocitizenship_song_song_id_fkey FOREIGN KEY (song_song_id) REFERENCES song(song_id);


--
-- Name: _songtonet_worth_millions _songtonet_worth_millions_song_song_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _songtonet_worth_millions
    ADD CONSTRAINT _songtonet_worth_millions_song_song_id_fkey FOREIGN KEY (song_song_id) REFERENCES song(song_id);


--
-- Name: singer_to_song singer_to_song_singer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY singer_to_song
    ADD CONSTRAINT singer_to_song_singer_id_fkey FOREIGN KEY (singer_id) REFERENCES singer(singer_id);


--
-- Name: singer_to_song singer_to_song_song_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY singer_to_song
    ADD CONSTRAINT singer_to_song_song_id_fkey FOREIGN KEY (song_id) REFERENCES song(song_id);


--
-- PostgreSQL database dump complete
--

