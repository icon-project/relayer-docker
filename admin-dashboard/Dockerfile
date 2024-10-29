ARG ICON_REPO=iconcommunity
ARG BASE_TAG=latest
FROM ${ICON_REPO}/relay-base:${BASE_TAG}
ARG DASHBOARD_VERSION=latest

LABEL org.opencontainers.image.title="Relayer Admin Dashboard"
LABEL org.opencontainers.image.description="Relayer Admin Dashboard for managing relayers"
LABEL org.opencontainers.image.url="https://icon.community"
LABEL org.opencontainers.image.source="https://github.com/icon-project/relayer-admin-dashboard"
LABEL org.opencontainers.image.documentation="https://github.com/icon-project/relayer-admin-dashboard/wiki"

ADD https://raw.githubusercontent.com/acmesh-official/acme.sh/3.0.7/acme.sh /opt
COPY rootfs/ /

RUN apt-dpkg-wrap apt-get update && \
  apt-dpkg-wrap apt-get install -y dnsutils cron nginx-extras socat curl jq unzip && \
  if [ "${DASHBOARD_VERSION}" = "latest" ]; then \
  DASHBOARD_VERSION="$(curl 'https://api.github.com/repos/icon-project/relayer-admin-dashboard/releases/latest' -s | jq -r '.tag_name' | cut -c2-)"; \
  fi && \
  wget https://github.com/icon-project/relayer-admin-dashboard/releases/download/v${DASHBOARD_VERSION}/relayer-admin-dashboard.deb && \
  apt-dpkg-wrap dpkg -i relayer-admin-dashboard.deb && \
  apt-dpkg-wrap apt-get clean && \
  rm -rf relayer-admin-dashboard.deb /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80 443

VOLUME ["/config", "/data"]