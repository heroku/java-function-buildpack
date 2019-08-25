# `java-function-buildpack`
[![CircleCI](https://circleci.com/gh/heroku/java-function-buildpack.svg?style=svg)](https://circleci.com/gh/heroku/java-function-buildpack)

The Java Function Buildpack is a Cloud Native Buildpack V3 that provides the riff [Java Function Invoker](https://github.com/projectriff/java-function-invoker) to functions.

This buildpack is designed to work in collaboration with other Heroku buildpacks, which are tailored to
support (and know how to build / run) languages supported by Heroku.

**NOTE**: Java 11 is required for building your Java Function.  To specific Java 11, please add a `system.properties` file 
with `java.runtime.version=11` in the body of the file.  Here's an [example](https://github.com/elbandito/java-func) of a Java Function project.

## In Plain English

When combined with the other buildpacks present in the [Heroku functions builder](https://github.com/heroku/pack-images/blob/master/functions-builder.toml), 
users can use the `pack create-builder` command to build a builder image to build a Java Function image via `pack build`.
- The presence of a `pom.xml` file will result in the compilation and execution of a java function, thanks to the [java invoker](https://github.com/projectriff/java-function-invoker)
- Ambiguity in the detection process will result in a build failure

## Detailed Buildpack Behavior

### Detection Phase

Detection passes if: 

TBD

If detection passes, the buildpack will contribute an `openjdk-jre` key with `launch` metadata to instruct
the `openjdk-buildpack` to provide a JRE. It will also add a `riff-invoker-java` key and `handler`
metadata extracted from the riff metadata.

If several languages are detected simultaneously, the detect phase errors out.
The `override` key in `riff.toml` can be used to bypass detection and force the use of a particular invoker.

### Build Phase

If a java build has been detected

- Contributes the riff Java Invoker to a launch layer, set as the main java entry point with `function.uri = <build-directory>?handler=<handler>` 
set as an environment variable (`FUNCTION_URI`).  This value is automatically set to point to the .jar file located in `/workspace/target`.
At the moment, it is assumed only 1 .jar exits in this directory.

The function behavior is exposed _via_ standard buildpack [process types](https://github.com/buildpack/spec/blob/master/buildpack.md#launch):

- Contributes `web` process
- Contributes `function` process

## How to Build

### Prerequisites
To build the java-function-buildpack you'll need

- Java 11
- Go 1.12+
- to run acceptance tests:
  - a running local docker daemon
  - the [`pack`](https://github.com/buildpack/pack command line tool, [version](https://github.com/buildpack/pack/releases) `>= 0.2.0`.

You can build the buildpack by running

```bash
make build
```

This will package (with pre-downloaded cache layers) the buildpack in the root directory. That can be used as a `uri` in a `functions-builder.toml`
file of a builder (see https://github.com/heroku/pack-images)

## License

This buildpack is released under version 2.0 of the [Apache License](https://www.apache.org/licenses/LICENSE-2.0).
