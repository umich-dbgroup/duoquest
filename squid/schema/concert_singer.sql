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
-- Name: _aggr_aoo_singer_in_concert_concert_idtosinger_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_singer_in_concert_concert_idtosinger_id (
    concert_id integer,
    singer_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_singer_in_concert_concert_idtosinger_id OWNER TO afariha;

--
-- Name: _aggr_aoo_singer_in_concert_singer_idtoconcert_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_singer_in_concert_singer_idtoconcert_id (
    singer_id integer,
    concert_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_singer_in_concert_singer_idtoconcert_id OWNER TO afariha;

--
-- Name: _aggr_aoo_singer_to_country_country_idtosinger_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_singer_to_country_country_idtosinger_id (
    country_id integer,
    singer_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_singer_to_country_country_idtosinger_id OWNER TO afariha;

--
-- Name: _aggr_aoo_singer_to_country_singer_idtocountry_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_singer_to_country_singer_idtocountry_id (
    singer_id integer,
    country_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_singer_to_country_singer_idtocountry_id OWNER TO afariha;

--
-- Name: _concerttoage; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _concerttoage (
    concert_concert_id integer NOT NULL,
    age integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _concerttoage OWNER TO afariha;

--
-- Name: _concerttosong_name; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _concerttosong_name (
    concert_concert_id integer NOT NULL,
    song_name text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _concerttosong_name OWNER TO afariha;

--
-- Name: _concerttosong_release_year; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _concerttosong_release_year (
    concert_concert_id integer NOT NULL,
    song_release_year text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _concerttosong_release_year OWNER TO afariha;

--
-- Name: _countrytoage; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _countrytoage (
    country_id integer NOT NULL,
    age integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _countrytoage OWNER TO afariha;

--
-- Name: _countrytosong_name; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _countrytosong_name (
    country_id integer NOT NULL,
    song_name text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _countrytosong_name OWNER TO afariha;

--
-- Name: _countrytosong_release_year; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _countrytosong_release_year (
    country_id integer NOT NULL,
    song_release_year text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _countrytosong_release_year OWNER TO afariha;

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
-- Name: _singertotheme; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _singertotheme (
    singer_singer_id integer NOT NULL,
    theme text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _singertotheme OWNER TO afariha;

--
-- Name: _singertoyear; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _singertoyear (
    singer_singer_id integer NOT NULL,
    year text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _singertoyear OWNER TO afariha;

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
-- Name: country; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE country (
    id integer NOT NULL,
    name text
);


ALTER TABLE country OWNER TO afariha;

--
-- Name: country_id_seq; Type: SEQUENCE; Schema: public; Owner: afariha
--

CREATE SEQUENCE country_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE country_id_seq OWNER TO afariha;

--
-- Name: country_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: afariha
--

ALTER SEQUENCE country_id_seq OWNED BY country.id;


--
-- Name: singer; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE singer (
    singer_id integer NOT NULL,
    name text,
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
-- Name: singer_to_country; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE singer_to_country (
    country_id integer,
    singer_id integer
);


ALTER TABLE singer_to_country OWNER TO afariha;

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
-- Name: country id; Type: DEFAULT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY country ALTER COLUMN id SET DEFAULT nextval('country_id_seq'::regclass);


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
-- Name: country country_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY country
    ADD CONSTRAINT country_pkey PRIMARY KEY (id);


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
-- Name: _aggr_aoo_singer_in_concert_concert_idtosinger_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_singer_in_concert_concert_idtosinger_id_idx ON _aggr_aoo_singer_in_concert_concert_idtosinger_id USING btree (concert_id);


--
-- Name: _aggr_aoo_singer_in_concert_singer_idtoconcert_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_singer_in_concert_singer_idtoconcert_id_idx ON _aggr_aoo_singer_in_concert_singer_idtoconcert_id USING btree (singer_id);


--
-- Name: _aggr_aoo_singer_to_country_country_idtosinger_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_singer_to_country_country_idtosinger_id_idx ON _aggr_aoo_singer_to_country_country_idtosinger_id USING btree (country_id);


--
-- Name: _aggr_aoo_singer_to_country_singer_idtocountry_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_singer_to_country_singer_idtocountry_id_idx ON _aggr_aoo_singer_to_country_singer_idtocountry_id USING btree (singer_id);


--
-- Name: _concerttoage_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _concerttoage_idx ON _concerttoage USING btree (age, freq);

ALTER TABLE _concerttoage CLUSTER ON _concerttoage_idx;


--
-- Name: _concerttoage_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _concerttoage_idx_2 ON _concerttoage USING btree (concert_concert_id);


--
-- Name: _concerttosong_name_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _concerttosong_name_idx ON _concerttosong_name USING btree (song_name, freq);

ALTER TABLE _concerttosong_name CLUSTER ON _concerttosong_name_idx;


--
-- Name: _concerttosong_name_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _concerttosong_name_idx_2 ON _concerttosong_name USING btree (concert_concert_id);


--
-- Name: _concerttosong_release_year_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _concerttosong_release_year_idx ON _concerttosong_release_year USING btree (song_release_year, freq);

ALTER TABLE _concerttosong_release_year CLUSTER ON _concerttosong_release_year_idx;


--
-- Name: _concerttosong_release_year_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _concerttosong_release_year_idx_2 ON _concerttosong_release_year USING btree (concert_concert_id);


--
-- Name: _countrytoage_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _countrytoage_idx ON _countrytoage USING btree (age, freq);

ALTER TABLE _countrytoage CLUSTER ON _countrytoage_idx;


--
-- Name: _countrytoage_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _countrytoage_idx_2 ON _countrytoage USING btree (country_id);


--
-- Name: _countrytosong_name_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _countrytosong_name_idx ON _countrytosong_name USING btree (song_name, freq);

ALTER TABLE _countrytosong_name CLUSTER ON _countrytosong_name_idx;


--
-- Name: _countrytosong_name_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _countrytosong_name_idx_2 ON _countrytosong_name USING btree (country_id);


--
-- Name: _countrytosong_release_year_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _countrytosong_release_year_idx ON _countrytosong_release_year USING btree (song_release_year, freq);

ALTER TABLE _countrytosong_release_year CLUSTER ON _countrytosong_release_year_idx;


--
-- Name: _countrytosong_release_year_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _countrytosong_release_year_idx_2 ON _countrytosong_release_year USING btree (country_id);


--
-- Name: _invertedcolumnindex_word_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _invertedcolumnindex_word_idx ON _invertedcolumnindex USING btree (word);

ALTER TABLE _invertedcolumnindex CLUSTER ON _invertedcolumnindex_word_idx;


--
-- Name: _singertotheme_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _singertotheme_idx ON _singertotheme USING btree (theme, freq);

ALTER TABLE _singertotheme CLUSTER ON _singertotheme_idx;


--
-- Name: _singertotheme_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _singertotheme_idx_2 ON _singertotheme USING btree (singer_singer_id);


--
-- Name: _singertoyear_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _singertoyear_idx ON _singertoyear USING btree (year, freq);

ALTER TABLE _singertoyear CLUSTER ON _singertoyear_idx;


--
-- Name: _singertoyear_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _singertoyear_idx_2 ON _singertoyear USING btree (singer_singer_id);


--
-- Name: idx_62790_sqlite_autoindex_stadium_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_62790_sqlite_autoindex_stadium_1 ON stadium USING btree (stadium_id);


--
-- Name: idx_62796_sqlite_autoindex_singer_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_62796_sqlite_autoindex_singer_1 ON singer USING btree (singer_id);


--
-- Name: idx_62802_sqlite_autoindex_concert_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_62802_sqlite_autoindex_concert_1 ON concert USING btree (concert_id);


--
-- Name: idx_62808_sqlite_autoindex_singer_in_concert_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_62808_sqlite_autoindex_singer_in_concert_1 ON singer_in_concert USING btree (concert_id, singer_id);


--
-- Name: _aggr_aoo_singer_in_concert_concert_idtosinger_id _aggr_aoo_singer_in_concert_concert_idtosinger_id_concert_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_singer_in_concert_concert_idtosinger_id
    ADD CONSTRAINT _aggr_aoo_singer_in_concert_concert_idtosinger_id_concert_id_fk FOREIGN KEY (concert_id) REFERENCES concert(concert_id);


--
-- Name: _aggr_aoo_singer_in_concert_singer_idtoconcert_id _aggr_aoo_singer_in_concert_singer_idtoconcert_id_singer_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_singer_in_concert_singer_idtoconcert_id
    ADD CONSTRAINT _aggr_aoo_singer_in_concert_singer_idtoconcert_id_singer_id_fk FOREIGN KEY (singer_id) REFERENCES singer(singer_id);


--
-- Name: _aggr_aoo_singer_to_country_country_idtosinger_id _aggr_aoo_singer_to_country_country_idtosinger_id_country_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_singer_to_country_country_idtosinger_id
    ADD CONSTRAINT _aggr_aoo_singer_to_country_country_idtosinger_id_country_id_fk FOREIGN KEY (country_id) REFERENCES country(id);


--
-- Name: _aggr_aoo_singer_to_country_singer_idtocountry_id _aggr_aoo_singer_to_country_singer_idtocountry_id_singer_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_singer_to_country_singer_idtocountry_id
    ADD CONSTRAINT _aggr_aoo_singer_to_country_singer_idtocountry_id_singer_id_fk FOREIGN KEY (singer_id) REFERENCES singer(singer_id);


--
-- Name: _concerttoage _concerttoage_concert_concert_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _concerttoage
    ADD CONSTRAINT _concerttoage_concert_concert_id_fkey FOREIGN KEY (concert_concert_id) REFERENCES concert(concert_id);


--
-- Name: _concerttosong_name _concerttosong_name_concert_concert_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _concerttosong_name
    ADD CONSTRAINT _concerttosong_name_concert_concert_id_fkey FOREIGN KEY (concert_concert_id) REFERENCES concert(concert_id);


--
-- Name: _concerttosong_release_year _concerttosong_release_year_concert_concert_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _concerttosong_release_year
    ADD CONSTRAINT _concerttosong_release_year_concert_concert_id_fkey FOREIGN KEY (concert_concert_id) REFERENCES concert(concert_id);


--
-- Name: _countrytoage _countrytoage_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _countrytoage
    ADD CONSTRAINT _countrytoage_country_id_fkey FOREIGN KEY (country_id) REFERENCES country(id);


--
-- Name: _countrytosong_name _countrytosong_name_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _countrytosong_name
    ADD CONSTRAINT _countrytosong_name_country_id_fkey FOREIGN KEY (country_id) REFERENCES country(id);


--
-- Name: _countrytosong_release_year _countrytosong_release_year_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _countrytosong_release_year
    ADD CONSTRAINT _countrytosong_release_year_country_id_fkey FOREIGN KEY (country_id) REFERENCES country(id);


--
-- Name: _singertotheme _singertotheme_singer_singer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _singertotheme
    ADD CONSTRAINT _singertotheme_singer_singer_id_fkey FOREIGN KEY (singer_singer_id) REFERENCES singer(singer_id);


--
-- Name: _singertoyear _singertoyear_singer_singer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _singertoyear
    ADD CONSTRAINT _singertoyear_singer_singer_id_fkey FOREIGN KEY (singer_singer_id) REFERENCES singer(singer_id);


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
-- Name: singer_to_country singer_to_country_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY singer_to_country
    ADD CONSTRAINT singer_to_country_country_id_fkey FOREIGN KEY (country_id) REFERENCES country(id);


--
-- Name: singer_to_country singer_to_country_singer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY singer_to_country
    ADD CONSTRAINT singer_to_country_singer_id_fkey FOREIGN KEY (singer_id) REFERENCES singer(singer_id);


--
-- PostgreSQL database dump complete
--

