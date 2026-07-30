SETUP := jyi.setup

.PHONY: build deploy push clean

build:
	scripts/mtime-restore.pl
	ikiwiki --setup $(SETUP)
	ikiwiki-calendar $(SETUP)
	cp -r plugins/l2d/ ../jyi2ya.github.io/

deploy: build
	cd ../jyi2ya.github.io && \
		git checkout --orphan temp && \
		git add --all && \
		git commit -m 'update site' && \
		git branch -D main && \
		git branch -m main && \
		git push -f origin main

push:
	scripts/mtime-save.pl
	git add --all
	git commit
	git push

clean:
	rm -rf ../jyi2ya.github.io/*
