FROM alpine:3.17 as builder

WORKDIR /tmp

RUN apk add --update --no-cache wget \
    && wget https://github.com/netbirdio/netbird/releases/download/v0.22.4/netbird_0.22.4_linux_amd64.tar.gz \
    && tar xvzf netbird_0.22.4_linux_amd64.tar.gz

FROM alpine:3.17

RUN apk add --no-cache ca-certificates iptables ip6tables iptables-dev bpftool
ENV NB_FOREGROUND_MODE=true
COPY --from=builder /tmp/netbird /go/bin/netbird
ENTRYPOINT [ "/go/bin/netbird","up"]
