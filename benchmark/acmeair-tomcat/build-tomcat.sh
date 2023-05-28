#!/bin/bash
set -ex 

TOMCAT_MAJOR=10
TOMCAT_VERSION=10.1.9
TOMCAT_SHA512=cfdc182e62b33b98ce61f084f51c9cf0bcc5e5f4fff341d6e8bcb7c54b12c058faa2e164a587100ba1c6172b9ae2b32ff4a7193a859b368d1f67baca6aa1680f

curl -fL -o 'tomcat.tar.gz' "https://www.apache.org/dyn/closer.cgi?action=download&filename=tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz"
echo "$TOMCAT_SHA512 *tomcat.tar.gz" | sha512sum --strict --check -
tar -xf tomcat.tar.gz --strip-components=1 
rm bin/*.bat
rm tomcat.tar.gz*

# https://tomcat.apache.org/tomcat-9.0-doc/security-howto.html#Default_web_applications
rm -r webapps
mkdir webapps
# we don't delete them completely because they're frankly a pain to get back for users who do want them, and they're generally tiny (~7MB)

nativeBuildDir="$(mktemp -d)"
tar -xf bin/tomcat-native.tar.gz -C "$nativeBuildDir" --strip-components=1

export CATALINA_HOME="$PWD"
cd "$nativeBuildDir/native"
aprConfig="$(command -v apr-1-config)"
./configure \
    --libdir="$TOMCAT_NATIVE_LIBDIR" \
    --prefix="$CATALINA_HOME" \
    --with-apr="$aprConfig" \
    --with-java-home="$JAVA_HOME" \

make CFLAGS=-DOPENSSL_SUPPRESS_DEPRECATED -j "$(nproc)"

make install
cd $CATALINA_HOME
rm -rf "$nativeBuildDir"
rm bin/tomcat-native.tar.gz; 

chmod -R +rX .
chmod 1777 logs temp work

catalina.sh version
