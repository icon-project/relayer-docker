ARG ICON_REPO=iconcommunity
ARG BASE_TAG=latest
FROM ${ICON_REPO}/relay-base:${BASE_TAG}
ARG RELAYER_VERSION=latest

LABEL org.opencontainers.image.title="Centralized Relay"
LABEL org.opencontainers.image.description="Centralized relay"
LABEL org.opencontainers.image.url="https://icon.community"
LABEL org.opencontainers.image.source="https://github.com/icon-project/centralized-relay"
LABEL org.opencontainers.image.documentation="https://github.com/icon-project/centralized-relay/wiki"
LABEL org.opencontainers.image.version=${RELAYER_VERSION}

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
  if [ "${RELAYER_VERSION}" = "latest" ]; then \
  RELAYER_VERSION="$(curl 'https://api.github.com/repos/icon-project/centralized-relay/releases/latest' -s | jq -r '.tag_name')"; \
  fi && \
  wget -q https://github.com/icon-project/centralized-relay/releases/download/${RELAYER_VERSION}/centralized-relay_${RELAYER_VERSION#v}_linux_${ARCH}.tar.gz && \
  tar -zxf centralized-relay_${RELAYER_VERSION#v}_linux_${ARCH}.tar.gz && \
  mv centralized-relay_${RELAYER_VERSION#v}_linux_${ARCH}/centralized-relay /usr/bin && \
  rm -rf centralized-relay_${RELAYER_VERSION#v}_linux_${ARCH}* && \
  useradd -mU relayer -s /bin/bash

VOLUME /data