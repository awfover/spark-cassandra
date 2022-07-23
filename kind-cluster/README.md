# Deploy Local Spark Cassandra Cluster

## Setup Kind Cluster
```shell
./setup-kind-multicluster.sh -o
```

## Setup Cassandra Cluster
```shell
$PASSWORD=123 ./setup-k8ssandra-cluster.sh
```

## Load Sample Data
```shell
./load-cassandra-snapshots.sh
```

## Setup Spark Cluster
```shell
./setup-spark-cluster.sh
```

## Setup Nginx
```shell
./setup-nginx.sh
```