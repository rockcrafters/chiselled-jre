ARG BASE_IMAGE=amazoncorretto:8u362-alpine3.14-jre
ARG TOMCAT_IMAGE=acmeair-tomcat
FROM $TOMCAT_IMAGE as builder
FROM $BASE_IMAGE

COPY --chown=$UID:$GID --from=builder \
    /usr/local/tomcat /usr/local/tomcat

ENV CATALINA_HOME=/usr/local/tomcat
ENV PATH=$CATALINA_HOME/bin:$PATH
WORKDIR $CATALINA_HOME

ENV TOMCAT_NATIVE_LIBDIR=$CATALINA_HOME/native-jni-lib
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$TOMCAT_NATIVE_LIBDIR

ENTRYPOINT [ "/bin/sh" ]
CMD [ "/usr/local/tomcat/bin/catalina.sh", "run" ]
