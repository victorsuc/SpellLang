#!/bin/bash

set -e

./cleanup.sh

flex="lib/jflex-full-1.9.1.jar"
cup="lib/java-cup-11b.jar"
libs=".:lib/java-cup-11b.jar:lib/java-cup-11b-runtime.jar"

build() {
    java -jar "$flex" spelllang.flex
    java -jar "$cup" -parser parser -symbols sym spelllang.cup
    javac -cp "$libs" *.java
}

if [[ "${SPELLLANG_VERBOSE_BUILD:-}" == "1" ]]; then
    build
else
    build > /dev/null 2>&1
fi

java -cp "$libs" Main "${@:-input.txt}"
