ARG BASE_IMAGE=ubuntu/chiselled-jre:8_edge
ARG MAVEN_IMAGE=maven:3.9.0-eclipse-temurin-8
ARG USER=app
ARG UID=101
ARG GROUP=app
ARG GID=101

FROM $MAVEN_IMAGE as builder

FROM $BASE_IMAGE

ARG USER
ARG UID
ARG GID
USER $UID:$GID
COPY --from=builder /bin/sh /bin/sh
COPY --from=builder /usr/bin/chmod /usr/bin/chmod
COPY --from=builder /usr/bin/uname /usr/bin/uname
COPY --from=builder /usr/bin/dirname /usr/bin/dirname
# note, Temurin base does not install into /etc/maven and /usr/share/java
# other base might require copying those folders
COPY --from=builder /usr/share/maven /usr/share/maven

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre

# Add javac compiler for maven (it always recompiles package-info.java)
COPY --from=builder /opt/java/openjdk/bin/javac \
    /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/
COPY --from=builder /opt/java/openjdk/lib/tools.jar \
    /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/

ENTRYPOINT [ "/usr/share/maven/bin/mvn" ]
