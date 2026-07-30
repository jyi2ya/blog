.PHONY: build deploy push clean

build:
	scripts/setup.pl

deploy:
	scripts/setup.pl --deploy

push:
	scripts/push.pl

clean:
	rm -rf ../jyi2ya.github.io/*
