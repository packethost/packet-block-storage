FROM alpine:3.9

RUN apk --update add open-iscsi multipath-tools jq supervisor curl

COPY packet-* /usr/local/bin/
COPY entrypoint /usr/local/bin/

CMD entrypoint
