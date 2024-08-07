ARG PETCLINIC_REPO
ARG PETCLINIC_TAG

ARG BASE_IMAGE=ubuntu/jre:17_edge
ARG USER=app
ARG UID=101
ARG GROUP=app
ARG GID=101

FROM eclipse-temurin:17.0.12_7-jdk-jammy as builder

ENV PETCLINIC_TAG=${PETCLINIC_TAG:-spring-boot-3.0.6}
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
    /spring-petclinic/target/spring-petclinic-3.0.6.jar /

WORKDIR /

ENTRYPOINT ["/opt/java/bin/java", \
    "-jar", \
    "spring-petclinic-3.0.6.jar" ]
