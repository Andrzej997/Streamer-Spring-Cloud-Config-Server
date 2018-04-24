DROP VIEW IF EXISTS USERS_VIEW;
DROP FOREIGN TABLE IF EXISTS USERS;
DROP SERVER IF EXISTS users_srv;
DROP EXTENSION IF EXISTS postgres_fdw;
DROP TABLE IF EXISTS DIRECTORS CASCADE;
DROP TABLE IF EXISTS FILM_GENRES CASCADE;
DROP TABLE IF EXISTS PLAYLISTS_VIDEOS CASCADE;
DROP TABLE IF EXISTS VIDEO_FILES CASCADE;
DROP TABLE IF EXISTS VIDEO_PLAYLISTS CASCADE;
DROP TABLE IF EXISTS VIDEO_SERIES CASCADE;
DROP TABLE IF EXISTS VIDEOS CASCADE;
DROP TABLE IF EXISTS VIDEOS_AUTHORS CASCADE;

CREATE TABLE DIRECTORS (
  DIRECTOR_ID BIGINT NOT NULL,
  NAME        VARCHAR(255),
  NAME_2      VARCHAR(255),
  SURNAME     VARCHAR(255),
  BIRTH_DATE  TIMESTAMP,
  DEATH_DATE  TIMESTAMP,
  COMMENTS    TEXT,
  RATINGS     REAL
);

CREATE TABLE FILM_GENRES (
  FILM_GENRE_ID BIGINT NOT NULL,
  NAME          TEXT   NOT NULL,
  COMMENTS      TEXT
);

CREATE TABLE PLAYLISTS_VIDEOS (
  PLAYLIST_ID  BIGINT  NOT NULL,
  VIDEO_ID     BIGINT  NOT NULL,
  ORDER_NUMBER INTEGER NOT NULL
);

CREATE TABLE VIDEO_FILES (
  VIDEO_FILE_ID BIGINT               NOT NULL,
  FILE_NAME     TEXT                 NOT NULL,
  FILE_SIZE     BIGINT               NOT NULL,
  EXTENSION     VARCHAR(10)          NOT NULL,
  CREATION_DATE TIMESTAMP            NOT NULL,
  IS_PUBLIC     BOOLEAN DEFAULT TRUE NOT NULL,
  FILE 		OID 		     NOT NULL
);

CREATE TABLE VIDEO_PLAYLISTS (
  PLAYLIST_ID   BIGINT NOT NULL,
  USER_ID       BIGINT,
  TITLE         TEXT   NOT NULL,
  CREATION_DATE TIMESTAMP
);

CREATE TABLE VIDEO_SERIES (
  VIDEO_SERIE_ID BIGINT NOT NULL,
  TITLE          TEXT,
  NUMBER         INTEGER,
  COMMENTS       TEXT,
  YEAR           TIMESTAMP
);

CREATE TABLE VIDEOS (
  VIDEO_ID        BIGINT NOT NULL,
  VIDEO_FILE_ID   BIGINT NOT NULL,
  TITLE           TEXT   NOT NULL,
  RATING_TIMES    BIGINT,
  FILM_GENRE_ID   BIGINT,
  VIDEO_SERIE_ID  BIGINT,
  RATING          REAL,
  PRODUCTION_YEAR SMALLINT,
  OWNER_ID        BIGINT
);

CREATE TABLE VIDEOS_AUTHORS (
  VIDEO_ID  BIGINT NOT NULL,
  AUTHOR_ID BIGINT NOT NULL
);


ALTER TABLE DIRECTORS
  ADD CONSTRAINT PK_DIRECTORS
PRIMARY KEY (DIRECTOR_ID);


ALTER TABLE FILM_GENRES
  ADD CONSTRAINT PK_FILM_GENRES
PRIMARY KEY (FILM_GENRE_ID);


ALTER TABLE PLAYLISTS_VIDEOS
  ADD CONSTRAINT PK_PLAYLISTS_VIDEOS
PRIMARY KEY (PLAYLIST_ID, VIDEO_ID);


ALTER TABLE VIDEO_FILES
  ADD CONSTRAINT PK_VIDEO_FILES
PRIMARY KEY (VIDEO_FILE_ID);


ALTER TABLE VIDEO_PLAYLISTS
  ADD CONSTRAINT PK_VIDEO_PLAYLISTS
PRIMARY KEY (PLAYLIST_ID);


ALTER TABLE VIDEO_SERIES
  ADD CONSTRAINT PK_VIDEO_SERIES
