DROP TABLE IF EXISTS USERS CASCADE;
create schema users_schema;

CREATE TABLE users_schema.USERS (
  USER_ID     BIGINT        NOT NULL,
  USER_NAME   VARCHAR(255)  NOT NULL,
  PASSWORD    VARCHAR(255)  NOT NULL,
  NAME        VARCHAR(255),
  SURNAME     VARCHAR(255),
  NATIONALITY VARCHAR(255),
  EMAIL       VARCHAR(1024) NOT NULL
);

ALTER TABLE users_schema.USERS
  ADD CONSTRAINT UQ_Users_EMAIL UNIQUE (EMAIL);
ALTER TABLE users_schema.USERS
  ADD CONSTRAINT UQ_Users_USER_NAME UNIQUE (USER_NAME);
  
  ALTER TABLE users_schema.USERS
  ADD CONSTRAINT PK_Users
PRIMARY KEY (USER_ID);

CREATE SEQUENCE DEFAULTDBSEQ START 1;

create extension postgres_fdw;