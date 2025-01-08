#!/bin/sh -xe
cd /home/sdk/blog
inotifywait -m -r . -e modify -e move -e create -e delete \
    | while read event
do
    echo "Got event: $event"
    case "$event" in
        */.git/*) echo "-> ignored" ;;
      */public/*) echo "-> ignored" ;;
               *) echo -n "-> testbuild: " 
                  if hugo --quiet=true
                   then
                       echo "ok"
                       echo "-> deploy"
                       make update
                   else
                       echo "not ok, won't deploy"
                   fi
    esac
done
