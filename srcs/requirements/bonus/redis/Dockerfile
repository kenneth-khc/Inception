FROM debian:stable

ARG UID=1000
ARG GID=1000
RUN groupadd --gid ${GID} redis && \
    useradd --uid ${UID} --gid redis redis

RUN apt-get update && apt-get -y install redis-server
COPY --chown=redis:redis ./redis.conf /etc/redis/redis.conf
RUN mkdir -p /data && chown -R redis:redis /data

USER redis
ENTRYPOINT [ "redis-server" ]
CMD [ "/etc/redis/redis.conf" ]
