DROP SEQUENCE IF EXISTS DEFAULTDBSEQ;
drop extension if exists postgres_fdw;
DROP TABLE IF EXISTS users_schema.USERS CASCADE;
DROP schema if exists users_schema CASCADE;

create schema users_schema;

CREATE TABLE users_schema.USERS (
  USER_ID     BIGINT        NOT NULL,
  USER_NAME   VARCHAR(255)  NOT NULL,
  PASSWORD    VARCHAR(255)  NOT NULL,
  NAME        VARCHAR(255),
  SURNAME     VARCHAR(255),
  NATIONALITY VARCHAR(255),
  EMAIL       VARCHAR(1024) NOT NULL,
  ACCOUNT_EXPIRATION_DATE TIMESTAMP NOT NULL,
  ACCOUNT_LOCKED BOOLEAN DEFAULT TRUE NOT NULL,
  PASSWORD_EXPIRATION_DATE TIMESTAMP NOT NULL
);

CREATE TABLE users_schema.AUTHORITY (
  authority_id      BIGINT        NOT NULL,
  authority         VARCHAR(255)  NOT NULL,
  user_id           BIGINT        NOT NULL
);

ALTER TABLE users_schema.USERS
  ADD CONSTRAINT UQ_Users_EMAIL UNIQUE (EMAIL);
ALTER TABLE users_schema.USERS
  ADD CONSTRAINT UQ_Users_USER_NAME UNIQUE (USER_NAME);
  
  ALTER TABLE users_schema.USERS
  ADD CONSTRAINT PK_Users
PRIMARY KEY (USER_ID);

CREATE INDEX AUTHORITY_IDX ON users_schema.AUTHORITY (user_id);

ALTER TABLE users_schema.AUTHORITY
  ADD CONSTRAINT PK_Authority
PRIMARY KEY (authority_id);

ALTER TABLE users_schema.AUTHORITY
    ADD CONSTRAINT FK_Authority_Users
FOREIGN KEY (user_id) REFERENCES users_schema.users (user_id)
ON DELETE CASCADE ON UPDATE CASCADE;

CREATE SEQUENCE DEFAULTDBSEQ START 1;

create extension postgres_fdw;

INSERT INTO USERS_SCHEMA.USERS
(USER_ID, USER_NAME, PASSWORD, NAME, SURNAME, NATIONALITY, EMAIL, account_expiration_date, account_locked, password_expiration_date)
VALUES (nextval('DEFAULTDBSEQ'), 'admin', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918',
'admin', 'admin', 'PL', 'admin@admin', current_date + 120, false, current_date + 120);

INSERT INTO USERS_SCHEMA.AUTHORITY
(authority_id, authority, user_id)
VALUES (nextval('DEFAULTDBSEQ'), 'ROLE_ADMIN', 1);

INSERT INTO USERS_SCHEMA.AUTHORITY
(authority_id, authority, user_id)
VALUES (nextval('DEFAULTDBSEQ'), 'ROLE_USER', 1);
