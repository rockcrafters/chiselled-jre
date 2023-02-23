#!/bin/bash
PROJECT=acmeair-monolithic-java
TAG=chiselled-demo
ACMEAIR_REPO=https://github.com/vpa1977/${PROJECT}

git clone --branch ${TAG} ${ACMEAIR_REPO} || \
    (cd ${PROJECT} && \
     git checkout ${TAG})

pushd ${PROJECT}

mvn clean package -Pexternal-tomcat

cp target/acmeair-java-2.0.0-SNAPSHOT.war ../acmeair-liberty/
cp target/acmeair-java-2.0.0-SNAPSHOT.war ../acmeair-tomcat/

popd

docker build -t acmeair-liberty acmeair-liberty
docker build -t acmeair-cliberty acmeair-cliberty
docker build -t acmeair-tomcat acmeair-tomcat
docker build -t acmeair-ctomcat acmeair-ctomcat
