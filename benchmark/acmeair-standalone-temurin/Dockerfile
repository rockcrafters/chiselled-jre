FROM eclipse-temurin:8u362-b09-jre-jammy

ADD acmeair-java-2.0.0-SNAPSHOT.jar /
# uncomment to enabled CDS
#RUN java -Xshare:dump
#CMD [ "java", "-Xshare:on", "-jar", "/acmeair-java-2.0.0-SNAPSHOT.jar" ]
CMD [ "java", "-jar", "/acmeair-java-2.0.0-SNAPSHOT.jar" ]
