#!/bin/bash

# Stop on first error (optional but recommended)
set -e

# Run cleanup script
./cleanup.sh

flex="lib/jflex-full-1.9.1.jar"
cup="lib/java-cup-11b.jar"
libs=".:lib/java-cup-11b.jar:lib/java-cup-11b-runtime.jar:lib/jflex-1.8.2.jar"

java -jar "$flex" calc.flex
java -jar "$cup" -parser parser -symbols sym calc.cup
javac -cp "$libs" *.java
java -cp "$libs" Main