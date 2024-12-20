#!/bin/sh -e

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
		hugo --gc -D -E -F \
                    --noChmod \
                    --cleanDestinationDir \
                    --baseURL="https://dev.shagen.me/" \
                    --destination=/home/www/htdocs/shagen.dev/

		echo "date: $(date)" >> /home/www/htdocs/shagen.dev/commit.txt
		echo "trigger: $current" >> /home/www/htdocs/shagen.dev/commit.txt
		echo "$(git log --sparse | head -1)" >> /home/www/htdocs/shagen.dev/commit.txt
		echo >> /home/www/htdocs/shagen.dev/commit.txt

		if [ "$current" == "update-production" ]
		then
			# production
			hugo --gc \
                            --noChmod \
                            --cleanDestinationDir \
                            --destination=/home/www/htdocs/shagen/

			echo "date: $(date)" >> /home/www/htdocs/shagen/commit.txt
			echo "trigger: $current" >> /home/www/htdocs/shagen/commit.txt
			echo "$(git log --sparse | head -1)" >> /home/www/htdocs/shagen/commit.txt
			echo >> /home/www/htdocs/shagen/commit.txt
		fi

		# still the same? if not, do it again!
		next="$(cat /home/www/tmp/github-update-trigger)"
		[ "$current" == "$next" ] \
			&& break
	done
done
