
.ONESHELL:

SHELL=/bin/bash
TEMURIN_TAG=17-jre-jammy
IMAGE_TEMURIN=eclipse-temurin:$(TEMURIN_TAG)
IMAGE_UBUNTU=azul/zulu-openjdk:17.0.7-17.42.19-jre-headless
IMAGE_AL2023=amazoncorretto:17.0.7-al2023-headless
IMAGE_ALPINE=azul/zulu-openjdk-alpine:17.0.7-17.42.19-jre-headless
IMAGES=$(IMAGE_TEMURIN) $(IMAGE_UBUNTU) $(IMAGE_ALPNE)

PROJECT=acmeair-monolithic-java
TAG=chiselled-demo
ACMEAIR_REPO=https://github.com/vpa1977/$(PROJECT)


all: maven acmeair-standalone acmeair-tomcat

maven:
	git clone --branch $(TAG) $(ACMEAIR_REPO) || \
		(cd $(PROJECT) && git checkout $(TAG))
	(cd $(PROJECT) && mvn clean package -Pexternal-tomcat \
		&& cp target/acmeair-java-2.0.0-SNAPSHOT.war ../acmeair-tomcat/ \
		&& mvn -DskipTests=true package -Pexternal-liberty \
		&& cp target/acmeair-java-2.0.0-SNAPSHOT.jar ../acmeair-standalone)

acmeair-standalone: maven
	for x in $(IMAGES); do \
	    docker build -t standalone-$$x --build-arg BASE_IMAGE=$$x acmeair-standalone || exit 1;\
	done
	
acmeair-tomcat:
	docker build -t tomcat-temurin --build-arg BASE_IMAGE=tomcat:$(TEMURIN_TAG) acmeair-tomcat -f Dockerfile.temurin
	for x in $(IMAGE_UBUNTU); do \ 
		docker build -t tomcat-$$x --build-arg BASE_IMAGE=$$x acmeair-tomcat -f Dockerfile.ubuntu || exit 1;\
	done
	for x in $(IMAGE_ALPINE); do \ 
		docker build -t tomcat-$$x --build-arg BASE_IMAGE=$$x acmeair-tomcat -f Dockerfile.alpine || exit 1;\
	done
	for x in $(IMAGE_AL2023); do \ 
		docker build -t tomcat-$$x --build-arg BASE_IMAGE=$$x acmeair-tomcat -f Dockerfile.al2023 || exit 1;\
	done


.PHONY=acmeair-standalone acmeair-tomcat
