#!/bin/bash

set -e

export SCRIPTPATH=$(realpath $(dirname ${BASH_SOURCE[0]}))
export VERSION=latest

EASEAGENTDIR=${SCRIPTPATH}/easeagent/downloaded
EASEAGENTFILE=${EASEAGENTDIR}/easeagent-${VERSION}.jar
EASEAGENT_INUSE=${EASEAGENTDIR}/easeagent.jar

DOCKERCOMPOSEFILE=${SCRIPTPATH}/docker-compose.yml
> ${DOCKERCOMPOSEFILE}

function generate_specs() {
  envsubst < ${SCRIPTPATH}/docker-compose.yml.templ > ${DOCKERCOMPOSEFILE}
}


function prepare() {
  mkdir -p ${EASEAGENTDIR}

  if [ ! -f ${EASEAGENTFILE} ]; then
    echo "easeagent-${VERSION}.jar file can't be found. Downloading from github release page..."
    if [ "$VERSION" == "latest" ]; then
        curl -sLk https://github.com/megaease/easeagent/releases/latest/download/easeagent.jar -o ${EASEAGENTFILE}
    else
        curl -sLk https://github.com/megaease/easeagent/releases/download/${VERSION}/easeagent.jar -o ${EASEAGENTFILE}
    fi
    echo "The file was downloaded succeed"
  fi
  cp -f ${EASEAGENTFILE} ${EASEAGENT_INUSE}
}


function start() {
  prepare
  generate_specs
  docker-compose -f ${DOCKERCOMPOSEFILE} up -d
  echo "The stack was provisioned successfully."
}

function stop() {
  generate_specs
  docker-compose -f ${DOCKERCOMPOSEFILE} down
}


if [ $# -ne 1 ];then
   echo "usage: ${BASH_SOURCE[0]} <start/stop/generate>"
   exit 1
fi

case $1 in

  "start")
    start
    ;;

  "stop")
    stop
    ;;

  "generate ")
    generate_specs
    ;;

  *)
    echo "usage: ${BASH_SOURCE[0]} <start/stop/generate>"
    exit 1 
    ;;
esac
