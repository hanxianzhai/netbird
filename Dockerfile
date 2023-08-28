FROM debian:stable as builder

WORKDIR /tmp

RUN apt update && apt install -y wget \
    && wget https://github.com/netbirdio/netbird/releases/download/v0.22.7/netbird_0.22.7_linux_amd64.tar.gz \
    && tar xvzf netbird_0.22.7_linux_amd64.tar.gz

FROM debian:stable

RUN apt update && apt install -y --no-install-recommends ca-certificates iptables ip6tables \
    && apt-get clean && \
    && rm -rf /var/lib/apt/lists/*
    
ENV NB_FOREGROUND_MODE=true
COPY --from=builder /tmp/netbird /go/bin/netbird
ENTRYPOINT [ "/go/bin/netbird","up"]
