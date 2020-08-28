#!/bin/bash
host_array=("c7n1" "c7n2" "c7n3" "c7n4" "c7n5" "c7n6" "c7n7" "c7n8" "c7n9" "c7n10" "c7n11" "c7n12" "c7n13")
master_array=("100" "0" "0" "0" "90" "0" "0" "0" "0" "0" "0" "0" "80")
ip_array=("10.8.0.11" "10.8.0.12" "10.8.0.13" "10.8.0.14" "10.8.0.15" "10.8.0.16" "10.8.0.17" "10.8.0.18" "10.8.0.19" "10.8.0.20" "10.8.0.21" "10.8.0.22" "10.8.0.23")

vip_host="cvip"
vip_ip="10.8.0.88"
network_interface="tap0"

arg1=$1
echo $arg1
idx=0
echo $idx
for (( i = 0 ; i < ${#host_array[@]} ; i++ )) do

	if [ $arg1 == ${host_array[$i]} ]
	then
	   break
	fi
	let "idx++"
done
echo "idx: ${idx}"


# echo 'update ifcfg-enp0s3...'
# sed -i 's/BOOTPROTO="none"/BOOTPROTO="static"/g' /etc/sysconfig/network-scripts/ifcfg-enp0s3
# sed -i 's/ONBOOT="no"/ONBOOT="yes"/g' /etc/sysconfig/network-scripts/ifcfg-enp0s3
# sed -i 's/BOOTPROTO=none/BOOTPROTO=static/g' /etc/sysconfig/network-scripts/ifcfg-enp0s3
# sed -i 's/ONBOOT=no/ONBOOT=yes/g' /etc/sysconfig/network-scripts/ifcfg-enp0s3

# echo 'update ifcfg-enp0s8...'
# sed -i 's/BOOTPROTO="none"/BOOTPROTO="static"/g' /etc/sysconfig/network-scripts/ifcfg-enp0s8
# sed -i 's/ONBOOT="no"/ONBOOT="yes"/g' /etc/sysconfig/network-scripts/ifcfg-enp0s8
# sed -i 's/BOOTPROTO=none/BOOTPROTO=static/g' /etc/sysconfig/network-scripts/ifcfg-enp0s8
# sed -i 's/ONBOOT=no/ONBOOT=yes/g' /etc/sysconfig/network-scripts/ifcfg-enp0s8


# service network restart


echo 'update yum repo to aliyun...'
yum -y install wget
yum install epel-release -y

cp /etc/yum/pluginconf.d/fastestmirror.conf /etc/yum/pluginconf.d/fastestmirror.conf.bak
sed -i 's/enabled=1/enabled=0/g' /etc/yum/pluginconf.d/fastestmirror.conf

cp /etc/yum.conf /etc/yum.conf.bak
sed -i 's/plugins=1/plugins=0/g' /etc/yum.conf

cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo

cp /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.bak
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo

echo 'update yum repo to kubernetes...'
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

yum clean all
yum -y makecache

echo 'install openvpn, bzip2 & kernel...'
yum install openvpn -y
yum -y install bzip2.x86_64
yum update kernel -y
yum install kernel-headers kernel-devel gcc make -y

echo 'disable selinux...'
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

echo 'disable firewalld...'
systemctl stop firewalld.service
systemctl disable firewalld.service
firewall-cmd --state

echo 'swap off...'
swapoff -a
sed -i.bak '/swap/s/^/#/' /etc/fstab


echo 'build rc.local for br_netfilter...'
modprobe br_netfilter
cat >> /etc/rc.local << EOF
modprobe br_netfilter
EOF

chmod +x /etc/rc.local


echo 'init /etc/hosts...'
for (( i = 0 ; i < ${#host_array[@]} ; i++ )) do
	echo "${ip_array[$i]}    ${host_array[$i]}" >> /etc/hosts
done
echo "${vip_ip}    ${vip_host}" >> /etc/hosts

echo 'config iptables...'
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sysctl -p /etc/sysctl.d/k8s.conf

echo 'check mac address'
cat /sys/class/net/enp0s8/address
echo 'check product uuid'
cat /sys/class/dmi/id/product_uuid


# key另抽脚本

# 1. 生成

# ssh-keygen -t rsa


# 2. 分发

# ssh-copy-id -i /root/.ssh/id_rsa.pub root@10.8.0.11

# ssh-copy-id -i /root/.ssh/id_rsa.pub root@10.8.0.12

# ssh-copy-id -i /root/.ssh/id_rsa.pub root@10.8.0.13

# ssh-copy-id -i /root/.ssh/id_rsa.pub root@10.8.0.14


# 生成脚本

# 2. cert build

# 3. cert get


echo 'please reboot'