FROM debian:stable

# TODO: utilities for debugging within the container, remove later
RUN apt update -y && apt install -y vim curl bat
############################################

RUN apt update -y && apt install -y nginx
WORKDIR /etc/nginx/
COPY ./conf ./nginx.conf

EXPOSE 80 443
ENTRYPOINT ["nginx"]
