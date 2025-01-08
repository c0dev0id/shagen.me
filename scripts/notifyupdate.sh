#!/bin/sh -xe
cd /home/sdk/blog
inotifywait -m --exclude public --exclude .git -r . -e modify -e move -e create -e delete \
    | while read event
do
    echo "Processeing event: $event"
    case "$event" in
        *.git*) echo "Ignoring change in .git/" ;;
             *) hugo && make update || true ;;
    esac
done
