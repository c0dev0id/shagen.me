#!/bin/sh

S=$((cd content/posts/ && ls -1 | grep -v "_index.md"; echo NEW;) \
    | fzf --tac -e --no-sort;)

[ -z "$S" ] && exit 0

case "$S" in
    "NEW")
        echo -n "Filename: ";
        read filename
        hugo content new --editor vim "content/posts/$filename";
        ;;
    *) vim "content/posts/$S"
esac

