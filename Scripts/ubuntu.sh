#!/bin/bash

if ! command -v docker > /dev/null; then
    echo "Install docker https://docker.com" >&2
    exit 1
fi
action=$1
swift=$2
ubuntu=$3
dockerfile=$(mktemp)
echo "FROM swift:$swift-$ubuntu"    >  $dockerfile
echo 'ADD . aoc-2020'               >> $dockerfile
echo 'WORKDIR aoc-2020'             >> $dockerfile
echo 'RUN apt-get update && apt-get install -y make' >> $dockerfile
echo "RUN make $action"             >> $dockerfile
image=drstring
docker image rm -f "$image" > /dev/null
docker build -t "$image" -f $dockerfile .
docker run --rm "$image"