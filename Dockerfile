FROM ubuntu:14.04.3

MAINTAINER serge.dmitriev@gmail.com

RUN apt-get update 
RUN apt-get install -y apt-utils
RUN apt-get install -y curl ntpdate lsb-release locales htop \
                    mc git gcc flex bison libmysqlclient-dev \
                    make libssl-dev libcurl4-openssl-dev \
                    libxml2-dev libpcre3-dev libexpat1-dev

RUN apt-get upgrade -y

RUN mkdir -p /usr/local/src/kamailio-4.3 && \
    cd /usr/local/src/kamailio-4.3 && \
    git clone --depth 1 --no-single-branch git://git.kamailio.org/kamailio kamailio && \
    cd kamailio && \
    git checkout -b 4.3 origin/4.3

RUN apt-get install -y libunistring-dev

RUN cd /usr/local/src/kamailio-4.3/kamailio && \ 
    make include_modules="db_mysql dialplan nth presence xmpp xml websocket tls ims" cfg && \
    make Q=0 all && \
    make install