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
-- Name: _aggr_aoo_channel_to_cartoon_cartoon_idtochannel_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_channel_to_cartoon_cartoon_idtochannel_id (
    cartoon_id integer,
    channel_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_channel_to_cartoon_cartoon_idtochannel_id OWNER TO afariha;

--
-- Name: _aggr_aoo_channel_to_cartoon_channel_idtocartoon_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_channel_to_cartoon_channel_idtocartoon_id (
    channel_id integer,
    cartoon_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_channel_to_cartoon_channel_idtocartoon_id OWNER TO afariha;

--
-- Name: _aggr_aoo_channel_to_content_channel_idtocontent_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_channel_to_content_channel_idtocontent_id (
    channel_id integer,
    content_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_channel_to_content_channel_idtocontent_id OWNER TO afariha;

--
-- Name: _aggr_aoo_channel_to_content_content_idtochannel_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_channel_to_content_content_idtochannel_id (
    content_id integer,
    channel_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_channel_to_content_content_idtochannel_id OWNER TO afariha;

--
-- Name: _aggr_aoo_channel_to_country_channel_idtocountry_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_channel_to_country_channel_idtocountry_id (
    channel_id integer,
    country_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_channel_to_country_channel_idtocountry_id OWNER TO afariha;

--
-- Name: _aggr_aoo_channel_to_country_country_idtochannel_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_channel_to_country_country_idtochannel_id (
    country_id integer,
    channel_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_channel_to_country_country_idtochannel_id OWNER TO afariha;

--
-- Name: _aggr_aoo_channel_to_pack_opt_channel_idtopack_opt_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_channel_to_pack_opt_channel_idtopack_opt_id (
    channel_id integer,
    pack_opt_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_channel_to_pack_opt_channel_idtopack_opt_id OWNER TO afariha;

--
-- Name: _aggr_aoo_channel_to_pack_opt_pack_opt_idtochannel_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_channel_to_pack_opt_pack_opt_idtochannel_id (
    pack_opt_id integer,
    channel_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_channel_to_pack_opt_pack_opt_idtochannel_id OWNER TO afariha;

--
-- Name: _aggr_aoo_channel_to_pixel_channel_idtopixel_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_channel_to_pixel_channel_idtopixel_id (
    channel_id integer,
    pixel_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_channel_to_pixel_channel_idtopixel_id OWNER TO afariha;

--
-- Name: _aggr_aoo_channel_to_pixel_pixel_idtochannel_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_channel_to_pixel_pixel_idtochannel_id (
    pixel_id integer,
    channel_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_channel_to_pixel_pixel_idtochannel_id OWNER TO afariha;

--
-- Name: _aggr_aoo_series_to_air_date_air_date_idtoseries_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_series_to_air_date_air_date_idtoseries_id (
    air_date_id integer,
    series_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_series_to_air_date_air_date_idtoseries_id OWNER TO afariha;

--
-- Name: _aggr_aoo_series_to_air_date_series_idtoair_date_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_series_to_air_date_series_idtoair_date_id (
    series_id integer,
    air_date_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_series_to_air_date_series_idtoair_date_id OWNER TO afariha;

--
-- Name: _aggr_aoo_series_to_channel_channel_idtoseries_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_series_to_channel_channel_idtoseries_id (
    channel_id integer,
    series_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_series_to_channel_channel_idtoseries_id OWNER TO afariha;

--
-- Name: _aggr_aoo_series_to_channel_series_idtochannel_id; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _aggr_aoo_series_to_channel_series_idtochannel_id (
    series_id integer,
    channel_id_aggr integer[],
    count bigint
);


ALTER TABLE _aggr_aoo_series_to_channel_series_idtochannel_id OWNER TO afariha;

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
-- Name: _tv_channeltodirected_by; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _tv_channeltodirected_by (
    tv_channel_id integer NOT NULL,
    directed_by text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _tv_channeltodirected_by OWNER TO afariha;

--
-- Name: _tv_channeltowritten_by; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE _tv_channeltowritten_by (
    tv_channel_id integer NOT NULL,
    written_by text,
    freq integer,
    normalized_freq integer
);


ALTER TABLE _tv_channeltowritten_by OWNER TO afariha;

--
-- Name: air_date; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE air_date (
    id integer NOT NULL,
    air_date text
);


ALTER TABLE air_date OWNER TO afariha;

--
-- Name: air_date_id_seq; Type: SEQUENCE; Schema: public; Owner: afariha
--

CREATE SEQUENCE air_date_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE air_date_id_seq OWNER TO afariha;

--
-- Name: air_date_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: afariha
--

ALTER SEQUENCE air_date_id_seq OWNED BY air_date.id;


--
-- Name: cartoon; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE cartoon (
    id real NOT NULL,
    title text,
    directed_by text,
    written_by text,
    original_air_date text,
    production_code real
);


ALTER TABLE cartoon OWNER TO afariha;

--
-- Name: channel_to_cartoon; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE channel_to_cartoon (
    channel_id integer,
    cartoon_id integer
);


ALTER TABLE channel_to_cartoon OWNER TO afariha;

--
-- Name: channel_to_content; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE channel_to_content (
    channel_id integer,
    content_id integer
);


ALTER TABLE channel_to_content OWNER TO afariha;

--
-- Name: channel_to_country; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE channel_to_country (
    channel_id integer,
    country_id integer
);


ALTER TABLE channel_to_country OWNER TO afariha;

--
-- Name: channel_to_pack_opt; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE channel_to_pack_opt (
    channel_id integer,
    pack_opt_id integer
);


ALTER TABLE channel_to_pack_opt OWNER TO afariha;

--
-- Name: channel_to_pixel; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE channel_to_pixel (
    channel_id integer,
    pixel_id integer
);


ALTER TABLE channel_to_pixel OWNER TO afariha;

--
-- Name: content; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE content (
    id integer NOT NULL,
    content text
);


ALTER TABLE content OWNER TO afariha;

--
-- Name: content_id_seq; Type: SEQUENCE; Schema: public; Owner: afariha
--

CREATE SEQUENCE content_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE content_id_seq OWNER TO afariha;

--
-- Name: content_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: afariha
--

ALTER SEQUENCE content_id_seq OWNED BY content.id;


--
-- Name: country; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE country (
    id integer NOT NULL,
    country text
);


ALTER TABLE country OWNER TO afariha;

--
-- Name: country_id_seq; Type: SEQUENCE; Schema: public; Owner: afariha
--

CREATE SEQUENCE country_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE country_id_seq OWNER TO afariha;

--
-- Name: country_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: afariha
--

ALTER SEQUENCE country_id_seq OWNED BY country.id;


--
-- Name: pack_opt; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE pack_opt (
    id integer NOT NULL,
    pack_opt text
);


ALTER TABLE pack_opt OWNER TO afariha;

--
-- Name: pack_opt_id_seq; Type: SEQUENCE; Schema: public; Owner: afariha
--

CREATE SEQUENCE pack_opt_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pack_opt_id_seq OWNER TO afariha;

--
-- Name: pack_opt_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: afariha
--

ALTER SEQUENCE pack_opt_id_seq OWNED BY pack_opt.id;


--
-- Name: pixel; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE pixel (
    id integer NOT NULL,
    pixel text
);


ALTER TABLE pixel OWNER TO afariha;

--
-- Name: pixel_id_seq; Type: SEQUENCE; Schema: public; Owner: afariha
--

CREATE SEQUENCE pixel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pixel_id_seq OWNER TO afariha;

--
-- Name: pixel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: afariha
--

ALTER SEQUENCE pixel_id_seq OWNED BY pixel.id;


--
-- Name: series_to_air_date; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE series_to_air_date (
    series_id integer,
    air_date_id integer
);


ALTER TABLE series_to_air_date OWNER TO afariha;

--
-- Name: series_to_channel; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE series_to_channel (
    series_id integer,
    channel_id integer
);


ALTER TABLE series_to_channel OWNER TO afariha;

--
-- Name: tv_channel; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE tv_channel (
    id integer NOT NULL,
    series_name text,
    language text,
    hight_definition_tv text,
    pay_per_view_ppv text
);


ALTER TABLE tv_channel OWNER TO afariha;

--
-- Name: tv_series; Type: TABLE; Schema: public; Owner: afariha
--

CREATE TABLE tv_series (
    id real NOT NULL,
    episode text,
    rating text,
    share real,
    a18_49_rating_share text,
    viewers_m text,
    weekly_rank real,
    channel integer
);


ALTER TABLE tv_series OWNER TO afariha;

--
-- Name: air_date id; Type: DEFAULT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY air_date ALTER COLUMN id SET DEFAULT nextval('air_date_id_seq'::regclass);


--
-- Name: content id; Type: DEFAULT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY content ALTER COLUMN id SET DEFAULT nextval('content_id_seq'::regclass);


--
-- Name: country id; Type: DEFAULT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY country ALTER COLUMN id SET DEFAULT nextval('country_id_seq'::regclass);


--
-- Name: pack_opt id; Type: DEFAULT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY pack_opt ALTER COLUMN id SET DEFAULT nextval('pack_opt_id_seq'::regclass);


--
-- Name: pixel id; Type: DEFAULT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY pixel ALTER COLUMN id SET DEFAULT nextval('pixel_id_seq'::regclass);


--
-- Name: _invertedcolumnindex _invertedcolumnindex_word_tabname_colname_key; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _invertedcolumnindex
    ADD CONSTRAINT _invertedcolumnindex_word_tabname_colname_key UNIQUE (word, tabname, colname);


--
-- Name: air_date air_date_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY air_date
    ADD CONSTRAINT air_date_pkey PRIMARY KEY (id);


--
-- Name: content content_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY content
    ADD CONSTRAINT content_pkey PRIMARY KEY (id);


--
-- Name: country country_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY country
    ADD CONSTRAINT country_pkey PRIMARY KEY (id);


--
-- Name: tv_channel idx_92961_sqlite_autoindex_tv_channel_1; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY tv_channel
    ADD CONSTRAINT idx_92961_sqlite_autoindex_tv_channel_1 PRIMARY KEY (id);


--
-- Name: tv_series idx_92967_sqlite_autoindex_tv_series_1; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY tv_series
    ADD CONSTRAINT idx_92967_sqlite_autoindex_tv_series_1 PRIMARY KEY (id);


--
-- Name: cartoon idx_92973_sqlite_autoindex_cartoon_1; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY cartoon
    ADD CONSTRAINT idx_92973_sqlite_autoindex_cartoon_1 PRIMARY KEY (id);


--
-- Name: pack_opt pack_opt_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY pack_opt
    ADD CONSTRAINT pack_opt_pkey PRIMARY KEY (id);


--
-- Name: pixel pixel_pkey; Type: CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY pixel
    ADD CONSTRAINT pixel_pkey PRIMARY KEY (id);


--
-- Name: _aggr_aoo_channel_to_cartoon_cartoon_idtochannel_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_channel_to_cartoon_cartoon_idtochannel_id_idx ON _aggr_aoo_channel_to_cartoon_cartoon_idtochannel_id USING btree (cartoon_id);


--
-- Name: _aggr_aoo_channel_to_cartoon_channel_idtocartoon_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_channel_to_cartoon_channel_idtocartoon_id_idx ON _aggr_aoo_channel_to_cartoon_channel_idtocartoon_id USING btree (channel_id);


--
-- Name: _aggr_aoo_channel_to_content_channel_idtocontent_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_channel_to_content_channel_idtocontent_id_idx ON _aggr_aoo_channel_to_content_channel_idtocontent_id USING btree (channel_id);


--
-- Name: _aggr_aoo_channel_to_content_content_idtochannel_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_channel_to_content_content_idtochannel_id_idx ON _aggr_aoo_channel_to_content_content_idtochannel_id USING btree (content_id);


--
-- Name: _aggr_aoo_channel_to_country_channel_idtocountry_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_channel_to_country_channel_idtocountry_id_idx ON _aggr_aoo_channel_to_country_channel_idtocountry_id USING btree (channel_id);


--
-- Name: _aggr_aoo_channel_to_country_country_idtochannel_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_channel_to_country_country_idtochannel_id_idx ON _aggr_aoo_channel_to_country_country_idtochannel_id USING btree (country_id);


--
-- Name: _aggr_aoo_channel_to_pack_opt_channel_idtopack_opt_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_channel_to_pack_opt_channel_idtopack_opt_id_idx ON _aggr_aoo_channel_to_pack_opt_channel_idtopack_opt_id USING btree (channel_id);


--
-- Name: _aggr_aoo_channel_to_pack_opt_pack_opt_idtochannel_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_channel_to_pack_opt_pack_opt_idtochannel_id_idx ON _aggr_aoo_channel_to_pack_opt_pack_opt_idtochannel_id USING btree (pack_opt_id);


--
-- Name: _aggr_aoo_channel_to_pixel_channel_idtopixel_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_channel_to_pixel_channel_idtopixel_id_idx ON _aggr_aoo_channel_to_pixel_channel_idtopixel_id USING btree (channel_id);


--
-- Name: _aggr_aoo_channel_to_pixel_pixel_idtochannel_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_channel_to_pixel_pixel_idtochannel_id_idx ON _aggr_aoo_channel_to_pixel_pixel_idtochannel_id USING btree (pixel_id);


--
-- Name: _aggr_aoo_series_to_air_date_air_date_idtoseries_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_series_to_air_date_air_date_idtoseries_id_idx ON _aggr_aoo_series_to_air_date_air_date_idtoseries_id USING btree (air_date_id);


--
-- Name: _aggr_aoo_series_to_air_date_series_idtoair_date_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_series_to_air_date_series_idtoair_date_id_idx ON _aggr_aoo_series_to_air_date_series_idtoair_date_id USING btree (series_id);


--
-- Name: _aggr_aoo_series_to_channel_channel_idtoseries_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_series_to_channel_channel_idtoseries_id_idx ON _aggr_aoo_series_to_channel_channel_idtoseries_id USING btree (channel_id);


--
-- Name: _aggr_aoo_series_to_channel_series_idtochannel_id_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _aggr_aoo_series_to_channel_series_idtochannel_id_idx ON _aggr_aoo_series_to_channel_series_idtochannel_id USING btree (series_id);


--
-- Name: _invertedcolumnindex_word_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _invertedcolumnindex_word_idx ON _invertedcolumnindex USING btree (word);

ALTER TABLE _invertedcolumnindex CLUSTER ON _invertedcolumnindex_word_idx;


--
-- Name: _tv_channeltodirected_by_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _tv_channeltodirected_by_idx ON _tv_channeltodirected_by USING btree (directed_by, freq);

ALTER TABLE _tv_channeltodirected_by CLUSTER ON _tv_channeltodirected_by_idx;


--
-- Name: _tv_channeltodirected_by_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _tv_channeltodirected_by_idx_2 ON _tv_channeltodirected_by USING btree (tv_channel_id);


--
-- Name: _tv_channeltowritten_by_idx; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _tv_channeltowritten_by_idx ON _tv_channeltowritten_by USING btree (written_by, freq);

ALTER TABLE _tv_channeltowritten_by CLUSTER ON _tv_channeltowritten_by_idx;


--
-- Name: _tv_channeltowritten_by_idx_2; Type: INDEX; Schema: public; Owner: afariha
--

CREATE INDEX _tv_channeltowritten_by_idx_2 ON _tv_channeltowritten_by USING btree (tv_channel_id);


--
-- Name: _aggr_aoo_channel_to_cartoon_cartoon_idtochannel_id _aggr_aoo_channel_to_cartoon_cartoon_idtochannel_id_cartoon_id_; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_channel_to_cartoon_cartoon_idtochannel_id
    ADD CONSTRAINT _aggr_aoo_channel_to_cartoon_cartoon_idtochannel_id_cartoon_id_ FOREIGN KEY (cartoon_id) REFERENCES cartoon(id);


--
-- Name: _aggr_aoo_channel_to_cartoon_channel_idtocartoon_id _aggr_aoo_channel_to_cartoon_channel_idtocartoon_id_channel_id_; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_channel_to_cartoon_channel_idtocartoon_id
    ADD CONSTRAINT _aggr_aoo_channel_to_cartoon_channel_idtocartoon_id_channel_id_ FOREIGN KEY (channel_id) REFERENCES tv_channel(id);


--
-- Name: _aggr_aoo_channel_to_content_channel_idtocontent_id _aggr_aoo_channel_to_content_channel_idtocontent_id_channel_id_; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_channel_to_content_channel_idtocontent_id
    ADD CONSTRAINT _aggr_aoo_channel_to_content_channel_idtocontent_id_channel_id_ FOREIGN KEY (channel_id) REFERENCES tv_channel(id);


--
-- Name: _aggr_aoo_channel_to_content_content_idtochannel_id _aggr_aoo_channel_to_content_content_idtochannel_id_content_id_; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_channel_to_content_content_idtochannel_id
    ADD CONSTRAINT _aggr_aoo_channel_to_content_content_idtochannel_id_content_id_ FOREIGN KEY (content_id) REFERENCES content(id);


--
-- Name: _aggr_aoo_channel_to_country_channel_idtocountry_id _aggr_aoo_channel_to_country_channel_idtocountry_id_channel_id_; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_channel_to_country_channel_idtocountry_id
    ADD CONSTRAINT _aggr_aoo_channel_to_country_channel_idtocountry_id_channel_id_ FOREIGN KEY (channel_id) REFERENCES tv_channel(id);


--
-- Name: _aggr_aoo_channel_to_country_country_idtochannel_id _aggr_aoo_channel_to_country_country_idtochannel_id_country_id_; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_channel_to_country_country_idtochannel_id
    ADD CONSTRAINT _aggr_aoo_channel_to_country_country_idtochannel_id_country_id_ FOREIGN KEY (country_id) REFERENCES country(id);


--
-- Name: _aggr_aoo_channel_to_pack_opt_channel_idtopack_opt_id _aggr_aoo_channel_to_pack_opt_channel_idtopack_opt_id_channel_i; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_channel_to_pack_opt_channel_idtopack_opt_id
    ADD CONSTRAINT _aggr_aoo_channel_to_pack_opt_channel_idtopack_opt_id_channel_i FOREIGN KEY (channel_id) REFERENCES tv_channel(id);


--
-- Name: _aggr_aoo_channel_to_pack_opt_pack_opt_idtochannel_id _aggr_aoo_channel_to_pack_opt_pack_opt_idtochannel_id_pack_opt_; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_channel_to_pack_opt_pack_opt_idtochannel_id
    ADD CONSTRAINT _aggr_aoo_channel_to_pack_opt_pack_opt_idtochannel_id_pack_opt_ FOREIGN KEY (pack_opt_id) REFERENCES pack_opt(id);


--
-- Name: _aggr_aoo_channel_to_pixel_channel_idtopixel_id _aggr_aoo_channel_to_pixel_channel_idtopixel_id_channel_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_channel_to_pixel_channel_idtopixel_id
    ADD CONSTRAINT _aggr_aoo_channel_to_pixel_channel_idtopixel_id_channel_id_fk FOREIGN KEY (channel_id) REFERENCES tv_channel(id);


--
-- Name: _aggr_aoo_channel_to_pixel_pixel_idtochannel_id _aggr_aoo_channel_to_pixel_pixel_idtochannel_id_pixel_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_channel_to_pixel_pixel_idtochannel_id
    ADD CONSTRAINT _aggr_aoo_channel_to_pixel_pixel_idtochannel_id_pixel_id_fk FOREIGN KEY (pixel_id) REFERENCES pixel(id);


--
-- Name: _aggr_aoo_series_to_air_date_air_date_idtoseries_id _aggr_aoo_series_to_air_date_air_date_idtoseries_id_air_date_id; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_series_to_air_date_air_date_idtoseries_id
    ADD CONSTRAINT _aggr_aoo_series_to_air_date_air_date_idtoseries_id_air_date_id FOREIGN KEY (air_date_id) REFERENCES air_date(id);


--
-- Name: _aggr_aoo_series_to_air_date_series_idtoair_date_id _aggr_aoo_series_to_air_date_series_idtoair_date_id_series_id_f; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_series_to_air_date_series_idtoair_date_id
    ADD CONSTRAINT _aggr_aoo_series_to_air_date_series_idtoair_date_id_series_id_f FOREIGN KEY (series_id) REFERENCES tv_series(id);


--
-- Name: _aggr_aoo_series_to_channel_channel_idtoseries_id _aggr_aoo_series_to_channel_channel_idtoseries_id_channel_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_series_to_channel_channel_idtoseries_id
    ADD CONSTRAINT _aggr_aoo_series_to_channel_channel_idtoseries_id_channel_id_fk FOREIGN KEY (channel_id) REFERENCES tv_channel(id);


--
-- Name: _aggr_aoo_series_to_channel_series_idtochannel_id _aggr_aoo_series_to_channel_series_idtochannel_id_series_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _aggr_aoo_series_to_channel_series_idtochannel_id
    ADD CONSTRAINT _aggr_aoo_series_to_channel_series_idtochannel_id_series_id_fk FOREIGN KEY (series_id) REFERENCES tv_series(id);


--
-- Name: _tv_channeltodirected_by _tv_channeltodirected_by_tv_channel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _tv_channeltodirected_by
    ADD CONSTRAINT _tv_channeltodirected_by_tv_channel_id_fkey FOREIGN KEY (tv_channel_id) REFERENCES tv_channel(id);


--
-- Name: _tv_channeltowritten_by _tv_channeltowritten_by_tv_channel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY _tv_channeltowritten_by
    ADD CONSTRAINT _tv_channeltowritten_by_tv_channel_id_fkey FOREIGN KEY (tv_channel_id) REFERENCES tv_channel(id);


--
-- Name: channel_to_cartoon channel_to_cartoon_cartoon_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY channel_to_cartoon
    ADD CONSTRAINT channel_to_cartoon_cartoon_id_fkey FOREIGN KEY (cartoon_id) REFERENCES cartoon(id);


--
-- Name: channel_to_cartoon channel_to_cartoon_channel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY channel_to_cartoon
    ADD CONSTRAINT channel_to_cartoon_channel_id_fkey FOREIGN KEY (channel_id) REFERENCES tv_channel(id);


--
-- Name: channel_to_content channel_to_content_channel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY channel_to_content
    ADD CONSTRAINT channel_to_content_channel_id_fkey FOREIGN KEY (channel_id) REFERENCES tv_channel(id);


--
-- Name: channel_to_content channel_to_content_content_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY channel_to_content
    ADD CONSTRAINT channel_to_content_content_id_fkey FOREIGN KEY (content_id) REFERENCES content(id);


--
-- Name: channel_to_country channel_to_country_channel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY channel_to_country
    ADD CONSTRAINT channel_to_country_channel_id_fkey FOREIGN KEY (channel_id) REFERENCES tv_channel(id);


--
-- Name: channel_to_country channel_to_country_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY channel_to_country
    ADD CONSTRAINT channel_to_country_country_id_fkey FOREIGN KEY (country_id) REFERENCES country(id);


--
-- Name: channel_to_pack_opt channel_to_pack_opt_channel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY channel_to_pack_opt
    ADD CONSTRAINT channel_to_pack_opt_channel_id_fkey FOREIGN KEY (channel_id) REFERENCES tv_channel(id);


--
-- Name: channel_to_pack_opt channel_to_pack_opt_pack_opt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY channel_to_pack_opt
    ADD CONSTRAINT channel_to_pack_opt_pack_opt_id_fkey FOREIGN KEY (pack_opt_id) REFERENCES pack_opt(id);


--
-- Name: channel_to_pixel channel_to_pixel_channel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY channel_to_pixel
    ADD CONSTRAINT channel_to_pixel_channel_id_fkey FOREIGN KEY (channel_id) REFERENCES tv_channel(id);


--
-- Name: channel_to_pixel channel_to_pixel_pixel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY channel_to_pixel
    ADD CONSTRAINT channel_to_pixel_pixel_id_fkey FOREIGN KEY (pixel_id) REFERENCES pixel(id);


--
-- Name: series_to_air_date series_to_air_date_air_date_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY series_to_air_date
    ADD CONSTRAINT series_to_air_date_air_date_id_fkey FOREIGN KEY (air_date_id) REFERENCES air_date(id);


--
-- Name: series_to_air_date series_to_air_date_series_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY series_to_air_date
    ADD CONSTRAINT series_to_air_date_series_id_fkey FOREIGN KEY (series_id) REFERENCES tv_series(id);


--
-- Name: series_to_channel series_to_channel_channel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY series_to_channel
    ADD CONSTRAINT series_to_channel_channel_id_fkey FOREIGN KEY (channel_id) REFERENCES tv_channel(id);


--
-- Name: series_to_channel series_to_channel_series_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: afariha
--

ALTER TABLE ONLY series_to_channel
    ADD CONSTRAINT series_to_channel_series_id_fkey FOREIGN KEY (series_id) REFERENCES tv_series(id);


--
-- PostgreSQL database dump complete
--

