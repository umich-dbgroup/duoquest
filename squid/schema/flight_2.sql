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
-- Name: _aggr_aoo_airline_to_abbrev_abbrev_idtoairline_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_airline_to_abbrev_abbrev_idtoairline_id (
    abbrev_id integer,
    airline_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_airline_to_abbrev_abbrev_idtoairline_id OWNER TO afariha;

--
-- Name: _aggr_aoo_airline_to_abbrev_airline_idtoabbrev_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_airline_to_abbrev_airline_idtoabbrev_id (
    airline_id integer,
    abbrev_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_airline_to_abbrev_airline_idtoabbrev_id OWNER TO afariha;

--
-- Name: _aggr_aoo_airline_to_country_airline_idtocountry_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_airline_to_country_airline_idtocountry_id (
    airline_id integer,
    country_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_airline_to_country_airline_idtocountry_id OWNER TO afariha;

--
-- Name: _aggr_aoo_airline_to_country_country_idtoairline_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_airline_to_country_country_idtoairline_id (
    country_id integer,
    airline_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_airline_to_country_country_idtoairline_id OWNER TO afariha;

--
-- Name: _aggr_aoo_flights_airlinetodestairport_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_flights_airlinetodestairport_id (
    airline bigint,
    destairport_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_flights_airlinetodestairport_id OWNER TO afariha;

--
-- Name: _aggr_aoo_flights_airlinetosourceairport_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_flights_airlinetosourceairport_id (
    airline bigint,
    sourceairport_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_flights_airlinetosourceairport_id OWNER TO afariha;

--
-- Name: _aggr_aoo_flights_destairport_idtoairline; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_flights_destairport_idtoairline (
    destairport_id integer,
    airline_aggr bigint[],
    count bigint
);


ALTER TABLE _aggr_aoo_flights_destairport_idtoairline OWNER TO afariha;

--
-- Name: _aggr_aoo_flights_destairport_idtosourceairport_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_flights_destairport_idtosourceairport_id (
    destairport_id integer,
    sourceairport_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_flights_destairport_idtosourceairport_id OWNER TO afariha;

--
-- Name: _aggr_aoo_flights_sourceairport_idtoairline; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_flights_sourceairport_idtoairline (
    sourceairport_id integer,
    airline_aggr bigint[],
    count bigint
);


ALTER TABLE _aggr_aoo_flights_sourceairport_idtoairline OWNER TO afariha;

--
-- Name: _aggr_aoo_flights_sourceairport_idtodestairport_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_flights_sourceairport_idtodestairport_id (
    sourceairport_id integer,
    destairport_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_flights_sourceairport_idtodestairport_id OWNER TO afariha;

--
-- Name: _airlinestoairportcode; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _airlinestoairportcode (
    airlines_uid integer NOT NULL,
    airportcode text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _airlinestoairportcode OWNER TO afariha;

--
-- Name: _airlinestocity; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _airlinestocity (
    airlines_uid integer NOT NULL,
    city text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _airlinestocity OWNER TO afariha;

--
-- Name: _airlinestocountry; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _airlinestocountry (
    airlines_uid integer NOT NULL,
    country text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _airlinestocountry OWNER TO afariha;

--
-- Name: _airlinestocountryabbrev; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _airlinestocountryabbrev (
    airlines_uid integer NOT NULL,
    countryabbrev text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _airlinestocountryabbrev OWNER TO afariha;

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
-- Name: airline_abbrev; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE airline_abbrev (
    id integer NOT NULL,
    abbrev text
);


ALTER TABLE airline_abbrev OWNER TO afariha;

--
-- Name: airline_abbrev_id_seq; Type: SEQUENCE; Schema: public; Owner: afariha
--

CREATE SEQUENCE airline_abbrev_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE airline_abbrev_id_seq OWNER TO afariha;

--
-- Name: airline_abbrev_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: afariha
--

ALTER SEQUENCE airline_abbrev_id_seq OWNED BY airline_abbrev.id;


--
-- Name: airline_country; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE airline_country (
    id integer NOT NULL,
    name text
);


ALTER TABLE airline_country OWNER TO afariha;

--
-- Name: airline_country_id_seq; Type: SEQUENCE; Schema: public; Owner: afariha
--

CREATE SEQUENCE airline_country_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE airline_country_id_seq OWNER TO afariha;

--
-- Name: airline_country_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: afariha
--

ALTER SEQUENCE airline_country_id_seq OWNED BY airline_country.id;


--
-- Name: airline_to_abbrev; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE airline_to_abbrev (
    airline_id integer,
    abbrev_id integer
);


ALTER TABLE airline_to_abbrev OWNER TO afariha;

--
-- Name: airline_to_country; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE airline_to_country (
    airline_id integer,
    country_id integer
);


ALTER TABLE airline_to_country OWNER TO afariha;

--
-- Name: airlines; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE airlines (
    uid bigint NOT NULL,
    airline text
);


ALTER TABLE airlines OWNER TO afariha;

--
-- Name: airports; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE airports (
    city text,
    airportcode text,
    airportname text,
    country text,
    countryabbrev text,
    airport_id integer NOT NULL
);


ALTER TABLE airports OWNER TO afariha;

--
-- Name: airports_airport_id_seq; Type: SEQUENCE; Schema: public; Owner: afariha
--

CREATE SEQUENCE airports_airport_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE airports_airport_id_seq OWNER TO afariha;

--
-- Name: airports_airport_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: afariha
--

ALTER SEQUENCE airports_airport_id_seq OWNED BY airports.airport_id;


--
-- Name: flights; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE flights (
    airline bigint NOT NULL,
    flightno bigint NOT NULL,
    sourceairport_id integer,
    destairport_id integer
);


ALTER TABLE flights OWNER TO afariha;

--
-- Name: airline_abbrev id; Type: DEFAULT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY airline_abbrev ALTER COLUMN id SET DEFAULT nextval('airline_abbrev_id_seq'::regclass);


--
-- Name: airline_country id; Type: DEFAULT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY airline_country ALTER COLUMN id SET DEFAULT nextval('airline_country_id_seq'::regclass);


--
-- Name: airports airport_id; Type: DEFAULT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY airports ALTER COLUMN airport_id SET DEFAULT nextval('airports_airport_id_seq'::regclass);


--
-- Name: _invertedcolumnindex _invertedcolumnindex_word_tabname_colname_key; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _invertedcolumnindex
    ADD CONSTRAINT _invertedcolumnindex_word_tabname_colname_key UNIQUE (word, tabname, colname);


--
-- Name: airline_abbrev airline_abbrev_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY airline_abbrev
    ADD CONSTRAINT airline_abbrev_pkey PRIMARY KEY (id);


--
-- Name: airline_country airline_country_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY airline_country
    ADD CONSTRAINT airline_country_pkey PRIMARY KEY (id);


--
-- Name: airports airports_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY airports
    ADD CONSTRAINT airports_pkey PRIMARY KEY (airport_id);


--
-- Name: airlines idx_64909_airlines_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY airlines
    ADD CONSTRAINT idx_64909_airlines_pkey PRIMARY KEY (uid);


--
-- Name: flights idx_64921_flights_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY flights
    ADD CONSTRAINT idx_64921_flights_pkey PRIMARY KEY (airline, flightno);


--
-- Name: _aggr_aoo_airline_to_abbrev_abbrev_idtoairline_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_airline_to_abbrev_abbrev_idtoairline_id_idx ON _aggr_aoo_airline_to_abbrev_abbrev_idtoairline_id USING btree (abbrev_id);


--
-- Name: _aggr_aoo_airline_to_abbrev_airline_idtoabbrev_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_airline_to_abbrev_airline_idtoabbrev_id_idx ON _aggr_aoo_airline_to_abbrev_airline_idtoabbrev_id USING btree (airline_id);


--
-- Name: _aggr_aoo_airline_to_country_airline_idtocountry_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_airline_to_country_airline_idtocountry_id_idx ON _aggr_aoo_airline_to_country_airline_idtocountry_id USING btree (airline_id);


--
-- Name: _aggr_aoo_airline_to_country_country_idtoairline_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_airline_to_country_country_idtoairline_id_idx ON _aggr_aoo_airline_to_country_country_idtoairline_id USING btree (country_id);


--
-- Name: _aggr_aoo_flights_airlinetodestairport_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_flights_airlinetodestairport_id_idx ON _aggr_aoo_flights_airlinetodestairport_id USING btree (airline);


--
-- Name: _aggr_aoo_flights_airlinetosourceairport_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_flights_airlinetosourceairport_id_idx ON _aggr_aoo_flights_airlinetosourceairport_id USING btree (airline);


--
-- Name: _aggr_aoo_flights_destairport_idtoairline_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_flights_destairport_idtoairline_idx ON _aggr_aoo_flights_destairport_idtoairline USING btree (destairport_id);


--
-- Name: _aggr_aoo_flights_destairport_idtosourceairport_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_flights_destairport_idtosourceairport_id_idx ON _aggr_aoo_flights_destairport_idtosourceairport_id USING btree (destairport_id);


--
-- Name: _aggr_aoo_flights_sourceairport_idtoairline_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_flights_sourceairport_idtoairline_idx ON _aggr_aoo_flights_sourceairport_idtoairline USING btree (sourceairport_id);


--
-- Name: _aggr_aoo_flights_sourceairport_idtodestairport_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_flights_sourceairport_idtodestairport_id_idx ON _aggr_aoo_flights_sourceairport_idtodestairport_id USING btree (sourceairport_id);


--
-- Name: _airlinestoairportcode_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _airlinestoairportcode_idx ON _airlinestoairportcode USING btree (airportcode, freq);

ALTER TABLE _airlinestoairportcode CLUSTER ON _airlinestoairportcode_idx;


--
-- Name: _airlinestoairportcode_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _airlinestoairportcode_idx_2 ON _airlinestoairportcode USING btree (airlines_uid);


--
-- Name: _airlinestocity_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _airlinestocity_idx ON _airlinestocity USING btree (city, freq);

ALTER TABLE _airlinestocity CLUSTER ON _airlinestocity_idx;


--
-- Name: _airlinestocity_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _airlinestocity_idx_2 ON _airlinestocity USING btree (airlines_uid);


--
-- Name: _airlinestocountry_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _airlinestocountry_idx ON _airlinestocountry USING btree (country, freq);

ALTER TABLE _airlinestocountry CLUSTER ON _airlinestocountry_idx;


--
-- Name: _airlinestocountry_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _airlinestocountry_idx_2 ON _airlinestocountry USING btree (airlines_uid);


--
-- Name: _airlinestocountryabbrev_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _airlinestocountryabbrev_idx ON _airlinestocountryabbrev USING btree (countryabbrev, freq);

ALTER TABLE _airlinestocountryabbrev CLUSTER ON _airlinestocountryabbrev_idx;


--
-- Name: _airlinestocountryabbrev_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _airlinestocountryabbrev_idx_2 ON _airlinestocountryabbrev USING btree (airlines_uid);


--
-- Name: _invertedcolumnindex_word_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _invertedcolumnindex_word_idx ON _invertedcolumnindex USING btree (word);

ALTER TABLE _invertedcolumnindex CLUSTER ON _invertedcolumnindex_word_idx;


--
-- Name: idx_64915_sqlite_autoindex_airports_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_64915_sqlite_autoindex_airports_1 ON airports USING btree (airportcode);


--
-- Name: idx_64921_sqlite_autoindex_flights_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_64921_sqlite_autoindex_flights_1 ON flights USING btree (airline, flightno);


--
-- Name: _aggr_aoo_airline_to_abbrev_abbrev_idtoairline_id _aggr_aoo_airline_to_abbrev_abbrev_idtoairline_id_abbrev_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_airline_to_abbrev_abbrev_idtoairline_id
    ADD CONSTRAINT _aggr_aoo_airline_to_abbrev_abbrev_idtoairline_id_abbrev_id_fk FOREIGN KEY (abbrev_id) REFERENCES airline_abbrev(id);


--
-- Name: _aggr_aoo_airline_to_abbrev_airline_idtoabbrev_id _aggr_aoo_airline_to_abbrev_airline_idtoabbrev_id_airline_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_airline_to_abbrev_airline_idtoabbrev_id
    ADD CONSTRAINT _aggr_aoo_airline_to_abbrev_airline_idtoabbrev_id_airline_id_fk FOREIGN KEY (airline_id) REFERENCES airlines(uid);


--
-- Name: _aggr_aoo_airline_to_country_airline_idtocountry_id _aggr_aoo_airline_to_country_airline_idtocountry_id_airline_id_; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_airline_to_country_airline_idtocountry_id
    ADD CONSTRAINT _aggr_aoo_airline_to_country_airline_idtocountry_id_airline_id_ FOREIGN KEY (airline_id) REFERENCES airlines(uid);


--
-- Name: _aggr_aoo_airline_to_country_country_idtoairline_id _aggr_aoo_airline_to_country_country_idtoairline_id_country_id_; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_airline_to_country_country_idtoairline_id
    ADD CONSTRAINT _aggr_aoo_airline_to_country_country_idtoairline_id_country_id_ FOREIGN KEY (country_id) REFERENCES airline_country(id);


--
-- Name: _aggr_aoo_flights_airlinetodestairport_id _aggr_aoo_flights_airlinetodestairport_id_airline_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_flights_airlinetodestairport_id
    ADD CONSTRAINT _aggr_aoo_flights_airlinetodestairport_id_airline_fk FOREIGN KEY (airline) REFERENCES airlines(uid);


--
-- Name: _aggr_aoo_flights_airlinetosourceairport_id _aggr_aoo_flights_airlinetosourceairport_id_airline_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_flights_airlinetosourceairport_id
    ADD CONSTRAINT _aggr_aoo_flights_airlinetosourceairport_id_airline_fk FOREIGN KEY (airline) REFERENCES airlines(uid);


--
-- Name: _aggr_aoo_flights_destairport_idtoairline _aggr_aoo_flights_destairport_idtoairline_destairport_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_flights_destairport_idtoairline
    ADD CONSTRAINT _aggr_aoo_flights_destairport_idtoairline_destairport_id_fk FOREIGN KEY (destairport_id) REFERENCES airports(airport_id);


--
-- Name: _aggr_aoo_flights_destairport_idtosourceairport_id _aggr_aoo_flights_destairport_idtosourceairport_id_destairport_; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_flights_destairport_idtosourceairport_id
    ADD CONSTRAINT _aggr_aoo_flights_destairport_idtosourceairport_id_destairport_ FOREIGN KEY (destairport_id) REFERENCES airports(airport_id);


--
-- Name: _aggr_aoo_flights_sourceairport_idtoairline _aggr_aoo_flights_sourceairport_idtoairline_sourceairport_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_flights_sourceairport_idtoairline
    ADD CONSTRAINT _aggr_aoo_flights_sourceairport_idtoairline_sourceairport_id_fk FOREIGN KEY (sourceairport_id) REFERENCES airports(airport_id);


--
-- Name: _aggr_aoo_flights_sourceairport_idtodestairport_id _aggr_aoo_flights_sourceairport_idtodestairport_id_sourceairpor; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_flights_sourceairport_idtodestairport_id
    ADD CONSTRAINT _aggr_aoo_flights_sourceairport_idtodestairport_id_sourceairpor FOREIGN KEY (sourceairport_id) REFERENCES airports(airport_id);


--
-- Name: _airlinestoairportcode _airlinestoairportcode_airlines_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _airlinestoairportcode
    ADD CONSTRAINT _airlinestoairportcode_airlines_uid_fkey FOREIGN KEY (airlines_uid) REFERENCES airlines(uid);


--
-- Name: _airlinestocity _airlinestocity_airlines_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _airlinestocity
    ADD CONSTRAINT _airlinestocity_airlines_uid_fkey FOREIGN KEY (airlines_uid) REFERENCES airlines(uid);


--
-- Name: _airlinestocountry _airlinestocountry_airlines_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _airlinestocountry
    ADD CONSTRAINT _airlinestocountry_airlines_uid_fkey FOREIGN KEY (airlines_uid) REFERENCES airlines(uid);


--
-- Name: _airlinestocountryabbrev _airlinestocountryabbrev_airlines_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _airlinestocountryabbrev
    ADD CONSTRAINT _airlinestocountryabbrev_airlines_uid_fkey FOREIGN KEY (airlines_uid) REFERENCES airlines(uid);


--
-- Name: airline_to_abbrev airline_to_abbrev_abbrev_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY airline_to_abbrev
    ADD CONSTRAINT airline_to_abbrev_abbrev_id_fkey FOREIGN KEY (abbrev_id) REFERENCES airline_abbrev(id);


--
-- Name: airline_to_abbrev airline_to_abbrev_airline_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY airline_to_abbrev
    ADD CONSTRAINT airline_to_abbrev_airline_id_fkey FOREIGN KEY (airline_id) REFERENCES airlines(uid);


--
-- Name: airline_to_country airline_to_country_airline_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY airline_to_country
    ADD CONSTRAINT airline_to_country_airline_id_fkey FOREIGN KEY (airline_id) REFERENCES airlines(uid);


--
-- Name: airline_to_country airline_to_country_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY airline_to_country
    ADD CONSTRAINT airline_to_country_country_id_fkey FOREIGN KEY (country_id) REFERENCES airline_country(id);


--
-- Name: flights flights_airline_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY flights
    ADD CONSTRAINT flights_airline_fk FOREIGN KEY (airline) REFERENCES airlines(uid);


--
-- Name: flights flights_dest_airport_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY flights
    ADD CONSTRAINT flights_dest_airport_fk FOREIGN KEY (destairport_id) REFERENCES airports(airport_id);


--
-- Name: flights flights_source_airport_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY flights
    ADD CONSTRAINT flights_source_airport_fk FOREIGN KEY (sourceairport_id) REFERENCES airports(airport_id);


--
-- PostgreSQL database dump complete
--

