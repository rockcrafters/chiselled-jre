FROM websphere-liberty:23.0.0.1-full-java8-ibmjava

COPY --chown=1001:0 config/server.xml /opt/ibm/wlp/usr/servers/defaultServer/server.xml

RUN installUtility install defaultServer

COPY --chown=1001:0 config/jvm.options /opt/ibm/wlp/usr/servers/defaultServer/jvm.options
COPY --chown=1001:0 acmeair-java-2.0.0-SNAPSHOT.war /opt/ibm/wlp/usr/servers/defaultServer/apps/

CMD ["/opt/ibm/wlp/bin/server", "debug", "defaultServer"]
