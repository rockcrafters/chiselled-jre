#!/bin/bash
PROJECT=acmeair-monolithic-java
ACMEAIR_REPO=https://github.com/vpa1977/${PROJECT}

git clone $ACMEAIR_REPO || \
    (cd ${PROJECT} && \
     git pull)

pushd ${PROJECT}

mvn package

cp target/*.war ../acmeair-liberty/
cp target/*.war ../acmeair-tomcat/

popd

docker build -t acmeair-liberty acmeair-liberty