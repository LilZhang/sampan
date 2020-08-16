#!/bin/sh
# author:lilzhang90s

echo "10.8.0.14    nexus.lilzh.com" >> /etc/hosts

mkdir -p /biz

cd /biz

git clone https://github.com/LilZhang/sampan-java-parent.git

cd sampan-java-parent/test/boot-demo

mvn clean package

cd target

java -jar -Xms1024m -Xmx1024m boot-demo-0.0.1-SNAPSHOT.jar