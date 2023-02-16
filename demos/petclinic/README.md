# Spring PetClinic

This Dockerfile runs the [Spring PetClinic](https://github.com/spring-projects/spring-petclinic) sample on the `ubuntu/chiselled-jre` container image.

# Running the sample

Execute:

`` docker build -t petclinic . && docker run -p 8080:8080 --tmpfs /tmp:exec petclinic ``

Give it a few minutes to build the sample application and then navigate to http://localhost:8080 to explore the demo.
