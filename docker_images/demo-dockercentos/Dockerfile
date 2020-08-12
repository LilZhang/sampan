# just demo
# author: lilzh
# TODO: ssh,
# TODO: java, db, 

# centos:centos7.5.1804
FROM centos:centos7.5.1804

MAINTAINER from lilzh.com by lilzhang90s (lilzhang90s@163.com)

RUN \
  mkdir -p /sampan/dockercentos && \
  echo 1 > /sampan/dockercentos/1.txt

# -> 86
EXPOSE 22

CMD ["tail", "-f", "/sampan/dockercentos/1.txt"]