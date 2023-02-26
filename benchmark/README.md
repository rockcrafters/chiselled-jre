# Acme Air Sample and Benchmark (monolithic simple spring boot version)

This application shows an implementation of a fictitious airline called "Acme Air".  The application was built with some key business requirements: the ability to scale to billions of web API calls per day, and the need to develop and deploy the application targeting multiple cloud platforms (including Public, Private and hybrid).  The application can be deployed both on-prem as well as on Cloud platforms.

This version of acmeair supports deployment to:
    - WebSphere Liberty Profile to Mongodb
    - Apache Tomcat

# Building & Running

Run `./build.sh` to clone and build acmeair project.

## Official Docker Images

Run `docker-compose -f docker-compose.liberty.yml up` to bring up WebSphere liberty.
Run `docker-compose -f docker-compose.tomcat.yml up` to bring up Tomcat.
Run `docker-compose -f docker-compose.standalone-temurin.yml up` to bring up standalone Spring Boot app.

Wait for the application startup and navigate to http://localhost:9080/ to explore the application.

## Chiselled Docker Images

Run `docker-compose -f docker-compose.cliberty.yml up` to bring up chiselled WebSphere liberty.
Run `docker-compose -f docker-compose.ctomcat.yml up` to bring up Tomcat.
Run `docker-compose -f docker-compose.standalone-chisel.yml up` to bring up standalone Spring Boot app.

Wait for the application startup and navigate to http://localhost:9080/ to explore the application.


# Running Benchmarks

Run `(cd ./acmeair-monolithic-java/jmeter/ && ./build.sh)` to prepare the environment.

Start the application and load the database by navigating to http://localhost:9080/rest/info/loader/load?numCustomers=10000.

Running test in GUI: `(cd ./acmeair-monolithic-java/jmeter/ && ./apache-jmeter-5.5/bin/jmeter.sh -DusePureIDs=true )`
