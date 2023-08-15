FROM alpine:3 as builder

WORKDIR /tmp

RUN apk add --update --no-cache wget \
    && wget https://github.com/netbirdio/netbird/releases/download/v0.22.4/netbird_0.22.4_linux_amd64.tar.gz \
    && tar xvzf netbird_0.22.4_linux_amd64.tar.gz

FROM alpine:3
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

RUN apk add --no-cache ca-certificates iptables-legacy iptables-legacy
ENV NB_FOREGROUND_MODE=true
COPY --from=builder /tmp/netbird /go/bin/netbird
ENTRYPOINT [ "/go/bin/netbird","up"]
