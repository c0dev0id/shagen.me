all: build

clean:
	rm -rf public resources

update:
	git add -A . || true
	git commit -m "Content Update" || true
	git push || true

dev:
	ssh codevoid.de \
		"echo update-development > /home/www/tmp/github-update-trigger"

prod:
	ssh codevoid.de \
		"echo update-production > /home/www/tmp/github-update-trigger"

maintenance:
	scp maintenance.html codevoid.de:/home/www/htdocs/shagen/index.html

watch:
	 while true; \
	 do \
	 	./scripts/deploy_hugo.sh || true; \
	 done || true
