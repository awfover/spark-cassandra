#!/usr/bin/env bash

# install cert manager
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.7.1/cert-manager.yaml

kubectl -n cert-manager wait --for=condition=ready pods --all

if [ -z $PASSWORD ]; then
    PASSWORD="123456"
fi

cat ./demo-superuser.yaml | sed -e "s/{PASSWORD}/$(echo "$PASSWORD" | base64)/g" |  kubectl apply -f -

# install k8ssandra operator
kustomize build ./k8ssandra-operator/deployments/control-plane | kubectl apply --server-side -f -

kubectl -n k8ssandra-operator wait --for=condition=ready pods --all

# install k8ssandra cluster
kubectl -n k8ssandra-operator apply -f ./k8ssandra-cluster.yaml

while ! kubectl -n k8ssandra-operator get pod demo-dc1-default-sts-0; do sleep 1; done

kubectl -n k8ssandra-operator wait --for=condition=ready pods -l cassandra.datastax.com/cluster=demo --timeout=10m