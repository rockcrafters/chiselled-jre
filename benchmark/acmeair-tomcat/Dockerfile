FROM tomcat:9.0.71-jre8-temurin-jammy

#RUN rm -rf /usr/local/tomcat/webapps/*
ADD config/server.xml /usr/local/tomcat/conf/server.xml
ADD acmeair-java-2.0.0-SNAPSHOT.war /usr/local/tomcat/webapps
