FROM neo4j:4.4

# this image will be deployed as part of the monarch-stack-v3
# (https://github.com/monarch-initiative/monarch-stack-v3)

# to faciliate deployment, we're copying in configuration and other support
# scripts into the image rather than having to copy them to the neo4j host at
# runtime.

# adds curl to the image, as we need it for performing health checks
RUN apt-get update && apt-get install -y curl

COPY ./scripts /scripts
COPY ./neo4j/conf /var/lib/neo4j/conf
