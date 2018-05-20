#!/bin/sh

docker run -it --hostname raspberrypi -v"`pwd`":/mnt darvin/mathematica "$@" 