#!/bin/sh -e
cd /home/sdk/blog
inotifywait -m -r . -e modify -e move -e create -e delete \
    | while read event
do
    echo -n "Got event: $event "
    case "$event" in
        */.git/*) echo "-> ignored" ;;
      */public/*) echo "-> ignored" ;;
               *) echo "-> trigger update" 
                  if hugo --quiet=true
                   then
                       echo "-> testbuild ok: deploy"
                       make update > /dev/null 2>&1 || true
                   else
                       echo "-> testbuild failed: skip deployment"
                   fi
    esac
done
