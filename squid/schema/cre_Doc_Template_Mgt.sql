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
-- Name: _invertedcolumnindex; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _invertedcolumnindex (
    word text,
    tabname text,
    colname text
);


ALTER TABLE _invertedcolumnindex OWNER TO afariha;

--
-- Name: documents; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE documents (
    document_id bigint NOT NULL,
    template_id bigint,
    document_name text,
    document_description text,
    other_details text
);


ALTER TABLE documents OWNER TO afariha;

--
-- Name: paragraphs; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE paragraphs (
    paragraph_id bigint NOT NULL,
    document_id bigint,
    paragraph_text text,
    other_details text
);


ALTER TABLE paragraphs OWNER TO afariha;

--
-- Name: ref_template_types; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE ref_template_types (
    template_type_code text,
    template_type_description text,
    type_id integer NOT NULL
);


ALTER TABLE ref_template_types OWNER TO afariha;

--
-- Name: ref_template_types_type_id_seq; Type: SEQUENCE; Schema: public; Owner: afariha
--

CREATE SEQUENCE ref_template_types_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ref_template_types_type_id_seq OWNER TO afariha;

--
-- Name: ref_template_types_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: afariha
--

ALTER SEQUENCE ref_template_types_type_id_seq OWNED BY ref_template_types.type_id;


--
-- Name: templates; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE templates (
    template_id bigint NOT NULL,
    version_number bigint,
    template_type_code text,
    date_effective_from timestamp with time zone,
    date_effective_to timestamp with time zone,
    template_details text
);


ALTER TABLE templates OWNER TO afariha;

--
-- Name: ref_template_types type_id; Type: DEFAULT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY ref_template_types ALTER COLUMN type_id SET DEFAULT nextval('ref_template_types_type_id_seq'::regclass);


--
-- Name: _invertedcolumnindex _invertedcolumnindex_word_tabname_colname_key; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _invertedcolumnindex
    ADD CONSTRAINT _invertedcolumnindex_word_tabname_colname_key UNIQUE (word, tabname, colname);


--
-- Name: templates idx_45422_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY templates
    ADD CONSTRAINT idx_45422_templates_pkey PRIMARY KEY (template_id);


--
-- Name: documents idx_45428_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY documents
    ADD CONSTRAINT idx_45428_documents_pkey PRIMARY KEY (document_id);


--
-- Name: paragraphs idx_45434_paragraphs_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY paragraphs
    ADD CONSTRAINT idx_45434_paragraphs_pkey PRIMARY KEY (paragraph_id);


--
-- Name: ref_template_types ref_template_types_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY ref_template_types
    ADD CONSTRAINT ref_template_types_pkey PRIMARY KEY (type_id);


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
-- Name: idx_45416_sqlite_autoindex_ref_template_types_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_45416_sqlite_autoindex_ref_template_types_1 ON ref_template_types USING btree (template_type_code);


--
-- Name: documents documents_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY documents
    ADD CONSTRAINT documents_template_id_fkey FOREIGN KEY (template_id) REFERENCES templates(template_id);


--
-- Name: paragraphs paragraphs_document_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY paragraphs
    ADD CONSTRAINT paragraphs_document_id_fkey FOREIGN KEY (document_id) REFERENCES documents(document_id);


--
-- Name: templates templates_template_type_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY templates
    ADD CONSTRAINT templates_template_type_code_fkey FOREIGN KEY (template_type_code) REFERENCES ref_template_types(template_type_code);


--
-- PostgreSQL database dump complete
--

