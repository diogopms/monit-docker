# syntax=docker/dockerfile:1

FROM alpine:3.24.1 AS builder

ENV MONIT_VERSION=6.0.0 \
    MONIT_SHA256=ddacd2a8120aeb2351e4486ee04a17782b5004aee99f2041d829bc4dcf2a5b3b \
    MONIT_URL=https://mmonit.com/monit/dist

WORKDIR /opt/src

# hadolint ignore=DL3018
RUN apk add --no-cache gcc musl-dev make openssl-dev zlib-dev && \
    wget -q "${MONIT_URL}/monit-${MONIT_VERSION}.tar.gz" && \
    echo "${MONIT_SHA256}  monit-${MONIT_VERSION}.tar.gz" > monit.sha256 && \
    sha256sum -c monit.sha256 && \
    tar xzf "monit-${MONIT_VERSION}.tar.gz"

WORKDIR /opt/src/monit-${MONIT_VERSION}

RUN ./configure --prefix=/opt/monit --without-pam && \
    make -j"$(nproc)" && \
    make install

FROM alpine:3.24.1

ENV MONIT_VERSION=6.0.0 \
    MONIT_HOME=/opt/monit \
    PATH=$PATH:/opt/monit/bin

# hadolint ignore=DL3018
RUN apk add --no-cache bash ca-certificates curl python3

COPY --from=builder /opt/monit /opt/monit
COPY slack /bin/slack
COPY pushover /bin/pushover
COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s /usr/local/bin/docker-entrypoint.sh /entrypoint.sh # backwards compat

EXPOSE 2812

ENTRYPOINT ["/entrypoint.sh"]

CMD ["monit", "-I", "-B", "-c", "/etc/monitrc_root"]
