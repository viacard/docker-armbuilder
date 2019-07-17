#!/bin/bash

BASENAME=viacard/armbuilder
VERSION=v1

if [[ "$1" == "build" ]]; then
  echo Untarring atmel.tar.bz2
  tar -xf atmel.tar.bz2
fi

declare -a samtags=(
    "SAM4E"     "SAMG"     "SAMDA1"   "SAM4S"    "SAMR30"    
    "SAM4C"     "SAMR21"   "SAM3U"    "SAML21"   "SAMB11"  
    "SAM3A"     "SAML22"   "SAM3S"    "SAMD11"   "SAMD10"  
    "SAME70"    "SAMD09"   "SAMD21"   "SAMD20"   "SAME54"    
    "SAME53"    "SAM3N"    "SAML11"   "SAMV71"   "SAMV70" 
    "SAML10"    "SAME51"   "SAM3X"    "SAM4L"    "SAMS70"  
    "SAM4N"     "SAMD51"   "SAMHA1"   "SAMC21"   "SAMC20"
)

for TAG in ${samtags[@]}; do
  TAGLC=$(echo $TAG | tr "A-Z" "a-z")
  if [[ "$1" == "build" ]]; then
    echo " "
    echo ----------------------------------------
    echo NOW BUILDING $BASENAME:$TAGLC-$VERSION
    echo ----------------------------------------
    docker build -f Dockerfile.SAM --build-arg proctype=$TAG --build-arg proctypelc=$TAGLC --tag $BASENAME:$TAGLC-latest --tag $BASENAME:$TAGLC-$VERSION .
  fi
  if [[ "$1" == "build" ]]; then
    echo " "
    echo ----------------------------------------
    echo NOW PUSHING $BASENAME:$TAGLC-$VERSION
    echo ----------------------------------------
    docker push $BASENAME:$TAGLC-latest 
    docker push $BASENAME:$TAGLC-$VERSION
  fi
done

if [[ "$1" == "build" ]]; then
  rm -rf atmel
fi
