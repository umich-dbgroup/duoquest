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
-- Name: _aggr_aoc_dogs_to_sizes; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoc_dogs_to_sizes (
    dog_id integer,
    size_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoc_dogs_to_sizes OWNER TO afariha;

--
-- Name: _aggr_aoo_dogs_to_breeds_breed_idtodog_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_dogs_to_breeds_breed_idtodog_id (
    breed_id integer,
    dog_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_dogs_to_breeds_breed_idtodog_id OWNER TO afariha;

--
-- Name: _aggr_aoo_dogs_to_breeds_dog_idtobreed_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_dogs_to_breeds_dog_idtobreed_id (
    dog_id integer,
    breed_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_dogs_to_breeds_dog_idtobreed_id OWNER TO afariha;

--
-- Name: _aggr_aoo_owners_to_dogs_dog_idtoowner_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_owners_to_dogs_dog_idtoowner_id (
    dog_id integer,
    owner_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_owners_to_dogs_dog_idtoowner_id OWNER TO afariha;

--
-- Name: _aggr_aoo_owners_to_dogs_owner_idtodog_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_owners_to_dogs_owner_idtodog_id (
    owner_id integer,
    dog_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_owners_to_dogs_owner_idtodog_id OWNER TO afariha;

--
-- Name: _aggr_aoo_treatments_dog_idtoprofessional_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_treatments_dog_idtoprofessional_id (
    dog_id bigint,
    professional_id_aggr bigint[],
    count bigint
);


ALTER TABLE _aggr_aoo_treatments_dog_idtoprofessional_id OWNER TO afariha;

--
-- Name: _aggr_aoo_treatments_professional_idtodog_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_treatments_professional_idtodog_id (
    professional_id bigint,
    dog_id_aggr bigint[],
    count bigint
);


ALTER TABLE _aggr_aoo_treatments_professional_idtodog_id OWNER TO afariha;

--
-- Name: _breedstosizes; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _breedstosizes (
    breeds_breed_id integer NOT NULL,
    size_id integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _breedstosizes OWNER TO afariha;

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
-- Name: _ownerstosizes; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _ownerstosizes (
    owners_owner_id integer NOT NULL,
    size_id integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _ownerstosizes OWNER TO afariha;

--
-- Name: _professionalstosizes; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _professionalstosizes (
    professionals_professional_id integer NOT NULL,
    size_id integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _professionalstosizes OWNER TO afariha;

--
-- Name: breeds; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE breeds (
    breed_id integer NOT NULL,
    breed_code text,
    breed_name text
);


ALTER TABLE breeds OWNER TO afariha;

--
-- Name: breeds_breed_id_seq; Type: SEQUENCE; Schema: public; Owner: afariha
--

CREATE SEQUENCE breeds_breed_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE breeds_breed_id_seq OWNER TO afariha;

--
-- Name: breeds_breed_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: afariha
--

ALTER SEQUENCE breeds_breed_id_seq OWNED BY breeds.breed_id;


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
    abandoned_yn text,
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
-- Name: dogs_to_breeds; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE dogs_to_breeds (
    dog_id integer,
    breed_id integer
);


ALTER TABLE dogs_to_breeds OWNER TO afariha;

--
-- Name: dogs_to_sizes; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE dogs_to_sizes (
    dog_id integer,
    size_id integer
);


ALTER TABLE dogs_to_sizes OWNER TO afariha;

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
-- Name: owners_to_dogs; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE owners_to_dogs (
    owner_id integer,
    dog_id integer
);


ALTER TABLE owners_to_dogs OWNER TO afariha;

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
    size_id integer NOT NULL,
    size_code text,
    size_description text
);


ALTER TABLE sizes OWNER TO afariha;

--
-- Name: sizes_size_id_seq; Type: SEQUENCE; Schema: public; Owner: afariha
--

CREATE SEQUENCE sizes_size_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sizes_size_id_seq OWNER TO afariha;

--
-- Name: sizes_size_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: afariha
--

ALTER SEQUENCE sizes_size_id_seq OWNED BY sizes.size_id;


--
-- Name: treatment_types; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE treatment_types (
    treatment_type_id integer NOT NULL,
    treatment_type_code text,
    treatment_type_description text
);


ALTER TABLE treatment_types OWNER TO afariha;

--
-- Name: treatment_types_treatment_type_id_seq; Type: SEQUENCE; Schema: public; Owner: afariha
--

CREATE SEQUENCE treatment_types_treatment_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE treatment_types_treatment_type_id_seq OWNER TO afariha;

--
-- Name: treatment_types_treatment_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: afariha
--

ALTER SEQUENCE treatment_types_treatment_type_id_seq OWNED BY treatment_types.treatment_type_id;


--
-- Name: treatments; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE treatments (
    treatment_id bigint NOT NULL,
    dog_id bigint,
    professional_id bigint,
    date_of_treatment text,
    cost_of_treatment numeric(19,4),
    treatment_type_id integer
);


ALTER TABLE treatments OWNER TO afariha;

--
-- Name: breeds breed_id; Type: DEFAULT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY breeds ALTER COLUMN breed_id SET DEFAULT nextval('breeds_breed_id_seq'::regclass);


--
-- Name: sizes size_id; Type: DEFAULT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY sizes ALTER COLUMN size_id SET DEFAULT nextval('sizes_size_id_seq'::regclass);


--
-- Name: treatment_types treatment_type_id; Type: DEFAULT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY treatment_types ALTER COLUMN treatment_type_id SET DEFAULT nextval('treatment_types_treatment_type_id_seq'::regclass);


--
-- Name: _invertedcolumnindex _invertedcolumnindex_word_tabname_colname_key; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _invertedcolumnindex
    ADD CONSTRAINT _invertedcolumnindex_word_tabname_colname_key UNIQUE (word, tabname, colname);


--
-- Name: breeds breeds_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY breeds
    ADD CONSTRAINT breeds_pkey PRIMARY KEY (breed_id);


--
-- Name: charges idx_88451_charges_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY charges
    ADD CONSTRAINT idx_88451_charges_pkey PRIMARY KEY (charge_id);


--
-- Name: owners idx_88469_owners_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY owners
    ADD CONSTRAINT idx_88469_owners_pkey PRIMARY KEY (owner_id);


--
-- Name: dogs idx_88475_dogs_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY dogs
    ADD CONSTRAINT idx_88475_dogs_pkey PRIMARY KEY (dog_id);


--
-- Name: professionals idx_88481_professionals_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY professionals
    ADD CONSTRAINT idx_88481_professionals_pkey PRIMARY KEY (professional_id);


--
-- Name: treatments idx_88487_treatments_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY treatments
    ADD CONSTRAINT idx_88487_treatments_pkey PRIMARY KEY (treatment_id);


--
-- Name: sizes sizes_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY sizes
    ADD CONSTRAINT sizes_pkey PRIMARY KEY (size_id);


--
-- Name: treatment_types treatment_types_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY treatment_types
    ADD CONSTRAINT treatment_types_pkey PRIMARY KEY (treatment_type_id);


--
-- Name: _aggr_aoc_dogs_to_sizes_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoc_dogs_to_sizes_idx ON _aggr_aoc_dogs_to_sizes USING btree (dog_id);


--
-- Name: _aggr_aoo_dogs_to_breeds_breed_idtodog_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_dogs_to_breeds_breed_idtodog_id_idx ON _aggr_aoo_dogs_to_breeds_breed_idtodog_id USING btree (breed_id);


--
-- Name: _aggr_aoo_dogs_to_breeds_dog_idtobreed_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_dogs_to_breeds_dog_idtobreed_id_idx ON _aggr_aoo_dogs_to_breeds_dog_idtobreed_id USING btree (dog_id);


--
-- Name: _aggr_aoo_owners_to_dogs_dog_idtoowner_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_owners_to_dogs_dog_idtoowner_id_idx ON _aggr_aoo_owners_to_dogs_dog_idtoowner_id USING btree (dog_id);


--
-- Name: _aggr_aoo_owners_to_dogs_owner_idtodog_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_owners_to_dogs_owner_idtodog_id_idx ON _aggr_aoo_owners_to_dogs_owner_idtodog_id USING btree (owner_id);


--
-- Name: _aggr_aoo_treatments_dog_idtoprofessional_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_treatments_dog_idtoprofessional_id_idx ON _aggr_aoo_treatments_dog_idtoprofessional_id USING btree (dog_id);


--
-- Name: _aggr_aoo_treatments_professional_idtodog_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_treatments_professional_idtodog_id_idx ON _aggr_aoo_treatments_professional_idtodog_id USING btree (professional_id);


--
-- Name: _breedstosizes_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _breedstosizes_idx ON _breedstosizes USING btree (size_id, freq);

ALTER TABLE _breedstosizes CLUSTER ON _breedstosizes_idx;


--
-- Name: _breedstosizes_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _breedstosizes_idx_2 ON _breedstosizes USING btree (breeds_breed_id);


--
-- Name: _invertedcolumnindex_word_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _invertedcolumnindex_word_idx ON _invertedcolumnindex USING btree (word);

ALTER TABLE _invertedcolumnindex CLUSTER ON _invertedcolumnindex_word_idx;


--
-- Name: _ownerstosizes_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _ownerstosizes_idx ON _ownerstosizes USING btree (size_id, freq);

ALTER TABLE _ownerstosizes CLUSTER ON _ownerstosizes_idx;


--
-- Name: _ownerstosizes_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _ownerstosizes_idx_2 ON _ownerstosizes USING btree (owners_owner_id);


--
-- Name: _professionalstosizes_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _professionalstosizes_idx ON _professionalstosizes USING btree (size_id, freq);

ALTER TABLE _professionalstosizes CLUSTER ON _professionalstosizes_idx;


--
-- Name: _professionalstosizes_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _professionalstosizes_idx_2 ON _professionalstosizes USING btree (professionals_professional_id);


--
-- Name: _aggr_aoc_dogs_to_sizes _aggr_aocdogs_to_sizes_dog_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoc_dogs_to_sizes
    ADD CONSTRAINT _aggr_aocdogs_to_sizes_dog_id_fk FOREIGN KEY (dog_id) REFERENCES dogs(dog_id);


--
-- Name: _aggr_aoo_dogs_to_breeds_breed_idtodog_id _aggr_aoo_dogs_to_breeds_breed_idtodog_id_breed_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_dogs_to_breeds_breed_idtodog_id
    ADD CONSTRAINT _aggr_aoo_dogs_to_breeds_breed_idtodog_id_breed_id_fk FOREIGN KEY (breed_id) REFERENCES breeds(breed_id);


--
-- Name: _aggr_aoo_dogs_to_breeds_dog_idtobreed_id _aggr_aoo_dogs_to_breeds_dog_idtobreed_id_dog_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_dogs_to_breeds_dog_idtobreed_id
    ADD CONSTRAINT _aggr_aoo_dogs_to_breeds_dog_idtobreed_id_dog_id_fk FOREIGN KEY (dog_id) REFERENCES dogs(dog_id);


--
-- Name: _aggr_aoo_owners_to_dogs_dog_idtoowner_id _aggr_aoo_owners_to_dogs_dog_idtoowner_id_dog_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_owners_to_dogs_dog_idtoowner_id
    ADD CONSTRAINT _aggr_aoo_owners_to_dogs_dog_idtoowner_id_dog_id_fk FOREIGN KEY (dog_id) REFERENCES dogs(dog_id);


--
-- Name: _aggr_aoo_owners_to_dogs_owner_idtodog_id _aggr_aoo_owners_to_dogs_owner_idtodog_id_owner_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_owners_to_dogs_owner_idtodog_id
    ADD CONSTRAINT _aggr_aoo_owners_to_dogs_owner_idtodog_id_owner_id_fk FOREIGN KEY (owner_id) REFERENCES owners(owner_id);


--
-- Name: _aggr_aoo_treatments_dog_idtoprofessional_id _aggr_aoo_treatments_dog_idtoprofessional_id_dog_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_treatments_dog_idtoprofessional_id
    ADD CONSTRAINT _aggr_aoo_treatments_dog_idtoprofessional_id_dog_id_fk FOREIGN KEY (dog_id) REFERENCES dogs(dog_id);


--
-- Name: _aggr_aoo_treatments_professional_idtodog_id _aggr_aoo_treatments_professional_idtodog_id_professional_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_treatments_professional_idtodog_id
    ADD CONSTRAINT _aggr_aoo_treatments_professional_idtodog_id_professional_id_fk FOREIGN KEY (professional_id) REFERENCES professionals(professional_id);


--
-- Name: _breedstosizes _breedstosizes_breeds_breed_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _breedstosizes
    ADD CONSTRAINT _breedstosizes_breeds_breed_id_fkey FOREIGN KEY (breeds_breed_id) REFERENCES breeds(breed_id);


--
-- Name: _breedstosizes _breedstosizes_size_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _breedstosizes
    ADD CONSTRAINT _breedstosizes_size_id_fkey FOREIGN KEY (size_id) REFERENCES sizes(size_id);


--
-- Name: _ownerstosizes _ownerstosizes_owners_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _ownerstosizes
    ADD CONSTRAINT _ownerstosizes_owners_owner_id_fkey FOREIGN KEY (owners_owner_id) REFERENCES owners(owner_id);


--
-- Name: _ownerstosizes _ownerstosizes_size_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _ownerstosizes
    ADD CONSTRAINT _ownerstosizes_size_id_fkey FOREIGN KEY (size_id) REFERENCES sizes(size_id);


--
-- Name: _professionalstosizes _professionalstosizes_professionals_professional_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _professionalstosizes
    ADD CONSTRAINT _professionalstosizes_professionals_professional_id_fkey FOREIGN KEY (professionals_professional_id) REFERENCES professionals(professional_id);


--
-- Name: _professionalstosizes _professionalstosizes_size_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _professionalstosizes
    ADD CONSTRAINT _professionalstosizes_size_id_fkey FOREIGN KEY (size_id) REFERENCES sizes(size_id);


--
-- Name: dogs_to_breeds dogs_to_breeds_breed_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY dogs_to_breeds
    ADD CONSTRAINT dogs_to_breeds_breed_id_fkey FOREIGN KEY (breed_id) REFERENCES breeds(breed_id);


--
-- Name: dogs_to_breeds dogs_to_breeds_dog_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY dogs_to_breeds
    ADD CONSTRAINT dogs_to_breeds_dog_id_fkey FOREIGN KEY (dog_id) REFERENCES dogs(dog_id);


--
-- Name: dogs_to_sizes dogs_to_sizes_dog_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY dogs_to_sizes
    ADD CONSTRAINT dogs_to_sizes_dog_id_fkey FOREIGN KEY (dog_id) REFERENCES dogs(dog_id);


--
-- Name: dogs_to_sizes dogs_to_sizes_size_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY dogs_to_sizes
    ADD CONSTRAINT dogs_to_sizes_size_id_fkey FOREIGN KEY (size_id) REFERENCES sizes(size_id);


--
-- Name: owners_to_dogs owners_to_dogs_dog_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY owners_to_dogs
    ADD CONSTRAINT owners_to_dogs_dog_id_fkey FOREIGN KEY (dog_id) REFERENCES dogs(dog_id);


--
-- Name: owners_to_dogs owners_to_dogs_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY owners_to_dogs
    ADD CONSTRAINT owners_to_dogs_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES owners(owner_id);


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
-- Name: treatments treatments_treatment_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY treatments
    ADD CONSTRAINT treatments_treatment_type_id_fkey FOREIGN KEY (treatment_type_id) REFERENCES treatment_types(treatment_type_id);


--
-- PostgreSQL database dump complete
--

