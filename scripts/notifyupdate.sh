#!/bin/sh -e
cd /home/sdk/blog
inotifywait -m -r . -e modify -e move -e create -e delete \
    | while read event
do
    echo -n "Got event: $event "
    case "$event" in
        */.git/*) echo "-> ignored" ;;
      */public/*) echo "-> ignored" ;;
               *) echo; echo -n "-> testbuild: " 
                  if hugo --quiet=true
                   then
                       echo "ok"
                       echo "-> deploy"
                       make update > /dev/null || true
                   else
                       echo "not ok, won't deploy"
                   fi
    esac
done
