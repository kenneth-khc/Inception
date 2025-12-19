FROM debian:stable

RUN groupadd nginx && \
    useradd nginx --gid nginx
RUN apt-get update && apt-get install -y nginx
WORKDIR /etc/nginx/
COPY --chown=nginx:nginx ./nginx.conf ./nginx.conf

EXPOSE 443/tcp
ENTRYPOINT ["nginx"]
