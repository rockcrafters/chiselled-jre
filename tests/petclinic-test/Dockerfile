ARG UBUNTU_RELEASE=22.04
ARG BASE_IMAGE=ubuntu/jre:8_edge
FROM public.ecr.aws/ubuntu/ubuntu:$UBUNTU_RELEASE@sha256:74f1fdaef92dff9c4da5c35e90b92b07807ef8c27114f622c700107d7042d79e AS builder
FROM $BASE_IMAGE
# shell is needed for maven surefire plugin
COPY --from=builder /bin/sh /bin/sh
