FROM debian:stable

ARG UID=1000
ARG GID=1000

RUN groupadd mysql --gid ${GID} && \
    useradd mysql --uid ${UID} --gid ${GID}

RUN apt-get update && apt-get install -y mariadb-server mariadb-client

WORKDIR /etc/mysql/
COPY --chown=mysql:mysql ./my.cnf ./my.cnf
COPY --chown=mysql:mysql ./setup-mariadb.sh /usr/local/bin/setup-mariadb.sh
COPY --chown=mysql:mysql ./healthcheck.sh /usr/local/bin/healthcheck.sh
RUN chmod +x /usr/local/bin/setup-mariadb.sh
RUN chmod +x /usr/local/bin/healthcheck.sh
RUN mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql

USER mysql
EXPOSE 3306
ENTRYPOINT [ "/usr/local/bin/setup-mariadb.sh" ]
