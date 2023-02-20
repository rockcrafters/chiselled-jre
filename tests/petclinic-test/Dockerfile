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
ADD sh /bin/sh

