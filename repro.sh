#!/bin/bash
set -ex

rm -rf clean
mkdir clean
cd clean/
virtualenv tmpvenv

export CFLAGS='-g'  # enable debug symbols for extensions built by pip
./tmpvenv/bin/pip install --upgrade pip wheel coverage
./tmpvenv/bin/pip wheel coverage
./tmpvenv/bin/python -m coverage.__main__ run -m pip install --no-index --ignore-installed --find-links wheelhouse/ coverage
