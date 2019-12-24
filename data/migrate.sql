PRAGMA foreign_keys=off;

BEGIN TRANSACTION;

ALTER TABLE publication RENAME TO _publication_old;

CREATE TABLE IF NOT EXISTS "publication" (
    "pid" INTEGER NOT NULL,
    "title" VARCHAR(200) NULL,
    "year" INTEGER NULL,
    "cid" INTEGER NULL,
    "jid" INTEGER NULL,
    "reference_num" INTEGER NULL,
    "citation_num" INTEGER NULL,
    PRIMARY KEY ("pid"),
    FOREIGN KEY ("cid") REFERENCES "conference" ("cid"),
    FOREIGN KEY ("jid") REFERENCES "journal" ("jid")
);

INSERT INTO publication SELECT * FROM _publication_old;

ALTER TABLE cite RENAME TO _cite_old;

CREATE TABLE IF NOT EXISTS "cite" (
    "citing" INTEGER NOT NULL,
    "cited" INTEGER NOT NULL,
    PRIMARY KEY ("citing", "cited"),
    FOREIGN KEY ("citing") REFERENCES "publication" ("pid"),
    FOREIGN KEY ("cited") REFERENCES "publication" ("pid")
);

INSERT INTO cite SELECT * FROM _cite_old;

ALTER TABLE domain_author RENAME TO _domain_author_old;

CREATE TABLE IF NOT EXISTS "domain_author" (
    "aid" INTEGER NOT NULL,
    "did" INTEGER NOT NULL,
    PRIMARY KEY ("aid", "did"),
    FOREIGN KEY ("aid") REFERENCES "author" ("aid"),
    FOREIGN KEY ("did") REFERENCES "domain" ("did")
);

INSERT INTO domain_author SELECT * FROM _domain_author_old;

ALTER TABLE domain_conference RENAME TO _domain_conference_old;

CREATE TABLE IF NOT EXISTS "domain_conference" (
    "cid" INTEGER NOT NULL,
    "did" INTEGER NOT NULL,
    PRIMARY KEY ("cid", "did"),
    FOREIGN KEY ("cid") REFERENCES "conference" ("cid"),
    FOREIGN KEY ("did") REFERENCES "domain" ("did")
);

INSERT INTO domain_conference SELECT * FROM _domain_conference_old;

ALTER TABLE domain_journal RENAME TO _domain_journal_old;

CREATE TABLE IF NOT EXISTS "domain_journal" (
    "jid" INTEGER NOT NULL,
    "did" INTEGER NOT NULL,
    PRIMARY KEY ("jid", "did"),
    FOREIGN KEY ("jid") REFERENCES "journal" ("jid"),
    FOREIGN KEY ("did") REFERENCES "domain" ("did")
);

INSERT INTO domain_journal SELECT * FROM _domain_journal_old;

ALTER TABLE domain_keyword RENAME TO _domain_keyword_old;

CREATE TABLE IF NOT EXISTS "domain_keyword" (
    "kid" INTEGER NOT NULL,
    "did" INTEGER NOT NULL,
    "rank" INTEGER NOT NULL,
    PRIMARY KEY ("kid", "did", "rank"),
    FOREIGN KEY ("kid") REFERENCES "keyword" ("kid"),
    FOREIGN KEY ("did") REFERENCES "domain" ("did")
);

INSERT INTO domain_keyword SELECT * FROM _domain_keyword_old;

ALTER TABLE domain_publication RENAME TO _domain_publication_old;

CREATE TABLE IF NOT EXISTS "domain_publication" (
    "pid" INTEGER NOT NULL,
    "did" INTEGER NOT NULL,
    PRIMARY KEY ("pid", "did"),
    FOREIGN KEY ("pid") REFERENCES "publication" ("pid"),
    FOREIGN KEY ("did") REFERENCES "domain" ("did")
);

INSERT INTO domain_publication SELECT * FROM _domain_publication_old;

ALTER TABLE publication_keyword RENAME TO _publication_keyword_old;

CREATE TABLE IF NOT EXISTS "publication_keyword" (
    "pid" INTEGER NOT NULL,
    "kid" INTEGER NOT NULL,
    PRIMARY KEY ("pid", "kid"),
    FOREIGN KEY ("pid") REFERENCES "publication" ("pid"),
    FOREIGN KEY ("kid") REFERENCES "keyword" ("kid")
);

INSERT INTO publication_keyword SELECT * FROM _publication_keyword_old;

ALTER TABLE writes RENAME TO _writes_old;

CREATE TABLE IF NOT EXISTS "writes" (
    "aid" INTEGER NOT NULL,
    "pid" INTEGER NOT NULL,
    PRIMARY KEY ("aid", "pid"),
    FOREIGN KEY ("aid") REFERENCES "author" ("aid"),
    FOREIGN KEY ("pid") REFERENCES "publication" ("pid")
);

INSERT INTO writes SELECT * FROM _writes_old;

DROP TABLE _publication_old;
DROP TABLE _cite_old;
DROP TABLE _domain_author_old;
DROP TABLE _domain_conference_old;
DROP TABLE _domain_journal_old;
DROP TABLE _domain_keyword_old;
DROP TABLE _domain_publication_old;
DROP TABLE _publication_keyword_old;
DROP TABLE _writes_old;

CREATE INDEX da_aid ON "domain_author" ("aid");
CREATE INDEX da_did ON "domain_author" ("did");
CREATE INDEX pub_cid ON "publication" ("cid");
CREATE INDEX pub_jid ON "publication" ("jid");
CREATE INDEX writes_aid ON "writes" ("aid");
CREATE INDEX writes_pid ON "writes" ("pid");

COMMIT;

PRAGMA foreign_keys=on;

VACUUM;
