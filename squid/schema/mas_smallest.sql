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
-- Name: _aggr_aoc_author_organization; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoc_author_organization (
    author_id integer,
    organization_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoc_author_organization OWNER TO afariha;

--
-- Name: _aggr_aoc_domain_author; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoc_domain_author (
    author_id integer,
    domain_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoc_domain_author OWNER TO afariha;

--
-- Name: _aggr_aoc_publication_conference; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoc_publication_conference (
    publication_id integer,
    conference_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoc_publication_conference OWNER TO afariha;

--
-- Name: _aggr_aoo_writes_author_idtopublication_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_writes_author_idtopublication_id (
    author_id integer,
    publication_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_writes_author_idtopublication_id OWNER TO afariha;

--
-- Name: _aggr_aoo_writes_publication_idtoauthor_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_writes_publication_idtoauthor_id (
    publication_id integer,
    author_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_writes_publication_idtoauthor_id OWNER TO afariha;

--
-- Name: _authortoconference_of_publication; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _authortoconference_of_publication (
    author_author_id integer NOT NULL,
    conference_id integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _authortoconference_of_publication OWNER TO afariha;

--
-- Name: _authortopublication_year; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _authortopublication_year (
    author_author_id integer NOT NULL,
    publication_year integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _authortopublication_year OWNER TO afariha;

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
-- Name: _publicationtodomain_of_author; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _publicationtodomain_of_author (
    publication_publication_id integer NOT NULL,
    domain_id integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _publicationtodomain_of_author OWNER TO afariha;

--
-- Name: _publicationtoorganization_of_author; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _publicationtoorganization_of_author (
    publication_publication_id integer NOT NULL,
    organization_id integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _publicationtoorganization_of_author OWNER TO afariha;

--
-- Name: author; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE author (
    author_id integer NOT NULL,
    name text
);


ALTER TABLE author OWNER TO afariha;

--
-- Name: author_organization; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE author_organization (
    author_id integer,
    organization_id integer
);


ALTER TABLE author_organization OWNER TO afariha;

--
-- Name: conference_of_publication; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE conference_of_publication (
    conference_id integer NOT NULL,
    name text
);


ALTER TABLE conference_of_publication OWNER TO afariha;

--
-- Name: domain_author; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE domain_author (
    author_id integer NOT NULL,
    domain_id integer NOT NULL
);


ALTER TABLE domain_author OWNER TO afariha;

--
-- Name: domain_of_author; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE domain_of_author (
    domain_id integer NOT NULL,
    name text
);


ALTER TABLE domain_of_author OWNER TO afariha;

--
-- Name: organization_of_author; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE organization_of_author (
    organization_id integer NOT NULL,
    name text,
    continent text
);


ALTER TABLE organization_of_author OWNER TO afariha;

--
-- Name: publication; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE publication (
    publication_id integer NOT NULL,
    title text,
    publication_year integer
);


ALTER TABLE publication OWNER TO afariha;

--
-- Name: publication_conference; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE publication_conference (
    publication_id integer,
    conference_id integer
);


ALTER TABLE publication_conference OWNER TO afariha;

--
-- Name: writes; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE writes (
    author_id integer NOT NULL,
    publication_id integer NOT NULL
);


ALTER TABLE writes OWNER TO afariha;

--
-- Name: _invertedcolumnindex _invertedcolumnindex_word_tabname_colname_key; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _invertedcolumnindex
    ADD CONSTRAINT _invertedcolumnindex_word_tabname_colname_key UNIQUE (word, tabname, colname);


--
-- Name: author idx_49559_author_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY author
    ADD CONSTRAINT idx_49559_author_pkey PRIMARY KEY (author_id);


--
-- Name: conference_of_publication idx_49568_conference_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY conference_of_publication
    ADD CONSTRAINT idx_49568_conference_pkey PRIMARY KEY (conference_id);


--
-- Name: domain_of_author idx_49574_domain_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY domain_of_author
    ADD CONSTRAINT idx_49574_domain_pkey PRIMARY KEY (domain_id);


--
-- Name: domain_author idx_49580_sqlite_autoindex_domain_author_1; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY domain_author
    ADD CONSTRAINT idx_49580_sqlite_autoindex_domain_author_1 PRIMARY KEY (author_id, domain_id);


--
-- Name: organization_of_author idx_49607_organization_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY organization_of_author
    ADD CONSTRAINT idx_49607_organization_pkey PRIMARY KEY (organization_id);


--
-- Name: publication idx_49613_publication_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY publication
    ADD CONSTRAINT idx_49613_publication_pkey PRIMARY KEY (publication_id);


--
-- Name: writes idx_49622_sqlite_autoindex_writes_1; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY writes
    ADD CONSTRAINT idx_49622_sqlite_autoindex_writes_1 PRIMARY KEY (author_id, publication_id);


--
-- Name: _aggr_aoc_author_organization_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoc_author_organization_idx ON _aggr_aoc_author_organization USING btree (author_id);


--
-- Name: _aggr_aoc_domain_author_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoc_domain_author_idx ON _aggr_aoc_domain_author USING btree (author_id);


--
-- Name: _aggr_aoc_publication_conference_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoc_publication_conference_idx ON _aggr_aoc_publication_conference USING btree (publication_id);


--
-- Name: _aggr_aoo_writes_author_idtopublication_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_writes_author_idtopublication_id_idx ON _aggr_aoo_writes_author_idtopublication_id USING btree (author_id);


--
-- Name: _aggr_aoo_writes_publication_idtoauthor_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_writes_publication_idtoauthor_id_idx ON _aggr_aoo_writes_publication_idtoauthor_id USING btree (publication_id);


--
-- Name: _authortoconference_of_publication_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _authortoconference_of_publication_idx ON _authortoconference_of_publication USING btree (conference_id, freq);

ALTER TABLE _authortoconference_of_publication CLUSTER ON _authortoconference_of_publication_idx;


--
-- Name: _authortoconference_of_publication_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _authortoconference_of_publication_idx_2 ON _authortoconference_of_publication USING btree (author_author_id);


--
-- Name: _authortopublication_year_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _authortopublication_year_idx ON _authortopublication_year USING btree (publication_year, freq);

ALTER TABLE _authortopublication_year CLUSTER ON _authortopublication_year_idx;


--
-- Name: _authortopublication_year_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _authortopublication_year_idx_2 ON _authortopublication_year USING btree (author_author_id);


--
-- Name: _invertedcolumnindex_word_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _invertedcolumnindex_word_idx ON _invertedcolumnindex USING btree (word);

ALTER TABLE _invertedcolumnindex CLUSTER ON _invertedcolumnindex_word_idx;


--
-- Name: _publicationtodomain_of_author_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _publicationtodomain_of_author_idx ON _publicationtodomain_of_author USING btree (domain_id, freq);

ALTER TABLE _publicationtodomain_of_author CLUSTER ON _publicationtodomain_of_author_idx;


--
-- Name: _publicationtodomain_of_author_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _publicationtodomain_of_author_idx_2 ON _publicationtodomain_of_author USING btree (publication_publication_id);


--
-- Name: _publicationtoorganization_of_author_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _publicationtoorganization_of_author_idx ON _publicationtoorganization_of_author USING btree (organization_id, freq);

ALTER TABLE _publicationtoorganization_of_author CLUSTER ON _publicationtoorganization_of_author_idx;


--
-- Name: _publicationtoorganization_of_author_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _publicationtoorganization_of_author_idx_2 ON _publicationtoorganization_of_author USING btree (publication_publication_id);


--
-- Name: author_org_aid_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX author_org_aid_idx ON author_organization USING btree (author_id);


--
-- Name: author_org_oid_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX author_org_oid_idx ON author_organization USING btree (organization_id);


--
-- Name: idx_49559_author_name; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX idx_49559_author_name ON author USING btree (name);


--
-- Name: idx_49568_conf_name; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX idx_49568_conf_name ON conference_of_publication USING btree (name);


--
-- Name: idx_49574_domain_name; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX idx_49574_domain_name ON domain_of_author USING btree (name);


--
-- Name: idx_49580_da_aid; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX idx_49580_da_aid ON domain_author USING btree (author_id);


--
-- Name: idx_49580_da_did; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX idx_49580_da_did ON domain_author USING btree (domain_id);


--
-- Name: idx_49607_org_continent; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX idx_49607_org_continent ON organization_of_author USING btree (continent);


--
-- Name: idx_49607_organization_id; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX idx_49607_organization_id ON organization_of_author USING btree (name);


--
-- Name: idx_49622_writes_aid; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX idx_49622_writes_aid ON writes USING btree (author_id);


--
-- Name: idx_49622_writes_pid; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX idx_49622_writes_pid ON writes USING btree (publication_id);


--
-- Name: pub_conf_cid_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX pub_conf_cid_idx ON publication_conference USING btree (conference_id);


--
-- Name: pub_conf_pid_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX pub_conf_pid_idx ON publication_conference USING btree (publication_id);


--
-- Name: _aggr_aoc_author_organization _aggr_aocauthor_organization_author_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoc_author_organization
    ADD CONSTRAINT _aggr_aocauthor_organization_author_id_fk FOREIGN KEY (author_id) REFERENCES author(author_id);


--
-- Name: _aggr_aoc_domain_author _aggr_aocdomain_author_author_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoc_domain_author
    ADD CONSTRAINT _aggr_aocdomain_author_author_id_fk FOREIGN KEY (author_id) REFERENCES author(author_id);


--
-- Name: _aggr_aoc_publication_conference _aggr_aocpublication_conference_publication_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoc_publication_conference
    ADD CONSTRAINT _aggr_aocpublication_conference_publication_id_fk FOREIGN KEY (publication_id) REFERENCES publication(publication_id);


--
-- Name: _aggr_aoo_writes_author_idtopublication_id _aggr_aoo_writes_author_idtopublication_id_author_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_writes_author_idtopublication_id
    ADD CONSTRAINT _aggr_aoo_writes_author_idtopublication_id_author_id_fk FOREIGN KEY (author_id) REFERENCES author(author_id);


--
-- Name: _aggr_aoo_writes_publication_idtoauthor_id _aggr_aoo_writes_publication_idtoauthor_id_publication_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_writes_publication_idtoauthor_id
    ADD CONSTRAINT _aggr_aoo_writes_publication_idtoauthor_id_publication_id_fk FOREIGN KEY (publication_id) REFERENCES publication(publication_id);


--
-- Name: _authortoconference_of_publication _authortoconference_of_publication_author_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _authortoconference_of_publication
    ADD CONSTRAINT _authortoconference_of_publication_author_author_id_fkey FOREIGN KEY (author_author_id) REFERENCES author(author_id);


--
-- Name: _authortoconference_of_publication _authortoconference_of_publication_conference_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _authortoconference_of_publication
    ADD CONSTRAINT _authortoconference_of_publication_conference_id_fkey FOREIGN KEY (conference_id) REFERENCES conference_of_publication(conference_id);


--
-- Name: _authortopublication_year _authortopublication_year_author_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _authortopublication_year
    ADD CONSTRAINT _authortopublication_year_author_author_id_fkey FOREIGN KEY (author_author_id) REFERENCES author(author_id);


--
-- Name: _publicationtodomain_of_author _publicationtodomain_of_author_domain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _publicationtodomain_of_author
    ADD CONSTRAINT _publicationtodomain_of_author_domain_id_fkey FOREIGN KEY (domain_id) REFERENCES domain_of_author(domain_id);


--
-- Name: _publicationtodomain_of_author _publicationtodomain_of_author_publication_publication_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _publicationtodomain_of_author
    ADD CONSTRAINT _publicationtodomain_of_author_publication_publication_id_fkey FOREIGN KEY (publication_publication_id) REFERENCES publication(publication_id);


--
-- Name: _publicationtoorganization_of_author _publicationtoorganization_of_a_publication_publication_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _publicationtoorganization_of_author
    ADD CONSTRAINT _publicationtoorganization_of_a_publication_publication_id_fkey FOREIGN KEY (publication_publication_id) REFERENCES publication(publication_id);


--
-- Name: _publicationtoorganization_of_author _publicationtoorganization_of_author_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _publicationtoorganization_of_author
    ADD CONSTRAINT _publicationtoorganization_of_author_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES organization_of_author(organization_id);


--
-- Name: author_organization author_org_aid; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY author_organization
    ADD CONSTRAINT author_org_aid FOREIGN KEY (author_id) REFERENCES author(author_id);


--
-- Name: author_organization author_org_oid; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY author_organization
    ADD CONSTRAINT author_org_oid FOREIGN KEY (organization_id) REFERENCES organization_of_author(organization_id);


--
-- Name: domain_author domain_author_aid; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY domain_author
    ADD CONSTRAINT domain_author_aid FOREIGN KEY (author_id) REFERENCES author(author_id);


--
-- Name: domain_author domain_author_did; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY domain_author
    ADD CONSTRAINT domain_author_did FOREIGN KEY (domain_id) REFERENCES domain_of_author(domain_id);


--
-- Name: publication_conference pub_conf_cid; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY publication_conference
    ADD CONSTRAINT pub_conf_cid FOREIGN KEY (conference_id) REFERENCES conference_of_publication(conference_id);


--
-- Name: publication_conference pub_conf_pid; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY publication_conference
    ADD CONSTRAINT pub_conf_pid FOREIGN KEY (publication_id) REFERENCES publication(publication_id);


--
-- Name: writes writes_aid; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY writes
    ADD CONSTRAINT writes_aid FOREIGN KEY (author_id) REFERENCES author(author_id);


--
-- Name: writes writes_pid; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY writes
    ADD CONSTRAINT writes_pid FOREIGN KEY (publication_id) REFERENCES publication(publication_id);


--
-- PostgreSQL database dump complete
--

