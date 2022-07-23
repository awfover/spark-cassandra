#!/bin/bash

images="
docker.io/datastax/cass-config-builder:1.0.4-ubi7
docker.io/k8ssandra/cass-management-api:4.0.1
docker.io/k8ssandra/system-logger:v1.10.0
docker.io/kindest/kindnetd:v20211122-a2c10462
docker.io/library/busybox:1.34.1
docker.io/library/ubuntu:focal
docker.io/rancher/local-path-provisioner:v0.0.14
k8s.gcr.io/build-image/debian-base:buster-v1.7.2
k8s.gcr.io/coredns/coredns:v1.8.4
k8s.gcr.io/etcd:3.5.0-0
k8s.gcr.io/kube-apiserver:v1.22.7
k8s.gcr.io/kube-controller-manager:v1.22.7
k8s.gcr.io/kube-proxy:v1.22.7
k8s.gcr.io/kube-scheduler:v1.22.7
k8s.gcr.io/pause:3.6
quay.io/jetstack/cert-manager-webhook:v1.7.1
docker.io/k8ssandra/cass-operator:v1.10.0
docker.io/k8ssandra/k8ssandra-operator:v1.0.0
quay.io/jetstack/cert-manager-controller:v1.7.1
quay.io/jetstack/cert-manager-cainjector:v1.7.1
"

for image in $images
do
    docker pull $image
    kind load --name kind-0 docker-image $image
done
