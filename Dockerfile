FROM debian:jessie-slim

MAINTAINER Fully-Web

RUN groupadd -r -g 666 utorrent \
    && useradd -r -u 666 -g 666 -d /utorrent -m utorrent


RUN apt-get -q update
RUN apt-get install -qy curl libssl1.0.0 \
    && curl -s http://download-hr.utorrent.com/track/beta/endpoint/utserver/os/linux-x64-debian-7-0 | tar xzf - --strip-components 1 -C utorrent \
    && chown -R utorrent: utorrent \
    && apt-get -y remove curl \
    && apt-get -y autoremove \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

RUN mkdir /configs
RUN ln -s /utorrent/webui.zip /configs/webui.zip

VOLUME ["/configs", "/media"]

EXPOSE 8080 6881

WORKDIR /utorrent

CMD exec su -pc "./utserver -configfile /utorrent/utserver.conf -settingspath /configs -logfile /dev/stdout utorrent"
