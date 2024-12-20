#!/bin/sh -xe

inotifywait -q -e modify --monitor /home/www/tmp/github-update-trigger \
	| while read trigger
do
	while true
	do	
		current="$(cat /home/www/tmp/github-update-trigger)"

		cd /home/sdk/shagen.me
		git fetch --all
		git reset --hard origin/main

		# development
		hugo --gc --cleanDestinationDir -D -E -F --baseURL="https://dev.shagen.me/"
		rsync -rvP --delete public/ /home/www/htdocs/shagen.dev/
		chmod -R u=+Xrw,g=+Xr-w,o=-Xr-w public
		
		# # production
		# hugo --gc --cleanDestinationDir --minify
		# rsync -rvP --delete public/ /home/www/htdocs/shagen/

		# still the same? if not, do it again!
		next="$(cat /home/www/tmp/github-update-trigger)"
		[ "$current" == "$next" ] \
			&& break
	done
done
