FROM debian:slim as builder

WORKDIR /tmp

RUN apt update && apt install -y wget \
    && wget https://github.com/netbirdio/netbird/releases/download/v0.22.7/netbird_0.22.7_linux_amd64.tar.gz \
    && tar xvzf netbird_0.22.7_linux_amd64.tar.gz

FROM debian:slim

RUN apt update && apt install -y --no-install-recommends ca-certificates iptables ip6tables
ENV NB_FOREGROUND_MODE=true
COPY --from=builder /tmp/netbird /go/bin/netbird
ENTRYPOINT [ "/go/bin/netbird","up"]
