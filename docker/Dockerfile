#
# EXAMPLE - DO NOT USE
# Copy and adapt this to your needs.
#
FROM ubuntu:jammy

COPY scripts /docker
COPY example-install.bash /docker

RUN cd /docker && bash example-install.bash
