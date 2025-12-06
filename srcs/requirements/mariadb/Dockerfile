FROM debian:stable

# TODO: utilities for debugging within the container, remove later
RUN apt update -y && apt install -y vim curl bat wget iproute2
##################################################################

RUN apt update -y && apt install -y mariadb-server mariadb-client

WORKDIR /etc/mysql/
COPY ./my.cnf ./my.cnf
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld
COPY ./setup-mariadb.sh /usr/local/bin/setup-mariadb.sh
RUN chmod +x /usr/local/bin/setup-mariadb.sh

EXPOSE 3306
ENTRYPOINT [ "/usr/local/bin/setup-mariadb.sh" ]
