#!/bin/sh -xe
cd /home/sdk/blog
inotifywait -m -r . -e modify -e move -e create -e delete \
    | while read event
do
    set -x
    case "$line" in
        *.git*) echo "Ignoring change in .git/" ;;
             *) hugo && make update || true ;;
    esac
done
