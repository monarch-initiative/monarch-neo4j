#!/bin/bash

DEFAULT_NEO4J_DATABASE="monarch-kg"

NEO4J_DUMP_FILENAME=${1:-${DEFAULT_NEO4J_DATABASE}.neo4j.dump}
NEO4J_DATABASE=${2:-${DEFAULT_NEO4J_DATABASE}}

[ ! -z ${DO_LOAD} ] && \
    echo "Loading Neo4j dump file '$NEO4J_DUMP_FILENAME' into database '$NEO4J_DATABASE'" && \
    neo4j-admin load --force --from=/dumps/$NEO4J_DUMP_FILENAME

chown -R neo4j /data

tini -s -g -- /startup/docker-entrypoint.sh neo4j start
