ARG ICON_REPO=iconcommunity
ARG BASE_TAG=latest
FROM ${ICON_REPO}/relay-base:${BASE_TAG}

LABEL org.opencontainers.image.title="Admin Dashboard"
LABEL org.opencontainers.image.description="Control panel to control and operate relayers remotly"
LABEL org.opencontainers.image.url="https://icon.community"
LABEL org.opencontainers.image.source="https://github.com/icon-project/relayer-admin-dashboard"
LABEL org.opencontainers.image.documentation="https://github.com/relayer-admin-dashboard/wiki"

ADD https://raw.githubusercontent.com/acmesh-official/acme.sh/3.0.7/acme.sh /opt
COPY rootfs/ /

RUN apt-dpkg-wrap apt-get update && \
  apt-dpkg-wrap apt-get install -y dnsutils cron nginx-extras socat curl jq && \
  rm -f /etc/nginx/conf.d/default.conf && \
  apt-cleanup

EXPOSE 80 443

VOLUME ["/config"]