FROM debian:bullseye
# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# MAJ list & packages on machine
RUN apt update -y && apt upgrade -y
RUN apt-get install mariadb-server -y

# Copy my configuration files in the container filesystem
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

# Create MySQL runtime directory
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

CMD ["/usr/local/bin/setup.sh"]