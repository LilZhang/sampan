# just demo
# author: lilzh
# TODO: java, db

FROM alpine:3.12.0

MAINTAINER from lilzh.com by lilzhang90s (lilzhang90s@163.com)

RUN \
  apk update && \
  apk add git=2.26.2-r0 && \
  apk add busybox=1.31.1-r16 && \
  apk add tzdata=2020a-r0 && \
  apk add curl=7.69.1-r0 && \
  cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
  date && \
  echo Asia/Shanghai > /etc/timezone && \
  apk del tzdata && \
  rm -rf /tmp/* /var/cache/apk/* && \

CMD ["/bin/sh"]