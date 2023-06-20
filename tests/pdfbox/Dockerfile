ARG MAVEN_IMAGE
ARG UBUNTU_RELEASE=23.10
ARG USER=app
ARG UID=101
ARG GROUP=app
ARG GID=101

FROM golang:1.18 AS chisel
ARG UBUNTU_RELEASE
RUN git clone https://github.com/canonical/chisel-releases /opt/chisel-releases \
    && git clone --depth 1 -b main https://github.com/canonical/chisel /opt/chisel
WORKDIR /opt/chisel
RUN go generate internal/deb/version.go \
    && go build ./cmd/chisel

FROM public.ecr.aws/ubuntu/ubuntu:$UBUNTU_RELEASE@sha256:3cd44a5edabc0fbc0fe0fc0f0bbd4e2c086b1f372a0d58d8303bc10635bf7587 AS builder
SHELL ["/bin/bash", "-oeux", "pipefail", "-c"]
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates \
        ca-certificates-java \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
COPY --from=chisel /opt/chisel/chisel /usr/bin/

### BOILERPLATE END ###

FROM builder AS sliced-deps
ARG USER
ARG UID
ARG GROUP
ARG GID
SHELL ["/bin/bash", "-oeux", "pipefail", "-c"]
COPY --from=chisel /opt/chisel-releases /opt/chisel-releases
# use Java 8 headless AWT depedendencies

RUN mkdir -p /rootfs \
      && chisel cut --release /opt/chisel-releases --root /rootfs \
        openjdk-8-jre-headless_awt

FROM $MAVEN_IMAGE
COPY --from=sliced-deps /rootfs /
