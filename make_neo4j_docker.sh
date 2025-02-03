RELEASE=$1

sudo docker build --build-arg MONARCH_KG_RELEASE=$RELEASE --no-cache -t monarch-neo4j-image-$RELEASE .

#Make the container from the image
sudo docker container create -p 80:7474 -p 7687:7687 -p 443:7473 --name  monarch-neo4j-container-$RELEASE monarch-neo4j-image-$RELEASE tini -s -g -- /startup/docker-entrypoint.sh neo4j start 

#Remove and kill running containers. (https://stackoverflow.com/a/60254450)
#sudo docker container rm $(sudo docker container ls -aq) -f

#sudo docker container rm $(sudo docker container ls -q -f before=monarch-neo4j-container-$RELEASE) -f
#sudo docker container ls --quiet --filter before=monarch-neo4j-container-$RELEASE
sudo docker container rm $(sudo docker container ls --quiet --filter before=monarch-neo4j-container-$RELEASE) -f

#Start the container 
sudo docker container start monarch-neo4j-container-$RELEASE


sudo docker image prune --all --force
sudo docker builder prune --all --force
sudo docker volume prune --all --force

