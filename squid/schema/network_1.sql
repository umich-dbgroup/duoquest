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
-- Name: _aggr_aoo_friend_friend_idtostudent_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_friend_friend_idtostudent_id (
    friend_id integer,
    student_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_friend_friend_idtostudent_id OWNER TO afariha;

--
-- Name: _aggr_aoo_friend_student_idtofriend_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_friend_student_idtofriend_id (
    student_id integer,
    friend_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_friend_student_idtofriend_id OWNER TO afariha;

--
-- Name: _aggr_aoo_likes_liked_idtostudent_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_likes_liked_idtostudent_id (
    liked_id integer,
    student_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_likes_liked_idtostudent_id OWNER TO afariha;

--
-- Name: _aggr_aoo_likes_student_idtoliked_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_likes_student_idtoliked_id (
    student_id integer,
    liked_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_likes_student_idtoliked_id OWNER TO afariha;

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
-- Name: friend; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE friend (
    student_id integer NOT NULL,
    friend_id integer NOT NULL
);


ALTER TABLE friend OWNER TO afariha;

--
-- Name: highschooler; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE highschooler (
    id integer NOT NULL,
    name text,
    grade integer
);


ALTER TABLE highschooler OWNER TO afariha;

--
-- Name: likes; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE likes (
    student_id integer NOT NULL,
    liked_id integer NOT NULL
);


ALTER TABLE likes OWNER TO afariha;

--
-- Name: _invertedcolumnindex _invertedcolumnindex_word_tabname_colname_key; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _invertedcolumnindex
    ADD CONSTRAINT _invertedcolumnindex_word_tabname_colname_key UNIQUE (word, tabname, colname);


--
-- Name: highschooler highschooler_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY highschooler
    ADD CONSTRAINT highschooler_pkey PRIMARY KEY (id);


--
-- Name: friend idx_91277_sqlite_autoindex_friend_1; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY friend
    ADD CONSTRAINT idx_91277_sqlite_autoindex_friend_1 PRIMARY KEY (student_id, friend_id);


--
-- Name: likes idx_91280_sqlite_autoindex_likes_1; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY likes
    ADD CONSTRAINT idx_91280_sqlite_autoindex_likes_1 PRIMARY KEY (student_id, liked_id);


--
-- Name: _aggr_aoo_friend_friend_idtostudent_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_friend_friend_idtostudent_id_idx ON _aggr_aoo_friend_friend_idtostudent_id USING btree (friend_id);


--
-- Name: _aggr_aoo_friend_student_idtofriend_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_friend_student_idtofriend_id_idx ON _aggr_aoo_friend_student_idtofriend_id USING btree (student_id);


--
-- Name: _aggr_aoo_likes_liked_idtostudent_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_likes_liked_idtostudent_id_idx ON _aggr_aoo_likes_liked_idtostudent_id USING btree (liked_id);


--
-- Name: _aggr_aoo_likes_student_idtoliked_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_likes_student_idtoliked_id_idx ON _aggr_aoo_likes_student_idtoliked_id USING btree (student_id);


--
-- Name: _invertedcolumnindex_word_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _invertedcolumnindex_word_idx ON _invertedcolumnindex USING btree (word);

ALTER TABLE _invertedcolumnindex CLUSTER ON _invertedcolumnindex_word_idx;


--
-- Name: idx_91271_sqlite_autoindex_highschooler_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_91271_sqlite_autoindex_highschooler_1 ON highschooler USING btree (id);


--
-- Name: _aggr_aoo_friend_friend_idtostudent_id _aggr_aoo_friend_friend_idtostudent_id_friend_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_friend_friend_idtostudent_id
    ADD CONSTRAINT _aggr_aoo_friend_friend_idtostudent_id_friend_id_fk FOREIGN KEY (friend_id) REFERENCES highschooler(id);


--
-- Name: _aggr_aoo_friend_student_idtofriend_id _aggr_aoo_friend_student_idtofriend_id_student_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_friend_student_idtofriend_id
    ADD CONSTRAINT _aggr_aoo_friend_student_idtofriend_id_student_id_fk FOREIGN KEY (student_id) REFERENCES highschooler(id);


--
-- Name: _aggr_aoo_likes_liked_idtostudent_id _aggr_aoo_likes_liked_idtostudent_id_liked_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_likes_liked_idtostudent_id
    ADD CONSTRAINT _aggr_aoo_likes_liked_idtostudent_id_liked_id_fk FOREIGN KEY (liked_id) REFERENCES highschooler(id);


--
-- Name: _aggr_aoo_likes_student_idtoliked_id _aggr_aoo_likes_student_idtoliked_id_student_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_likes_student_idtoliked_id
    ADD CONSTRAINT _aggr_aoo_likes_student_idtoliked_id_student_id_fk FOREIGN KEY (student_id) REFERENCES highschooler(id);


--
-- Name: friend friend_friend_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY friend
    ADD CONSTRAINT friend_friend_id_fkey FOREIGN KEY (friend_id) REFERENCES highschooler(id);


--
-- Name: friend friend_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY friend
    ADD CONSTRAINT friend_student_id_fkey FOREIGN KEY (student_id) REFERENCES highschooler(id);


--
-- Name: likes likes_liked_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY likes
    ADD CONSTRAINT likes_liked_id_fkey FOREIGN KEY (liked_id) REFERENCES highschooler(id);


--
-- Name: likes likes_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY likes
    ADD CONSTRAINT likes_student_id_fkey FOREIGN KEY (student_id) REFERENCES highschooler(id);


--
-- PostgreSQL database dump complete
--

