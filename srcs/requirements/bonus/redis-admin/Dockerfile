FROM debian:stable

ARG UID=1000
ARG GID=1000
RUN groupadd redis-admin -f --gid ${GID} && \
    useradd redis-admin --uid ${UID} --gid ${GID}

RUN apt-get update && apt-get -y install git php8.4 php8.4-fpm php8.4-mbstring curl && \
    curl -s http://getcomposer.org/installer | php && \
    mkdir -p /srv/redis-admin && \
    php composer.phar create-project -s dev erik-dubbelboer/php-redis-admin /srv/redis-admin

COPY ./config.inc.php /srv/redis-admin/includes/config.inc.php
COPY ./fpm.conf /etc/php/8.4/fpm/pool.d/fpm.conf

RUN chown -R redis-admin:redis-admin /srv/redis-admin
ENTRYPOINT ["php-fpm8.4", "--nodaemonize"]
