#!/bin/bash
swapoff -a
hostnamectl set-hostname 'node-1'
#exec bash
setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

systemctl start firewalld
systemctl enable firewalld

firewall-cmd --permanent --add-port=6443/tcp
firewall-cmd --permanent --add-port=2379-2380/tcp
firewall-cmd --permanent --add-port=10250/tcp
firewall-cmd --permanent --add-port=10251/tcp
firewall-cmd --permanent --add-port=10252/tcp
firewall-cmd --permanent --add-port=10255/tcp
firewall-cmd --permanent --add-port=8001/tcp
firewall-cmd --reload

modprobe br_netfilter

echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
cat /proc/sys/net/bridge/bridge-nf-call-iptables | grep '1'  && echo 'ok: 1' || echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
cat /etc/hosts | grep '172.17.35.101' && echo 'ok' || echo '172.17.35.101 node-1' >> /etc/hosts
cat /etc/hosts | grep '172.17.35.102' && echo 'ok' || echo '172.17.35.102 node-2' >> /etc/hosts
cat /etc/hosts | grep '172.17.35.103' && echo 'ok' || echo '172.17.35.103 node-3' >> /etc/hosts

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
systemctl restart kubelet && systemctl enable kubelet

echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables

kubeadm init --apiserver-advertise-address 172.17.35.101 --pod-network-cidr=10.244.0.0/16

mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

#export kubever=$(kubectl version | base64 | tr -d '\n')
#kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever"

kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml

#kubectl create -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel-rbac.yml

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta4/aio/deploy/recommended.yaml