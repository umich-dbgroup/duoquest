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
-- Name: _aggr_aoo_hiring_shop_idtoemployee_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_hiring_shop_idtoemployee_id (
    shop_id integer,
    employee_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_hiring_shop_idtoemployee_id OWNER TO afariha;

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
-- Name: employee; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE employee (
    employee_id integer NOT NULL,
    name text,
    age integer,
    city text
);


ALTER TABLE employee OWNER TO afariha;

--
-- Name: evaluation; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE evaluation (
    employee_id integer,
    year_awarded text,
    bonus real
);


ALTER TABLE evaluation OWNER TO afariha;

--
-- Name: hiring; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE hiring (
    shop_id integer,
    employee_id integer,
    start_from text,
    is_full_time boolean
);


ALTER TABLE hiring OWNER TO afariha;

--
-- Name: shop; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE shop (
    shop_id integer NOT NULL,
    name text,
    location text,
    district text,
    number_products integer,
    manager_name text
);


ALTER TABLE shop OWNER TO afariha;

--
-- Name: _invertedcolumnindex _invertedcolumnindex_word_tabname_colname_key; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _invertedcolumnindex
    ADD CONSTRAINT _invertedcolumnindex_word_tabname_colname_key UNIQUE (word, tabname, colname);


--
-- Name: employee employee_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (employee_id);


--
-- Name: shop shop_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY shop
    ADD CONSTRAINT shop_pkey PRIMARY KEY (shop_id);


--
-- Name: _aggr_aoo_hiring_shop_idtoemployee_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_hiring_shop_idtoemployee_id_idx ON _aggr_aoo_hiring_shop_idtoemployee_id USING btree (shop_id);


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
-- Name: idx_44297_sqlite_autoindex_employee_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_44297_sqlite_autoindex_employee_1 ON employee USING btree (employee_id);


--
-- Name: idx_44303_sqlite_autoindex_shop_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_44303_sqlite_autoindex_shop_1 ON shop USING btree (shop_id);


--
-- Name: idx_44309_sqlite_autoindex_hiring_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_44309_sqlite_autoindex_hiring_1 ON hiring USING btree (employee_id);


--
-- Name: idx_44315_sqlite_autoindex_evaluation_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_44315_sqlite_autoindex_evaluation_1 ON evaluation USING btree (employee_id, year_awarded);


--
-- Name: evaluation evaluation_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY evaluation
    ADD CONSTRAINT evaluation_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES employee(employee_id);


--
-- Name: hiring hiring_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY hiring
    ADD CONSTRAINT hiring_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES employee(employee_id);


--
-- Name: hiring hiring_shop_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY hiring
    ADD CONSTRAINT hiring_shop_id_fkey FOREIGN KEY (shop_id) REFERENCES shop(shop_id);


--
-- PostgreSQL database dump complete
--

