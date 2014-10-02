FROM centos:centos6
MAINTAINER Doug Smith <dsmith@800response.com>
ENV build_date 2014-10-02

RUN yum update -y
RUN yum install kernel-headers gcc gcc-c++ cpp ncurses ncurses-devel libxml2 libxml2-devel sqlite sqlite-devel openssl-devel newt-devel kernel-devel libuuid-devel net-snmp-devel xinetd tar -y

# Download asterisk.
# Currently Certified Asterisk 11.6 cert 6.
RUN curl -sf -o /tmp/asterisk.tar.gz -L http://downloads.asterisk.org/pub/telephony/certified-asterisk/certified-asterisk-11.6-current.tar.gz

# gunzip asterisk
RUN mkdir /tmp/asterisk
RUN tar -xzf /tmp/asterisk.tar.gz -C /tmp/asterisk --strip-components=1
WORKDIR /tmp/asterisk

# make asterisk.
RUN ./configure --libdir=/usr/lib64
RUN make
RUN make install

WORKDIR /

RUN mkdir -p /etc/asterisk
ADD modules.conf /etc/asterisk/
ADD iax.conf /etc/asterisk/
ADD extensions.conf /etc/asterisk/