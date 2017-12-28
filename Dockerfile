FROM alpine:latest

MAINTAINER James Eckersall <james.eckersall@gmail.com>

RUN \
  apk update && \
  apk add bash curl openvpn unzip && \
  mkdir -p /openvpn >/dev/null 2>&1 && \
  curl -s https://www.privateinternetaccess.com/openvpn/openvpn.zip -o /openvpn/openvpn.zip && \
  cd /openvpn && unzip -qo /openvpn/openvpn.zip && \
  rm /openvpn/openvpn.zip

ADD entrypoint.sh /

ENV USERNAME="" \
    PASSWORD="" \
    REGION="UK London" \
    LOCAL_NETWORKS=""

ENTRYPOINT bash /entrypoint.sh
