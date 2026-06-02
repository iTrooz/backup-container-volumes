FROM alpine:latest

RUN apk add restic docker tini

COPY entrypoint.sh /
COPY scripts/ /scripts/

ENTRYPOINT ["/entrypoint.sh"]
