#!/usr/bin/env bash

set -euo pipefail

if [[ -d $PWD/go-module-cache && ! -d ${GOPATH}/pkg/mod ]]; then
  mkdir -p ${GOPATH}/pkg
  ln -s $PWD/go-module-cache ${GOPATH}/pkg/mod
fi

PROJECT_ROOT=$1
VERSION=$2

PACKAGE_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'package')

cd "$(dirname "${BASH_SOURCE[0]}")/.."

GIT_TIMESTAMP=$(TZ=UTC git show --quiet --date='format-local:%Y%m%d%H%M%S' --format="%cd")
GIT_SHA=$(git rev-parse HEAD)

go build -ldflags='-s -w' -o bin/package github.com/heroku/libhkbuildpack/packager
bin/package ${PACKAGE_DIR}

cd ${PACKAGE_DIR}

TARGET="java-function-buildpack-${VERSION}.tgz"

tar czf ${TARGET} *
mv ${TARGET} ${PROJECT_ROOT}
