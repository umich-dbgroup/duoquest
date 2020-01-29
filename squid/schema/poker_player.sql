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
-- Name: _aggr_aoo_people_to_poker_player_people_idtopoker_player_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_people_to_poker_player_people_idtopoker_player_id (
    people_id integer,
    poker_player_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_people_to_poker_player_people_idtopoker_player_id OWNER TO afariha;

--
-- Name: _aggr_aoo_people_to_poker_player_poker_player_idtopeople_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_people_to_poker_player_poker_player_idtopeople_id (
    poker_player_id integer,
    people_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_people_to_poker_player_poker_player_idtopeople_id OWNER TO afariha;

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
-- Name: _peopletobest_finish; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _peopletobest_finish (
    people_people_id integer NOT NULL,
    best_finish integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _peopletobest_finish OWNER TO afariha;

--
-- Name: _peopletoearnings; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _peopletoearnings (
    people_people_id integer NOT NULL,
    earnings integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _peopletoearnings OWNER TO afariha;

--
-- Name: _peopletofinal_table_made; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _peopletofinal_table_made (
    people_people_id integer NOT NULL,
    final_table_made integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _peopletofinal_table_made OWNER TO afariha;

--
-- Name: _poker_playertobirth_date; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _poker_playertobirth_date (
    poker_player_poker_player_id integer NOT NULL,
    birth_date text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _poker_playertobirth_date OWNER TO afariha;

--
-- Name: _poker_playertoheight; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _poker_playertoheight (
    poker_player_poker_player_id integer NOT NULL,
    height integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _poker_playertoheight OWNER TO afariha;

--
-- Name: _poker_playertonationality; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _poker_playertonationality (
    poker_player_poker_player_id integer NOT NULL,
    nationality text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _poker_playertonationality OWNER TO afariha;

--
-- Name: people; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE people (
    people_id integer NOT NULL,
    nationality text,
    name text,
    birth_date text,
    height real
);


ALTER TABLE people OWNER TO afariha;

--
-- Name: people_to_poker_player; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE people_to_poker_player (
    people_id integer,
    poker_player_id integer
);


ALTER TABLE people_to_poker_player OWNER TO afariha;

--
-- Name: poker_player; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE poker_player (
    poker_player_id integer NOT NULL,
    final_table_made real,
    best_finish real,
    money_rank real,
    earnings real
);


ALTER TABLE poker_player OWNER TO afariha;

--
-- Name: _invertedcolumnindex _invertedcolumnindex_word_tabname_colname_key; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _invertedcolumnindex
    ADD CONSTRAINT _invertedcolumnindex_word_tabname_colname_key UNIQUE (word, tabname, colname);


--
-- Name: people people_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY people
    ADD CONSTRAINT people_pkey PRIMARY KEY (people_id);


--
-- Name: poker_player poker_player_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY poker_player
    ADD CONSTRAINT poker_player_pkey PRIMARY KEY (poker_player_id);


--
-- Name: _aggr_aoo_people_to_poker_player_people_idtopoker_player_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_people_to_poker_player_people_idtopoker_player_id_idx ON _aggr_aoo_people_to_poker_player_people_idtopoker_player_id USING btree (people_id);


--
-- Name: _aggr_aoo_people_to_poker_player_poker_player_idtopeople_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_people_to_poker_player_poker_player_idtopeople_id_idx ON _aggr_aoo_people_to_poker_player_poker_player_idtopeople_id USING btree (poker_player_id);


--
-- Name: _invertedcolumnindex_word_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _invertedcolumnindex_word_idx ON _invertedcolumnindex USING btree (word);

ALTER TABLE _invertedcolumnindex CLUSTER ON _invertedcolumnindex_word_idx;


--
-- Name: _peopletobest_finish_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _peopletobest_finish_idx ON _peopletobest_finish USING btree (best_finish, freq);

ALTER TABLE _peopletobest_finish CLUSTER ON _peopletobest_finish_idx;


--
-- Name: _peopletobest_finish_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _peopletobest_finish_idx_2 ON _peopletobest_finish USING btree (people_people_id);


--
-- Name: _peopletoearnings_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _peopletoearnings_idx ON _peopletoearnings USING btree (earnings, freq);

ALTER TABLE _peopletoearnings CLUSTER ON _peopletoearnings_idx;


--
-- Name: _peopletoearnings_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _peopletoearnings_idx_2 ON _peopletoearnings USING btree (people_people_id);


--
-- Name: _peopletofinal_table_made_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _peopletofinal_table_made_idx ON _peopletofinal_table_made USING btree (final_table_made, freq);

ALTER TABLE _peopletofinal_table_made CLUSTER ON _peopletofinal_table_made_idx;


--
-- Name: _peopletofinal_table_made_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _peopletofinal_table_made_idx_2 ON _peopletofinal_table_made USING btree (people_people_id);


--
-- Name: _poker_playertobirth_date_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _poker_playertobirth_date_idx ON _poker_playertobirth_date USING btree (birth_date, freq);

ALTER TABLE _poker_playertobirth_date CLUSTER ON _poker_playertobirth_date_idx;


--
-- Name: _poker_playertobirth_date_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _poker_playertobirth_date_idx_2 ON _poker_playertobirth_date USING btree (poker_player_poker_player_id);


--
-- Name: _poker_playertoheight_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _poker_playertoheight_idx ON _poker_playertoheight USING btree (height, freq);

ALTER TABLE _poker_playertoheight CLUSTER ON _poker_playertoheight_idx;


--
-- Name: _poker_playertoheight_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _poker_playertoheight_idx_2 ON _poker_playertoheight USING btree (poker_player_poker_player_id);


--
-- Name: _poker_playertonationality_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _poker_playertonationality_idx ON _poker_playertonationality USING btree (nationality, freq);

ALTER TABLE _poker_playertonationality CLUSTER ON _poker_playertonationality_idx;


--
-- Name: _poker_playertonationality_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _poker_playertonationality_idx_2 ON _poker_playertonationality USING btree (poker_player_poker_player_id);


--
-- Name: idx_84700_sqlite_autoindex_poker_player_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_84700_sqlite_autoindex_poker_player_1 ON poker_player USING btree (poker_player_id);


--
-- Name: idx_84703_sqlite_autoindex_people_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_84703_sqlite_autoindex_people_1 ON people USING btree (people_id);


--
-- Name: _aggr_aoo_people_to_poker_player_people_idtopoker_player_id _aggr_aoo_people_to_poker_player_people_idtopoker_player_id_peo; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_people_to_poker_player_people_idtopoker_player_id
    ADD CONSTRAINT _aggr_aoo_people_to_poker_player_people_idtopoker_player_id_peo FOREIGN KEY (people_id) REFERENCES people(people_id);


--
-- Name: _aggr_aoo_people_to_poker_player_poker_player_idtopeople_id _aggr_aoo_people_to_poker_player_poker_player_idtopeople_id_pok; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_people_to_poker_player_poker_player_idtopeople_id
    ADD CONSTRAINT _aggr_aoo_people_to_poker_player_poker_player_idtopeople_id_pok FOREIGN KEY (poker_player_id) REFERENCES poker_player(poker_player_id);


--
-- Name: _peopletobest_finish _peopletobest_finish_people_people_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _peopletobest_finish
    ADD CONSTRAINT _peopletobest_finish_people_people_id_fkey FOREIGN KEY (people_people_id) REFERENCES people(people_id);


--
-- Name: _peopletoearnings _peopletoearnings_people_people_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _peopletoearnings
    ADD CONSTRAINT _peopletoearnings_people_people_id_fkey FOREIGN KEY (people_people_id) REFERENCES people(people_id);


--
-- Name: _peopletofinal_table_made _peopletofinal_table_made_people_people_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _peopletofinal_table_made
    ADD CONSTRAINT _peopletofinal_table_made_people_people_id_fkey FOREIGN KEY (people_people_id) REFERENCES people(people_id);


--
-- Name: _poker_playertobirth_date _poker_playertobirth_date_poker_player_poker_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _poker_playertobirth_date
    ADD CONSTRAINT _poker_playertobirth_date_poker_player_poker_player_id_fkey FOREIGN KEY (poker_player_poker_player_id) REFERENCES poker_player(poker_player_id);


--
-- Name: _poker_playertoheight _poker_playertoheight_poker_player_poker_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _poker_playertoheight
    ADD CONSTRAINT _poker_playertoheight_poker_player_poker_player_id_fkey FOREIGN KEY (poker_player_poker_player_id) REFERENCES poker_player(poker_player_id);


--
-- Name: _poker_playertonationality _poker_playertonationality_poker_player_poker_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _poker_playertonationality
    ADD CONSTRAINT _poker_playertonationality_poker_player_poker_player_id_fkey FOREIGN KEY (poker_player_poker_player_id) REFERENCES poker_player(poker_player_id);


--
-- Name: people_to_poker_player people_to_poker_player_people_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY people_to_poker_player
    ADD CONSTRAINT people_to_poker_player_people_id_fkey FOREIGN KEY (people_id) REFERENCES people(people_id);


--
-- Name: people_to_poker_player people_to_poker_player_poker_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY people_to_poker_player
    ADD CONSTRAINT people_to_poker_player_poker_player_id_fkey FOREIGN KEY (poker_player_id) REFERENCES poker_player(poker_player_id);


--
-- PostgreSQL database dump complete
--

