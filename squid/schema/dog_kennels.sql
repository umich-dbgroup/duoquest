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
-- Name: _dogstocell_number; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _dogstocell_number (
    dogs_dog_id integer NOT NULL,
    cell_number text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _dogstocell_number OWNER TO afariha;

--
-- Name: _dogstocity; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _dogstocity (
    dogs_dog_id integer NOT NULL,
    city text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _dogstocity OWNER TO afariha;

--
-- Name: _dogstoemail_address; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _dogstoemail_address (
    dogs_dog_id integer NOT NULL,
    email_address text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _dogstoemail_address OWNER TO afariha;

--
-- Name: _dogstohome_phone; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _dogstohome_phone (
    dogs_dog_id integer NOT NULL,
    home_phone text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _dogstohome_phone OWNER TO afariha;

--
-- Name: _dogstolast_name; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _dogstolast_name (
    dogs_dog_id integer NOT NULL,
    last_name text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _dogstolast_name OWNER TO afariha;

--
-- Name: _dogstostate; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _dogstostate (
    dogs_dog_id integer NOT NULL,
    state text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _dogstostate OWNER TO afariha;

--
-- Name: _dogstostreet; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _dogstostreet (
    dogs_dog_id integer NOT NULL,
    street text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _dogstostreet OWNER TO afariha;

--
-- Name: _dogstozip_code; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _dogstozip_code (
    dogs_dog_id integer NOT NULL,
    zip_code text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _dogstozip_code OWNER TO afariha;

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
-- Name: _professionalstoabandoned_yn; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _professionalstoabandoned_yn (
    professionals_professional_id integer NOT NULL,
    abandoned_yn text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _professionalstoabandoned_yn OWNER TO afariha;

--
-- Name: _professionalstoage; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _professionalstoage (
    professionals_professional_id integer NOT NULL,
    age text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _professionalstoage OWNER TO afariha;

--
-- Name: _professionalstodate_adopted; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _professionalstodate_adopted (
    professionals_professional_id integer NOT NULL,
    date_adopted integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _professionalstodate_adopted OWNER TO afariha;

--
-- Name: _professionalstodate_arrived; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _professionalstodate_arrived (
    professionals_professional_id integer NOT NULL,
    date_arrived integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _professionalstodate_arrived OWNER TO afariha;

--
-- Name: _professionalstodate_departed; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _professionalstodate_departed (
    professionals_professional_id integer NOT NULL,
    date_departed integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _professionalstodate_departed OWNER TO afariha;

--
-- Name: _professionalstodate_of_birth; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _professionalstodate_of_birth (
    professionals_professional_id integer NOT NULL,
    date_of_birth integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _professionalstodate_of_birth OWNER TO afariha;

--
-- Name: _professionalstogender; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _professionalstogender (
    professionals_professional_id integer NOT NULL,
    gender text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _professionalstogender OWNER TO afariha;

--
-- Name: _professionalstoweight; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _professionalstoweight (
    professionals_professional_id integer NOT NULL,
    weight text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _professionalstoweight OWNER TO afariha;

--
-- Name: breeds; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE breeds (
    breed_code text NOT NULL,
    breed_name text
);


ALTER TABLE breeds OWNER TO afariha;

--
-- Name: charges; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE charges (
    charge_id bigint NOT NULL,
    charge_type text,
    charge_amount numeric(19,4)
);


ALTER TABLE charges OWNER TO afariha;

--
-- Name: dogs; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE dogs (
    dog_id bigint NOT NULL,
    owner_id bigint,
    abandoned_yn text,
    breed_code text,
    size_code text,
    name text,
    age text,
    date_of_birth text,
    gender text,
    weight text,
    date_arrived text,
    date_adopted text,
    date_departed text
);


ALTER TABLE dogs OWNER TO afariha;

--
-- Name: owners; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE owners (
    owner_id bigint NOT NULL,
    first_name text,
    last_name text,
    street text,
    city text,
    state text,
    zip_code text,
    email_address text,
    home_phone text,
    cell_number text
);


ALTER TABLE owners OWNER TO afariha;

--
-- Name: professionals; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE professionals (
    professional_id bigint NOT NULL,
    role_code text,
    first_name text,
    street text,
    city text,
    state text,
    zip_code text,
    last_name text,
    email_address text,
    home_phone text,
    cell_number text
);


ALTER TABLE professionals OWNER TO afariha;

--
-- Name: sizes; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE sizes (
    size_code text NOT NULL,
    size_description text
);


ALTER TABLE sizes OWNER TO afariha;

--
-- Name: treatment_types; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE treatment_types (
    treatment_type_code text NOT NULL,
    treatment_type_description text
);


ALTER TABLE treatment_types OWNER TO afariha;

--
-- Name: treatments; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE treatments (
    treatment_id bigint NOT NULL,
    dog_id bigint,
    professional_id bigint,
    treatment_type_code text,
    date_of_treatment text,
    cost_of_treatment numeric(19,4)
);


ALTER TABLE treatments OWNER TO afariha;

--
-- Name: _invertedcolumnindex _invertedcolumnindex_word_tabname_colname_key; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _invertedcolumnindex
    ADD CONSTRAINT _invertedcolumnindex_word_tabname_colname_key UNIQUE (word, tabname, colname);


--
-- Name: breeds idx_44088_sqlite_autoindex_breeds_1; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY breeds
    ADD CONSTRAINT idx_44088_sqlite_autoindex_breeds_1 PRIMARY KEY (breed_code);


--
-- Name: charges idx_44094_charges_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY charges
    ADD CONSTRAINT idx_44094_charges_pkey PRIMARY KEY (charge_id);


--
-- Name: sizes idx_44100_sqlite_autoindex_sizes_1; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY sizes
    ADD CONSTRAINT idx_44100_sqlite_autoindex_sizes_1 PRIMARY KEY (size_code);


--
-- Name: treatment_types idx_44106_sqlite_autoindex_treatment_types_1; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY treatment_types
    ADD CONSTRAINT idx_44106_sqlite_autoindex_treatment_types_1 PRIMARY KEY (treatment_type_code);


--
-- Name: owners idx_44112_owners_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY owners
    ADD CONSTRAINT idx_44112_owners_pkey PRIMARY KEY (owner_id);


--
-- Name: dogs idx_44118_dogs_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY dogs
    ADD CONSTRAINT idx_44118_dogs_pkey PRIMARY KEY (dog_id);


--
-- Name: professionals idx_44124_professionals_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY professionals
    ADD CONSTRAINT idx_44124_professionals_pkey PRIMARY KEY (professional_id);


--
-- Name: treatments idx_44130_treatments_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY treatments
    ADD CONSTRAINT idx_44130_treatments_pkey PRIMARY KEY (treatment_id);


--
-- Name: _dogstocell_number_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _dogstocell_number_idx ON _dogstocell_number USING btree (cell_number, freq);

ALTER TABLE _dogstocell_number CLUSTER ON _dogstocell_number_idx;


--
-- Name: _dogstocell_number_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _dogstocell_number_idx_2 ON _dogstocell_number USING btree (dogs_dog_id);


--
-- Name: _dogstocity_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _dogstocity_idx ON _dogstocity USING btree (city, freq);

ALTER TABLE _dogstocity CLUSTER ON _dogstocity_idx;


--
-- Name: _dogstocity_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _dogstocity_idx_2 ON _dogstocity USING btree (dogs_dog_id);


--
-- Name: _dogstoemail_address_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _dogstoemail_address_idx ON _dogstoemail_address USING btree (email_address, freq);

ALTER TABLE _dogstoemail_address CLUSTER ON _dogstoemail_address_idx;


--
-- Name: _dogstoemail_address_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _dogstoemail_address_idx_2 ON _dogstoemail_address USING btree (dogs_dog_id);


--
-- Name: _dogstohome_phone_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _dogstohome_phone_idx ON _dogstohome_phone USING btree (home_phone, freq);

ALTER TABLE _dogstohome_phone CLUSTER ON _dogstohome_phone_idx;


--
-- Name: _dogstohome_phone_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _dogstohome_phone_idx_2 ON _dogstohome_phone USING btree (dogs_dog_id);


--
-- Name: _dogstolast_name_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _dogstolast_name_idx ON _dogstolast_name USING btree (last_name, freq);

ALTER TABLE _dogstolast_name CLUSTER ON _dogstolast_name_idx;


--
-- Name: _dogstolast_name_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _dogstolast_name_idx_2 ON _dogstolast_name USING btree (dogs_dog_id);


--
-- Name: _dogstostate_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _dogstostate_idx ON _dogstostate USING btree (state, freq);

ALTER TABLE _dogstostate CLUSTER ON _dogstostate_idx;


--
-- Name: _dogstostate_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _dogstostate_idx_2 ON _dogstostate USING btree (dogs_dog_id);


--
-- Name: _dogstostreet_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _dogstostreet_idx ON _dogstostreet USING btree (street, freq);

ALTER TABLE _dogstostreet CLUSTER ON _dogstostreet_idx;


--
-- Name: _dogstostreet_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _dogstostreet_idx_2 ON _dogstostreet USING btree (dogs_dog_id);


--
-- Name: _dogstozip_code_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _dogstozip_code_idx ON _dogstozip_code USING btree (zip_code, freq);

ALTER TABLE _dogstozip_code CLUSTER ON _dogstozip_code_idx;


--
-- Name: _dogstozip_code_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _dogstozip_code_idx_2 ON _dogstozip_code USING btree (dogs_dog_id);


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
-- Name: _professionalstoabandoned_yn_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _professionalstoabandoned_yn_idx ON _professionalstoabandoned_yn USING btree (abandoned_yn, freq);

ALTER TABLE _professionalstoabandoned_yn CLUSTER ON _professionalstoabandoned_yn_idx;


--
-- Name: _professionalstoabandoned_yn_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _professionalstoabandoned_yn_idx_2 ON _professionalstoabandoned_yn USING btree (professionals_professional_id);


--
-- Name: _professionalstoage_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _professionalstoage_idx ON _professionalstoage USING btree (age, freq);

ALTER TABLE _professionalstoage CLUSTER ON _professionalstoage_idx;


--
-- Name: _professionalstoage_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _professionalstoage_idx_2 ON _professionalstoage USING btree (professionals_professional_id);


--
-- Name: _professionalstodate_adopted_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _professionalstodate_adopted_idx ON _professionalstodate_adopted USING btree (date_adopted, freq);

ALTER TABLE _professionalstodate_adopted CLUSTER ON _professionalstodate_adopted_idx;


--
-- Name: _professionalstodate_adopted_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _professionalstodate_adopted_idx_2 ON _professionalstodate_adopted USING btree (professionals_professional_id);


--
-- Name: _professionalstodate_arrived_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _professionalstodate_arrived_idx ON _professionalstodate_arrived USING btree (date_arrived, freq);

ALTER TABLE _professionalstodate_arrived CLUSTER ON _professionalstodate_arrived_idx;


--
-- Name: _professionalstodate_arrived_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _professionalstodate_arrived_idx_2 ON _professionalstodate_arrived USING btree (professionals_professional_id);


--
-- Name: _professionalstodate_departed_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _professionalstodate_departed_idx ON _professionalstodate_departed USING btree (date_departed, freq);

ALTER TABLE _professionalstodate_departed CLUSTER ON _professionalstodate_departed_idx;


--
-- Name: _professionalstodate_departed_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _professionalstodate_departed_idx_2 ON _professionalstodate_departed USING btree (professionals_professional_id);


--
-- Name: _professionalstodate_of_birth_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _professionalstodate_of_birth_idx ON _professionalstodate_of_birth USING btree (date_of_birth, freq);

ALTER TABLE _professionalstodate_of_birth CLUSTER ON _professionalstodate_of_birth_idx;


--
-- Name: _professionalstodate_of_birth_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _professionalstodate_of_birth_idx_2 ON _professionalstodate_of_birth USING btree (professionals_professional_id);


--
-- Name: _professionalstogender_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _professionalstogender_idx ON _professionalstogender USING btree (gender, freq);

ALTER TABLE _professionalstogender CLUSTER ON _professionalstogender_idx;


--
-- Name: _professionalstogender_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _professionalstogender_idx_2 ON _professionalstogender USING btree (professionals_professional_id);


--
-- Name: _professionalstoweight_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _professionalstoweight_idx ON _professionalstoweight USING btree (weight, freq);

ALTER TABLE _professionalstoweight CLUSTER ON _professionalstoweight_idx;


--
-- Name: _professionalstoweight_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _professionalstoweight_idx_2 ON _professionalstoweight USING btree (professionals_professional_id);


--
-- Name: dogs dogs_breed_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY dogs
    ADD CONSTRAINT dogs_breed_code_fkey FOREIGN KEY (breed_code) REFERENCES breeds(breed_code);


--
-- Name: dogs dogs_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY dogs
    ADD CONSTRAINT dogs_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES owners(owner_id);


--
-- Name: dogs dogs_owner_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY dogs
    ADD CONSTRAINT dogs_owner_id_fkey1 FOREIGN KEY (owner_id) REFERENCES owners(owner_id);


--
-- Name: dogs dogs_size_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY dogs
    ADD CONSTRAINT dogs_size_code_fkey FOREIGN KEY (size_code) REFERENCES sizes(size_code);


--
-- Name: treatments treatments_dog_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY treatments
    ADD CONSTRAINT treatments_dog_id_fkey FOREIGN KEY (dog_id) REFERENCES dogs(dog_id);


--
-- Name: treatments treatments_professional_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY treatments
    ADD CONSTRAINT treatments_professional_id_fkey FOREIGN KEY (professional_id) REFERENCES professionals(professional_id);


--
-- Name: treatments treatments_treatment_type_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY treatments
    ADD CONSTRAINT treatments_treatment_type_code_fkey FOREIGN KEY (treatment_type_code) REFERENCES treatment_types(treatment_type_code);


--
-- PostgreSQL database dump complete
--

