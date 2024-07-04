ARG MAVEN_IMAGE
ARG UBUNTU_RELEASE=22.04
ARG USER=app
ARG UID=101
ARG GROUP=app
ARG GID=101
ARG CHISEL_VERSION=0.10.0
ARG TARGETARCH=amd64

FROM public.ecr.aws/ubuntu/ubuntu:$UBUNTU_RELEASE@sha256:507d5d9e56228b802b0fff23956efa631dd01a2a6d9a8c511838592d3aac92b6 AS builder
ARG CHISEL_VERSION
ARG TARGETARCH
ADD https://github.com/canonical/chisel/releases/download/v${CHISEL_VERSION}/chisel_v${CHISEL_VERSION}_linux_${TARGETARCH}.tar.gz chisel.tar.gz
RUN tar -xvf chisel.tar.gz -C /usr/bin/

SHELL ["/bin/bash", "-oeux", "pipefail", "-c"]
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates \
        ca-certificates-java \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /rootfs \
      && chisel cut --root /rootfs \
        openjdk-8-jre-headless_awt

FROM $MAVEN_IMAGE
COPY --from=builder /rootfs /
