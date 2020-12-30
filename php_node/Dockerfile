# php部分直接使用 cffycls/php
# php7.4.13; Feb 7, 2019 link: https://github.com/docker-library/php/tree/master/7.4/alpine3.12/cli
# nodejs 15.5.0 参考官方link: https://github.com/nodejs/docker-node/blob/master/15/alpine3.12/Dockerfile
# Base images 基础镜像+阿里源: php-cli
FROM alpine:3.12

#MAINTAINER 维护者信息
MAINTAINER cffycls@foxmail.com

# dependencies required for running "phpize" 2020.4.10组件更新
ENV PHP_VERSION 7.4.13
ADD packages /tmp/
ENV PHPIZE_DEPS "\
            autoconf \
            dpkg-dev dpkg \
            file \
            g++ \
            gcc \
            libc-dev \
            make \
            pkgconf \
            re2c \
            curl tar xz openssl wget "
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    \
    && echo "use local '/tmp/*' packages..." && ls -l /tmp \
    && apk update \
    && addgroup -g 82 -S www-data \
    && adduser -u 82 -D -S -G www-data www-data \
    && mkdir -p "/usr/local/etc/php/conf.d" && mkdir -p "/var/www/html" \
    && chown www-data:www-data /var/www/html && chmod 777 /var/www/html \
    \
    #安装依赖
    && PHP_DEVS="\
       		argon2-dev \
       		coreutils \
       		curl-dev \
       		libedit-dev \
       		libsodium-dev \
       		libxml2-dev \
       		openssl-dev \
       		sqlite-dev \
       		libjpeg-turbo-dev \
            libxpm-dev \
           	gd-dev \
       		gettext-dev \
       		freetype-dev \
       		libevent-dev \
       		rabbitmq-c-dev \
            pcre2-dev \
            oniguruma \
            oniguruma-dev \
       		" \
## oniguruma: 安装php7.4的过程中，mbstring的正则表达式处理功能对这个包有依赖性
    && apk add --no-cache \
        curl \
        tar \
        xz \
        openssl \
        wget \
		$PHPIZE_DEPS $PHP_DEVS \
    \
    && mkdir -p ~/bulid/php && cd ~/bulid/php \
    && tar -Jxf /tmp/php.tar.xz --strip-components 1 \
	&& ./configure \
        --prefix="/usr/local/php" \
        --with-config-file-path="/usr/local/php/etc" \
        --with-config-file-scan-dir="/usr/local/php/etc/conf.d" \
        \
        --enable-mbstring \
        ## 正则表达式函数中多字节字符的支持
        --enable-mbregex \
        --enable-mysqlnd \
        --with-mysqli \
        --with-pdo-mysql \
        --enable-sysvmsg \
        --enable-ftp \
        ## 操作图像元数据，配合gd
        --enable-exif \
        ## 信号处理的回调
        --enable-pcntl \
        --enable-sockets \
        --enable-sysvsem \
        --enable-xml \
        ## 高精度运算的函数库
        --enable-bcmath \
        --with-openssl \
        --with-curl \
        ## 命令行交互的库
        --with-libedit \
        --with-zlib \
        ## pcre动态编译
        --with-pcre-jit \
        --with-pear \
        --with-libxml \
        ## gd图片库
        --enable-gd \
        --with-jpeg \
        --with-xpm \
        --with-freetype \
        ## 国际化语言扩展
        --with-gettext \
        ## 字符集转换
        --with-iconv \
        \
        --enable-fpm \
        --with-fpm-user=www-data \
        --with-fpm-group=www-data \
        --disable-cgi \
    && make -j "$(nproc)" \
    && find -type f -name '*.a' -delete \
    && make install \
    && rm -rf /tmp/pear ~/.pearrc \
    && cd ../ && rm -rf php \
	\
#======================================================================================================
#测试 -- 需要对话参数，所以自定义安装
    \
	# swoole
    && \
    mkdir -p ~/build/swoole && cd ~/build/swoole && \
    tar zxvf /tmp/swoole.tar.gz --strip-components 1 && \
    /usr/local/php/bin/phpize && \
    ./configure \
        --with-php-config=/usr/local/php/bin/php-config \
		--enable-openssl  \
		--enable-http2  \
		--enable-sockets \
		&& \
    make && make install && \
    cd ../ && rm -rf swoole \
	\
    #uuid 1.0.4 (libuuid-1.0.3)
    && \
    mkdir -p ~/build/libuuid && cd ~/build/libuuid && \
    tar -zxf /tmp/libuuid.tgz --strip-components 1 && \
    ./configure --prefix=/usr && \
    make && make install && \
    cd ../ && rm -rf libuuid \
    \
#======================================================================================================
    \
    && ln -s /usr/local/php/bin/* /usr/local/bin/ \
    && ln -s /usr/local/php/sbin/php-fpm /usr/local/bin \
    && pecl channel-update pecl.php.net \
    && pecl install igbinary amqp apcu protobuf redis uuid inotify event \
    && rm -rf /tmp/* ~/.pearrc ~/build \
    && php -m


ENV NODE_VERSION 15.5.0
ENV BUILD_NODE_DEPS '\
     binutils-gold \
     g++ \
     gcc \
     gnupg \
     libgcc \
     linux-headers \
     make \
     python3'
RUN addgroup -g 1000 node \
    && adduser -u 1000 -G node -s /bin/sh -D node \
    \
    && apk update \
    && apk add --no-cache \
        libstdc++ \
    && echo "Building from source" \
    # backup build
    && apk add --no-cache $BUILD_NODE_DEPS \
    && for key in \
      4ED778F539E3634C779C87C6D7062848A1AB005C \
      94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
      1C050899334244A8AF75E53792EF661D867B9DFA \
      71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
      8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
      C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
      C82FA3AE1CBEDC6BE46B9360C43CEC45C17AB93C \
      DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
      A48C2BEE680E841632CD4E44F07496B3EB3C1762 \
      108F52B48DB57BB0CC439B2997B01419BD92F80A \
      B9E2F5981AA6E0CD28160D9FF13993A75599653C \
    ; do \
      gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
      gpg --batch --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
      gpg --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
    done \
    && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.xz" \
    && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
    && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
    && grep " node-v$NODE_VERSION.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
    && tar -xf "node-v$NODE_VERSION.tar.xz" \
    && cd "node-v$NODE_VERSION" \
    && ./configure \
    && make -j$(getconf _NPROCESSORS_ONLN) V= \
    && make install \
    && cd .. \
    && rm -Rf "node-v$NODE_VERSION" \
    && rm "node-v$NODE_VERSION.tar.xz" \
    && rm -f "node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz" \
    # smoke tests
    && node --version \
    && npm --version

ENV YARN_VERSION 1.22.5
RUN curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
  && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc" \
  && mkdir -p /opt \
  && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
  && rm yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  # smoke test
  && yarn --version

RUN apk del $PHPIZE_DEPS $BUILD_NODE_DEPS
CMD ["php-fpm"]
# CMD ["php", "-a"]
#CMD [ "node" ]
