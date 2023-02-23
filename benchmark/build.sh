#!/bin/bash
PROJECT=acmeair-monolithic-java
ACMEAIR_REPO=https://github.com/vpa1977/${PROJECT}

git clone $ACMEAIR_REPO || \
    (cd ${PROJECT} && \
     git checkout ${PETCLINIC_TAG} &&
     git reset --hard)

cd ${PROJECT}

mvn package