#!/bin/sh -xe
cd /home/sdk/blog
inotifywait -m -r . -e modify -e move -e create -e delete \
    | while read event
do
    hugo && make update || true
done
