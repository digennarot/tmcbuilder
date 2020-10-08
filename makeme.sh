#!/bin/bash
TMC_VERSION=${1:-7}
PKG_ARCHIVE_URL="https://tomcat.apache.org/download-${TMC_VERSION}0.cgi"
PKG_VERSION=$(curl -s ${PKG_ARCHIVE_URL} | grep "${TMC_VERSION}\.0\.[0-9]\+</a>" | sed -e 's|.*>\(.*\)<.*|\1|g' | tail -1)
make PKG_RELEASE=1 PKG_VERSION="${PKG_VERSION=}" TMC_VERSION="${TMC_VERSION}" -C .
