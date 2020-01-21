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
-- Name: car_makers; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE car_makers (
    id bigint NOT NULL,
    maker text,
    fullname text,
    country text
);


ALTER TABLE car_makers OWNER TO afariha;

--
-- Name: car_names; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE car_names (
    makeid bigint NOT NULL,
    model text,
    make text
);


ALTER TABLE car_names OWNER TO afariha;

--
-- Name: cars_data; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE cars_data (
    id bigint NOT NULL,
    mpg text,
    cylinders bigint,
    edispl real,
    horsepower text,
    weight bigint,
    accelerate real,
    year bigint
);


ALTER TABLE cars_data OWNER TO afariha;

--
-- Name: continents; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE continents (
    contid bigint NOT NULL,
    continent text
);


ALTER TABLE continents OWNER TO afariha;

--
-- Name: countries; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE countries (
    countryid bigint NOT NULL,
    countryname text,
    continent bigint
);


ALTER TABLE countries OWNER TO afariha;

--
-- Name: model_list; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE model_list (
    modelid bigint NOT NULL,
    maker bigint,
    model text
);


ALTER TABLE model_list OWNER TO afariha;

--
-- Name: _invertedcolumnindex _invertedcolumnindex_word_tabname_colname_key; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _invertedcolumnindex
    ADD CONSTRAINT _invertedcolumnindex_word_tabname_colname_key UNIQUE (word, tabname, colname);


--
-- Name: continents idx_44225_continents_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY continents
    ADD CONSTRAINT idx_44225_continents_pkey PRIMARY KEY (contid);


--
-- Name: countries idx_44231_countries_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY countries
    ADD CONSTRAINT idx_44231_countries_pkey PRIMARY KEY (countryid);


--
-- Name: car_makers idx_44237_car_makers_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY car_makers
    ADD CONSTRAINT idx_44237_car_makers_pkey PRIMARY KEY (id);


--
-- Name: model_list idx_44243_model_list_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY model_list
    ADD CONSTRAINT idx_44243_model_list_pkey PRIMARY KEY (modelid);


--
-- Name: car_names idx_44249_car_names_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY car_names
    ADD CONSTRAINT idx_44249_car_names_pkey PRIMARY KEY (makeid);


--
-- Name: cars_data idx_44255_cars_data_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY cars_data
    ADD CONSTRAINT idx_44255_cars_data_pkey PRIMARY KEY (id);


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
-- Name: _invertedcolumnindex_word_idx5; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _invertedcolumnindex_word_idx5 ON _invertedcolumnindex USING btree (word);


--
-- Name: idx_44243_sqlite_autoindex_model_list_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_44243_sqlite_autoindex_model_list_1 ON model_list USING btree (model);


--
-- Name: cars_data cars_data_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY cars_data
    ADD CONSTRAINT cars_data_id_fkey FOREIGN KEY (id) REFERENCES car_names(makeid);


--
-- Name: countries countries_continent_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY countries
    ADD CONSTRAINT countries_continent_fkey FOREIGN KEY (continent) REFERENCES continents(contid);


--
-- PostgreSQL database dump complete
--

