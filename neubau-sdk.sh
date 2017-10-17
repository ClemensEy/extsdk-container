#!/bin/bash
echo "Neubau sdk-script..."
docker start samba && sudo ifconfig lo0 127.0.0.2 alias up
#open socat in background
socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" &

#open Xquartz für X11
open -a Xquartz
#get ip
ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '{print $2}'


#TODO ip in das folgende comando

#run docker (ip durch localhost ersetzen?)

docker run --rm -it --name neubau-sdk --hostname neubau.sdk -v myvolume:/workdir -v /Users/clemens/Developer/keys:/home/sdkuser/.ssh/ -e DISPLAY=192.168.188.103:0 clemensey/extsdk-container --url http://server.neubau.io:50080/x86_64-buildtools-nativesdk-standalone-2.4.sh
