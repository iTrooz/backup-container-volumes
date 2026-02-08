FROM alpine:latest

RUN apk add restic docker tini

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
