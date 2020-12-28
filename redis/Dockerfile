
# redis6.0 官方link: https://github.com/docker-library/redis/blob/master/6.0/alpine/Dockerfile
# Base images 基础镜像+阿里源
FROM alpine:3.12
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
	&& apk update

#MAINTAINER 维护者信息
MAINTAINER cffycls@foxmail.com

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN addgroup -S redis && adduser -S -G redis redis

RUN apk add --no-cache \
		'su-exec>=0.2' \
		tzdata

ENV REDIS_VERSION 6.0.9
ENV REDIS_DEPS 'coreutils gcc linux-headers make musl-dev'

COPY redis-$REDIS_VERSION.tar.gz /tmp/redis.tar.gz
RUN set -ex; \
	\
    apk update \
	&& apk add $REDIS_DEPS \
	\
	&& cd /tmp && mkdir -p /usr/src/redis \
    # 下载过慢
	# wget -O redis.tar.gz "$REDIS_DOWNLOAD_URL"; \
	&& tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1 \
	&& rm redis.tar.gz \
	&& make -C /usr/src/redis -j "$(nproc)" \
	&& make -C /usr/src/redis install \
        && mv /usr/src/redis/src/redis-trib.rb /bin && chmod +x /bin/redis-trib.rb \
	&& rm -r /usr/src/redis \
	&& apk del $REDIS_DEPS \
    && mkdir /data && mkdir /sentinel \
	\
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
    && redis-cli --version; \
	redis-server --version

EXPOSE 6379
EXPOSE 16379
CMD ["redis-server","/etc/redis/redis.conf"]
# docker build -t cffycls/redis .
