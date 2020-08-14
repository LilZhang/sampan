# just demo
# author: lilzh
# TODO: java, db

FROM 10.8.0.16:5000/demo-dockerbase:0.0.1

MAINTAINER from lilzh.com by lilzhang90s (lilzhang90s@163.com)

RUN \
  apk update && \
  apk add openjdk8=8.252.09-r0 && \
  rm -rf /tmp/* /var/cache/apk/*

CMD ["/bin/sh"]