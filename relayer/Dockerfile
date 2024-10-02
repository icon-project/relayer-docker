ARG ICON_REPO=iconcommunity
ARG BASE_TAG=latest
ARG RELAYER_VERSION=latest
FROM ${ICON_REPO}/relay-base:${BASE_TAG}

LABEL org.opencontainers.image.title="Centralized Relay"
LABEL org.opencontainers.image.description="Centralized relay"
LABEL org.opencontainers.image.url="https://icon.community"
LABEL org.opencontainers.image.source="https://github.com/icon-project/centralized-relay"
LABEL org.opencontainers.image.documentation="https://github.com/icon-project/centralized-relay/wiki"

COPY rootfs/ /

RUN apt-dpkg-wrap apt-get update && \
  apt-dpkg-wrap apt-get install -y dnsutils socat curl jq tar && \
  apt-cleanup

RUN \
  dpkgArch="$(dpkg --print-architecture)" && \
  case "${dpkgArch##*-}" in \
  "amd64") ARCH=amd64 ;; \
  "arm64") ARCH=arm64 ;; \
  *) echo "unsupported architecture"; exit 1 ;; \
  esac && \
  RELAYER_VERSION=1.6.1-rc1; \
  wget https://github.com/icon-project/centralized-relay/releases/download/v${RELAYER_VERSION}/centralized-relay_${RELAYER_VERSION}_linux_${ARCH}.tar.gz && \
  tar -zxf centralized-relay_${RELAYER_VERSION}_linux_${ARCH}.tar.gz && \
  mv centralized-relay_${RELAYER_VERSION}_linux_${ARCH}/centralized-relay /usr/bin && \
  rm centralized-relay_${RELAYER_VERSION}_linux_${ARCH}.tar.gz && \
  useradd -mU relayer -s /bin/bash
