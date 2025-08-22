#!/bin/bash

set -e

export SCRIPTPATH=$(realpath $(dirname ${BASH_SOURCE[0]}))
export VERSION=latest
export SPRING_PETCLINIC_VERSION=${SPRING_PETCLINIC_VERSION:-3.2.0}
export PROMETHEUS_VERSION=v2.42.0
export SPRING_PETCLINIC_MICROSERVICES_CONFIG_BRANCH=${SPRING_PETCLINIC_MICROSERVICES_CONFIG_BRANCH:-7126666fccacb248e6725f7ad8537eee3b9cd805}

EASEAGENTDIR=${SCRIPTPATH}/easeagent/downloaded
EASEAGENTFILE=${EASEAGENTDIR}/easeagent-${VERSION}.jar
EASEAGENT_INUSE=${EASEAGENTDIR}/easeagent.jar

export EASEAGENT_CONFIG_FILE=${EASEAGENT_CONFIG_FILE:-agent_demo_${SPRING_PETCLINIC_VERSION}.properties}
export PROMETHEUS_CONFIG_FILE=${PROMETHEUS_CONFIG_FILE:-prometheus.yaml}

COMPOSER=${COMPOSER:-docker-compose}

DOCKERCOMPOSEFILE=${SCRIPTPATH}/${COMPOSER}.yml
> ${DOCKERCOMPOSEFILE}

function generate_specs() {
  envsubst < ${SCRIPTPATH}/templ/${COMPOSER}-${SPRING_PETCLINIC_VERSION}.yml.templ > ${DOCKERCOMPOSEFILE}
}

function init_spring_configs() {
  old_dir=$(pwd)
  cd ${SCRIPTPATH}/spring-petclinic-microservices-config
  git checkout $SPRING_PETCLINIC_MICROSERVICES_CONFIG_BRANCH
  cd $old_dir
}


EASEAGENT=${EASEAGENT-true}

function prepare() {
  mkdir -p ${EASEAGENTDIR}

  if [ "$EASEAGENT" == "true" ]; then
    if [ ! -f ${EASEAGENTFILE} ]; then
      echo "easeagent-${VERSION}.jar file can't be found. Downloading from github release page..."
      if [ "$VERSION" == "latest" ]; then
          curl -sLk https://github.com/megaease/easeagent/releases/latest/download/easeagent.jar -o ${EASEAGENTFILE}
      else
          curl -sLk https://github.com/megaease/easeagent/releases/download/${VERSION}/easeagent.jar -o ${EASEAGENTFILE}
      fi
      echo "The file was downloaded succeed"
    fi
    export JAVA_AGENT_CONFIG="-javaagent:/easeagent-volume/downloaded/easeagent.jar"
    cp -f ${EASEAGENTFILE} ${EASEAGENT_INUSE}
    echo "with agent:${DOCKERCOMPOSEFILE}"
  else
      echo "without agent:${DOCKERCOMPOSEFILE}"
      export JAVA_AGENT_CONFIG="-Deaseagent.enable=false"
  fi
}


function start() {
  init_spring_configs
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

  "generate")
    prepare
    generate_specs
    ;;

  *)
    echo "usage: ${BASH_SOURCE[0]} <start/stop/generate>"
    exit 1 
    ;;
esac
