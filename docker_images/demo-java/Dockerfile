# just demo
# author: lilzh
# TODO: java, db

FROM 10.8.0.16:5000/demo-dockerbase:0.0.1

MAINTAINER from lilzh.com by lilzhang90s (lilzhang90s@163.com)

RUN \
  apk update && \
  apk --no-cache add openjdk8=8.252.09-r0 && \
  apk --no-cache add maven=3.6.3-r0 && \
  sed -i "125i<server>\n<id>releases</id>\n<username>admin</username>\n<password>the_passwd</password>\n</server>\n<server>\n<id>snapshots</id>\n<username>admin</username>\n<password>the_passwd</password>\n</server>" /usr/share/java/maven-3/conf/settings.xml && \
  echo "10.8.0.14    nexus.lilzh.com" >> /etc/hosts && \
  rm -rf /tmp/* /var/cache/apk/*

CMD ["/bin/sh"]