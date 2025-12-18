FROM debian:stable

ARG UID=1000
ARG GID=1000
RUN groupadd inception_ftp -f --gid ${GID} && \
    useradd inception_ftp --uid ${UID} --gid ${GID}

RUN apt-get update && apt-get install -y vsftpd

# vsftpd has to be run as root and the config file also has to be owned by root
# for it to work
COPY ./vsftpd.conf /etc/vsftpd.conf

WORKDIR /usr/local/sbin
COPY --chown=inception_ftp:inception_ftp ./setup-ftp.sh ./setup-ftp.sh
RUN chmod +x ./setup-ftp.sh

EXPOSE 21
EXPOSE 30000-30010
ENTRYPOINT [ "setup-ftp.sh" ]
