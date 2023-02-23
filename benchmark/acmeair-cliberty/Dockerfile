ARG BASE_IMAGE=ubuntu/chiselled-jre:8_edge
ARG LIBERTY_IMAGE=acmeair-liberty
FROM $LIBERTY_IMAGE as builder
FROM $BASE_IMAGE

USER 1001:0

COPY --from=builder /opt /opt

# liberty launcher support
COPY --from=builder /bin/grep /usr/bin/
COPY --from=builder /usr/bin/tr /usr/bin/
COPY --from=builder /bin/cat /usr/bin/
COPY --from=builder /bin/uname /usr/bin/
COPY --from=builder /usr/bin/dirname /usr/bin/
COPY --from=builder /bin/readlink /usr/bin/
COPY --from=builder /bin/sed /usr/bin/
COPY --from=builder /lib/x86_64-linux-gnu/libacl.so.1 /lib/x86_64-linux-gnu/
COPY --from=builder /usr/bin/basename /usr/bin/
COPY --from=builder /bin/chmod /usr/bin/
COPY --from=builder /bin/sh /bin/sh
COPY --from=builder /bin/mkdir /usr/bin

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre

WORKDIR /

ENTRYPOINT ["/opt/ibm/wlp/bin/server", "run", "defaultServer"]
