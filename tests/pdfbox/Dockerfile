ARG MAVEN_IMAGE
ARG UBUNTU_RELEASE=24.04
ARG USER=app
ARG UID=101
ARG GROUP=app
ARG GID=101
ARG CHISEL_VERSION=1.0.0
ARG TARGETARCH=amd64

FROM public.ecr.aws/ubuntu/ubuntu:$UBUNTU_RELEASE@sha256:da20fb875cfefd317c49e7aaf3998d3e5ad42c5b20f34a0eec6dca2fe4fbb8f4 AS builder
ARG CHISEL_VERSION
ARG TARGETARCH
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-oeux", "pipefail", "-c"]
ADD https://github.com/canonical/chisel/releases/download/v${CHISEL_VERSION}/chisel_v${CHISEL_VERSION}_linux_${TARGETARCH}.tar.gz chisel.tar.gz
RUN tar -xvf chisel.tar.gz -C /usr/bin/
RUN mkdir -p /rootfs \
      && chisel cut --root /rootfs \
        liblcms2-2_libs \
        libfontconfig1_libs \
        libfreetype6_libs \
        libjpeg-turbo8_libs

FROM $MAVEN_IMAGE
COPY --from=builder /rootfs /
