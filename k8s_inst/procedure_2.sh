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




echo 'install docker...'
yum install -y yum-utils   device-mapper-persistent-data   lvm2
yum-config-manager     --add-repo     https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce-18.09.9 docker-ce-cli-18.09.9 containerd.io -y

mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["http://hub-mirror.c.163.com"],
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF

systemctl start docker
systemctl enable docker

# systemctl daemon-reload
# systemctl restart docker

docker --version
docker run hello-world



### 安装 k8s

yum install -y kubelet-1.16.4 kubeadm-1.16.4 kubectl-1.16.4
systemctl enable kubelet && systemctl start kubelet


# 手动阿里云下载 docker 镜像
url=registry.cn-hangzhou.aliyuncs.com/loong576
version=v1.16.4
images=(`kubeadm config images list --kubernetes-version=$version|awk -F '/' '{print $2}'`)
for imagename in ${images[@]} ; do
  docker pull $url/$imagename
  docker tag $url/$imagename k8s.gcr.io/$imagename
  docker rmi -f $url/$imagename
done


echo 'build rc.local for openvpn...'
scp root@47.103.11.145:/root/lilzh_ov_${host_array[$idx]}.ovpn /root/
nohup openvpn /root/lilzh_ov_${host_array[$idx]}.ovpn > /root/openvpn.log 2>&1 &
cat >> /etc/rc.local << EOF
nohup openvpn /root/lilzh_ov_${host_array[$idx]}.ovpn > /root/openvpn.log 2>&1 &
EOF

echo 'print rc.local below...'
cat /etc/rc.local



### 安装 keepalived
echo 'install keepalived...'

# maybe useful
# iptables -I INPUT 1 -p vrrp -j ACCEPT


yum -y install keepalived



# master 加载不同配置至 /etc/keepalived/keepalived.conf


mv /etc/keepalived/keepalived.conf /etc/keepalived/keepalived.conf.bak

iptables -I INPUT 1 -p vrrp -j ACCEPT

# 以下限 master
master_num=${master_array[$idx]}
if [ $master_num == "100" ]
then
   # == 100 主主
echo 'config master MASTER...'
cat <<EOF >  /etc/keepalived/keepalived.conf
! Configuration File for keepalived
global_defs {
   router_id ${host_array[$idx]}
}
vrrp_instance VI_1 {
    state MASTER 
    interface ${network_interface}
    virtual_router_id 50
    priority ${master_num}
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass the_pswd
    }
    virtual_ipaddress {
        ${vip_ip}
    }
}
EOF

service keepalived start
systemctl enable keepalived

elif [ $master_num != "0" ]
then
   # != 0 主备
echo 'config master BACKUP...'
cat <<EOF >  /etc/keepalived/keepalived.conf
! Configuration File for keepalived
global_defs {
   router_id ${host_array[$idx]}
}
vrrp_instance VI_1 {
    state BACKUP 
    interface ${network_interface}
    virtual_router_id 50
    priority ${master_num}
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass the_pswd
    }
    virtual_ipaddress {
        ${vip_ip}
    }
}
EOF

service keepalived start
systemctl enable keepalived
fi







### 后续进入初始化阶段
# kubeadm init --config=kubeadm-config.yaml --ignore-preflight-errors=NumCPU
# 1