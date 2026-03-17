#!/bin/bash

sudo apt update && sudo apt install netselect-apt -y
rmdir /tmp/aptsources >/dev/null 2>&1
mkdir -p /tmp/sources >/dev/null 2>&1
pushd /tmp/sources
netselect-apt
popd >/dev/null 2>&1
