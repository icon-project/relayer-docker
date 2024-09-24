ARG ICON_REPO=iconcommunity
ARG BASE_TAG=latest
ARG RELAYER_VERSION=latest
FROM ${ICON_REPO}/base:${BASE_TAG}

LABEL org.opencontainers.image.title="Centralized Relay"
LABEL org.opencontainers.image.description="Centralized relay"
LABEL org.opencontainers.image.url="https://icon.community"
LABEL org.opencontainers.image.source="https://github.com/icon-project/centralized-relay"
LABEL org.opencontainers.image.documentation="https://github.com/icon-project/centralized-relay/wiki"

COPY rootfs/ /

RUN apt-dpkg-wrap apt-get update && \
  apt-dpkg-wrap apt-get install -y dnsutils socat curl yq jq tar && \
  apt-cleanup

RUN dpkgArch="$(dpkg --print-architecture)" && \
  case "${dpkgArch##*-}" in \
  "amd64") ARCH=amd64; \
  "arm64") ARCH=arm64;; \
  *) echo "unsupported architecture"; exit 1 ;; \
  esac && \
  if [ "$RELAYER_VERSION" = "latest" ]; then \
  LATEST_VERSION="$(curl 'https://api.github.com/repos/icon-project/centralized-relay/releases/latest' -s | jq -r '.tag_name' | cut -c2-6)" && \
  wget https://github.com/icon-project/centralized-relay/releases/download/v${LATEST_VERSION}/centralized-relay_${LATEST_VERSION}_linux_${ARCH}.tar.gz; \
  else \
  wget https://github.com/icon-project/centralized-relay/releases/download/v${RELAYER_VERSION}/centralized-relay_${RELAYER_VERSION}_linux_${ARCH}.tar.gz; \
  fi

VOLUME ["/data"]