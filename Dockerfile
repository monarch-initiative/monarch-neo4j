FROM us-central1-docker.pkg.dev/monarch-initiative/monarch-api/monarch-neo4j:4.4
WORKDIR /var/lib/neo4j

ARG MONARCH_KG_RELEASE
#This line forces an arg to be provided.
RUN test -n "$MONARCH_KG_RELEASE"

COPY neo4j.cert /var/lib/neo4j/certificates/https/neo4j.cert
COPY neo4j.key /var/lib/neo4j/certificates/https/neo4j.key

COPY neo4j.cert /var/lib/neo4j/certificates/bolt/neo4j.cert
COPY neo4j.key /var/lib/neo4j/certificates/bolt/neo4j.key

COPY neo4j.conf /var/lib/neo4j/conf/neo4j.conf

#COPY monarch-stack-v3/stack /stack

RUN apt-get update
RUN apt-get install build-essential -y

#RUN mkdir -p /stack/data/dumps

#RUN the Makefile located in the monarch-stack-v3/stack directory.
#WORKDIR /stack
ENV NEO4J_ARCHIVE_URL=https://data.monarchinitiative.org/monarch-kg/${MONARCH_KG_RELEASE}/monarch-kg.neo4j.dump
#RUN make setup_neo4j
RUN ["mkdir", "-p", "/dumps"]
RUN curl -L -o /dumps/monarch-kg.neo4j.dump $NEO4J_ARCHIVE_URL
#RUN ln -s /stack/data/dumps /dumps 
#ENV DO_LOAD=1
#HTTP
EXPOSE 7474
#HTTPS
EXPOSE 7473
#BOLT
EXPOSE 7687 
# sudo docker run -p 80:7474 -p 7687:7687 -p 443:7473 

#CMD ["/bin/bash"]
#MEDUKHA
#/scripts/load_and_boot_neo4j.sh monarch-kg.neo4j.dump
RUN ["neo4j-admin", "load", "--force", "--from=/dumps/monarch-kg.neo4j.dump"]

#RUN ["chown", "-R", "neo4j", "/data"]

#tini -s -g -- /startup/docker-entrypoint.sh neo4j start
