FROM debian:bookworm

RUN apt-get update -y && \
	apt-get upgrade -y && \
	apt-get install mariadb-server -y &&\
	rm -rf /var/lib/apt/lists/*
#remplace fichier de config
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
#script a la racine
COPY tools/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

CMD ["/usr/local/bin/setup.sh"]