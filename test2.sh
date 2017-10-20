#!/bin/bash

sambarun=$(docker inspect -f {{.State.Running}} samba)
echo $sambarun
