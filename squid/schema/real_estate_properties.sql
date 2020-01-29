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
-- Name: _aggr_aoo_features_to_types_feature_idtotype_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_features_to_types_feature_idtotype_id (
    feature_id integer,
    type_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_features_to_types_feature_idtotype_id OWNER TO afariha;

--
-- Name: _aggr_aoo_features_to_types_type_idtofeature_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_features_to_types_type_idtofeature_id (
    type_id integer,
    feature_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_features_to_types_type_idtofeature_id OWNER TO afariha;

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
-- Name: features_to_types; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE features_to_types (
    feature_id integer,
    type_id integer
);


ALTER TABLE features_to_types OWNER TO afariha;

--
-- Name: other_available_features; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE other_available_features (
    feature_id bigint NOT NULL,
    feature_name text,
    feature_description text
);


ALTER TABLE other_available_features OWNER TO afariha;

--
-- Name: other_property_features; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE other_property_features (
    property_id bigint,
    feature_id bigint,
    property_feature_description text
);


ALTER TABLE other_property_features OWNER TO afariha;

--
-- Name: properties; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE properties (
    property_id bigint NOT NULL,
    property_type_code text,
    date_on_market timestamp with time zone,
    date_sold timestamp with time zone,
    property_name text,
    property_address text,
    room_count bigint,
    vendor_requested_price numeric(19,4),
    buyer_offered_price numeric(19,4),
    agreed_selling_price numeric(19,4),
    apt_feature_1 text,
    apt_feature_2 text,
    apt_feature_3 text,
    fld_feature_1 text,
    fld_feature_2 text,
    fld_feature_3 text,
    hse_feature_1 text,
    hse_feature_2 text,
    hse_feature_3 text,
    oth_feature_1 text,
    oth_feature_2 text,
    oth_feature_3 text,
    shp_feature_1 text,
    shp_feature_2 text,
    shp_feature_3 text,
    other_property_details text
);


ALTER TABLE properties OWNER TO afariha;

--
-- Name: ref_feature_types; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE ref_feature_types (
    id integer NOT NULL,
    feature_type_code text,
    feature_type_name text
);


ALTER TABLE ref_feature_types OWNER TO afariha;

--
-- Name: ref_feature_types_id_seq; Type: SEQUENCE; Schema: public; Owner: afariha
--

CREATE SEQUENCE ref_feature_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ref_feature_types_id_seq OWNER TO afariha;

--
-- Name: ref_feature_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: afariha
--

ALTER SEQUENCE ref_feature_types_id_seq OWNED BY ref_feature_types.id;


--
-- Name: ref_property_types; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE ref_property_types (
    property_type_code text NOT NULL,
    property_type_description text
);


ALTER TABLE ref_property_types OWNER TO afariha;

--
-- Name: ref_feature_types id; Type: DEFAULT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY ref_feature_types ALTER COLUMN id SET DEFAULT nextval('ref_feature_types_id_seq'::regclass);


--
-- Name: _invertedcolumnindex _invertedcolumnindex_word_tabname_colname_key; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _invertedcolumnindex
    ADD CONSTRAINT _invertedcolumnindex_word_tabname_colname_key UNIQUE (word, tabname, colname);


--
-- Name: ref_property_types idx_91744_sqlite_autoindex_ref_property_types_1; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY ref_property_types
    ADD CONSTRAINT idx_91744_sqlite_autoindex_ref_property_types_1 PRIMARY KEY (property_type_code);


--
-- Name: other_available_features idx_91750_other_available_features_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY other_available_features
    ADD CONSTRAINT idx_91750_other_available_features_pkey PRIMARY KEY (feature_id);


--
-- Name: properties idx_91756_properties_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY properties
    ADD CONSTRAINT idx_91756_properties_pkey PRIMARY KEY (property_id);


--
-- Name: ref_feature_types ref_feature_types_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY ref_feature_types
    ADD CONSTRAINT ref_feature_types_pkey PRIMARY KEY (id);


--
-- Name: _aggr_aoo_features_to_types_feature_idtotype_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_features_to_types_feature_idtotype_id_idx ON _aggr_aoo_features_to_types_feature_idtotype_id USING btree (feature_id);


--
-- Name: _aggr_aoo_features_to_types_type_idtofeature_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_features_to_types_type_idtofeature_id_idx ON _aggr_aoo_features_to_types_type_idtofeature_id USING btree (type_id);


--
-- Name: _invertedcolumnindex_word_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _invertedcolumnindex_word_idx ON _invertedcolumnindex USING btree (word);

ALTER TABLE _invertedcolumnindex CLUSTER ON _invertedcolumnindex_word_idx;


--
-- Name: _aggr_aoo_features_to_types_feature_idtotype_id _aggr_aoo_features_to_types_feature_idtotype_id_feature_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_features_to_types_feature_idtotype_id
    ADD CONSTRAINT _aggr_aoo_features_to_types_feature_idtotype_id_feature_id_fk FOREIGN KEY (feature_id) REFERENCES other_available_features(feature_id);


--
-- Name: _aggr_aoo_features_to_types_type_idtofeature_id _aggr_aoo_features_to_types_type_idtofeature_id_type_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_features_to_types_type_idtofeature_id
    ADD CONSTRAINT _aggr_aoo_features_to_types_type_idtofeature_id_type_id_fk FOREIGN KEY (type_id) REFERENCES ref_feature_types(id);


--
-- Name: features_to_types features_to_types_feature_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY features_to_types
    ADD CONSTRAINT features_to_types_feature_id_fkey FOREIGN KEY (feature_id) REFERENCES other_available_features(feature_id);


--
-- Name: features_to_types features_to_types_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY features_to_types
    ADD CONSTRAINT features_to_types_type_id_fkey FOREIGN KEY (type_id) REFERENCES ref_feature_types(id);


--
-- Name: other_property_features other_property_features_feature_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY other_property_features
    ADD CONSTRAINT other_property_features_feature_id_fkey FOREIGN KEY (feature_id) REFERENCES other_available_features(feature_id);


--
-- Name: other_property_features other_property_features_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY other_property_features
    ADD CONSTRAINT other_property_features_property_id_fkey FOREIGN KEY (property_id) REFERENCES properties(property_id);


--
-- Name: properties properties_property_type_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY properties
    ADD CONSTRAINT properties_property_type_code_fkey FOREIGN KEY (property_type_code) REFERENCES ref_property_types(property_type_code);


--
-- PostgreSQL database dump complete
--

