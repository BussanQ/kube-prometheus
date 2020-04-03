#!/bin/bash

input() {
read -p "please input nfs server ip:" nfs_serer_ip
read -p "please input nfs server path:" nfs_serer_path

sed -i "s@192.168.227.127@${nfs_serer_ip}@g" deployment.yaml
sed -i "s@/data/nfs-client@${nfs_serer_path}@g" deployment.yaml 
}

nfs_client_provisioner(){
NAMESPACE=monitoring
sed -i'' "s/namespace:.*/namespace: $NAMESPACE/g" rbac.yaml deployment.yaml
kubectl apply  -f rbac.yaml
kubectl apply  -f deployment.yaml
kubectl apply  -f storageclass.yaml
kubectl apply  -f grafana-pvc.yaml
kubectl delete -f grafana-deployment.yaml
kubectl apply  -f grafana-deployment.yaml
kubectl delete -f prometheus-prometheus.yaml
kubectl apply  -f prometheus-prometheus.yaml
}


pvc_check(){
sleep 3
echo -----------------------------------------
kubectl get pvc -n monitoring
}


input
nfs_client_provisioner
pvc_check
