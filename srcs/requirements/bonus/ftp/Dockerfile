FROM debian:stable

# TODO: utilities for debugging within the container, remove later
RUN apt-get update && apt-get install -y vim
##################################################################

RUN apt-get update && apt-get install -y vsftpd
COPY ./vsftpd.conf /etc/vsftpd.conf

EXPOSE 21
EXPOSE 30000-30010

ENTRYPOINT [ "vsftpd", "/etc/vsftpd.conf" ]
