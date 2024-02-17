FROM dperson/openvpn-client

RUN set -eux; \
    apk add --no-cache ca-certificates bash openssh expect curl wget openssh net-tools

WORKDIR /root

COPY ovpn.exp /usr/local/bin/ovpn
COPY docker-entrypoint.sh docker-healcheck.sh /usr/local/bin/

RUN chmod +x \
    /usr/local/bin/docker-entrypoint.sh \
    /usr/local/bin/docker-healcheck.sh \
    /usr/local/bin/ovpn

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

ENV VPN_PASS=""
ENV VPN_TIMEOUT=""

HEALTHCHECK --interval=30s --timeout=5s \
    CMD bash /usr/local/bin/docker-healcheck.sh || pkill -SIGILL -f 1
