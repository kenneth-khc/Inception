FROM debian:stable

# TODO: utilities for debugging within the container, remove later
RUN apt update -y && apt install -y vim curl bat wget iproute2
##################################################################
 
RUN apt update -y && apt install -y php-fpm php-mysql
WORKDIR /etc/php/8.4/fpm/pool.d/
RUN groupadd user
RUN useradd -g user user
COPY ./wordpress_pool.conf ./wordpress_pool.conf
WORKDIR /var/www/html/
RUN wget https://wordpress.org/latest.tar.gz && \
tar -xzvf latest.tar.gz && rm latest.tar.gz
RUN echo "<?php echo phpinfo();?>" > /var/www/html/wordpress/info.php

EXPOSE 9000
ENTRYPOINT ["/usr/sbin/php-fpm8.4", "--nodaemonize"]
