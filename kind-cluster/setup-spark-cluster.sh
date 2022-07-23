#!/usr/bin/env bash

kubectl apply -f ./ingress-nginx.yaml

kubectl apply -f ./spark-rabc.yaml

kubectl apply -f ./spark-sql-svc.yaml

kubectl apply -f ./spark-sql-sts.yaml

kubectl apply -f ./spark-sql-ingress.yaml
