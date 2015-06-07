# Squid
MAINTAINER Rudy Gevaert <Rudy.Gevaert@UGent.be>
ENV SQUID_VERSION=3.5.5
LABEL Description="This image is used to start Squid a caching proxy that was compiled" Version="${SQUID_VERSION}"


FROM debian:jessie
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -yq --no-install-recommends && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends wget build-essential && \
    DEBIAN_FRONTEND=noninteractive apt-get clean

RUN wget "http://www.squid-cache.org/Versions/v3/3.5/squid-${SQUID_VERSION}.tar.gz"

RUN cd /usr/local/src && \
    tar -xvzf "/squid-${SQUID_VERSION}.tar.gz" && \
    rm "/squid-${SQUID_VERSION}.tar.gz" && \
    cd "squid-${SQUID_VERSION}" && \
    ./configure && \
    make && \
    make install && \
    rm -fr "/usr/local/src/squid-${SQUID_VERSION}"

RUN mkdir -p /usr/local/squid/var/cache/squid /usr/local/squid/var/logs
RUN chown -R nobody:nogroup /usr/local/squid/var/cache/squid /usr/local/squid/var/logs

EXPOSE 3128
ENTRYPOINT ["/usr/local/squid/sbin/squid", "-N"]
