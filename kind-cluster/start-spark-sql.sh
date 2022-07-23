#!/usr/bin/env bash

if [ -z "${SPARK_HOME}" ]; then
  export SPARK_HOME="$(cd "`dirname "$0"`"/..; pwd)"
fi

args=("$@")

if [ -n "$CASSANDRA_USERNAME" ] && [ -n "$CASSANDRA_PASSWORD" ]
then
    args+=("--conf" "spark.cassandra.auth.username=$CASSANDRA_USERNAME")
    args+=("--conf" "spark.cassandra.auth.password=$CASSANDRA_PASSWORD")
fi

"${SPARK_HOME}/bin"/spark-submit "${args[@]}"
