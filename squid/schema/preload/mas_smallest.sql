DROP TABLE cite;
DROP TABLE domain_conference;
DROP TABLE domain_journal;
DROP TABLE domain_keyword;
DROP TABLE domain_publication;
DROP TABLE journal;
DROP TABLE keyword;
DROP TABLE publication_keyword;

DELETE FROM author WHERE NOT EXISTS (SELECT * FROM organization WHERE organization.organization_id = author.organization_id);
ALTER TABLE author ALTER COLUMN author_id TYPE integer;

CREATE TABLE author_organization (
  author_id INTEGER,
  organization_id INTEGER
);
CREATE INDEX author_org_aid_idx ON author_organization(author_id);
CREATE INDEX author_org_oid_idx ON author_organization(organization_id);
INSERT INTO author_organization (author_id, organization_id)
  SELECT author_id, organization_id FROM author;
ALTER TABLE author_organization ADD CONSTRAINT author_org_aid FOREIGN KEY (author_id) REFERENCES author(author_id);
ALTER TABLE author_organization ADD CONSTRAINT author_org_oid FOREIGN KEY (organization_id) REFERENCES organization(organization_id);
ALTER TABLE author DROP COLUMN organization_id;
ALTER TABLE author DROP COLUMN homepage;
ALTER TABLE author DROP COLUMN photo;

ALTER TABLE conference ALTER COLUMN conference_id TYPE integer;
ALTER TABLE conference DROP COLUMN homepage;
ALTER TABLE conference DROP COLUMN full_name;

ALTER TABLE domain ALTER COLUMN domain_id TYPE integer;

DELETE FROM domain_author WHERE NOT EXISTS (SELECT * FROM author WHERE domain_author.author_id = author.author_id);
ALTER TABLE domain_author ADD CONSTRAINT domain_author_aid FOREIGN KEY (author_id) REFERENCES author(author_id);
ALTER TABLE domain_author ADD CONSTRAINT domain_author_did FOREIGN KEY (domain_id) REFERENCES domain(domain_id);
ALTER TABLE domain_author ALTER COLUMN author_id TYPE integer;
ALTER TABLE domain_author ALTER COLUMN domain_id TYPE integer;

ALTER TABLE organization ALTER COLUMN organization_id TYPE integer;
ALTER TABLE organization DROP COLUMN homepage;

DELETE FROM publication WHERE NOT EXISTS (SELECT * FROM conference WHERE publication.conference_id = conference.conference_id);
ALTER TABLE publication ALTER COLUMN publication_id TYPE integer;
ALTER TABLE publication ALTER COLUMN year TYPE integer;
ALTER TABLE publication DROP COLUMN journal_id;
ALTER TABLE publication DROP COLUMN _references;
ALTER TABLE publication DROP COLUMN citations;

CREATE TABLE publication_conference (
  publication_id INTEGER,
  conference_id INTEGER
);
CREATE INDEX pub_conf_pid_idx ON publication_conference(publication_id);
CREATE INDEX pub_conf_cid_idx ON publication_conference(conference_id);
INSERT INTO publication_conference (publication_id, conference_id)
  SELECT publication_id, conference_id FROM publication;
ALTER TABLE publication_conference ADD CONSTRAINT pub_conf_pid FOREIGN KEY (publication_id) REFERENCES publication(publication_id);
ALTER TABLE publication_conference ADD CONSTRAINT pub_conf_cid FOREIGN KEY (conference_id) REFERENCES conference(conference_id);
ALTER TABLE publication DROP COLUMN conference_id;

DELETE FROM writes WHERE NOT EXISTS (SELECT * FROM author WHERE author.author_id = writes.author_id);
DELETE FROM writes WHERE NOT EXISTS (SELECT * FROM publication WHERE publication.publication_id = writes.publication_id);
ALTER TABLE writes ADD CONSTRAINT writes_aid FOREIGN KEY (author_id) REFERENCES author(author_id);
ALTER TABLE writes ADD CONSTRAINT writes_pid FOREIGN KEY (publication_id) REFERENCES publication(publication_id);
ALTER TABLE writes ALTER COLUMN author_id TYPE integer;
ALTER TABLE writes ALTER COLUMN publication_id TYPE integer;

ALTER TABLE domain RENAME TO domain_of_author;
ALTER TABLE conference RENAME TO conference_of_publication;
ALTER TABLE organization RENAME TO organization_of_author;
ALTER TABLE publication RENAME COLUMN year TO publication_year;
