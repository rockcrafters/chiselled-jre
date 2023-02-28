# Uncomment to enable CDS
#FROM eclipse-temurin:8u362-b09-jre-jammy as builder
FROM amazoncorretto:8u362-alpine3.14-jre
#COPY --from=builder /opt/java/openjdk/lib/classlist /usr/lib/jvm/java-8-openjdk-amd64/jre/lib
#COPY --from=builder /bin/sh /bin/sh
#USER root
#RUN /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java -Xshare:dump
#USER app
ADD acmeair-java-2.0.0-SNAPSHOT.jar /
#CMD [ "-Xshare:on", "-jar", "/acmeair-java-2.0.0-SNAPSHOT.jar" ]
CMD ["java", "-jar", "/acmeair-java-2.0.0-SNAPSHOT.jar" ]
