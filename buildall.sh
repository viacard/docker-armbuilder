#!/bin/bash

BASENAME=viacard/armbuilder
VERSION=v1

declare -a samtags=(
    "SAM4E"     "SAMG"     "SAMDA1"   "SAM4S"    "SAMR30"
    "SAM4C"     "SAMR21"   "SAM3U"    "SAML21"   "SAMB11"
    "SAM3A"     "SAML22"   "SAM3S"    "SAMD11"   "SAMD10"
    "SAME70"    "SAMD09"   "SAMD21"   "SAMD20"   "SAME54"
    "SAME53"    "SAM3N"    "SAML11"   "SAMV71"   "SAMV70"
    "SAML10"    "SAME51"   "SAM3X"    "SAM4L"    "SAMS70"
    "SAM4N"     "SAMD51"   "SAMHA1"   "SAMC21"   "SAMC20"
)

if [[ "$1" == "delete" ]]; then
  docker images --format '{{.Repository}}:{{.Tag}}' | grep '^viacard/armbuilder*' > /dev/null
  if [[ "$?" == "0" ]]; then
    docker rmi -f $(docker images --format '{{.Repository}}:{{.Tag}}' | grep '^viacard/armbuilder*')
  fi
  docker image prune -f
  exit 0
fi


if [[ "$1" == "build" ]]; then
  echo Untarring atmel.tar.bz2
  tar -xf atmel.tar.bz2
  for TAG in ${samtags[@]}; do
    TAGLC=$(echo $TAG | tr "A-Z" "a-z")
    echo " "
    echo ----------------------------------------
    echo NOW BUILDING $BASENAME:$TAGLC-$VERSION
    echo ----------------------------------------
    INC2VER=$(ls -1 atmel/${TAG}_DFP)
    docker build -f Dockerfile.SAM --build-arg proctype=$TAG --build-arg proctypelc=$TAGLC --build-arg inc2ver=$INC2VER --tag $BASENAME:$TAGLC-$VERSION .
  done
  rm -rf atmel
  exit 0
fi


if [[ "$1" == "push" ]]; then
  for TAG in ${samtags[@]}; do
    TAGLC=$(echo $TAG | tr "A-Z" "a-z")
    echo " "
    echo ----------------------------------------
    echo NOW PUSHING $BASENAME:$TAGLC-$VERSION
    echo ----------------------------------------
    docker push $BASENAME:$TAGLC-$VERSION
  done
  exit 0
fi


echo Usage\:
echo $0 \<command\>
echo "   build"
echo "   push"
echo "   delete"
