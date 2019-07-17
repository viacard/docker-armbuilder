#!/bin/bash

docker images --format '{{.Repository}}:{{.Tag}}' | grep '^armbuilder*' > /dev/null

if [[ "$?" == "0" ]]; then
  docker rmi -f $(docker images --format '{{.Repository}}:{{.Tag}}' | grep '^armbuilder*')
fi

docker image prune -f
