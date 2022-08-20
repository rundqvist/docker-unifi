FROM ubuntu:xenial

ARG UNIFI_VERSION="7.2.92-18687-1"

LABEL maintainer="mattias.rundqvist@icloud.com"

WORKDIR /app

RUN apt update && apt -y full-upgrade

RUN apt -y install ca-certificates apt-transport-https wget gnupg supervisor

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 06E85760C0A52C50
RUN echo 'deb https://www.ui.com/downloads/unifi/debian stable ubiquiti' | tee /etc/apt/sources.list.d/100-ubnt-unifi.list

RUN wget -qO - https://www.mongodb.org/static/pgp/server-3.4.asc | apt-key add -
RUN echo "deb https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list

RUN apt update
RUN apt install -y openjdk-8-jre-headless mongodb-server unifi=${UNIFI_VERSION}

RUN apt -y remove wget && apt -y autoremove && apt -y autoclean

COPY root /
RUN chmod +x /app/entrypoint.sh

ENTRYPOINT [ "/app/entrypoint.sh" ]