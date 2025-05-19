FROM debian:bullseye

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install mariadb-server -y &&\
	rm -rf /var/lib/apt/lists/*

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY ./tools/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 3306
ENTRYPOINT ["setup.sh"] 

