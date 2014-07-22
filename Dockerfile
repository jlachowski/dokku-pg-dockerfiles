# forked from https://github.com/Kloadut/dokku-pg-dockerfiles

FROM	ubuntu:14.04
MAINTAINER	jlachowski "jalachowski@gmail.com"

# prevent apt from starting postgres right after the installation
RUN	echo "#!/bin/sh\nexit 101" > /usr/sbin/policy-rc.d; chmod +x /usr/sbin/policy-rc.d

RUN locale-gen --no-purge pl_PL.UTF-8
ENV LC_ALL pl_PL.UTF-8
ENV LC_COLLATE pl_PL.UTF-8
RUN dpkg-reconfigure locales

RUN apt-get update
RUN	DEBIAN_FRONTEND=noninteractive apt-get install -y -q postgresql-9.3 postgresql-contrib-9.3
RUN rm -rf /var/lib/apt/lists/*
RUN apt-get clean

# allow autostart again
RUN	rm /usr/sbin/policy-rc.d

ADD	. /usr/bin
RUN	chmod +x /usr/bin/start-pgsql.sh
RUN echo 'host all all 0.0.0.0/0 md5' >> /etc/postgresql/9.3/main/pg_hba.conf
RUN sed -i -e"s/var\/lib/opt/g" /etc/postgresql/9.3/main/postgresql.conf

EXPOSE 5432
