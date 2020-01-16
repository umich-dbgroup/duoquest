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
-- Name: cartoon; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE cartoon (
    id real NOT NULL,
    title text,
    directed_by text,
    written_by text,
    original_air_date text,
    production_code real,
    channel text
);


ALTER TABLE cartoon OWNER TO afariha;

--
-- Name: tv_channel; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE tv_channel (
    id text NOT NULL,
    series_name text,
    country text,
    language text,
    content text,
    pixel_aspect_ratio_par text,
    hight_definition_tv text,
    pay_per_view_ppv text,
    package_option text
);


ALTER TABLE tv_channel OWNER TO afariha;

--
-- Name: tv_series; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE tv_series (
    id real NOT NULL,
    episode text,
    air_date text,
    rating text,
    share real,
    a18_49_rating_share text,
    viewers_m text,
    weekly_rank real,
    channel text
);


ALTER TABLE tv_series OWNER TO afariha;

--
-- Name: _invertedcolumnindex _invertedcolumnindex_word_tabname_colname_key; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _invertedcolumnindex
    ADD CONSTRAINT _invertedcolumnindex_word_tabname_colname_key UNIQUE (word, tabname, colname);


--
-- Name: tv_channel idx_45050_sqlite_autoindex_tv_channel_1; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY tv_channel
    ADD CONSTRAINT idx_45050_sqlite_autoindex_tv_channel_1 PRIMARY KEY (id);


--
-- Name: tv_series idx_45056_sqlite_autoindex_tv_series_1; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY tv_series
    ADD CONSTRAINT idx_45056_sqlite_autoindex_tv_series_1 PRIMARY KEY (id);


--
-- Name: cartoon idx_45062_sqlite_autoindex_cartoon_1; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY cartoon
    ADD CONSTRAINT idx_45062_sqlite_autoindex_cartoon_1 PRIMARY KEY (id);


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
-- Name: cartoon cartoon_channel_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY cartoon
    ADD CONSTRAINT cartoon_channel_fkey FOREIGN KEY (channel) REFERENCES tv_channel(id);


--
-- Name: tv_series tv_series_channel_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY tv_series
    ADD CONSTRAINT tv_series_channel_fkey FOREIGN KEY (channel) REFERENCES tv_channel(id);


--
-- PostgreSQL database dump complete
--

