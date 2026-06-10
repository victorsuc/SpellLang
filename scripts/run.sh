#!/bin/bash

set -e

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

"$ROOT/scripts/cleanup.sh"

flex="lib/jflex-full-1.9.1.jar"
cup="lib/java-cup-11b.jar"
libs="build:lib/java-cup-11b.jar:lib/java-cup-11b-runtime.jar"

build() {
    java -jar "$flex" -d build grammar/spelllang.flex
    java -jar "$cup" -destdir build -parser parser -symbols sym grammar/spelllang.cup
    javac -cp "lib/java-cup-11b.jar:lib/java-cup-11b-runtime.jar" -d build src/*.java build/*.java
}

if [[ "${SPELLLANG_VERBOSE_BUILD:-}" == "1" ]]; then
    build
else
    build > /dev/null 2>&1
fi

if [[ $# -eq 0 ]]; then
    java -cp "$libs" Main examples/input.txt
else
    java -cp "$libs" Main "$@"
fi
