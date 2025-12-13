FROM debian:stable


RUN groupadd --system mysql && useradd --system --gid mysql mysql
RUN mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql
RUN apt-get update && apt-get install -y mariadb-server mariadb-client

WORKDIR /etc/mysql/
COPY --chown=mysql:mysql ./my.cnf ./my.cnf
COPY --chown=mysql:mysql ./setup-mariadb.sh /usr/local/bin/setup-mariadb.sh
RUN chmod +x /usr/local/bin/setup-mariadb.sh

USER mysql
EXPOSE 3306
ENTRYPOINT [ "/usr/local/bin/setup-mariadb.sh" ]
