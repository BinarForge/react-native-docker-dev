#!/bin/bash
docker run --rm -it \
    -v $(pwd):/home/dev/app \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /dev/bus/usb:/dev/bus/usb \
    -v /home/$USER/.android:/home/dev/.android \
    --privileged \
    --net host \
    -t -d --name rn node-img
