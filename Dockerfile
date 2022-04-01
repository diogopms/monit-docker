FROM alpine:3.15.3

LABEL maintainer="Diogo Serrano <info@diogoserrano.com>"

# monit environment variables
ENV MONIT_VERSION=5.26.0 \
    MONIT_HOME=/opt/monit \
    MONIT_URL=https://mmonit.com/monit/dist \
    PATH=$PATH:/opt/monit/bin

COPY slack /bin/slack
COPY pushover /bin/pushover

# Compile and install monit
RUN \
    apk add --update gcc musl-dev make bash python3 curl libressl-dev file zlib-dev && \
    mkdir -p /opt/src; cd /opt/src && \
    wget -qO- ${MONIT_URL}/monit-${MONIT_VERSION}.tar.gz | tar xz && \
    cd /opt/src/monit-${MONIT_VERSION} && \
    ./configure --prefix=${MONIT_HOME} --without-pam && \
    make && make install && \
    apk del gcc musl-dev make file zlib-dev && \
    rm -rf /var/cache/apk/* /opt/src

EXPOSE 2812

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s /usr/local/bin/docker-entrypoint.sh /entrypoint.sh # backwards compat
ENTRYPOINT ["/entrypoint.sh"]

CMD ["monit", "-I", "-B", "-c", "/etc/monitrc_root"]
