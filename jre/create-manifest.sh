#!/bin/bash
set -ex
INSTALL=$1
TARGETARCH=$2

mkdir -p $INSTALL/usr/share/rocks/
FIELDS=(
    '${db:Status-Abbrev}'
    '${binary:Package}'
    '${Version}'
    '${source:Package}'
    '${Source:Version}\n'
)
zstd -d -f -q $INSTALL/var/lib/chisel/manifest.wall \
-o /manifest

# add openjdk-21 package
(
    IFS="," && \
    echo "# os-release" && cat /etc/os-release && echo "# dpkg-query" && \
    dpkg-query -f "${FIELDS[*]}" \
        -W openjdk-17-jdk-headless | head -n 1
) > $INSTALL/usr/share/rocks/dpkg.query
# add rest of the packages
jq -r 'select(.kind == "package") | "\(.name) \(.version)"' \
    /manifest | \
awk -v arch=${TARGETARCH} -F' ' -f print-dpkg-query.awk \
    >> $INSTALL/usr/share/rocks/dpkg.query
