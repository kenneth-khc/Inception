FROM debian:stable

RUN groupadd adminer && \
    useradd adminer --gid adminer

RUN apt-get update && apt-get -y install php php-mysql wget
RUN mkdir -p /srv/adminer
WORKDIR /srv/adminer
RUN wget https://github.com/vrana/adminer/releases/download/v5.4.1/adminer-5.4.1.php
RUN chown adminer:adminer adminer-5.4.1.php

RUN apt-get update && apt-get -y install vim curl

USER adminer
ENTRYPOINT [ "php" ]
CMD [ "-S", "0.0.0.0:8080", "adminer-5.4.1.php"]
