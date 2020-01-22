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
-- Name: has_pet; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE has_pet (
    stuid bigint,
    petid bigint
);


ALTER TABLE has_pet OWNER TO afariha;

--
-- Name: pets; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE pets (
    petid bigint NOT NULL,
    pettype text,
    pet_age bigint,
    weight real
);


ALTER TABLE pets OWNER TO afariha;

--
-- Name: student; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE student (
    stuid bigint NOT NULL,
    lname text,
    fname text,
    age bigint,
    sex text,
    major bigint,
    advisor bigint,
    city_code text
);


ALTER TABLE student OWNER TO afariha;

--
-- Name: student idx_46501_student_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY student
    ADD CONSTRAINT idx_46501_student_pkey PRIMARY KEY (stuid);


--
-- Name: pets idx_46510_pets_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY pets
    ADD CONSTRAINT idx_46510_pets_pkey PRIMARY KEY (petid);


--
-- Name: has_pet has_pet_petid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY has_pet
    ADD CONSTRAINT has_pet_petid_fkey FOREIGN KEY (petid) REFERENCES pets(petid);


--
-- Name: has_pet has_pet_stuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY has_pet
    ADD CONSTRAINT has_pet_stuid_fkey FOREIGN KEY (stuid) REFERENCES student(stuid);


--
-- PostgreSQL database dump complete
--

