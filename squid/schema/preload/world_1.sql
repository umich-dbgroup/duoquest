ALTER TABLE city ALTER COLUMN name DROP DEFAULT;
ALTER TABLE city ALTER COLUMN district DROP DEFAULT;
ALTER TABLE city ALTER COLUMN population DROP DEFAULT;
ALTER TABLE country ALTER COLUMN code DROP DEFAULT;
ALTER TABLE country ALTER COLUMN name DROP DEFAULT;
ALTER TABLE country ALTER COLUMN continent DROP DEFAULT;
ALTER TABLE country ALTER COLUMN region DROP DEFAULT;
ALTER TABLE country ALTER COLUMN surfacearea DROP DEFAULT;
ALTER TABLE country ALTER COLUMN population DROP DEFAULT;
ALTER TABLE country ALTER COLUMN localname DROP DEFAULT;
ALTER TABLE country ALTER COLUMN governmentform DROP DEFAULT;
ALTER TABLE country ALTER COLUMN code2 DROP DEFAULT;
ALTER TABLE countrylanguage ALTER COLUMN language DROP DEFAULT;
ALTER TABLE countrylanguage ALTER COLUMN isofficial DROP DEFAULT;
ALTER TABLE countrylanguage ALTER COLUMN percentage DROP DEFAULT;

ALTER TABLE country ADD COLUMN id SERIAL PRIMARY KEY;
ALTER TABLE countrylanguage ADD COLUMN id SERIAL PRIMARY KEY;

CREATE TABLE city_to_country (
  city_id INTEGER REFERENCES city(id),
  country_id INTEGER REFERENCES country(id)
);

INSERT INTO city_to_country (city_id, country_id)
SELECT city.id, country.id
FROM city JOIN country ON city.countrycode = country.code;

ALTER TABLE city DROP COLUMN countrycode;

CREATE TABLE country_to_language (
  country_id INTEGER REFERENCES country(id),
  language_id INTEGER REFERENCES countrylanguage(id)
);

INSERT INTO country_to_language (country_id, language_id)
SELECT country.id, countrylanguage.id
FROM country JOIN countrylanguage ON country.code = countrylanguage.countrycode;

ALTER TABLE countrylanguage DROP COLUMN countrycode;

CREATE TABLE continent (
  id SERIAL PRIMARY KEY,
  continent TEXT
);

INSERT INTO continent (continent)
SELECT DISTINCT continent FROM country;

CREATE TABLE country_to_continent (
  country_id INTEGER REFERENCES country(id),
  continent_id INTEGER REFERENCES continent(id)
);

INSERT INTO country_to_continent (country_id, continent_id)
SELECT country.id, continent.id
FROM country JOIN continent ON country.continent = continent.continent;

ALTER TABLE country DROP COLUMN continent;

CREATE TABLE region (
  id SERIAL PRIMARY KEY,
  region TEXT
);

INSERT INTO region (region)
SELECT DISTINCT region FROM country;

CREATE TABLE country_to_region (
  country_id INTEGER REFERENCES country(id),
  region_id INTEGER REFERENCES region(id)
);

INSERT INTO country_to_region (country_id, region_id)
SELECT country.id, region.id
FROM country JOIN region ON country.region = region.region;

ALTER TABLE country DROP COLUMN region;
