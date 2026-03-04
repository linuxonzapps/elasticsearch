#!/bin/bash
set -e -o pipefail
read -ra arr <<< "$@"
version=${arr[1]}
trap 0 1 2 ERR
# Ensure sudo is installed
apt-get update && apt-get install sudo -y
# Extract DISTRO details for tagging
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO="$ID-$VERSION_ID"
    if [ "$VERSION_CODENAME" != "" ]; then
        DISTRO="$ID-$VERSION_CODENAME"
    fi
fi
current_dir="$PWD"
echo $DISTRO > .distro_zab.txt
bash /tmp/linux-on-ibm-z-scripts/Elasticsearch/${version}/build_elasticsearch.sh -y
# Package Elasticsearch
mv ./elasticsearch/distribution/archives/linux-s390x-tar/build/distributions/elasticsearch-${version}-SNAPSHOT-linux-s390x.tar.gz ${current_dir}/elasticsearch-${version}-linux-s390x.tar.gz
exit 0
