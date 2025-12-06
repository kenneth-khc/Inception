FROM debian:stable

# TODO: utilities for debugging within the container, remove later
RUN apt update -y && apt install -y vim curl bat wget iproute2
##################################################################
 
RUN apt update -y && apt install -y php-fpm php-mysql less

RUN groupadd --system wordpress && useradd --system --gid wordpress wordpress

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

WORKDIR /srv
RUN wp core download \
    --allow-root \
    --path=wordpress
RUN chown wordpress:wordpress wordpress/
USER wordpress
WORKDIR /srv/wordpress
EXPOSE 9000
ENTRYPOINT ["setup-wordpress.sh"]
