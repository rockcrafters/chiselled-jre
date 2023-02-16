ARG BASE_IMAGE=ubuntu/chiselled-jre:8_edge
ARG USER=app
ARG UID=101
ARG GROUP=app
ARG GID=101

FROM $BASE_IMAGE

ARG USER
ARG UID
ARG GID
USER $UID:$GID

# shell is needed for maven surefire plugin
ADD --chown=$UID:$GID sh /bin/sh
ADD --chown=$UID:$GID spring-petclinic /spring-petclinic
ADD --chown=$UID:$GID .m2 /.m2

WORKDIR /spring-petclinic

