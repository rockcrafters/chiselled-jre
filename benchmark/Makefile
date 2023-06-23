.ONESHELL:

SHELL=/bin/bash

IMAGE_TEMURIN=eclipse-temurin:17.0.7_7-jre-jammy
IMAGE_DISTROLESS=ubuntu/jre:17_edge azul/zulu-openjdk-distroless:17.0.7-17.42.19 gcr.io/distroless/java17-debian11
IMAGE_YUM=amazoncorretto:17.0.7-al2023-headless
IMAGE_ALPINE=eclipse-temurin:17.0.7_7-jre-alpine
STANDALONE_IMAGES=$(IMAGE_TEMURIN) $(IMAGE_DISTROLESS) $(IMAGE_YUM) $(IMAGE_ALPINE)

PROJECT=acmeair-monolithic-java
TAG=chiselled-demo-17
ACMEAIR_REPO=https://github.com/vpa1977/$(PROJECT)


all: maven standalone tomcat

maven:
	git clone --branch $(TAG) $(ACMEAIR_REPO) || \
		(cd $(PROJECT) && git checkout $(TAG))
	(cd $(PROJECT) && mvn clean package -Pexternal-tomcat \
		&& cp target/acmeair-java-2.0.0-SNAPSHOT.war ../acmeair-tomcat/ \
		&& mvn -DskipTests=true package -Pexternal-liberty \
		&& cp target/acmeair-java-2.0.0-SNAPSHOT.jar ../acmeair-standalone)

standalone: maven
	make build-template images="$(STANDALONE_IMAGES)" tag="standalone" ext=""

tomcat: maven temurin distroless yum alpine

temurin:
	docker build -t tomcat-temurin \
		--build-arg BASE_IMAGE=tomcat:10.1.9-jre17-temurin-jammy \
		acmeair-tomcat -f acmeair-tomcat/Dockerfile.temurin || exit 1

distroless:
	make build-template images="$(IMAGE_DISTROLESS)" tag="tomcat" ext=".distroless"

yum:
	make build-template images="$(IMAGE_YUM)" tag="tomcat" ext=".yum"

alpine:
	make build-template images="$(IMAGE_ALPINE)" tag="tomcat" ext=".yum"

export-tomcat: tomcat
	make export-template images="$(IMAGE_DISTROLESS) $(IMAGE_YUM) $(IMAGE_ALPINE)" tag="tomcat"

export-standalone: standalone
	make export-template images="$(STANDALONE_IMAGES)" tag="standalone"

export: export-tomcat export-standalone

build-template:
	for x in $(images); do \
		docker build -t $(tag)-$$x --build-arg BASE_IMAGE=$$x acmeair-$(tag)\
			-f acmeair-$(tag)/Dockerfile$(ext) || exit 1;\
	done

export-template:
	for x in $(images); do \
		name=$$(echo $(tag)-$$x | sed 's/\//_/g' ); \
		docker image save $(tag)-$$x -o $${name}.tar ;  gzip -f $${name}.tar ; \
	done

.PHONY: *
