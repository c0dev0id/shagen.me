#!/bin/sh

if [ -f /home/www/tmp/github-update-trigger ]
then
    ntime=$(cat /home/www/tmp/github-update-trigger)
    otime=$(cat /home/sdk/shagen.me/.lasttime)
else
    exit 0
fi

if [ "$ntime" == "$otime"]
then
    exit 0
fi

echo -n "$ntime" > /home/sdk/shagen.me/.lasttime
