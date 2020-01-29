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
-- Name: _aggr_aoo_city_to_country_city_idtocountry_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_city_to_country_city_idtocountry_id (
    city_id integer,
    country_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_city_to_country_city_idtocountry_id OWNER TO afariha;

--
-- Name: _aggr_aoo_city_to_country_country_idtocity_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_city_to_country_country_idtocity_id (
    country_id integer,
    city_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_city_to_country_country_idtocity_id OWNER TO afariha;

--
-- Name: _aggr_aoo_country_to_continent_continent_idtocountry_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_country_to_continent_continent_idtocountry_id (
    continent_id integer,
    country_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_country_to_continent_continent_idtocountry_id OWNER TO afariha;

--
-- Name: _aggr_aoo_country_to_continent_country_idtocontinent_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_country_to_continent_country_idtocontinent_id (
    country_id integer,
    continent_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_country_to_continent_country_idtocontinent_id OWNER TO afariha;

--
-- Name: _aggr_aoo_country_to_language_country_idtolanguage_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_country_to_language_country_idtolanguage_id (
    country_id integer,
    language_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_country_to_language_country_idtolanguage_id OWNER TO afariha;

--
-- Name: _aggr_aoo_country_to_language_language_idtocountry_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_country_to_language_language_idtocountry_id (
    language_id integer,
    country_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_country_to_language_language_idtocountry_id OWNER TO afariha;

--
-- Name: _aggr_aoo_country_to_region_country_idtoregion_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_country_to_region_country_idtoregion_id (
    country_id integer,
    region_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_country_to_region_country_idtoregion_id OWNER TO afariha;

--
-- Name: _aggr_aoo_country_to_region_region_idtocountry_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_country_to_region_region_idtocountry_id (
    region_id integer,
    country_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_country_to_region_region_idtocountry_id OWNER TO afariha;

--
-- Name: _citytoheadofstate; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _citytoheadofstate (
    city_id integer NOT NULL,
    headofstate text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _citytoheadofstate OWNER TO afariha;

--
-- Name: _continenttoheadofstate; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _continenttoheadofstate (
    continent_id integer NOT NULL,
    headofstate text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _continenttoheadofstate OWNER TO afariha;

--
-- Name: _countrylanguagetoheadofstate; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _countrylanguagetoheadofstate (
    countrylanguage_id integer NOT NULL,
    headofstate text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _countrylanguagetoheadofstate OWNER TO afariha;

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
-- Name: _regiontoheadofstate; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _regiontoheadofstate (
    region_id integer NOT NULL,
    headofstate text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _regiontoheadofstate OWNER TO afariha;

--
-- Name: city; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE city (
    id bigint NOT NULL,
    name text,
    district text,
    population bigint
);


ALTER TABLE city OWNER TO afariha;

--
-- Name: city_id_seq; Type: SEQUENCE; Schema: public; Owner: afariha
--

CREATE SEQUENCE city_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE city_id_seq OWNER TO afariha;

--
-- Name: city_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: afariha
--

ALTER SEQUENCE city_id_seq OWNED BY city.id;


--
-- Name: city_to_country; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE city_to_country (
    city_id integer,
    country_id integer
);


ALTER TABLE city_to_country OWNER TO afariha;

--
-- Name: continent; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE continent (
    id integer NOT NULL,
    continent text
);


ALTER TABLE continent OWNER TO afariha;

--
-- Name: continent_id_seq; Type: SEQUENCE; Schema: public; Owner: afariha
--

CREATE SEQUENCE continent_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE continent_id_seq OWNER TO afariha;

--
-- Name: continent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: afariha
--

ALTER SEQUENCE continent_id_seq OWNED BY continent.id;


--
-- Name: country; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE country (
    code text,
    name text,
    surfacearea double precision,
    indepyear bigint,
    population bigint,
    lifeexpectancy double precision,
    gnp double precision,
    gnpold double precision,
    localname text,
    governmentform text,
    headofstate text,
    capital bigint,
    code2 text,
    id integer NOT NULL
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
-- Name: country_to_continent; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE country_to_continent (
    country_id integer,
    continent_id integer
);


ALTER TABLE country_to_continent OWNER TO afariha;

--
-- Name: country_to_language; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE country_to_language (
    country_id integer,
    language_id integer
);


ALTER TABLE country_to_language OWNER TO afariha;

--
-- Name: country_to_region; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE country_to_region (
    country_id integer,
    region_id integer
);


ALTER TABLE country_to_region OWNER TO afariha;

--
-- Name: countrylanguage; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE countrylanguage (
    language text,
    isofficial text,
    percentage double precision,
    id integer NOT NULL
);


ALTER TABLE countrylanguage OWNER TO afariha;

--
-- Name: countrylanguage_id_seq; Type: SEQUENCE; Schema: public; Owner: afariha
--

CREATE SEQUENCE countrylanguage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE countrylanguage_id_seq OWNER TO afariha;

--
-- Name: countrylanguage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: afariha
--

ALTER SEQUENCE countrylanguage_id_seq OWNED BY countrylanguage.id;


--
-- Name: region; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE region (
    id integer NOT NULL,
    region text
);


ALTER TABLE region OWNER TO afariha;

--
-- Name: region_id_seq; Type: SEQUENCE; Schema: public; Owner: afariha
--

CREATE SEQUENCE region_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE region_id_seq OWNER TO afariha;

--
-- Name: region_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: afariha
--

ALTER SEQUENCE region_id_seq OWNED BY region.id;


--
-- Name: city id; Type: DEFAULT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY city ALTER COLUMN id SET DEFAULT nextval('city_id_seq'::regclass);


--
-- Name: continent id; Type: DEFAULT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY continent ALTER COLUMN id SET DEFAULT nextval('continent_id_seq'::regclass);


--
-- Name: country id; Type: DEFAULT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY country ALTER COLUMN id SET DEFAULT nextval('country_id_seq'::regclass);


--
-- Name: countrylanguage id; Type: DEFAULT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY countrylanguage ALTER COLUMN id SET DEFAULT nextval('countrylanguage_id_seq'::regclass);


--
-- Name: region id; Type: DEFAULT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY region ALTER COLUMN id SET DEFAULT nextval('region_id_seq'::regclass);


--
-- Name: _invertedcolumnindex _invertedcolumnindex_word_tabname_colname_key; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _invertedcolumnindex
    ADD CONSTRAINT _invertedcolumnindex_word_tabname_colname_key UNIQUE (word, tabname, colname);


--
-- Name: continent continent_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY continent
    ADD CONSTRAINT continent_pkey PRIMARY KEY (id);


--
-- Name: country country_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY country
    ADD CONSTRAINT country_pkey PRIMARY KEY (id);


--
-- Name: countrylanguage countrylanguage_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY countrylanguage
    ADD CONSTRAINT countrylanguage_pkey PRIMARY KEY (id);


--
-- Name: city idx_90715_city_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY city
    ADD CONSTRAINT idx_90715_city_pkey PRIMARY KEY (id);


--
-- Name: region region_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY region
    ADD CONSTRAINT region_pkey PRIMARY KEY (id);


--
-- Name: _aggr_aoo_city_to_country_city_idtocountry_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_city_to_country_city_idtocountry_id_idx ON _aggr_aoo_city_to_country_city_idtocountry_id USING btree (city_id);


--
-- Name: _aggr_aoo_city_to_country_country_idtocity_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_city_to_country_country_idtocity_id_idx ON _aggr_aoo_city_to_country_country_idtocity_id USING btree (country_id);


--
-- Name: _aggr_aoo_country_to_continent_continent_idtocountry_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_country_to_continent_continent_idtocountry_id_idx ON _aggr_aoo_country_to_continent_continent_idtocountry_id USING btree (continent_id);


--
-- Name: _aggr_aoo_country_to_continent_country_idtocontinent_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_country_to_continent_country_idtocontinent_id_idx ON _aggr_aoo_country_to_continent_country_idtocontinent_id USING btree (country_id);


--
-- Name: _aggr_aoo_country_to_language_country_idtolanguage_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_country_to_language_country_idtolanguage_id_idx ON _aggr_aoo_country_to_language_country_idtolanguage_id USING btree (country_id);


--
-- Name: _aggr_aoo_country_to_language_language_idtocountry_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_country_to_language_language_idtocountry_id_idx ON _aggr_aoo_country_to_language_language_idtocountry_id USING btree (language_id);


--
-- Name: _aggr_aoo_country_to_region_country_idtoregion_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_country_to_region_country_idtoregion_id_idx ON _aggr_aoo_country_to_region_country_idtoregion_id USING btree (country_id);


--
-- Name: _aggr_aoo_country_to_region_region_idtocountry_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_country_to_region_region_idtocountry_id_idx ON _aggr_aoo_country_to_region_region_idtocountry_id USING btree (region_id);


--
-- Name: _citytoheadofstate_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _citytoheadofstate_idx ON _citytoheadofstate USING btree (headofstate, freq);

ALTER TABLE _citytoheadofstate CLUSTER ON _citytoheadofstate_idx;


--
-- Name: _citytoheadofstate_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _citytoheadofstate_idx_2 ON _citytoheadofstate USING btree (city_id);


--
-- Name: _continenttoheadofstate_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _continenttoheadofstate_idx ON _continenttoheadofstate USING btree (headofstate, freq);

ALTER TABLE _continenttoheadofstate CLUSTER ON _continenttoheadofstate_idx;


--
-- Name: _continenttoheadofstate_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _continenttoheadofstate_idx_2 ON _continenttoheadofstate USING btree (continent_id);


--
-- Name: _countrylanguagetoheadofstate_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _countrylanguagetoheadofstate_idx ON _countrylanguagetoheadofstate USING btree (headofstate, freq);

ALTER TABLE _countrylanguagetoheadofstate CLUSTER ON _countrylanguagetoheadofstate_idx;


--
-- Name: _countrylanguagetoheadofstate_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _countrylanguagetoheadofstate_idx_2 ON _countrylanguagetoheadofstate USING btree (countrylanguage_id);


--
-- Name: _invertedcolumnindex_word_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _invertedcolumnindex_word_idx ON _invertedcolumnindex USING btree (word);

ALTER TABLE _invertedcolumnindex CLUSTER ON _invertedcolumnindex_word_idx;


--
-- Name: _regiontoheadofstate_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _regiontoheadofstate_idx ON _regiontoheadofstate USING btree (headofstate, freq);

ALTER TABLE _regiontoheadofstate CLUSTER ON _regiontoheadofstate_idx;


--
-- Name: _regiontoheadofstate_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _regiontoheadofstate_idx_2 ON _regiontoheadofstate USING btree (region_id);


--
-- Name: idx_90726_sqlite_autoindex_country_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_90726_sqlite_autoindex_country_1 ON country USING btree (code);


--
-- Name: _aggr_aoo_city_to_country_city_idtocountry_id _aggr_aoo_city_to_country_city_idtocountry_id_city_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_city_to_country_city_idtocountry_id
    ADD CONSTRAINT _aggr_aoo_city_to_country_city_idtocountry_id_city_id_fk FOREIGN KEY (city_id) REFERENCES city(id);


--
-- Name: _aggr_aoo_city_to_country_country_idtocity_id _aggr_aoo_city_to_country_country_idtocity_id_country_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_city_to_country_country_idtocity_id
    ADD CONSTRAINT _aggr_aoo_city_to_country_country_idtocity_id_country_id_fk FOREIGN KEY (country_id) REFERENCES country(id);


--
-- Name: _aggr_aoo_country_to_continent_continent_idtocountry_id _aggr_aoo_country_to_continent_continent_idtocountry_id_contine; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_country_to_continent_continent_idtocountry_id
    ADD CONSTRAINT _aggr_aoo_country_to_continent_continent_idtocountry_id_contine FOREIGN KEY (continent_id) REFERENCES continent(id);


--
-- Name: _aggr_aoo_country_to_continent_country_idtocontinent_id _aggr_aoo_country_to_continent_country_idtocontinent_id_country; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_country_to_continent_country_idtocontinent_id
    ADD CONSTRAINT _aggr_aoo_country_to_continent_country_idtocontinent_id_country FOREIGN KEY (country_id) REFERENCES country(id);


--
-- Name: _aggr_aoo_country_to_language_country_idtolanguage_id _aggr_aoo_country_to_language_country_idtolanguage_id_country_i; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_country_to_language_country_idtolanguage_id
    ADD CONSTRAINT _aggr_aoo_country_to_language_country_idtolanguage_id_country_i FOREIGN KEY (country_id) REFERENCES country(id);


--
-- Name: _aggr_aoo_country_to_language_language_idtocountry_id _aggr_aoo_country_to_language_language_idtocountry_id_language_; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_country_to_language_language_idtocountry_id
    ADD CONSTRAINT _aggr_aoo_country_to_language_language_idtocountry_id_language_ FOREIGN KEY (language_id) REFERENCES countrylanguage(id);


--
-- Name: _aggr_aoo_country_to_region_country_idtoregion_id _aggr_aoo_country_to_region_country_idtoregion_id_country_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_country_to_region_country_idtoregion_id
    ADD CONSTRAINT _aggr_aoo_country_to_region_country_idtoregion_id_country_id_fk FOREIGN KEY (country_id) REFERENCES country(id);


--
-- Name: _aggr_aoo_country_to_region_region_idtocountry_id _aggr_aoo_country_to_region_region_idtocountry_id_region_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_country_to_region_region_idtocountry_id
    ADD CONSTRAINT _aggr_aoo_country_to_region_region_idtocountry_id_region_id_fk FOREIGN KEY (region_id) REFERENCES region(id);


--
-- Name: _citytoheadofstate _citytoheadofstate_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _citytoheadofstate
    ADD CONSTRAINT _citytoheadofstate_city_id_fkey FOREIGN KEY (city_id) REFERENCES city(id);


--
-- Name: _continenttoheadofstate _continenttoheadofstate_continent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _continenttoheadofstate
    ADD CONSTRAINT _continenttoheadofstate_continent_id_fkey FOREIGN KEY (continent_id) REFERENCES continent(id);


--
-- Name: _countrylanguagetoheadofstate _countrylanguagetoheadofstate_countrylanguage_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _countrylanguagetoheadofstate
    ADD CONSTRAINT _countrylanguagetoheadofstate_countrylanguage_id_fkey FOREIGN KEY (countrylanguage_id) REFERENCES countrylanguage(id);


--
-- Name: _regiontoheadofstate _regiontoheadofstate_region_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _regiontoheadofstate
    ADD CONSTRAINT _regiontoheadofstate_region_id_fkey FOREIGN KEY (region_id) REFERENCES region(id);


--
-- Name: city_to_country city_to_country_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY city_to_country
    ADD CONSTRAINT city_to_country_city_id_fkey FOREIGN KEY (city_id) REFERENCES city(id);


--
-- Name: city_to_country city_to_country_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY city_to_country
    ADD CONSTRAINT city_to_country_country_id_fkey FOREIGN KEY (country_id) REFERENCES country(id);


--
-- Name: country_to_continent country_to_continent_continent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY country_to_continent
    ADD CONSTRAINT country_to_continent_continent_id_fkey FOREIGN KEY (continent_id) REFERENCES continent(id);


--
-- Name: country_to_continent country_to_continent_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY country_to_continent
    ADD CONSTRAINT country_to_continent_country_id_fkey FOREIGN KEY (country_id) REFERENCES country(id);


--
-- Name: country_to_language country_to_language_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY country_to_language
    ADD CONSTRAINT country_to_language_country_id_fkey FOREIGN KEY (country_id) REFERENCES country(id);


--
-- Name: country_to_language country_to_language_language_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY country_to_language
    ADD CONSTRAINT country_to_language_language_id_fkey FOREIGN KEY (language_id) REFERENCES countrylanguage(id);


--
-- Name: country_to_region country_to_region_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY country_to_region
    ADD CONSTRAINT country_to_region_country_id_fkey FOREIGN KEY (country_id) REFERENCES country(id);


--
-- Name: country_to_region country_to_region_region_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY country_to_region
    ADD CONSTRAINT country_to_region_region_id_fkey FOREIGN KEY (region_id) REFERENCES region(id);


--
-- PostgreSQL database dump complete
--

