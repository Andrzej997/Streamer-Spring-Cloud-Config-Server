FROM ubuntu
MAINTAINER MateuszSojka

RUN apt-get update && apt-get install -my wget gnupg

RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list

RUN apt-get update && apt-get install -y software-properties-common postgresql-9.6 postgresql-client-9.6 postgresql-contrib-9.6 && apt-get install -y iputils-ping

USER postgres

COPY Videodb_DDL.sql /etc/postgresql/

RUN    /etc/init.d/postgresql start &&\
    psql --command "CREATE USER sysadm WITH SUPERUSER PASSWORD 'sysadm';" &&\
    createdb -O sysadm videodb &&\
	psql "postgresql://sysadm:sysadm@localhost/videodb" -a -f /etc/postgresql/Videodb_DDL.sql

RUN sed -i -e 's/peer/md5/g' /etc/postgresql/9.6/main/pg_hba.conf

RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.6/main/pg_hba.conf

RUN echo "listen_addresses='*'" >> /etc/postgresql/9.6/main/postgresql.conf

RUN service postgresql restart

EXPOSE 5432

CMD ["/usr/lib/postgresql/9.6/bin/postgres", "-D", "/var/lib/postgresql/9.6/main", "-c", "config_file=/etc/postgresql/9.6/main/postgresql.conf"]
