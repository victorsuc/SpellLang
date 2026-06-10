#!/bin/bash

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

rm -f build/parser.java build/sym.java build/scanner.java
find build -type f -name "*.class" -delete 2>/dev/null || true
