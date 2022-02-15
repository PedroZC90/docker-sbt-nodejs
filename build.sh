#!/bin/bash

docker build --no-cache \
    --network host \
    --file ./Dockerfile \
    --tag pedrozc90/sbt-node \
    .

docker run -it --rm --name play-builder pedrozc90/sbt-node bash
