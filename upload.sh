#!/usr/bin/env bash

git remote add github git@github.com:openmeeg/openmeeg.github.io.git
touch build/html/.nojekyll
ghp-import -p build/html -r origin -b master
