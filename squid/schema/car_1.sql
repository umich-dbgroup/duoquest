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
-- Name: _aggr_aoo_maker_to_car_car_idtomaker_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_maker_to_car_car_idtomaker_id (
    car_id integer,
    maker_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_maker_to_car_car_idtomaker_id OWNER TO afariha;

--
-- Name: _aggr_aoo_maker_to_car_maker_idtocar_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_maker_to_car_maker_idtocar_id (
    maker_id integer,
    car_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_maker_to_car_maker_idtocar_id OWNER TO afariha;

--
-- Name: _aggr_aoo_maker_to_country_country_idtomaker_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_maker_to_country_country_idtomaker_id (
    country_id integer,
    maker_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_maker_to_country_country_idtomaker_id OWNER TO afariha;

--
-- Name: _aggr_aoo_maker_to_country_maker_idtocountry_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_maker_to_country_maker_idtocountry_id (
    maker_id integer,
    country_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_maker_to_country_maker_idtocountry_id OWNER TO afariha;

--
-- Name: _aggr_aoo_maker_to_model_maker_idtomodel_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_maker_to_model_maker_idtomodel_id (
    maker_id integer,
    model_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_maker_to_model_maker_idtomodel_id OWNER TO afariha;

--
-- Name: _aggr_aoo_maker_to_model_model_idtomaker_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_maker_to_model_model_idtomaker_id (
    model_id integer,
    maker_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_maker_to_model_model_idtomaker_id OWNER TO afariha;

--
-- Name: _car_makerstoaccelerate; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _car_makerstoaccelerate (
    car_makers_id integer NOT NULL,
    accelerate integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _car_makerstoaccelerate OWNER TO afariha;

--
-- Name: _car_makerstocontinent; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _car_makerstocontinent (
    car_makers_id integer NOT NULL,
    continent integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _car_makerstocontinent OWNER TO afariha;

--
-- Name: _car_makerstocylinders; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _car_makerstocylinders (
    car_makers_id integer NOT NULL,
    cylinders integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _car_makerstocylinders OWNER TO afariha;

--
-- Name: _car_makerstoedispl; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _car_makerstoedispl (
    car_makers_id integer NOT NULL,
    edispl integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _car_makerstoedispl OWNER TO afariha;

--
-- Name: _car_makerstohorsepower; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _car_makerstohorsepower (
    car_makers_id integer NOT NULL,
    horsepower text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _car_makerstohorsepower OWNER TO afariha;

--
-- Name: _car_makerstompg; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _car_makerstompg (
    car_makers_id integer NOT NULL,
    mpg text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _car_makerstompg OWNER TO afariha;

--
-- Name: _car_makerstoweight; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _car_makerstoweight (
    car_makers_id integer NOT NULL,
    weight integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _car_makerstoweight OWNER TO afariha;

--
-- Name: _car_makerstoyear; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _car_makerstoyear (
    car_makers_id integer NOT NULL,
    year integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _car_makerstoyear OWNER TO afariha;

--
-- Name: _cars_datatofullname; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _cars_datatofullname (
    cars_data_id integer NOT NULL,
    fullname text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _cars_datatofullname OWNER TO afariha;

--
-- Name: _countriestofullname; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _countriestofullname (
    countries_countryid integer NOT NULL,
    fullname text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _countriestofullname OWNER TO afariha;

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
-- Name: _model_listtofullname; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _model_listtofullname (
    model_list_modelid integer NOT NULL,
    fullname text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _model_listtofullname OWNER TO afariha;

--
-- Name: car_makers; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE car_makers (
    id bigint NOT NULL,
    maker text,
    fullname text
);


ALTER TABLE car_makers OWNER TO afariha;

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
    year bigint,
    model text
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
-- Name: maker_to_car; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE maker_to_car (
    maker_id integer,
    car_id integer
);


ALTER TABLE maker_to_car OWNER TO afariha;

--
-- Name: maker_to_country; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE maker_to_country (
    maker_id integer,
    country_id integer
);


ALTER TABLE maker_to_country OWNER TO afariha;

--
-- Name: maker_to_model; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE maker_to_model (
    maker_id integer,
    model_id integer
);


ALTER TABLE maker_to_model OWNER TO afariha;

--
-- Name: model_list; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE model_list (
    modelid bigint NOT NULL,
    model text
);


ALTER TABLE model_list OWNER TO afariha;

--
-- Name: _invertedcolumnindex _invertedcolumnindex_word_tabname_colname_key; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _invertedcolumnindex
    ADD CONSTRAINT _invertedcolumnindex_word_tabname_colname_key UNIQUE (word, tabname, colname);


--
-- Name: continents idx_64283_continents_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY continents
    ADD CONSTRAINT idx_64283_continents_pkey PRIMARY KEY (contid);


--
-- Name: countries idx_64289_countries_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY countries
    ADD CONSTRAINT idx_64289_countries_pkey PRIMARY KEY (countryid);


--
-- Name: car_makers idx_64295_car_makers_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY car_makers
    ADD CONSTRAINT idx_64295_car_makers_pkey PRIMARY KEY (id);


--
-- Name: model_list idx_64301_model_list_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY model_list
    ADD CONSTRAINT idx_64301_model_list_pkey PRIMARY KEY (modelid);


--
-- Name: cars_data idx_64313_cars_data_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY cars_data
    ADD CONSTRAINT idx_64313_cars_data_pkey PRIMARY KEY (id);


--
-- Name: _aggr_aoo_maker_to_car_car_idtomaker_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_maker_to_car_car_idtomaker_id_idx ON _aggr_aoo_maker_to_car_car_idtomaker_id USING btree (car_id);


--
-- Name: _aggr_aoo_maker_to_car_maker_idtocar_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_maker_to_car_maker_idtocar_id_idx ON _aggr_aoo_maker_to_car_maker_idtocar_id USING btree (maker_id);


--
-- Name: _aggr_aoo_maker_to_country_country_idtomaker_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_maker_to_country_country_idtomaker_id_idx ON _aggr_aoo_maker_to_country_country_idtomaker_id USING btree (country_id);


--
-- Name: _aggr_aoo_maker_to_country_maker_idtocountry_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_maker_to_country_maker_idtocountry_id_idx ON _aggr_aoo_maker_to_country_maker_idtocountry_id USING btree (maker_id);


--
-- Name: _aggr_aoo_maker_to_model_maker_idtomodel_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_maker_to_model_maker_idtomodel_id_idx ON _aggr_aoo_maker_to_model_maker_idtomodel_id USING btree (maker_id);


--
-- Name: _aggr_aoo_maker_to_model_model_idtomaker_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_maker_to_model_model_idtomaker_id_idx ON _aggr_aoo_maker_to_model_model_idtomaker_id USING btree (model_id);


--
-- Name: _car_makerstoaccelerate_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _car_makerstoaccelerate_idx ON _car_makerstoaccelerate USING btree (accelerate, freq);

ALTER TABLE _car_makerstoaccelerate CLUSTER ON _car_makerstoaccelerate_idx;


--
-- Name: _car_makerstoaccelerate_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _car_makerstoaccelerate_idx_2 ON _car_makerstoaccelerate USING btree (car_makers_id);


--
-- Name: _car_makerstocontinent_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _car_makerstocontinent_idx ON _car_makerstocontinent USING btree (continent, freq);

ALTER TABLE _car_makerstocontinent CLUSTER ON _car_makerstocontinent_idx;


--
-- Name: _car_makerstocontinent_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _car_makerstocontinent_idx_2 ON _car_makerstocontinent USING btree (car_makers_id);


--
-- Name: _car_makerstocylinders_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _car_makerstocylinders_idx ON _car_makerstocylinders USING btree (cylinders, freq);

ALTER TABLE _car_makerstocylinders CLUSTER ON _car_makerstocylinders_idx;


--
-- Name: _car_makerstocylinders_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _car_makerstocylinders_idx_2 ON _car_makerstocylinders USING btree (car_makers_id);


--
-- Name: _car_makerstoedispl_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _car_makerstoedispl_idx ON _car_makerstoedispl USING btree (edispl, freq);

ALTER TABLE _car_makerstoedispl CLUSTER ON _car_makerstoedispl_idx;


--
-- Name: _car_makerstoedispl_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _car_makerstoedispl_idx_2 ON _car_makerstoedispl USING btree (car_makers_id);


--
-- Name: _car_makerstohorsepower_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _car_makerstohorsepower_idx ON _car_makerstohorsepower USING btree (horsepower, freq);

ALTER TABLE _car_makerstohorsepower CLUSTER ON _car_makerstohorsepower_idx;


--
-- Name: _car_makerstohorsepower_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _car_makerstohorsepower_idx_2 ON _car_makerstohorsepower USING btree (car_makers_id);


--
-- Name: _car_makerstompg_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _car_makerstompg_idx ON _car_makerstompg USING btree (mpg, freq);

ALTER TABLE _car_makerstompg CLUSTER ON _car_makerstompg_idx;


--
-- Name: _car_makerstompg_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _car_makerstompg_idx_2 ON _car_makerstompg USING btree (car_makers_id);


--
-- Name: _car_makerstoweight_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _car_makerstoweight_idx ON _car_makerstoweight USING btree (weight, freq);

ALTER TABLE _car_makerstoweight CLUSTER ON _car_makerstoweight_idx;


--
-- Name: _car_makerstoweight_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _car_makerstoweight_idx_2 ON _car_makerstoweight USING btree (car_makers_id);


--
-- Name: _car_makerstoyear_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _car_makerstoyear_idx ON _car_makerstoyear USING btree (year, freq);

ALTER TABLE _car_makerstoyear CLUSTER ON _car_makerstoyear_idx;


--
-- Name: _car_makerstoyear_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _car_makerstoyear_idx_2 ON _car_makerstoyear USING btree (car_makers_id);


--
-- Name: _cars_datatofullname_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _cars_datatofullname_idx ON _cars_datatofullname USING btree (fullname, freq);

ALTER TABLE _cars_datatofullname CLUSTER ON _cars_datatofullname_idx;


--
-- Name: _cars_datatofullname_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _cars_datatofullname_idx_2 ON _cars_datatofullname USING btree (cars_data_id);


--
-- Name: _countriestofullname_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _countriestofullname_idx ON _countriestofullname USING btree (fullname, freq);

ALTER TABLE _countriestofullname CLUSTER ON _countriestofullname_idx;


--
-- Name: _countriestofullname_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _countriestofullname_idx_2 ON _countriestofullname USING btree (countries_countryid);


--
-- Name: _invertedcolumnindex_word_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _invertedcolumnindex_word_idx ON _invertedcolumnindex USING btree (word);

ALTER TABLE _invertedcolumnindex CLUSTER ON _invertedcolumnindex_word_idx;


--
-- Name: _model_listtofullname_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _model_listtofullname_idx ON _model_listtofullname USING btree (fullname, freq);

ALTER TABLE _model_listtofullname CLUSTER ON _model_listtofullname_idx;


--
-- Name: _model_listtofullname_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _model_listtofullname_idx_2 ON _model_listtofullname USING btree (model_list_modelid);


--
-- Name: idx_64301_sqlite_autoindex_model_list_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_64301_sqlite_autoindex_model_list_1 ON model_list USING btree (model);


--
-- Name: _aggr_aoo_maker_to_car_car_idtomaker_id _aggr_aoo_maker_to_car_car_idtomaker_id_car_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_maker_to_car_car_idtomaker_id
    ADD CONSTRAINT _aggr_aoo_maker_to_car_car_idtomaker_id_car_id_fk FOREIGN KEY (car_id) REFERENCES cars_data(id);


--
-- Name: _aggr_aoo_maker_to_car_maker_idtocar_id _aggr_aoo_maker_to_car_maker_idtocar_id_maker_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_maker_to_car_maker_idtocar_id
    ADD CONSTRAINT _aggr_aoo_maker_to_car_maker_idtocar_id_maker_id_fk FOREIGN KEY (maker_id) REFERENCES car_makers(id);


--
-- Name: _aggr_aoo_maker_to_country_country_idtomaker_id _aggr_aoo_maker_to_country_country_idtomaker_id_country_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_maker_to_country_country_idtomaker_id
    ADD CONSTRAINT _aggr_aoo_maker_to_country_country_idtomaker_id_country_id_fk FOREIGN KEY (country_id) REFERENCES countries(countryid);


--
-- Name: _aggr_aoo_maker_to_country_maker_idtocountry_id _aggr_aoo_maker_to_country_maker_idtocountry_id_maker_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_maker_to_country_maker_idtocountry_id
    ADD CONSTRAINT _aggr_aoo_maker_to_country_maker_idtocountry_id_maker_id_fk FOREIGN KEY (maker_id) REFERENCES car_makers(id);


--
-- Name: _aggr_aoo_maker_to_model_maker_idtomodel_id _aggr_aoo_maker_to_model_maker_idtomodel_id_maker_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_maker_to_model_maker_idtomodel_id
    ADD CONSTRAINT _aggr_aoo_maker_to_model_maker_idtomodel_id_maker_id_fk FOREIGN KEY (maker_id) REFERENCES car_makers(id);


--
-- Name: _aggr_aoo_maker_to_model_model_idtomaker_id _aggr_aoo_maker_to_model_model_idtomaker_id_model_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_maker_to_model_model_idtomaker_id
    ADD CONSTRAINT _aggr_aoo_maker_to_model_model_idtomaker_id_model_id_fk FOREIGN KEY (model_id) REFERENCES model_list(modelid);


--
-- Name: _car_makerstoaccelerate _car_makerstoaccelerate_car_makers_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _car_makerstoaccelerate
    ADD CONSTRAINT _car_makerstoaccelerate_car_makers_id_fkey FOREIGN KEY (car_makers_id) REFERENCES car_makers(id);


--
-- Name: _car_makerstocontinent _car_makerstocontinent_car_makers_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _car_makerstocontinent
    ADD CONSTRAINT _car_makerstocontinent_car_makers_id_fkey FOREIGN KEY (car_makers_id) REFERENCES car_makers(id);


--
-- Name: _car_makerstocontinent _car_makerstocontinent_continent_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _car_makerstocontinent
    ADD CONSTRAINT _car_makerstocontinent_continent_fkey FOREIGN KEY (continent) REFERENCES continents(contid);


--
-- Name: _car_makerstocylinders _car_makerstocylinders_car_makers_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _car_makerstocylinders
    ADD CONSTRAINT _car_makerstocylinders_car_makers_id_fkey FOREIGN KEY (car_makers_id) REFERENCES car_makers(id);


--
-- Name: _car_makerstoedispl _car_makerstoedispl_car_makers_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _car_makerstoedispl
    ADD CONSTRAINT _car_makerstoedispl_car_makers_id_fkey FOREIGN KEY (car_makers_id) REFERENCES car_makers(id);


--
-- Name: _car_makerstohorsepower _car_makerstohorsepower_car_makers_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _car_makerstohorsepower
    ADD CONSTRAINT _car_makerstohorsepower_car_makers_id_fkey FOREIGN KEY (car_makers_id) REFERENCES car_makers(id);


--
-- Name: _car_makerstompg _car_makerstompg_car_makers_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _car_makerstompg
    ADD CONSTRAINT _car_makerstompg_car_makers_id_fkey FOREIGN KEY (car_makers_id) REFERENCES car_makers(id);


--
-- Name: _car_makerstoweight _car_makerstoweight_car_makers_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _car_makerstoweight
    ADD CONSTRAINT _car_makerstoweight_car_makers_id_fkey FOREIGN KEY (car_makers_id) REFERENCES car_makers(id);


--
-- Name: _car_makerstoyear _car_makerstoyear_car_makers_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _car_makerstoyear
    ADD CONSTRAINT _car_makerstoyear_car_makers_id_fkey FOREIGN KEY (car_makers_id) REFERENCES car_makers(id);


--
-- Name: _cars_datatofullname _cars_datatofullname_cars_data_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _cars_datatofullname
    ADD CONSTRAINT _cars_datatofullname_cars_data_id_fkey FOREIGN KEY (cars_data_id) REFERENCES cars_data(id);


--
-- Name: _countriestofullname _countriestofullname_countries_countryid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _countriestofullname
    ADD CONSTRAINT _countriestofullname_countries_countryid_fkey FOREIGN KEY (countries_countryid) REFERENCES countries(countryid);


--
-- Name: _model_listtofullname _model_listtofullname_model_list_modelid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _model_listtofullname
    ADD CONSTRAINT _model_listtofullname_model_list_modelid_fkey FOREIGN KEY (model_list_modelid) REFERENCES model_list(modelid);


--
-- Name: countries countries_continent_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY countries
    ADD CONSTRAINT countries_continent_fkey FOREIGN KEY (continent) REFERENCES continents(contid);


--
-- Name: maker_to_car maker_to_car_car_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY maker_to_car
    ADD CONSTRAINT maker_to_car_car_id_fkey FOREIGN KEY (car_id) REFERENCES cars_data(id);


--
-- Name: maker_to_car maker_to_car_maker_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY maker_to_car
    ADD CONSTRAINT maker_to_car_maker_id_fkey FOREIGN KEY (maker_id) REFERENCES car_makers(id);


--
-- Name: maker_to_country maker_to_country_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY maker_to_country
    ADD CONSTRAINT maker_to_country_country_id_fkey FOREIGN KEY (country_id) REFERENCES countries(countryid);


--
-- Name: maker_to_country maker_to_country_maker_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY maker_to_country
    ADD CONSTRAINT maker_to_country_maker_id_fkey FOREIGN KEY (maker_id) REFERENCES car_makers(id);


--
-- Name: maker_to_model maker_to_model_maker_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY maker_to_model
    ADD CONSTRAINT maker_to_model_maker_id_fkey FOREIGN KEY (maker_id) REFERENCES car_makers(id);


--
-- Name: maker_to_model maker_to_model_model_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY maker_to_model
    ADD CONSTRAINT maker_to_model_model_id_fkey FOREIGN KEY (model_id) REFERENCES model_list(modelid);


--
-- PostgreSQL database dump complete
--

