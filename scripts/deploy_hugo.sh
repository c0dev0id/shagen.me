#!/bin/sh -e
echo "Starting monitor..."
inotifywait -q -e modify --monitor /home/www/tmp/github-update-trigger \
        | while read trigger
do
   echo "Trigger received, starting deployment:"

   while true
   do  
        current="$(cat /home/www/tmp/github-update-trigger)"
        cd /home/sdk/shagen.me

        echo "-> git update"

        git fetch --all
        git reset --hard origin/main

        if [ "$current" == "update-production" ]
        then
                echo "-> hugo deployment: prod environment"
                hugo --gc \
                    --noChmod \
                    --cleanDestinationDir \
                    --destination=/home/www/htdocs/shagen/ || true
                set +x

                echo "date: $(date)" >> /home/www/htdocs/shagen/commit.txt
                echo "trigger: $current" >> /home/www/htdocs/shagen/commit.txt
                echo "$(git log --sparse | head -1)" >> /home/www/htdocs/shagen/commit.txt
                echo >> /home/www/htdocs/shagen/commit.txt

            else

                echo "-> hugo deployment: dev environment"
                hugo --gc -D -E -F \
                    --noChmod \
                    --cleanDestinationDir \
                    --baseURL="https://dev.shagen.me/" \
                    --destination=/home/www/htdocs/shagen.dev/ || true

                echo "Deployment done."

                echo "date: $(date)" >> /home/www/htdocs/shagen.dev/commit.txt
                echo "trigger: $current" >> /home/www/htdocs/shagen.dev/commit.txt
                echo "$(git log --sparse | head -1)" >> /home/www/htdocs/shagen.dev/commit.txt
                echo >> /home/www/htdocs/shagen.dev/commit.txt

        fi

        # still the same? if not, do it again!
        next="$(cat /home/www/tmp/github-update-trigger)"
        [ "$current" == "$next" ] \
                && break
   done
   echo "Listening for next event..."
done
