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
    bash example-install.bash
