#!/usr/bin/env bash

rm -rf build/
make html
touch build/html/.nojekyll
ghp-import -p build/html -r origin -b master
