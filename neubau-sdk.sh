#!/bin/bash

# -Requirements
# socat
# make sure Xquarz is installed and configured to support X forwarding via network
# eg http://server.neubau.io:50080/x86_64-buildtools-nativesdk-standalone-2.4.sh
url=$1

echo "Neubau sdk-script..."
#shared directory (see https://github.com/crops/docker-win-mac-docs/wiki/Mac-Instructions)
docker start samba && sudo ifconfig lo0 127.0.0.2 alias up
#open socat in background (for X forwarding)
socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" &

#get ip
myip=$(ifconfig | grep "inet " | grep -Fv 127.0.0.1 | grep -Fv 127.0.0.2 | awk '{print $2}')


#run docker with our without url
if [[ -n "$url" ]]; then
  docker run --rm -it --name neubau-sdk --hostname neubau.sdk -v myvolume:/workdir -v /Users/clemens/Developer/keys:/home/sdkuser/.ssh/ -e DISPLAY=$myip:0 clemensey/extsdk-container --url $url
else
  docker run --rm -it --name neubau-sdk --hostname neubau.sdk -v myvolume:/workdir -v /Users/clemens/Developer/keys:/home/sdkuser/.ssh/ -e DISPLAY=$myip:0 clemensey/extsdk-container

fi
