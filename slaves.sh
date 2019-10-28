#!/bin/bash
swapoff -a
#exec bash
setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

systemctl start firewalld
systemctl enable firewalld

firewall-cmd --permanent --add-port=6783/tcp
firewall-cmd --permanent --add-port=30000-32767/tcp
firewall-cmd --permanent --add-port=10250/tcp
firewall-cmd --permanent --add-port=10255/tcp
firewall-cmd --reload

#modprobe br_netfilter

echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
cat /proc/sys/net/bridge/bridge-nf-call-iptables | grep '1'  && echo 'ok: 1' || echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
cat /etc/hosts | grep '192.168.1.10' && echo 'ok' || echo '192.168.1.10 node-1' >> /etc/hosts
cat /etc/hosts | grep '192.168.1.20' && echo 'ok' || echo '192.168.1.20 node-2' >> /etc/hosts
cat /etc/hosts | grep '192.168.1.30' && echo 'ok' || echo '192.168.1.30 node-3' >> /etc/hosts

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

yum install kubeadm docker -y
systemctl restart docker && systemctl enable docker

#kubeadm init


#mkdir -p $HOME/.kube
#cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
#chown $(id -u):$(id -g) $HOME/.kube/config

#export kubever=$(kubectl version | base64 | tr -d '\n')
#kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever"

#kubeadm join --token xxx