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
-- Name: airlines; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE airlines (
    uid bigint NOT NULL,
    airline text,
    abbreviation text,
    country text
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
-- Name: airports airport_id; Type: DEFAULT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY airports ALTER COLUMN airport_id SET DEFAULT nextval('airports_airport_id_seq'::regclass);


--
-- Name: airports airports_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY airports
    ADD CONSTRAINT airports_pkey PRIMARY KEY (airport_id);


--
-- Name: airlines idx_45967_airlines_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY airlines
    ADD CONSTRAINT idx_45967_airlines_pkey PRIMARY KEY (uid);


--
-- Name: flights idx_45979_flights_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY flights
    ADD CONSTRAINT idx_45979_flights_pkey PRIMARY KEY (airline, flightno);


--
-- Name: idx_45973_sqlite_autoindex_airports_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_45973_sqlite_autoindex_airports_1 ON airports USING btree (airportcode);


--
-- Name: idx_45979_sqlite_autoindex_flights_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_45979_sqlite_autoindex_flights_1 ON flights USING btree (airline, flightno);


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

