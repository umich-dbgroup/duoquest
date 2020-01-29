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
-- Name: _aggr_aoo_has_pet_petidtostuid; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_has_pet_petidtostuid (
    petid bigint,
    stuid_aggr bigint[],
    count bigint
);


ALTER TABLE _aggr_aoo_has_pet_petidtostuid OWNER TO afariha;

--
-- Name: _aggr_aoo_has_pet_stuidtopetid; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_has_pet_stuidtopetid (
    stuid bigint,
    petid_aggr bigint[],
    count bigint
);


ALTER TABLE _aggr_aoo_has_pet_stuidtopetid OWNER TO afariha;

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
-- Name: _petstoadvisor; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _petstoadvisor (
    pets_petid integer NOT NULL,
    advisor integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _petstoadvisor OWNER TO afariha;

--
-- Name: _petstoage; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _petstoage (
    pets_petid integer NOT NULL,
    age integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _petstoage OWNER TO afariha;

--
-- Name: _petstocity_code; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _petstocity_code (
    pets_petid integer NOT NULL,
    city_code text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _petstocity_code OWNER TO afariha;

--
-- Name: _petstofname; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _petstofname (
    pets_petid integer NOT NULL,
    fname text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _petstofname OWNER TO afariha;

--
-- Name: _petstomajor; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _petstomajor (
    pets_petid integer NOT NULL,
    major integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _petstomajor OWNER TO afariha;

--
-- Name: _petstosex; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _petstosex (
    pets_petid integer NOT NULL,
    sex text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _petstosex OWNER TO afariha;

--
-- Name: _studenttopet_age; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _studenttopet_age (
    student_stuid integer NOT NULL,
    pet_age integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _studenttopet_age OWNER TO afariha;

--
-- Name: _studenttoweight; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _studenttoweight (
    student_stuid integer NOT NULL,
    weight integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _studenttoweight OWNER TO afariha;

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
-- Name: _invertedcolumnindex _invertedcolumnindex_word_tabname_colname_key; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _invertedcolumnindex
    ADD CONSTRAINT _invertedcolumnindex_word_tabname_colname_key UNIQUE (word, tabname, colname);


--
-- Name: student idx_60486_student_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY student
    ADD CONSTRAINT idx_60486_student_pkey PRIMARY KEY (stuid);


--
-- Name: pets idx_60495_pets_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY pets
    ADD CONSTRAINT idx_60495_pets_pkey PRIMARY KEY (petid);


--
-- Name: _aggr_aoo_has_pet_petidtostuid_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_has_pet_petidtostuid_idx ON _aggr_aoo_has_pet_petidtostuid USING btree (petid);


--
-- Name: _aggr_aoo_has_pet_stuidtopetid_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_has_pet_stuidtopetid_idx ON _aggr_aoo_has_pet_stuidtopetid USING btree (stuid);


--
-- Name: _invertedcolumnindex_word_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _invertedcolumnindex_word_idx ON _invertedcolumnindex USING btree (word);

ALTER TABLE _invertedcolumnindex CLUSTER ON _invertedcolumnindex_word_idx;


--
-- Name: _petstoadvisor_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _petstoadvisor_idx ON _petstoadvisor USING btree (advisor, freq);

ALTER TABLE _petstoadvisor CLUSTER ON _petstoadvisor_idx;


--
-- Name: _petstoadvisor_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _petstoadvisor_idx_2 ON _petstoadvisor USING btree (pets_petid);


--
-- Name: _petstoage_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _petstoage_idx ON _petstoage USING btree (age, freq);

ALTER TABLE _petstoage CLUSTER ON _petstoage_idx;


--
-- Name: _petstoage_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _petstoage_idx_2 ON _petstoage USING btree (pets_petid);


--
-- Name: _petstocity_code_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _petstocity_code_idx ON _petstocity_code USING btree (city_code, freq);

ALTER TABLE _petstocity_code CLUSTER ON _petstocity_code_idx;


--
-- Name: _petstocity_code_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _petstocity_code_idx_2 ON _petstocity_code USING btree (pets_petid);


--
-- Name: _petstofname_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _petstofname_idx ON _petstofname USING btree (fname, freq);

ALTER TABLE _petstofname CLUSTER ON _petstofname_idx;


--
-- Name: _petstofname_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _petstofname_idx_2 ON _petstofname USING btree (pets_petid);


--
-- Name: _petstomajor_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _petstomajor_idx ON _petstomajor USING btree (major, freq);

ALTER TABLE _petstomajor CLUSTER ON _petstomajor_idx;


--
-- Name: _petstomajor_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _petstomajor_idx_2 ON _petstomajor USING btree (pets_petid);


--
-- Name: _petstosex_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _petstosex_idx ON _petstosex USING btree (sex, freq);

ALTER TABLE _petstosex CLUSTER ON _petstosex_idx;


--
-- Name: _petstosex_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _petstosex_idx_2 ON _petstosex USING btree (pets_petid);


--
-- Name: _studenttopet_age_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _studenttopet_age_idx ON _studenttopet_age USING btree (pet_age, freq);

ALTER TABLE _studenttopet_age CLUSTER ON _studenttopet_age_idx;


--
-- Name: _studenttopet_age_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _studenttopet_age_idx_2 ON _studenttopet_age USING btree (student_stuid);


--
-- Name: _studenttoweight_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _studenttoweight_idx ON _studenttoweight USING btree (weight, freq);

ALTER TABLE _studenttoweight CLUSTER ON _studenttoweight_idx;


--
-- Name: _studenttoweight_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _studenttoweight_idx_2 ON _studenttoweight USING btree (student_stuid);


--
-- Name: _aggr_aoo_has_pet_petidtostuid _aggr_aoo_has_pet_petidtostuid_petid_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_has_pet_petidtostuid
    ADD CONSTRAINT _aggr_aoo_has_pet_petidtostuid_petid_fk FOREIGN KEY (petid) REFERENCES pets(petid);


--
-- Name: _aggr_aoo_has_pet_stuidtopetid _aggr_aoo_has_pet_stuidtopetid_stuid_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_has_pet_stuidtopetid
    ADD CONSTRAINT _aggr_aoo_has_pet_stuidtopetid_stuid_fk FOREIGN KEY (stuid) REFERENCES student(stuid);


--
-- Name: _petstoadvisor _petstoadvisor_pets_petid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _petstoadvisor
    ADD CONSTRAINT _petstoadvisor_pets_petid_fkey FOREIGN KEY (pets_petid) REFERENCES pets(petid);


--
-- Name: _petstoage _petstoage_pets_petid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _petstoage
    ADD CONSTRAINT _petstoage_pets_petid_fkey FOREIGN KEY (pets_petid) REFERENCES pets(petid);


--
-- Name: _petstocity_code _petstocity_code_pets_petid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _petstocity_code
    ADD CONSTRAINT _petstocity_code_pets_petid_fkey FOREIGN KEY (pets_petid) REFERENCES pets(petid);


--
-- Name: _petstofname _petstofname_pets_petid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _petstofname
    ADD CONSTRAINT _petstofname_pets_petid_fkey FOREIGN KEY (pets_petid) REFERENCES pets(petid);


--
-- Name: _petstomajor _petstomajor_pets_petid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _petstomajor
    ADD CONSTRAINT _petstomajor_pets_petid_fkey FOREIGN KEY (pets_petid) REFERENCES pets(petid);


--
-- Name: _petstosex _petstosex_pets_petid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _petstosex
    ADD CONSTRAINT _petstosex_pets_petid_fkey FOREIGN KEY (pets_petid) REFERENCES pets(petid);


--
-- Name: _studenttopet_age _studenttopet_age_student_stuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _studenttopet_age
    ADD CONSTRAINT _studenttopet_age_student_stuid_fkey FOREIGN KEY (student_stuid) REFERENCES student(stuid);


--
-- Name: _studenttoweight _studenttoweight_student_stuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _studenttoweight
    ADD CONSTRAINT _studenttoweight_student_stuid_fkey FOREIGN KEY (student_stuid) REFERENCES student(stuid);


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

