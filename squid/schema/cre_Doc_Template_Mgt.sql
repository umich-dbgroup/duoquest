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
-- Name: _aggr_aoo_documents_to_templates_document_idtotemplate_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_documents_to_templates_document_idtotemplate_id (
    document_id integer,
    template_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_documents_to_templates_document_idtotemplate_id OWNER TO afariha;

--
-- Name: _aggr_aoo_documents_to_templates_template_idtodocument_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_documents_to_templates_template_idtodocument_id (
    template_id integer,
    document_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_documents_to_templates_template_idtodocument_id OWNER TO afariha;

--
-- Name: _aggr_aoo_templates_to_types_template_idtotype_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_templates_to_types_template_idtotype_id (
    template_id integer,
    type_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_templates_to_types_template_idtotype_id OWNER TO afariha;

--
-- Name: _aggr_aoo_templates_to_types_type_idtotemplate_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_templates_to_types_type_idtotemplate_id (
    type_id integer,
    template_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_templates_to_types_type_idtotemplate_id OWNER TO afariha;

--
-- Name: _aggr_aoo_types_to_descriptions_description_idtotype_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_types_to_descriptions_description_idtotype_id (
    description_id integer,
    type_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_types_to_descriptions_description_idtotype_id OWNER TO afariha;

--
-- Name: _aggr_aoo_types_to_descriptions_type_idtodescription_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_types_to_descriptions_type_idtodescription_id (
    type_id integer,
    description_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_types_to_descriptions_type_idtodescription_id OWNER TO afariha;

--
-- Name: _documentstodate_effective_from; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _documentstodate_effective_from (
    documents_document_id integer NOT NULL,
    date_effective_from text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _documentstodate_effective_from OWNER TO afariha;

--
-- Name: _documentstodate_effective_to; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _documentstodate_effective_to (
    documents_document_id integer NOT NULL,
    date_effective_to text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _documentstodate_effective_to OWNER TO afariha;

--
-- Name: _documentstoversion_number; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _documentstoversion_number (
    documents_document_id integer NOT NULL,
    version_number integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _documentstoversion_number OWNER TO afariha;

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
-- Name: _ref_template_typestodate_effective_from; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _ref_template_typestodate_effective_from (
    ref_template_types_type_id integer NOT NULL,
    date_effective_from text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _ref_template_typestodate_effective_from OWNER TO afariha;

--
-- Name: _ref_template_typestodate_effective_to; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _ref_template_typestodate_effective_to (
    ref_template_types_type_id integer NOT NULL,
    date_effective_to text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _ref_template_typestodate_effective_to OWNER TO afariha;

--
-- Name: _ref_template_typestoversion_number; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _ref_template_typestoversion_number (
    ref_template_types_type_id integer NOT NULL,
    version_number integer,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _ref_template_typestoversion_number OWNER TO afariha;

--
-- Name: _templatestodocument_description; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _templatestodocument_description (
    templates_template_id integer NOT NULL,
    document_description text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _templatestodocument_description OWNER TO afariha;

--
-- Name: _templatestoother_details; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _templatestoother_details (
    templates_template_id integer NOT NULL,
    other_details text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _templatestoother_details OWNER TO afariha;

--
-- Name: documents; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE documents (
    document_id bigint NOT NULL,
    document_name text,
    document_description text,
    other_details text
);


ALTER TABLE documents OWNER TO afariha;

--
-- Name: documents_to_templates; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE documents_to_templates (
    document_id integer,
    template_id integer
);


ALTER TABLE documents_to_templates OWNER TO afariha;

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
    date_effective_from text,
    date_effective_to text,
    template_details text
);


ALTER TABLE templates OWNER TO afariha;

--
-- Name: templates_to_types; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE templates_to_types (
    template_id integer,
    type_id integer
);


ALTER TABLE templates_to_types OWNER TO afariha;

--
-- Name: type_descriptions; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE type_descriptions (
    id integer NOT NULL,
    description text
);


ALTER TABLE type_descriptions OWNER TO afariha;

--
-- Name: type_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: afariha
--

CREATE SEQUENCE type_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE type_descriptions_id_seq OWNER TO afariha;

--
-- Name: type_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: afariha
--

ALTER SEQUENCE type_descriptions_id_seq OWNED BY type_descriptions.id;


--
-- Name: types_to_descriptions; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE types_to_descriptions (
    type_id integer,
    description_id integer
);


ALTER TABLE types_to_descriptions OWNER TO afariha;

--
-- Name: ref_template_types type_id; Type: DEFAULT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY ref_template_types ALTER COLUMN type_id SET DEFAULT nextval('ref_template_types_type_id_seq'::regclass);


--
-- Name: type_descriptions id; Type: DEFAULT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY type_descriptions ALTER COLUMN id SET DEFAULT nextval('type_descriptions_id_seq'::regclass);


--
-- Name: _invertedcolumnindex _invertedcolumnindex_word_tabname_colname_key; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _invertedcolumnindex
    ADD CONSTRAINT _invertedcolumnindex_word_tabname_colname_key UNIQUE (word, tabname, colname);


--
-- Name: templates idx_67391_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY templates
    ADD CONSTRAINT idx_67391_templates_pkey PRIMARY KEY (template_id);


--
-- Name: documents idx_67397_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY documents
    ADD CONSTRAINT idx_67397_documents_pkey PRIMARY KEY (document_id);


--
-- Name: paragraphs idx_67403_paragraphs_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY paragraphs
    ADD CONSTRAINT idx_67403_paragraphs_pkey PRIMARY KEY (paragraph_id);


--
-- Name: ref_template_types ref_template_types_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY ref_template_types
    ADD CONSTRAINT ref_template_types_pkey PRIMARY KEY (type_id);


--
-- Name: type_descriptions type_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY type_descriptions
    ADD CONSTRAINT type_descriptions_pkey PRIMARY KEY (id);


--
-- Name: _aggr_aoo_documents_to_templates_document_idtotemplate_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_documents_to_templates_document_idtotemplate_id_idx ON _aggr_aoo_documents_to_templates_document_idtotemplate_id USING btree (document_id);


--
-- Name: _aggr_aoo_documents_to_templates_template_idtodocument_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_documents_to_templates_template_idtodocument_id_idx ON _aggr_aoo_documents_to_templates_template_idtodocument_id USING btree (template_id);


--
-- Name: _aggr_aoo_templates_to_types_template_idtotype_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_templates_to_types_template_idtotype_id_idx ON _aggr_aoo_templates_to_types_template_idtotype_id USING btree (template_id);


--
-- Name: _aggr_aoo_templates_to_types_type_idtotemplate_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_templates_to_types_type_idtotemplate_id_idx ON _aggr_aoo_templates_to_types_type_idtotemplate_id USING btree (type_id);


--
-- Name: _aggr_aoo_types_to_descriptions_description_idtotype_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_types_to_descriptions_description_idtotype_id_idx ON _aggr_aoo_types_to_descriptions_description_idtotype_id USING btree (description_id);


--
-- Name: _aggr_aoo_types_to_descriptions_type_idtodescription_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_types_to_descriptions_type_idtodescription_id_idx ON _aggr_aoo_types_to_descriptions_type_idtodescription_id USING btree (type_id);


--
-- Name: _documentstodate_effective_from_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _documentstodate_effective_from_idx ON _documentstodate_effective_from USING btree (date_effective_from, freq);

ALTER TABLE _documentstodate_effective_from CLUSTER ON _documentstodate_effective_from_idx;


--
-- Name: _documentstodate_effective_from_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _documentstodate_effective_from_idx_2 ON _documentstodate_effective_from USING btree (documents_document_id);


--
-- Name: _documentstodate_effective_to_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _documentstodate_effective_to_idx ON _documentstodate_effective_to USING btree (date_effective_to, freq);

ALTER TABLE _documentstodate_effective_to CLUSTER ON _documentstodate_effective_to_idx;


--
-- Name: _documentstodate_effective_to_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _documentstodate_effective_to_idx_2 ON _documentstodate_effective_to USING btree (documents_document_id);


--
-- Name: _documentstoversion_number_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _documentstoversion_number_idx ON _documentstoversion_number USING btree (version_number, freq);

ALTER TABLE _documentstoversion_number CLUSTER ON _documentstoversion_number_idx;


--
-- Name: _documentstoversion_number_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _documentstoversion_number_idx_2 ON _documentstoversion_number USING btree (documents_document_id);


--
-- Name: _invertedcolumnindex_word_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _invertedcolumnindex_word_idx ON _invertedcolumnindex USING btree (word);

ALTER TABLE _invertedcolumnindex CLUSTER ON _invertedcolumnindex_word_idx;


--
-- Name: _ref_template_typestodate_effective_from_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _ref_template_typestodate_effective_from_idx ON _ref_template_typestodate_effective_from USING btree (date_effective_from, freq);

ALTER TABLE _ref_template_typestodate_effective_from CLUSTER ON _ref_template_typestodate_effective_from_idx;


--
-- Name: _ref_template_typestodate_effective_from_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _ref_template_typestodate_effective_from_idx_2 ON _ref_template_typestodate_effective_from USING btree (ref_template_types_type_id);


--
-- Name: _ref_template_typestodate_effective_to_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _ref_template_typestodate_effective_to_idx ON _ref_template_typestodate_effective_to USING btree (date_effective_to, freq);

ALTER TABLE _ref_template_typestodate_effective_to CLUSTER ON _ref_template_typestodate_effective_to_idx;


--
-- Name: _ref_template_typestodate_effective_to_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _ref_template_typestodate_effective_to_idx_2 ON _ref_template_typestodate_effective_to USING btree (ref_template_types_type_id);


--
-- Name: _ref_template_typestoversion_number_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _ref_template_typestoversion_number_idx ON _ref_template_typestoversion_number USING btree (version_number, freq);

ALTER TABLE _ref_template_typestoversion_number CLUSTER ON _ref_template_typestoversion_number_idx;


--
-- Name: _ref_template_typestoversion_number_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _ref_template_typestoversion_number_idx_2 ON _ref_template_typestoversion_number USING btree (ref_template_types_type_id);


--
-- Name: _templatestodocument_description_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _templatestodocument_description_idx ON _templatestodocument_description USING btree (document_description, freq);

ALTER TABLE _templatestodocument_description CLUSTER ON _templatestodocument_description_idx;


--
-- Name: _templatestodocument_description_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _templatestodocument_description_idx_2 ON _templatestodocument_description USING btree (templates_template_id);


--
-- Name: _templatestoother_details_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _templatestoother_details_idx ON _templatestoother_details USING btree (other_details, freq);

ALTER TABLE _templatestoother_details CLUSTER ON _templatestoother_details_idx;


--
-- Name: _templatestoother_details_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _templatestoother_details_idx_2 ON _templatestoother_details USING btree (templates_template_id);


--
-- Name: idx_67385_sqlite_autoindex_ref_template_types_1; Type: INDEX; Schema: public; Owner: afariha
--

CREATE UNIQUE INDEX idx_67385_sqlite_autoindex_ref_template_types_1 ON ref_template_types USING btree (template_type_code);


--
-- Name: _aggr_aoo_documents_to_templates_document_idtotemplate_id _aggr_aoo_documents_to_templates_document_idtotemplate_id_docum; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_documents_to_templates_document_idtotemplate_id
    ADD CONSTRAINT _aggr_aoo_documents_to_templates_document_idtotemplate_id_docum FOREIGN KEY (document_id) REFERENCES documents(document_id);


--
-- Name: _aggr_aoo_documents_to_templates_template_idtodocument_id _aggr_aoo_documents_to_templates_template_idtodocument_id_templ; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_documents_to_templates_template_idtodocument_id
    ADD CONSTRAINT _aggr_aoo_documents_to_templates_template_idtodocument_id_templ FOREIGN KEY (template_id) REFERENCES templates(template_id);


--
-- Name: _aggr_aoo_templates_to_types_template_idtotype_id _aggr_aoo_templates_to_types_template_idtotype_id_template_id_f; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_templates_to_types_template_idtotype_id
    ADD CONSTRAINT _aggr_aoo_templates_to_types_template_idtotype_id_template_id_f FOREIGN KEY (template_id) REFERENCES templates(template_id);


--
-- Name: _aggr_aoo_templates_to_types_type_idtotemplate_id _aggr_aoo_templates_to_types_type_idtotemplate_id_type_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_templates_to_types_type_idtotemplate_id
    ADD CONSTRAINT _aggr_aoo_templates_to_types_type_idtotemplate_id_type_id_fk FOREIGN KEY (type_id) REFERENCES ref_template_types(type_id);


--
-- Name: _aggr_aoo_types_to_descriptions_description_idtotype_id _aggr_aoo_types_to_descriptions_description_idtotype_id_descrip; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_types_to_descriptions_description_idtotype_id
    ADD CONSTRAINT _aggr_aoo_types_to_descriptions_description_idtotype_id_descrip FOREIGN KEY (description_id) REFERENCES type_descriptions(id);


--
-- Name: _aggr_aoo_types_to_descriptions_type_idtodescription_id _aggr_aoo_types_to_descriptions_type_idtodescription_id_type_id; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_types_to_descriptions_type_idtodescription_id
    ADD CONSTRAINT _aggr_aoo_types_to_descriptions_type_idtodescription_id_type_id FOREIGN KEY (type_id) REFERENCES ref_template_types(type_id);


--
-- Name: _documentstodate_effective_from _documentstodate_effective_from_documents_document_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _documentstodate_effective_from
    ADD CONSTRAINT _documentstodate_effective_from_documents_document_id_fkey FOREIGN KEY (documents_document_id) REFERENCES documents(document_id);


--
-- Name: _documentstodate_effective_to _documentstodate_effective_to_documents_document_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _documentstodate_effective_to
    ADD CONSTRAINT _documentstodate_effective_to_documents_document_id_fkey FOREIGN KEY (documents_document_id) REFERENCES documents(document_id);


--
-- Name: _documentstoversion_number _documentstoversion_number_documents_document_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _documentstoversion_number
    ADD CONSTRAINT _documentstoversion_number_documents_document_id_fkey FOREIGN KEY (documents_document_id) REFERENCES documents(document_id);


--
-- Name: _ref_template_typestodate_effective_to _ref_template_typestodate_effe_ref_template_types_type_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _ref_template_typestodate_effective_to
    ADD CONSTRAINT _ref_template_typestodate_effe_ref_template_types_type_id_fkey1 FOREIGN KEY (ref_template_types_type_id) REFERENCES ref_template_types(type_id);


--
-- Name: _ref_template_typestodate_effective_from _ref_template_typestodate_effec_ref_template_types_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _ref_template_typestodate_effective_from
    ADD CONSTRAINT _ref_template_typestodate_effec_ref_template_types_type_id_fkey FOREIGN KEY (ref_template_types_type_id) REFERENCES ref_template_types(type_id);


--
-- Name: _ref_template_typestoversion_number _ref_template_typestoversion_nu_ref_template_types_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _ref_template_typestoversion_number
    ADD CONSTRAINT _ref_template_typestoversion_nu_ref_template_types_type_id_fkey FOREIGN KEY (ref_template_types_type_id) REFERENCES ref_template_types(type_id);


--
-- Name: _templatestodocument_description _templatestodocument_description_templates_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _templatestodocument_description
    ADD CONSTRAINT _templatestodocument_description_templates_template_id_fkey FOREIGN KEY (templates_template_id) REFERENCES templates(template_id);


--
-- Name: _templatestoother_details _templatestoother_details_templates_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _templatestoother_details
    ADD CONSTRAINT _templatestoother_details_templates_template_id_fkey FOREIGN KEY (templates_template_id) REFERENCES templates(template_id);


--
-- Name: documents_to_templates documents_to_templates_document_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY documents_to_templates
    ADD CONSTRAINT documents_to_templates_document_id_fkey FOREIGN KEY (document_id) REFERENCES documents(document_id);


--
-- Name: documents_to_templates documents_to_templates_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY documents_to_templates
    ADD CONSTRAINT documents_to_templates_template_id_fkey FOREIGN KEY (template_id) REFERENCES templates(template_id);


--
-- Name: paragraphs paragraphs_document_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY paragraphs
    ADD CONSTRAINT paragraphs_document_id_fkey FOREIGN KEY (document_id) REFERENCES documents(document_id);


--
-- Name: templates_to_types templates_to_types_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY templates_to_types
    ADD CONSTRAINT templates_to_types_template_id_fkey FOREIGN KEY (template_id) REFERENCES templates(template_id);


--
-- Name: templates_to_types templates_to_types_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY templates_to_types
    ADD CONSTRAINT templates_to_types_type_id_fkey FOREIGN KEY (type_id) REFERENCES ref_template_types(type_id);


--
-- Name: types_to_descriptions types_to_descriptions_description_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY types_to_descriptions
    ADD CONSTRAINT types_to_descriptions_description_id_fkey FOREIGN KEY (description_id) REFERENCES type_descriptions(id);


--
-- Name: types_to_descriptions types_to_descriptions_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY types_to_descriptions
    ADD CONSTRAINT types_to_descriptions_type_id_fkey FOREIGN KEY (type_id) REFERENCES ref_template_types(type_id);


--
-- PostgreSQL database dump complete
--

