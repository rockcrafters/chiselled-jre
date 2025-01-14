#!/bin/sh
set -e 

(cd jre/ubuntu-24.04-headless && \
    rockcraft pack --build-for amd64 && \
    rockcraft.skopeo copy oci-archive:jre_21-edge_amd64.rock docker-daemon:ubuntu/jre:test)

docker build \
    -t ubuntu/jre:test-builder \
    --build-arg UID=$(id -u ${USER}) \
    --build-arg GID=$(id -g ${USER}) \
    -f tests/containers/builder/Dockerfile.24.04 \
    tests/containers/builder

docker build \
    -t ubuntu/jre:test-maven \
    --build-arg ARCH=amd64 \
    --build-arg UID=$(id -u ${USER}) \
    --build-arg GID=$(id -g ${USER}) \
    --build-arg BASE_IMAGE=ubuntu/jre:test \
    --build-arg MAVEN_IMAGE=maven:3.9.9-eclipse-temurin-21 \
    -f tests/containers/maven/Dockerfile.24.04 \
    tests/containers/maven
