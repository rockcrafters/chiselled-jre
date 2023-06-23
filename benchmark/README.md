# Acme Air Sample and Benchmark (monolithic simple spring boot version)

This application shows an implementation of a fictitious airline called "Acme Air".  The application was built with some key business requirements: the ability to scale to billions of web API calls per day, and the need to develop and deploy the application targeting multiple cloud platforms (including Public, Private, and hybrid).  The application can be deployed both on-prem as well as on Cloud platforms.

This version of acmeair supports deployment to:
    - WebSphere Liberty Profile to Mongodb
    - Apache Tomcat

# Building & Running

Run `make` to clone and build acmeair project and docker images.

Run `IMAGE=<image-tag> docker-compose up` to start the acmeair application.

Available tags:
```
tomcat-eclipse-temurin:17.0.7_7-jre-alpine
tomcat-amazoncorretto:17.0.7-al2023-headless
tomcat-gcr.io/distroless/java17-debian11:latest
tomcat-azul/zulu-openjdk-distroless:17.0.7-17.42.19
tomcat-ubuntu/jre:17_edge
tomcat-temurin:latest
standalone-eclipse-temurin:17.0.7_7-jre-alpine
standalone-amazoncorretto:17.0.7-al2023-headless
standalone-gcr.io/distroless/java17-debian11
standalone-azul/zulu-openjdk-distroless:17.0.7-17.42.19
standalone-ubuntu/jre:17_edge
standalone-eclipse-temurin:17.0.7_7-jre-jammy
```

Navigate to ``http://localhost:9080`` to explore the acmeair application.

# Running Benchmarks

Run `(cd ./acmeair-monolithic-java/jmeter/ && ./build.sh)` to prepare the environment.

Start the application and load the database by navigating to http://localhost:9080/rest/info/loader/load?numCustomers=10000.

Running test in GUI: `(cd ./acmeair-monolithic-java/jmeter/ && ./apache-jmeter-5.5/bin/jmeter.sh -DusePureIDs=true )`
