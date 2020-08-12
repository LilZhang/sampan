# just demo
# author: lilzh
# TODO: ssh,
# TODO: java, db, 

# centos:centos7.5.1804
FROM centos:centos7.5.1804

MAINTAINER from lilzh.com by lilzhang90s (lilzhang90s@163.com)

RUN \
  yum -y install wget epel-release && \
  cp /etc/yum/pluginconf.d/fastestmirror.conf /etc/yum/pluginconf.d/fastestmirror.conf.bak && \
  sed -i 's/enabled=1/enabled=0/g' /etc/yum/pluginconf.d/fastestmirror.conf && \
  cp /etc/yum.conf /etc/yum.conf.bak && \
  sed -i 's/plugins=1/plugins=0/g' /etc/yum.conf && \
  cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak && \
  wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo && \
  cp /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.bak && \
  wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo && \
  yum clean all && \
  yum -y makecache && \
  yum -y install openssh-server


# -> 86
EXPOSE 22

ENTRYPOINT ["tail", "-f", "/root/anaconda-ks.cfg"]