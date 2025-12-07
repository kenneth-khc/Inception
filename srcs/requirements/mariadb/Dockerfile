FROM debian:stable

# TODO: utilities for debugging within the container, remove later
RUN apt update -y && apt install -y vim curl bat wget iproute2
##################################################################

RUN groupadd --system mysql && useradd --system --gid mysql mysql
RUN apt update -y && apt install -y mariadb-server mariadb-client
RUN mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql

WORKDIR /etc/mysql/
COPY --chown=mysql:mysql ./my.cnf ./my.cnf
COPY --chown=mysql:mysql ./setup-mariadb.sh /usr/local/bin/setup-mariadb.sh
RUN chmod +x /usr/local/bin/setup-mariadb.sh

USER mysql
EXPOSE 3306
ENTRYPOINT [ "/usr/local/bin/setup-mariadb.sh" ]
