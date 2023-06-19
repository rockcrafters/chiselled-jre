ARG BASE_IMAGE=ubuntu/jre:8_edge
ARG TOMCAT_IMAGE=acmeair-tomcat
# Use x86_64 for amd64 and aarch64 for arm64
ARG ARCH=x86_64
FROM $TOMCAT_IMAGE as builder
FROM $BASE_IMAGE
ARG ARCH
ENV ARCH=${ARCH}

COPY --chown=$UID:$GID --from=builder \
    /usr/local/tomcat /usr/local/tomcat

#  launcher support
COPY --from=builder /bin/sh /bin/sh
COPY --from=builder /usr/bin/chmod /usr/bin/chmod
COPY --from=builder /usr/bin/uname /usr/bin/uname
COPY --from=builder /usr/bin/dirname /usr/bin/dirname

# tomcat native support
#(openssl)
COPY --from=builder /usr/lib/${ARCH}-linux-gnu/engines-3/*.so /usr/lib/${ARCH}-linux-gnu/engines-3/
COPY --from=builder /usr/lib/${ARCH}-linux-gnu/libcrypto.so.3 /usr/lib/${ARCH}-linux-gnu/libcrypto.so.3
COPY --from=builder /usr/lib/${ARCH}-linux-gnu/libssl.so.3 /usr/lib/${ARCH}-linux-gnu/libssl.so.3
COPY --from=builder /usr/lib/${ARCH}-linux-gnu/ossl-modules/* /usr/lib/${ARCH}-linux-gnu/ossl-modules/
# libapr
COPY --from=builder /usr/lib/${ARCH}-linux-gnu/libapr-1.so.0 /usr/lib/${ARCH}-linux-gnu/libapr-1.so.0
COPY --from=builder  /usr/lib/${ARCH}-linux-gnu/libuuid.so.1 /usr/lib/${ARCH}-linux-gnu/libuuid.so.1

ENV CATALINA_HOME=/usr/local/tomcat
ENV PATH=$CATALINA_HOME/bin:$PATH
WORKDIR $CATALINA_HOME

ENV TOMCAT_NATIVE_LIBDIR=$CATALINA_HOME/native-jni-lib
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$TOMCAT_NATIVE_LIBDIR

ENTRYPOINT [ "/bin/sh" ]
CMD [ "/usr/local/tomcat/bin/catalina.sh", "run" ]
