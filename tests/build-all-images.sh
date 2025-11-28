docker build \
          -t ubuntu/jre:test \
          --build-arg UID=$(id -u ${USER}) \
          --build-arg GID=$(id -g ${USER}) \
          --build-arg TARGETARCH=amd64 \
          -f jre/Dockerfile.22.04 \
          jre

docker build \
        -t ubuntu/jre:test-builder \
        --build-arg UID=$(id -u ${USER}) \
        --build-arg GID=$(id -g ${USER}) \
        -f tests/containers/builder/Dockerfile.22.04 \
        tests/containers/builder

docker build \
          -t ubuntu/jre:test-maven \
          --build-arg UID=$(id -u ${USER}) \
          --build-arg GID=$(id -g ${USER}) \
          --build-arg BASE_IMAGE=ubuntu/jre:test \
          --build-arg MAVEN_IMAGE=maven:3.9.1-eclipse-temurin-17 \
          -f tests/containers/maven/Dockerfile.22.04 \
          tests/containers/maven
