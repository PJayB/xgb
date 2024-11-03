#
# EXAMPLE - DO NOT USE
# Copy and adapt this to your needs.
#
# TODO: documentation
#
FROM ubuntu:jammy

COPY scripts /docker
COPY example-install.bash /docker

RUN cd /docker && \
    ./scripts/debian/apt-gen-sources.bash arm64 i386 amd64 > /etc/apt/sources.list && \
    apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get upgrade -y && \
    dpkg --add-architecture i386 && \
    dpkg --add-architecture amd64 && \
    dpkg --add-architecture arm64 && \
    bash example-install.bash
