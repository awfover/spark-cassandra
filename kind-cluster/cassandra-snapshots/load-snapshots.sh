#!/bin/sh

function realpath() {
    echo "$(cd "$(dirname "$1")"; pwd -P)/$(basename "$1")"
}

function listdirs() {
    echo $(ls -l $1 | awk '/^d/{print $9}')
}

function source_cql() {
    CQLSH_HOST=$host cqlsh -u $username -p $password -f $1
}

function load_sstable() {
    sstableloader --nodes $host -u $username -pw $password $1
}

while true; do
    case "$1" in
        -h) host="$2"; shift 2 ;;
        -u) username="$2"; shift 2 ;;
        -p) password="$2"; shift 2 ;;
        * ) snapshot_dir=$(realpath "$1"); break ;;
    esac
done


for keyspace in $(listdirs $snapshot_dir); do
    keyspace_dir=$snapshot_dir/$keyspace
    source_cql $keyspace_dir/schema.cql

    for table in $(listdirs $keyspace_dir); do
        table_dir=$keyspace_dir/$table
        source_cql $table_dir/schema.cql
        load_sstable $table_dir
    done
done

