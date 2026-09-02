ARG UBUNTU_RELEASE=26.04
ARG BASE_IMAGE=ubuntu/jre:8_edge
FROM public.ecr.aws/ubuntu/ubuntu:$UBUNTU_RELEASE@sha256:a8724cce691d74a71c42574d3c7e4ef59977b4c48f274cd8bc075e53339bae82 AS builder
FROM $BASE_IMAGE
# shell is needed for maven surefire plugin
COPY --from=builder /bin/sh /bin/sh
