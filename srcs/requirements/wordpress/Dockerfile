FROM debian:stable

ARG UID=1000
ARG GID=100
RUN groupadd wordpress -f --gid ${GID} && \
    useradd wordpress --uid ${UID} --gid ${GID}

RUN apt-get update && apt-get install -y php-fpm php-mysql curl

# download wp-cli
WORKDIR /usr/local/bin/
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    php wp-cli.phar --info && \
    mv wp-cli.phar wp && \
    chmod +x wp && \
    chown wordpress:wordpress wp

WORKDIR /etc/php/8.4/fpm/pool.d/
COPY ./wordpress-pool.conf ./wordpress-pool.conf
# TODO: copy some comments from www.conf to our conf
RUN rm -rf ./www.conf

ARG WORDPRESS_PATH=/srv/wordpress
ENV WORDPRESS_PATH ${WORDPRESS_PATH}
RUN wp core download \
    --allow-root \
    --path=${WORDPRESS_PATH}
WORKDIR ${WORDPRESS_PATH}

COPY --chown=wordpress:wordpress ./cat-favicon.png /tmp/cat-favicon.png

RUN chown -R wordpress:wordpress ${WORDPRESS_PATH}
# TODO: seems weird to change the owner. look at the permissions later
RUN chown -R wordpress:wordpress /run/php
COPY --chown=wordpress:wordpress \
    ./setup-wordpress.sh /usr/local/bin/setup-wordpress.sh


USER wordpress
WORKDIR ${WORDPRESS_PATH}
EXPOSE 9000
ENTRYPOINT ["setup-wordpress.sh"]
