#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
set -a
. ./.env
set +a
if [ -d /opt/homebrew/opt/openjdk@21 ] && [ -z "${JAVA_HOME:-}" ]; then export JAVA_HOME=/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home; fi
cd backend
exec mvn spring-boot:run
