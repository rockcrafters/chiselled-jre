ARG MAVEN_IMAGE
ARG UBUNTU_RELEASE=22.04
ARG USER=app
ARG UID=101
ARG GROUP=app
ARG GID=101
ARG CHISEL_VERSION=1.2.0
ARG TARGETARCH=amd64

FROM public.ecr.aws/ubuntu/ubuntu:$UBUNTU_RELEASE@sha256:c48359e1887a40c4a8396a4c3f40f4b8245bdbb6a64cb5f39b85c80510f0c868 AS builder
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
