all: build

build:
	hugo

clean:
	rm -rf public resources

server:
	set +e; while true; \
		do hugo server -D --disableFastRender --navigateToChanged; \
		echo "hugo server stopped" | xnotify & \
		echo "press enter to retry"; read; \
	done

server-home:
	set +e; while true; \
		do hugo server --baseURL="https://hugo.codevoid.de/" --appendPort=false --liveReloadPort=443 --noHTTPCache -D --disableFastRender --navigateToChanged; \
		echo "hugo server stopped"; \
		echo "press enter to retry"; read; \
	done

preview:
	chrome http://localhost:1313 >/dev/null 2>&1 &

edit:
	./scripts/edit.sh

dev:
	hugo --gc --cleanDestinationDir -D -E -F --baseURL="https://dev.shagen.me/"
	rsync -avzP --delete public/ codevoid.de:/home/www/htdocs/shagen.dev/

prod:
	hugo --gc --cleanDestinationDir --minify
	rsync -avzP --delete public/ codevoid.de:/home/www/htdocs/shagen/

