all: build

build:
	hugo

clean:
	rm -rf public resources

update:
	git add -A . || true
	git commit -m "Content Update" || true
	git push || true

dev:
	ssh codevoid.de "echo update-development > /home/www/tmp/github-update-trigger"

prod:
	ssh codevoid.de "echo update-production > /home/www/tmp/github-update-trigger"

watch:
	 while true; do ./scripts/deploy_hugo.sh; sleep 1; done
