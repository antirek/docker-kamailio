FROM ubuntu:14.04.3

MAINTAINER serge.dmitriev@gmail.com

RUN apt-get update 
RUN apt-get install -y apt-utils
RUN apt-get install -y curl ntpdate lsb-release locales
RUN apt-get upgrade -y

RUN curl http://deb.kamailio.org/kamailiodebkey.gpg | apt-key add -
RUN echo "deb http://deb.kamailio.org/kamailio43 trusty main" > /etc/apt/sources.list.d/kamailio.list
RUN echo "deb-src http://deb.kamailio.org/kamailio43 trusty main" >> /etc/apt/sources.list.d/kamailio.list

RUN apt-get update
RUN apt-get install -y rsyslog procps supervisor
RUN apt-get -y install mysql-client

RUN apt-get -y install kamailio kamailio-extra-modules kamailio-ims-modules kamailio-mysql-modules kamailio-nth kamailio-presence-modules kamailio-tls-modules kamailio-websocket-modules kamailio-xml-modules kamailio-xmpp-modules

RUN apt-get -y install net-tools

RUN apt-get clean

RUN apt-get install -y htop

COPY store/etc/default/kamailio /etc/default/

WORKDIR /tmp

RUN apt-get install -y make git && \
    git clone https://github.com/sippy/rtpproxy.git && \
    cd rtpproxy && \
    ./configure && make && make install


COPY store/etc/rtpproxy/rtpproxy.conf  /etc/default/rtpproxy

COPY store/etc/rtpproxy/rtpproxy /etc/init.d/

RUN chmod 755 /etc/init.d/rtpproxy