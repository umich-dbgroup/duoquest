ALTER TABLE ref_feature_types RENAME TO old_ref_feature_types;

CREATE TABLE ref_feature_types (
  id SERIAL PRIMARY KEY,
  feature_type_code TEXT,
  feature_type_name TEXT
);

INSERT INTO ref_feature_types (feature_type_code, feature_type_name)
SELECT feature_type_code, feature_type_name FROM old_ref_feature_types;

CREATE TABLE features_to_types (
  feature_id INTEGER REFERENCES other_available_features(feature_id),
  type_id INTEGER REFERENCES ref_feature_types(id)
);

INSERT INTO features_to_types (feature_id, type_id)
SELECT o.feature_id, f.id
FROM other_available_features o JOIN ref_feature_types f
  ON o.feature_type_code = f.feature_type_code;

ALTER TABLE other_available_features DROP COLUMN feature_type_code;

DROP TABLE old_ref_feature_types;
