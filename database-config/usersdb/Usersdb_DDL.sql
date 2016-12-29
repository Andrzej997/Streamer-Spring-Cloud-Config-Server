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

insert into users_schema.users(USER_ID, USER_NAME, PASSWORD, NAME, SURNAME, NATIONALITY, EMAIL) 
values (nextval('DEFAULTDBSEQ'), 'admin', 'admin', 'admin', 'admin', 'PL', 'admin@admin');
