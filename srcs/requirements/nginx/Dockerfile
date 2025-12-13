FROM debian:stable

RUN apt-get update && apt-get install -y nginx
WORKDIR /etc/nginx/
COPY ./conf ./nginx.conf

EXPOSE 443/tcp
ENTRYPOINT ["nginx"]
