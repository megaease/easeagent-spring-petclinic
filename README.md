# EaseAgent-Spring-PetClinic

A repository demonstrate how to leverage the EaseAgent to monitor java applications.

- [EaseAgent-Spring-PetClinic](#easeagent-spring-petclinic)
  - [Purpose](#purpose)
  - [Quick Start](#quick-start)
    - [Prerequisites](#prerequisites)
    - [Start the full stack](#start-the-full-stack)
    - [Stop the full stack](#stop-the-full-stack)
    - [](#)
  
## Purpose
With the EaseAgent, the metrics of [spring-petclinic applications](https://github.com/spring-petclinic/spring-petclinic-microservices) like throughput, latency, and tracing data could be collected prometheus and tempo. The Grafana allows us to query, visualize, on and understand our metrics that we stored in tempo and prometheus.

## Quick Start

### Prerequisites

- Make sure you have installed the docker, docker-compose in you environment.
- Make sure your docker version is higher than v19.+
- Make sure your docker-compose version is higher than v2.+

### Start the full stack

We leverage the docker-compose to provision the full stack service, services include:
- spring-petclinic services:
  -  `config-server`, `discovery-server`, `customers-service`, `vets-service`, `visits-service`, `api-gateway`
- `tempo` service which is dedicated to collecting the tracing data
- `prometheus` service which is dedicated scrape the metrics of the spring-petclinic services
- `grafana` service which is dedicated to visualize the metrics and tracing data.
- `loads` service which is dedicated to produce loads to all spring-petclinic services


> All images in the stacks are pulled from the docker official registry. You should make sure you can pull images from it. All images are official image. **WE HAVE NOT CHANGE ANY THING OF THEM**

Provisioning full stack command is:
```
./spring-petclinic.sh start
```

> The script will download the easeagent v2.0.2 release from the github release page. You should make sure you can access the internet or github. If you hard to access the github or internet, you could build easeagent from scratch, and put build target (easeagent-dep.jar) into the ` easeagent/downloaded/` directory, and rename the file name to `easeagent-v2.0.2.jar`

### Stop the full stack

After you finished test, using following command to destroy service

```
./spring-petclinic.sh stop
```
### 
