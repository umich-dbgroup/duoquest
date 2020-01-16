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
    airportcode text NOT NULL,
    airportname text,
    country text,
    countryabbrev text
);


ALTER TABLE airports OWNER TO afariha;

--
-- Name: flights; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE flights (
    airline bigint NOT NULL,
    flightno bigint NOT NULL,
    sourceairport text,
    destairport text
);


ALTER TABLE flights OWNER TO afariha;

--
-- Name: airports airports_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY airports
    ADD CONSTRAINT airports_pkey PRIMARY KEY (airportcode);


--
-- Name: airlines idx_44861_airlines_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY airlines
    ADD CONSTRAINT idx_44861_airlines_pkey PRIMARY KEY (uid);


--
-- Name: flights idx_44873_flights_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY flights
    ADD CONSTRAINT idx_44873_flights_pkey PRIMARY KEY (airline, flightno);


--
-- Name: idx_44867_sqlite_autoindex_airports_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_44867_sqlite_autoindex_airports_1 ON airports USING btree (airportcode);


--
-- Name: idx_44873_sqlite_autoindex_flights_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_44873_sqlite_autoindex_flights_1 ON flights USING btree (airline, flightno);


--
-- PostgreSQL database dump complete
--

