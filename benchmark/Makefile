.ONESHELL:

SHELL=/bin/bash

IMAGE_TEMURIN=eclipse-temurin:17.0.7_7-jre-jammy
IMAGE_DISTROLESS=ubuntu/chiselled-jre:17_edge azul/zulu-openjdk-distroless:17.0.7-17.42.19 gcr.io/distroless/java17-debian11
IMAGE_YUM=amazoncorretto:17.0.7-al2023-headless
IMAGE_ALPINE=eclipse-temurin:17.0.7_7-jre-alpine
STANDALONE_IMAGES=$(IMAGE_TEMURIN) $(IMAGE_DISTROLESS) $(IMAGE_YUM)

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
	for x in $(STANDALONE_IMAGES); do \
	    docker build -t standalone-$$x --build-arg BASE_IMAGE=$$x acmeair-standalone || exit 1;\
	done

tomcat: maven temurin distroless yum alpine

temurin:
	docker build -t tomcat-temurin \
		--build-arg BASE_IMAGE=tomcat:10.1.9-jre17-temurin-jammy \
		acmeair-tomcat -f acmeair-tomcat/Dockerfile.temurin || exit 1a
distroless:
	for x in $(IMAGE_DISTROLESS); do \
		docker build -t tomcat-$$x --build-arg BASE_IMAGE=$$x acmeair-tomcat \
			-f acmeair-tomcat/Dockerfile.distroless || exit 1;\
	done
yum:
	for x in $(IMAGE_YUM); do \
		docker build -t tomcat-$$x --build-arg BASE_IMAGE=$$x acmeair-tomcat \
			-f acmeair-tomcat/Dockerfile.yum || exit 1;\
	done
alpine:
	for x in $(IMAGE_ALPINE); do \
		docker build -t tomcat-$$x --build-arg BASE_IMAGE=$$x acmeair-tomcat \
			-f acmeair-tomcat/Dockerfile.alpine || exit 1;\
	done


