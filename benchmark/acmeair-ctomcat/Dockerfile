ARG BASE_IMAGE=ubuntu/chiselled-jre:8_edge
ARG TOMCAT_IMAGE=acmeair-tomcat
FROM $TOMCAT_IMAGE as builder
FROM $BASE_IMAGE

COPY --chown=$UID:$GID --from=builder \
    /usr/local/tomcat /usr/local/tomcat

#  launcher support
COPY --from=builder /bin/sh /bin/sh
COPY --from=builder /usr/bin/chmod /usr/bin/chmod
COPY --from=builder /usr/bin/uname /usr/bin/uname
COPY --from=builder /usr/bin/dirname /usr/bin/dirname

# tomcat native support
#(openssl)
COPY --from=builder /usr/lib/x86_64-linux-gnu/engines-3/*.so /usr/lib/x86_64-linux-gnu/engines-3/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libcrypto.so.3 /usr/lib/x86_64-linux-gnu/libcrypto.so.3
COPY --from=builder /usr/lib/x86_64-linux-gnu/libssl.so.3 /usr/lib/x86_64-linux-gnu/libssl.so.3
COPY --from=builder /usr/lib/x86_64-linux-gnu/ossl-modules/* /usr/lib/x86_64-linux-gnu/ossl-modules/
# libapr
COPY --from=builder /usr/lib/x86_64-linux-gnu/libapr-1.so.0 /usr/lib/x86_64-linux-gnu/libapr-1.so.0
COPY --from=builder  /usr/lib/x86_64-linux-gnu/libuuid.so.1 /usr/lib/x86_64-linux-gnu/libuuid.so.1

# add default logging properties
COPY --from=builder /opt/java/openjdk/lib/logging.properties /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre

ENV CATALINA_HOME=/usr/local/tomcat
ENV PATH=$CATALINA_HOME/bin:$PATH
WORKDIR $CATALINA_HOME

ENV TOMCAT_NATIVE_LIBDIR $CATALINA_HOME/native-jni-lib
ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$TOMCAT_NATIVE_LIBDIR

ENTRYPOINT [ "/bin/sh" ]
CMD [ "/usr/local/tomcat/bin/catalina.sh", "run" ]