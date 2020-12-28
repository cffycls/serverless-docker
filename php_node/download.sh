#!/bin/bash
#2020.12.25

mkdir -p /tmp/packages && \
  wget -O /tmp/packages/php.tar.xz "https://secure.php.net/get/php-7.4.13.tar.xz/from/this/mirror" && \
  wget -O /tmp/packages/libuuid.tgz "http://nchc.dl.sourceforge.net/project/libuuid/libuuid-1.0.3.tar.gz" && \
  # wget -O /tmp/packages/imagemagick.tgz "https://www.imagemagick.org/download/ImageMagick.tar.gz" && \
  wget -O /tmp/packages/swoole.tar.gz "https://codeload.github.com/swoole/swoole-src/tar.gz/master" && \
  mv /tmp/packages .
