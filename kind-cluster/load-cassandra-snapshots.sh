#!/usr/bin/env bash


username=$(kubectl -n k8ssandra-operator get secret demo-superuser -o jsonpath="{.data.username}" | base64 --decode)
password=$(kubectl -n k8ssandra-operator get secret demo-superuser -o jsonpath="{.data.password}" | base64 --decode)

kubectl apply -f ./cassandra-dev.yaml

kubectl -n dev wait --for=condition=ready pod cassandra-dev

kubectl -n dev \
    exec -it cassandra-dev \
    -- \
    /bin/bash \
    /shared-data/cassandra-snapshots/load-snapshots.sh \
    -h demo-dc1-service.k8ssandra-operator \
    -u $username \
    -p $password \
    /shared-data/cassandra-snapshots/snapshots/tpcds-1

kubectl -n dev delete pod cassandra-dev