#!/bin/bash

set -e

export SCRIPTPATH=$(realpath $(dirname ${BASH_SOURCE[0]}))
export VERSION=latest

EASEAGENTDIR=${SCRIPTPATH}/easeagent/downloaded
EASEAGENTFILE=${EASEAGENTDIR}/easeagent-${VERSION}.jar
EASEAGENT_INUSE=${EASEAGENTDIR}/easeagent.jar

export JMX_AGENT_FILE=${EASEAGENTDIR}/benchmark/jmx_prometheus_javaagent-0.16.2-SNAPSHOT.jar
export JMX_AGENT_CONFIG=${EASEAGENTDIR}/benchmark/jmx_prometheus_config.yml

export EASEAGENT_CONFIG_FILE=${EASEAGENT_CONFIG_FILE:-agent_benchmark.properties}
export PROMETHEUS_CONFIG_FILE=${PROMETHEUS_CONFIG_FILE:-prometheus_benchmark.yaml}

COMPOSER=${COMPOSER:-benchmark-swarm-composer}

DOCKERCOMPOSEFILE=${SCRIPTPATH}/${COMPOSER}.yml
> ${DOCKERCOMPOSEFILE}

function generate_specs() {
  envsubst < ${SCRIPTPATH}/templ/${COMPOSER}.yml.templ > ${DOCKERCOMPOSEFILE}
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
  prepare
  generate_specs
  #docker stack deploy --compose-file ${DOCKERCOMPOSEFILE} petclinc
  docker-compose -f ${DOCKERCOMPOSEFILE} up -d
  echo "The stack was provisioned successfully."
}

function stop() {
  generate_specs
  docker-compose -f ${DOCKERCOMPOSEFILE} down
  #docker stack rm petclinc
}


if [ $# -ne 1 ];then
    echo "usage: ${BASH_SOURCE[0]} <start [compoment(config/gateway/modules)]/stop [compoment(config/gateway/modules)>"
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
