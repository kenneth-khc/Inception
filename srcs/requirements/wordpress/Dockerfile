FROM debian:stable


RUN groupadd --system wordpress && useradd --system --gid wordpress wordpress
RUN apt-get update && apt-get install -y php-fpm php-mysql less

# download wp-cli
WORKDIR /usr/local/bin/
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    php wp-cli.phar --info && \
    mv wp-cli.phar wp && \
    chmod +x wp && \
    chown wordpress:wordpress wp
COPY --chown=wordpress:wordpress ./setup-wordpress.sh ./setup-wordpress.sh

WORKDIR /etc/php/8.4/fpm/pool.d/
COPY ./wordpress-pool.conf ./wordpress-pool.conf
# TODO: copy some comments from www.conf to our conf
RUN rm -rf ./www.conf

# TODO: seems weird to change the owner. look at the permissions later
RUN chown -R wordpress:wordpress /run/php

RUN wp core download \
    --allow-root \
    --path=${WORDPRESS_PATH:-/srv/wordpress}
RUN chown -R wordpress:wordpress ${WORDPRESS_PATH:-/srv/wordpress}
WORKDIR ${WORDPRESS_PATH:-/srv/wordpress}
COPY --chown=wordpress:wordpress ./cat-favicon.png /tmp/cat-favicon.png
USER wordpress
EXPOSE 9000
ENTRYPOINT ["setup-wordpress.sh"]
