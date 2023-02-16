# Spring PetClinic

This docker file contains [Spring PetClinic](https://github.com/spring-projects/spring-petclinic) sample built on top of chiselled-jre container.

# Running the sample

`` docker build -t petclinic . && docker run -p 8080:8080 --tmpfs /tmp:exec petclinic ``

Navigate to http://localhost:8080 to explore the demo.
