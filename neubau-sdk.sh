#!/bin/bash
echo "Neubau sdk-script..."
docker start samba && sudo ifconfig lo0 127.0.0.2 alias up
#open socat in background

#open Xquartz für X11
#open -a Xquartz
#get ip
myip=$(ifconfig | grep "inet " | grep -Fv 127.0.0.1 | grep -Fv 127.0.0.2 | awk '{print $2}')

#run docker (ip durch localhost ersetzen?)
# --url http://server.neubau.io:50080/x86_64-buildtools-nativesdk-standalone-2.4.sh
docker run --rm -it --name neubau-sdk --hostname neubau.sdk -v myvolume:/workdir -v /Users/clemens/Developer/keys:/home/sdkuser/.ssh/ -e DISPLAY=$myip:0 clemensey/extsdk-container
