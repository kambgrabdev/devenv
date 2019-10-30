# devenv

./recreate.sh

ssh vagrant@127.0.0.1 -p 2222 -i vagrant

sudo su
cd /vagrant/ 
sh/master.sh

save join command

ssh vagrant@worker-1 -i vagrant
sudo su
cd /vagrant/ 
sh/slaves.sh

kubectl proxy --address='0.0.0.0' 2>&1 & 
kubectl apply -f yamls/my-sa.yaml 
kubectl apply -f yamls/cluster-role-bindig.yaml 
kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')

http://127.0.0.1:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/clusterrole?namespace=default