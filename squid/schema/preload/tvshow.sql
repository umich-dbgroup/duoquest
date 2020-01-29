ALTER TABLE TV_series RENAME COLUMN "18_49_Rating_Share" TO a18_49_Rating_Share;
ALTER TABLE tv_series DROP CONSTRAINT tv_series_channel_fkey;
ALTER TABLE cartoon DROP CONSTRAINT cartoon_channel_fkey;

ALTER TABLE tv_channel ALTER COLUMN id TYPE INTEGER using id::integer;

ALTER TABLE cartoon ALTER COLUMN channel TYPE INTEGER using channel::integer;
ALTER TABLE ONLY cartoon ADD CONSTRAINT cartoon_channel_fkey FOREIGN KEY (channel) REFERENCES tv_channel(id);

ALTER TABLE tv_series ALTER COLUMN channel TYPE INTEGER using channel::integer;

CREATE TABLE series_to_channel (
  series_id INTEGER REFERENCES tv_series(id),
  channel_id INTEGER REFERENCES tv_channel(id)
);

INSERT INTO series_to_channel (series_id, channel_id)
SELECT id, channel FROM tv_series;

CREATE TABLE content (
  id SERIAL PRIMARY KEY,
  content text
);

CREATE TABLE channel_to_content (
  channel_id INTEGER REFERENCES tv_channel(id),
  content_id INTEGER REFERENCES content(id)
);

INSERT INTO content (content)
SELECT DISTINCT content FROM tv_channel;

INSERT INTO channel_to_content (channel_id, content_id)
SELECT h.id, c.id
FROM tv_channel h JOIN content c ON h.content = c.content;

ALTER TABLE tv_channel DROP COLUMN content;

CREATE TABLE country (
  id SERIAL PRIMARY KEY,
  country text
);

CREATE TABLE channel_to_country (
  channel_id INTEGER REFERENCES tv_channel(id),
  country_id INTEGER REFERENCES country(id)
);

INSERT INTO country (country)
SELECT DISTINCT country FROM tv_channel;

INSERT INTO channel_to_country (channel_id, country_id)
SELECT h.id, c.id
FROM tv_channel h JOIN country c ON h.country = c.country;

ALTER TABLE tv_channel DROP COLUMN country;

CREATE TABLE pixel (
  id SERIAL PRIMARY KEY,
  pixel text
);

CREATE TABLE channel_to_pixel (
  channel_id INTEGER REFERENCES tv_channel(id),
  pixel_id INTEGER REFERENCES pixel(id)
);

INSERT INTO pixel (pixel)
SELECT DISTINCT pixel_aspect_ratio_par FROM tv_channel;

INSERT INTO channel_to_pixel (channel_id, pixel_id)
SELECT h.id, p.id
FROM tv_channel h JOIN pixel p ON h.pixel_aspect_ratio_par = p.pixel;

ALTER TABLE tv_channel DROP COLUMN pixel_aspect_ratio_par;

CREATE TABLE pack_opt (
  id SERIAL PRIMARY KEY,
  pack_opt text
);

CREATE TABLE channel_to_pack_opt (
  channel_id INTEGER REFERENCES tv_channel(id),
  pack_opt_id INTEGER REFERENCES pack_opt(id)
);

INSERT INTO pack_opt (pack_opt)
SELECT DISTINCT package_option FROM tv_channel;

INSERT INTO channel_to_pack_opt (channel_id, pack_opt_id)
SELECT h.id, c.id
FROM tv_channel h JOIN pack_opt c ON h.package_option = c.pack_opt;

ALTER TABLE tv_channel DROP COLUMN package_option;

CREATE TABLE channel_to_cartoon (
  channel_id INTEGER REFERENCES tv_channel(id),
  cartoon_id INTEGER REFERENCES cartoon(id)
);

INSERT INTO channel_to_cartoon (channel_id, cartoon_id)
SELECT channel, id FROM cartoon;

ALTER TABLE cartoon DROP COLUMN channel;

CREATE TABLE air_date (
  id SERIAL PRIMARY KEY,
  air_date text
);

CREATE TABLE series_to_air_date (
  series_id INTEGER REFERENCES tv_series(id),
  air_date_id INTEGER REFERENCES air_date(id)
);

INSERT INTO air_date (air_date)
SELECT DISTINCT air_date FROM tv_series;

INSERT INTO series_to_air_date (series_id, air_date_id)
SELECT s.id, a.id
FROM tv_series s JOIN air_date a ON s.air_date = a.air_date;

ALTER TABLE tv_series DROP COLUMN air_date;
