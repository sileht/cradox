#!/bin/bash

set -e
set -x

version="$1"
[ -z "$version"] && version=$(python setup.py --version | sed 's/\.dev.*//')

status=$(git status -sz | grep -v '\.eggs/' | xargs)
[ -z "$status" ] || false
git checkout master
git push 
git tag -s $version -m "Release version ${version}"
git checkout $version
git clean -fdx
python setup.py --version
python setup.py sdist

set +x
echo
echo "release: cradox ${version}"
echo
echo "SHA1sum: "
sha1sum dist/*
echo "MD5sum: "
md5sum dist/*
echo
echo "uploading..."
echo
set -x

read
git push --tags
twine upload -r pypi -s dist/cradox-${version}.tar.gz
git checkout master
