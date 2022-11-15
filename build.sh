#!/bin/bash

docker image rm pedrozc90/sbt-nodejs:test

docker build --no-cache \
    --network host \
    --file ./Dockerfile \
    --tag pedrozc90/sbt-nodejs:test \
    .

# exit if docker build fails
if [[ $? -ne 0 ]]; then
    exit $?
fi

docker run -it --rm --name play-builder pedrozc90/sbt-nodejs:test bash
