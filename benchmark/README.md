# Acme Air Sample and Benchmark (monolithic simple version)

This application shows an implementation of a fictitious airline called "Acme Air".  The application was built with some key business requirements: the ability to scale to billions of web API calls per day, the need to develop and deploy the application targeting multiple cloud platforms (including Public, Private and hybrid).  The application can be deployed both on-prem as well as on Cloud platforms.

This version of acmeair supports deployment to:
    - WebSphere Liberty Profile to Mongodb
    - Apache Tomcat

# Building

Run `docker build -t acmeair-liberty acmeair-liberty && docker-compose up -f docker-compose.liberty.yml` to bring up WebSphere liberty version.

Run `docker build -t acmeair-tomcat acmeair-tomcat && docker-compose up -f docker-compose.tomcat.yml` to bring up Tomcat version.

# Running benchmarks

