
.ONESHELL:

SHELL=/bin/bash

IMAGE_TEMURIN=eclipse-temurin:17-jre-jammy
IMAGE_UBUNTU=ubuntu/chiselled-jre:17_edge azul/zulu-openjdk-distroless:17.0.7-17.42.19 gcr.io/distroless/java17-debian11
IMAGE_AL2023=amazoncorretto:17.0.7-al2023-headless
IMAGES=$(IMAGE_TEMURIN) $(IMAGE_UBUNTU) $(IMAGE_ALPNE)

PROJECT=acmeair-monolithic-java
TAG=chiselled-demo-17
ACMEAIR_REPO=https://github.com/vpa1977/$(PROJECT)

.PHONY=standalone tomcat

all: maven standalone tomcat

maven:
	git clone --branch $(TAG) $(ACMEAIR_REPO) || \
		(cd $(PROJECT) && git checkout $(TAG))
	(cd $(PROJECT) && mvn clean package -Pexternal-tomcat \
		&& cp target/acmeair-java-2.0.0-SNAPSHOT.war ../acmeair-tomcat/ \
		&& mvn -DskipTests=true package -Pexternal-liberty \
		&& cp target/acmeair-java-2.0.0-SNAPSHOT.jar ../acmeair-standalone)

standalone: maven
	for x in $(IMAGES); do \
	    docker build -t standalone-$$x --build-arg BASE_IMAGE=$$x acmeair-standalone || exit 1;\
	done
	
tomcat: maven
	docker build -t tomcat-temurin \
		--build-arg BASE_IMAGE=tomcat:10.1.9-jre17-temurin-jammy \
		acmeair-tomcat -f acmeair-tomcat/Dockerfile.temurin || exit 1
	for x in $(IMAGE_UBUNTU); do \ 
		docker build -t tomcat-$$x --build-arg BASE_IMAGE=$$x acmeair-tomcat \
			-f acmeair-tomcat/Dockerfile.ubuntu || exit 1;\
	done
	for x in $(IMAGE_AL2023); do \ 
		docker build -t tomcat-$$x --build-arg BASE_IMAGE=$$x acmeair-tomcat \
			-f acmeair-tomcat/Dockerfile.al2023 || exit 1;\
	done


