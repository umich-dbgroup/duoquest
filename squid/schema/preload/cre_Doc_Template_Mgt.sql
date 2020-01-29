ALTER TABLE Ref_Template_Types ADD COLUMN type_id SERIAL PRIMARY KEY;

ALTER TABLE Templates ALTER COLUMN date_effective_from TYPE text;
ALTER TABLE Templates ALTER COLUMN date_effective_to TYPE text;

CREATE TABLE documents_to_templates (
  document_id INTEGER REFERENCES documents(document_id),
  template_id INTEGER REFERENCES templates(template_id)
);

INSERT INTO documents_to_templates (document_id, template_id)
SELECT document_id, template_id FROM documents;

ALTER TABLE documents DROP COLUMN template_id;

CREATE TABLE templates_to_types (
  template_id INTEGER REFERENCES templates(template_id),
  type_id INTEGER REFERENCES Ref_Template_Types(type_id)
);

INSERT INTO templates_to_types (template_id, type_id)
SELECT t.template_id, r.type_id
FROM templates t JOIN Ref_Template_Types r
  ON t.template_type_code = r.template_type_code;

ALTER TABLE templates DROP COLUMN template_type_code;

CREATE TABLE type_descriptions (
  id SERIAL PRIMARY KEY,
  description TEXT
);

CREATE TABLE types_to_descriptions (
  type_id INTEGER REFERENCES Ref_Template_Types(type_id),
  description_id INTEGER REFERENCES type_descriptions(id)
);

INSERT INTO type_descriptions (description)
SELECT DISTINCT Template_Type_Description FROM Ref_Template_Types;

INSERT INTO types_to_descriptions (type_id, description_id)
SELECT t.type_id, d.id
FROM Ref_Template_Types t JOIN type_descriptions d
ON t.Template_Type_Description = d.description;

ALTER TABLE Ref_Template_Types DROP COLUMN Template_Type_Description;
