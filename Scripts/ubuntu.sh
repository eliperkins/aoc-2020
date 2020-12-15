#!/bin/bash

if ! command -v docker > /dev/null; then
    echo "Install docker https://docker.com" >&2
    exit 1
fi
action="$*"
dockerfile=$(mktemp)
echo "FROM swift:5.3.1-focal"   >  $dockerfile
echo 'ADD . aoc-2020'           >> $dockerfile
echo 'WORKDIR aoc-2020'         >> $dockerfile
echo "RUN swift $action"        >> $dockerfile
image=aoc-2020
docker image rm -f "$image" > /dev/null
docker build -t "$image" -f $dockerfile .
docker run --rm "$image"