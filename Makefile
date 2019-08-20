.PHONY: clean build test acceptance all
GO_SOURCES = $(shell find . -type f -name '*.go')

PROJECT_ROOT := $(shell pwd)
SHELL=/bin/bash -o pipefail

VERSION := "v$$(cat buildpack.toml | grep -m 1 version | sed -e 's/version = //g' | xargs)"

all: test build acceptance

build: artifactory/io/projectriff/java/io.projectriff.java

test:
	go test -v ./...

acceptance:
	pack create-builder -b acceptance/testdata/builder.toml projectriff/builder
	docker pull cnbs/build
	docker pull cnbs/run
	GO111MODULE=on go test -v -tags=acceptance ./acceptance

artifactory/io/projectriff/java/io.projectriff.java: buildpack.toml $(GO_SOURCES)
	rm -fR $@ 							&& \
	./ci/package.sh						&& \
	mkdir $@/latest 					&& \
	tar -C $@/latest -xzf $@/*/*.tgz

package: clean build
	@tar cvzf java-function-buildpack-$(VERSION).tgz bin/ dependency-cache/ buildpack.toml README.md LICENSE NOTICE


clean:
	@rm -fR artifactory/
	@rm -fR dependency-cache/
	@rm -f node-function-buildpack-$(VERSION).tgz