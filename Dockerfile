ARG BASEIMAGE=alpine:3.7
FROM ${BASEIMAGE}

ENV USERNAME samba
ENV PASSWORD password
ENV UID 1000
ENV GID 1000

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
ARG ARCH
ARG S6_ARCH=amd64
ARG S6_VER=1.22.1.0

LABEL mantainer="Yaroslav Rogov <rogovyaroslav@gmail.com>" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="Samba" \
    org.label-schema.description="Multiarch Samba for amd64 arm32v7 or arm64" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/arikai/samba_docker" \
    org.label-schema.vendor="arikai" \
    org.label-schema.version=$VERSION \
    org.label-schema.schema-version="1.0"

# Install Bash, Samba and OpenSSL
RUN apk update && \
  apk upgrade && \
  apk add bash samba samba-server samba-common-tools openssl && \
  rm -rf /var/cache/apk/*

# Add s6
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-${S6_ARCH}.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-${S6_ARCH}.tar.gz -C /


COPY s6/config.init /etc/cont-init.d/00-config
COPY s6/smbd.run /etc/services.d/smbd/run
COPY s6/nmbd.run /etc/services.d/nmbd/run

EXPOSE 137/udp 138/udp 139/tcp 445/tcp

CMD ["/init"]
