ARG UBUNTU_RELEASE=22.04
ARG BASE_IMAGE=ubuntu/jre:8_edge
FROM public.ecr.aws/ubuntu/ubuntu:$UBUNTU_RELEASE@sha256:f988120063b5a9ee23aa563983e6d5ff9a802349b6f65810e02caf84302e84f2 AS builder
FROM $BASE_IMAGE
# shell is needed for maven surefire plugin
COPY --from=builder /bin/sh /bin/sh
