#!/bin/bash

set -o errexit

if [ "$#" -ne 2 ]; then
    echo "Incorrect parameters"
    echo "Usage: build-services.sh <version> <prefix>"
    exit 1
fi

VERSION=$1
PREFIX=$2
SCRIPTDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

kubectl delete -f bookinfo.yaml

pushd "$SCRIPTDIR/main"
  docker build --pull -t "${PREFIX}/jaeger-main-python-v1:${VERSION}" -t "${PREFIX}/jaeger-main-python-v1:latest" .
popd

pushd "$SCRIPTDIR/formatter"
  docker build --pull -t "${PREFIX}/jaeger-formatter-python-v1:${VERSION}" -t "${PREFIX}/jaeger-formatter-python-v1:latest" .
popd

pushd "$SCRIPTDIR/jaeger-demo-a"
  #mvn clean package
  docker build --pull -t "${PREFIX}/jaeger-demo-a-v1:${VERSION}" -t "${PREFIX}/jaeger-demo-a-v1:latest" .
popd

kubectl apply -f bookinfo.yaml