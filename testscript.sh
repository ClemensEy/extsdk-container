#!/bin/bash

myip=$(ifconfig | grep "inet " | grep -Fv 127.0.0.1 | grep -Fv 127.0.0.2 | awk '{print $2}')
docker run -e DISPLAY=$myip:0 gns3/xeyes