PRIMARY KEY (VIDEO_SERIE_ID);


ALTER TABLE VIDEOS
  ADD CONSTRAINT PK_VIDEO
PRIMARY KEY (VIDEO_ID);


ALTER TABLE VIDEOS_AUTHORS
  ADD CONSTRAINT PK_VIDEOS_AUTHORS
PRIMARY KEY (VIDEO_ID, AUTHOR_ID);


ALTER TABLE PLAYLISTS_VIDEOS
  ADD CONSTRAINT FK_PLAYLISTS_VIDEOS_VIDEO_PLAYLISTS
FOREIGN KEY (PLAYLIST_ID) REFERENCES VIDEO_PLAYLISTS (PLAYLIST_ID)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE PLAYLISTS_VIDEOS
  ADD CONSTRAINT FK_PLAYLISTS_VIDEOS_VIDEOS
FOREIGN KEY (VIDEO_ID) REFERENCES VIDEOS (VIDEO_ID)
ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE VIDEOS
  ADD CONSTRAINT FK_VIDEOS_FILM_GENRES
FOREIGN KEY (FILM_GENRE_ID) REFERENCES FILM_GENRES (FILM_GENRE_ID)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE VIDEOS
  ADD CONSTRAINT FK_VIDEOS_VIDEO_FILES
FOREIGN KEY (VIDEO_FILE_ID) REFERENCES VIDEO_FILES (VIDEO_FILE_ID)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE VIDEOS
  ADD CONSTRAINT FK_VIDEOS_VIDEO_SERIES
FOREIGN KEY (VIDEO_SERIE_ID) REFERENCES VIDEO_SERIES (VIDEO_SERIE_ID)
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE VIDEOS_AUTHORS
  ADD CONSTRAINT FK_VIDEOS_AUTHORS_DIRECTORS
FOREIGN KEY (AUTHOR_ID) REFERENCES DIRECTORS (DIRECTOR_ID)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE VIDEOS_AUTHORS
  ADD CONSTRAINT FK_VIDEOS_AUTHORS_VIDEOS
FOREIGN KEY (VIDEO_ID) REFERENCES VIDEOS (VIDEO_ID)
ON DELETE CASCADE ON UPDATE CASCADE;

CREATE INDEX ON VIDEOS (VIDEO_FILE_ID);

CREATE INDEX ON VIDEOS (FILM_GENRE_ID);

CREATE INDEX ON VIDEOS (VIDEO_SERIE_ID);

CREATE INDEX ON VIDEOS (OWNER_ID);

CREATE INDEX ON VIDEOS_AUTHORS (VIDEO_ID);

CREATE INDEX ON VIDEOS_AUTHORS (AUTHOR_ID);

CREATE INDEX ON PLAYLISTS_VIDEOS (PLAYLIST_ID);

CREATE INDEX ON PLAYLISTS_VIDEOS (VIDEO_ID);

CREATE INDEX ON VIDEO_PLAYLISTS (USER_ID);

CREATE SEQUENCE DEFAULTDBSEQ START 1;

CREATE EXTENSION postgres_fdw;

CREATE SERVER users_srv foreign data wrapper postgres_fdw OPTIONS 
        ( host 'usersdb', port '5432', dbname 'usersdb');
		
CREATE USER MAPPING FOR sysadm SERVER users_srv OPTIONS 
        ( user 'sysadm', password 'sysadm' );

create foreign table USERS (
  USER_ID     BIGINT        NOT NULL,
  USER_NAME   VARCHAR(255)  NOT NULL,
  PASSWORD    VARCHAR(255)  NOT NULL,
  NAME        VARCHAR(255),
  SURNAME     VARCHAR(255),
  NATIONALITY VARCHAR(255),
  EMAIL       VARCHAR(1024) NOT NULL
) SERVER users_srv OPTIONS ( schema_name 'users_schema', table_name 'users' );

CREATE OR REPLACE VIEW USERS_VIEW AS SELECT * FROM USERS;

ALTER TABLE VIDEO_PLAYLISTS
  ADD CONSTRAINT FK_VIDEO_PLAYLISTS_USERS
FOREIGN KEY (USER_ID) REFERENCES USERS (USER_ID)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE VIDEOS
  ADD CONSTRAINT FK_VIDEOS_USERS
FOREIGN KEY (OWNER_ID) REFERENCES USERS (USER_ID)
ON DELETE CASCADE ON UPDATE CASCADE;

