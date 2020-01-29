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
-- Name: _aggr_aoc_area_code_to_state; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoc_area_code_to_state (
    state_id integer,
    area_code_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoc_area_code_to_state OWNER TO afariha;

--
-- Name: _aggr_aoo_votes_to_state_state_idtovote_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_votes_to_state_state_idtovote_id (
    state_id integer,
    vote_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_votes_to_state_state_idtovote_id OWNER TO afariha;

--
-- Name: _aggr_aoo_votes_to_state_vote_idtostate_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_votes_to_state_vote_idtostate_id (
    vote_id integer,
    state_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_votes_to_state_vote_idtostate_id OWNER TO afariha;

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
-- Name: _statetocontestant_number; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _statetocontestant_number (
    state_id integer NOT NULL,
    contestant_number integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _statetocontestant_number OWNER TO afariha;

--
-- Name: _votestoarea_code_state; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _votestoarea_code_state (
    votes_vote_id integer NOT NULL,
    area_code_id integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _votestoarea_code_state OWNER TO afariha;

--
-- Name: area_code_state; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE area_code_state (
    area_code bigint NOT NULL,
    area_code_value integer
);


ALTER TABLE area_code_state OWNER TO afariha;

--
-- Name: area_code_to_state; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE area_code_to_state (
    area_code_id integer,
    state_id integer
);


ALTER TABLE area_code_to_state OWNER TO afariha;

--
-- Name: contestants; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE contestants (
    contestant_number bigint NOT NULL,
    contestant_name text
);


ALTER TABLE contestants OWNER TO afariha;

--
-- Name: state; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE state (
    id integer NOT NULL,
    state text
);


ALTER TABLE state OWNER TO afariha;

--
-- Name: state_id_seq; Type: SEQUENCE; Schema: public; Owner: afariha
--

CREATE SEQUENCE state_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE state_id_seq OWNER TO afariha;

--
-- Name: state_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: afariha
--

ALTER SEQUENCE state_id_seq OWNED BY state.id;


--
-- Name: votes; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE votes (
    vote_id bigint NOT NULL,
    phone_number bigint,
    contestant_number bigint,
    created timestamp without time zone DEFAULT now()
);


ALTER TABLE votes OWNER TO afariha;

--
-- Name: votes_to_state; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE votes_to_state (
    vote_id integer,
    state_id integer
);


ALTER TABLE votes_to_state OWNER TO afariha;

--
-- Name: state id; Type: DEFAULT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY state ALTER COLUMN id SET DEFAULT nextval('state_id_seq'::regclass);


--
-- Name: _invertedcolumnindex _invertedcolumnindex_word_tabname_colname_key; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _invertedcolumnindex
    ADD CONSTRAINT _invertedcolumnindex_word_tabname_colname_key UNIQUE (word, tabname, colname);


--
-- Name: area_code_state idx_85335_area_code_state_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY area_code_state
    ADD CONSTRAINT idx_85335_area_code_state_pkey PRIMARY KEY (area_code);


--
-- Name: contestants idx_85341_contestants_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY contestants
    ADD CONSTRAINT idx_85341_contestants_pkey PRIMARY KEY (contestant_number);


--
-- Name: votes idx_85347_votes_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY votes
    ADD CONSTRAINT idx_85347_votes_pkey PRIMARY KEY (vote_id);


--
-- Name: state state_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY state
    ADD CONSTRAINT state_pkey PRIMARY KEY (id);


--
-- Name: _aggr_aoc_area_code_to_state_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoc_area_code_to_state_idx ON _aggr_aoc_area_code_to_state USING btree (state_id);


--
-- Name: _aggr_aoo_votes_to_state_state_idtovote_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_votes_to_state_state_idtovote_id_idx ON _aggr_aoo_votes_to_state_state_idtovote_id USING btree (state_id);


--
-- Name: _aggr_aoo_votes_to_state_vote_idtostate_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_votes_to_state_vote_idtostate_id_idx ON _aggr_aoo_votes_to_state_vote_idtostate_id USING btree (vote_id);


--
-- Name: _invertedcolumnindex_word_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _invertedcolumnindex_word_idx ON _invertedcolumnindex USING btree (word);

ALTER TABLE _invertedcolumnindex CLUSTER ON _invertedcolumnindex_word_idx;


--
-- Name: _statetocontestant_number_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _statetocontestant_number_idx ON _statetocontestant_number USING btree (contestant_number, freq);

ALTER TABLE _statetocontestant_number CLUSTER ON _statetocontestant_number_idx;


--
-- Name: _statetocontestant_number_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _statetocontestant_number_idx_2 ON _statetocontestant_number USING btree (state_id);


--
-- Name: _votestoarea_code_state_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _votestoarea_code_state_idx ON _votestoarea_code_state USING btree (area_code_id, freq);

ALTER TABLE _votestoarea_code_state CLUSTER ON _votestoarea_code_state_idx;


--
-- Name: _votestoarea_code_state_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _votestoarea_code_state_idx_2 ON _votestoarea_code_state USING btree (votes_vote_id);


--
-- Name: idx_85347_idx_votes_idx_votes_phone_number; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX idx_85347_idx_votes_idx_votes_phone_number ON votes USING btree (phone_number);


--
-- Name: _aggr_aoc_area_code_to_state _aggr_aocarea_code_to_state_state_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoc_area_code_to_state
    ADD CONSTRAINT _aggr_aocarea_code_to_state_state_id_fk FOREIGN KEY (state_id) REFERENCES state(id);


--
-- Name: _aggr_aoo_votes_to_state_state_idtovote_id _aggr_aoo_votes_to_state_state_idtovote_id_state_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_votes_to_state_state_idtovote_id
    ADD CONSTRAINT _aggr_aoo_votes_to_state_state_idtovote_id_state_id_fk FOREIGN KEY (state_id) REFERENCES state(id);


--
-- Name: _aggr_aoo_votes_to_state_vote_idtostate_id _aggr_aoo_votes_to_state_vote_idtostate_id_vote_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_votes_to_state_vote_idtostate_id
    ADD CONSTRAINT _aggr_aoo_votes_to_state_vote_idtostate_id_vote_id_fk FOREIGN KEY (vote_id) REFERENCES votes(vote_id);


--
-- Name: _statetocontestant_number _statetocontestant_number_contestant_number_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _statetocontestant_number
    ADD CONSTRAINT _statetocontestant_number_contestant_number_fkey FOREIGN KEY (contestant_number) REFERENCES contestants(contestant_number);


--
-- Name: _statetocontestant_number _statetocontestant_number_state_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _statetocontestant_number
    ADD CONSTRAINT _statetocontestant_number_state_id_fkey FOREIGN KEY (state_id) REFERENCES state(id);


--
-- Name: _votestoarea_code_state _votestoarea_code_state_area_code_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _votestoarea_code_state
    ADD CONSTRAINT _votestoarea_code_state_area_code_id_fkey FOREIGN KEY (area_code_id) REFERENCES area_code_state(area_code);


--
-- Name: _votestoarea_code_state _votestoarea_code_state_votes_vote_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _votestoarea_code_state
    ADD CONSTRAINT _votestoarea_code_state_votes_vote_id_fkey FOREIGN KEY (votes_vote_id) REFERENCES votes(vote_id);


--
-- Name: area_code_to_state area_code_to_state_area_code_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY area_code_to_state
    ADD CONSTRAINT area_code_to_state_area_code_id_fkey FOREIGN KEY (area_code_id) REFERENCES area_code_state(area_code);


--
-- Name: area_code_to_state area_code_to_state_state_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY area_code_to_state
    ADD CONSTRAINT area_code_to_state_state_id_fkey FOREIGN KEY (state_id) REFERENCES state(id);


--
-- Name: votes votes_contestant_number_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY votes
    ADD CONSTRAINT votes_contestant_number_fkey FOREIGN KEY (contestant_number) REFERENCES contestants(contestant_number);


--
-- Name: votes_to_state votes_to_state_state_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY votes_to_state
    ADD CONSTRAINT votes_to_state_state_id_fkey FOREIGN KEY (state_id) REFERENCES state(id);


--
-- Name: votes_to_state votes_to_state_vote_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY votes_to_state
    ADD CONSTRAINT votes_to_state_vote_id_fkey FOREIGN KEY (vote_id) REFERENCES votes(vote_id);


--
-- PostgreSQL database dump complete
--

