FROM tomcat:9.0.82-jdk8-corretto-al2

ADD config/server.xml /usr/local/tomcat/conf/server.xml
ADD acmeair-java-2.0.0-SNAPSHOT.war /usr/local/tomcat/webapps

CMD [ "/usr/local/tomcat/bin/catalina.sh", "run" ]
