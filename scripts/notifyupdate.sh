#!/bin/sh -e
cd /home/sdk/blog
inotifywait -m -r . -e modify -e move -e create -e delete \
    | while read event
do
    case "$event" in
        */.git/*) ;;
      */public/*) ;;
               *) echo "Got $event -> trigger update" 
                  if hugo -FDE
                   then
                       echo "-> testbuild ok: deploy"
                       make update || true
                   else
                       echo "-> testbuild failed: skip deployment"
                   fi
    esac
done
