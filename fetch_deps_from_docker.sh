#!/bin/bash

docker run --rm --entrypoint "cat /opt/wolfram-deps.tgz" darvin/mathematica > .deps.tgz