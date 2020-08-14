# just demo
# author: lilzh
# TODO: java, db

FROM 10.8.0.16:5000/demo-java:0.0.1

MAINTAINER from lilzh.com by lilzhang90s (lilzhang90s@163.com)

# TODO: pull code, mvn clean package, run java

RUN \
  mkdir -p /biz && \
  cd /biz && \
  git clone https://github.com/LilZhang/sampan-java-parent.git && \
  cd sampan-java-parent/test/boot-demo && \
  mvn clean package && \
  cd target && \

EXPOSE 8089

CMD ["java", "-jar", "-Xms1024m", "-Xmx1024m", "boot-demo-0.0.1-SNAPSHOT.jar"]