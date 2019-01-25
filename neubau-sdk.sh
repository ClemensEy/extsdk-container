#!/bin/bash

# -Requirements
# socat
# make sure Xquarz is installed and configured to support X forwarding via network
# eg http://server.neubau.io:50080/x86_64-buildtools-nativesdk-standalone-2.4.sh
url=$1
# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPTPATH=$(dirname "$SCRIPT")

echo "Neubau sdk-script"
echo "mount xtools toolchain"
hdiutil attach $SCRIPTPATH/xtools-2016-09-01.dmg &
#shared directory (see https://github.com/crops/docker-win-mac-docs/wiki/Mac-Instructions)
sambarun=$(docker inspect -f {{.State.Running}} samba)
#echo $sambarun

if [ "$sambarun" = true ]; then
  echo "samba container is running"
else
  echo "starting samba container"
  docker start samba && sudo ifconfig lo0 127.0.0.2 alias up
fi

#get ip
#myip=$(ifconfig | grep "inet " | grep -Fv 127.0.0.1 | grep -Fv 127.0.0.2 | awk '{print $2}')
myip=$(ifconfig | grep "inet " | grep -Fv 127.0.0.1 | grep -Fv 127.0.0.2 | awk 'NR>0 && NR<2 {print $2}')

#open socat in background (for X forwarding)
socat TCP-LISTEN:6000,bind=${myip},reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" &



#run docker with our without url (http://server.neubau.io:50080/sdk-installer.sh)
if [[ -n "$url" ]]; then
  docker run --rm -it --name neubau-sdk --hostname neubau.sdk -v myvolume:/workdir -v /Users/clemens/Developer/sdkuser-home/sdkuser:/home/sdkuser/ -v /Users/clemens/Developer/Projects:/workdir/Projects -e DISPLAY=$myip:0 clemensey/extsdk-container --url $url
else
  docker run --rm -it --name neubau-sdk --hostname neubau.sdk -v myvolume:/workdir -v /Users/clemens/Developer/sdkuser-home/sdkuser:/home/sdkuser/ -v /Users/clemens/Developer/Projects:/workdir/Projects -e DISPLAY=$myip:0 clemensey/extsdk-container

fi
