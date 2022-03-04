#!/bin/bash

set -e

export SCRIPTPATH=$(realpath $(dirname ${BASH_SOURCE[0]}))
export VERSION=v2.1.0

EASEAGENTDIR=${SCRIPTPATH}/easeagent/downloaded
EASEAGENTFILE=${EASEAGENTDIR}/easeagent-${VERSION}.jar
DOCKERCOMPOSEFILE=${SCRIPTPATH}/docker-compose.yml
> ${DOCKERCOMPOSEFILE}

function generate_specs() {
  envsubst < ${SCRIPTPATH}/docker-compose.yml.templ > ${DOCKERCOMPOSEFILE}
}


function prepare() {

  mkdir -p ${EASEAGENTDIR}
  if [ ! -f ${EASEAGENTFILE} ]; then
    echo "easeagent-${VERSION}.jar file can't be found. Downloading from github release page..."
    curl -sLk https://github.com/megaease/easeagent/releases/download/${VERSION}/easeagent.jar -o ${EASEAGENTFILE}
    echo "The file was downloaded succeed"
  fi
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
   echo "usage: ${BASH_SOURCE[0]} <start/stop>"
   exit 1
fi

case $1 in

  "start")
    start
    ;;

  "stop")
    stop
    ;;

  *)
    echo "usage: ${BASH_SOURCE[0]} <start/stop>"
    exit 1 
    ;;
esac
