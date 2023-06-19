ARG PETCLINIC_REPO
ARG PETCLINIC_TAG

ARG BASE_IMAGE=ubuntu/jre:8_edge
ARG USER=app
ARG UID=101
ARG GROUP=app
ARG GID=101

FROM eclipse-temurin:8u362-b09-jdk-jammy as builder

ENV PETCLINIC_TAG=${PETCLINIC_TAG:-spring-boot-2.7.3}
ENV PETCLINIC_REPO=${PETCLINIC_REPO:-https://github.com/vpa1977/spring-petclinic}

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y git

RUN git clone --branch $PETCLINIC_TAG $PETCLINIC_REPO

RUN cd spring-petclinic && ./mvnw package

FROM $BASE_IMAGE

ARG USER
ARG UID
ARG GID
USER $UID:$GID

# copy petclinic sample
COPY --chown=$UID:$GID --from=builder \
    /spring-petclinic/target/spring-petclinic-2.7.3.jar /

WORKDIR /

ENTRYPOINT ["/usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java", \
    "-jar", \
    "spring-petclinic-2.7.3.jar" ]
