.PHONY: clean build test acceptance all

PROJECT_ROOT := $(shell pwd)
SHELL=/bin/bash -o pipefail

VERSION := "v$$(cat buildpack.toml | grep -m 1 version | sed -e 's/version = //g' | xargs)"

all: test build acceptance

test:
	go test -v ./...

acceptance:
	pack create-builder -b acceptance/testdata/builder.toml projectriff/builder
	docker pull cnbs/build
	docker pull cnbs/run
	GO111MODULE=on go test -v -tags=acceptance ./acceptance

build:
	./ci/package.sh $(PROJECT_ROOT) $(VERSION)

clean:
	@rm -fR bin/
	@rm -fR dependency-cache/
	@rm -f java-function-buildpack-$(VERSION).tgz