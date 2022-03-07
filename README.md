# EaseAgent-Spring-PetClinic

A repository demonstrates how to leverage the EaseAgent to monitor java applications.

- [EaseAgent-Spring-PetClinic](#easeagent-spring-petclinic)
  - [Purpose](#purpose)
  - [Quick Start](#quick-start)
    - [Prerequisites](#prerequisites)
    - [Start the full stack](#start-the-full-stack)
    - [Stop the full stack](#stop-the-full-stack)
    - [Visualization](#visualization)
  - [Appendix](#appendix)
  
## Purpose
With the [EaseAgent](https://github.com/megaease/easeagent), the metrics of [spring-petclinic applications](https://github.com/spring-petclinic/spring-petclinic-microservices) like throughput, latency, and tracing data could be collected by the Prometheus and tempo. The Grafana allows us to query, visualize, on and understand the metrics that we stored in tempo and Prometheus.

## Quick Start

### Prerequisites

- Make sure you have installed the docker, docker-compose in your environment.
- Make sure your docker version is higher than v19.+.
- Make sure your docker-compose version is higher than v2.+.

### Start the full stack

We leverage the docker-compose to provision the full-stack service, services include:
- spring-petclinic services:
  -  `config-server`, `discovery-server`, `customers-service`, `vets-service`, `visits-service`, `api-gateway`
- `tempo` service is dedicated to collecting the tracing data of the spring-petclinic services.
- `prometheus` service which is dedicated scrapes the metrics of the spring-petclinic services.
- `grafana` service is dedicated to visualizing the metrics and tracing data.
- `loads` service which is dedicated to producing loads to all spring-petclinic services.

> As the spring-petclinic applications have integrated with the [spring-cloud-sleuth](https://github.com/spring-cloud/spring-cloud-sleuth). In order to avoiding interfering with the demonstration, we disable the spring sleuth via `spring.sleuth.enabled=false` and `spring.sleuth.web.enabled=false`.


After you clone the repository, you need to run **git submodule update --init** to update the submodule, which is the configuration of the spring-petclinic.

```shell
git submodule update --init
```


> All images in the stacks are pulled from the docker official registry. You should make sure you can pull images from it. All images are official images. **WE HAVE NOT CHANGE ANYTHING OF THEM**.

Provisioning full-stack command is:
```shell
./spring-petclinic.sh start
```


> The script will download the easeagent v2.1.0 release from the Github release page. You should make sure you can access the internet or Github. If you were hard to access the GitHub or internet, you could build easeagent from scratch and put the build target (easeagent-dep.jar) into the ` easeagent/downloaded/` directory, and rename the file name to `easeagent-v2.1.0.jar`.

### Stop the full stack

After you finished the test, use the following command to destroy the service.

```
./spring-petclinic.sh stop
```
### Visualization

Just follow the step-by-step instructions which will guide you to get a good visualization.

- Step 1. In order to get good visualization, you could wait a moment (about five minutes) before Prometheus collects enough metric data. Open a browser (chrome, firefox or edge is good). Input the `localhost:3000` in the address bar and press enter to open grafana UI.

- Step 2. Click the `search dashboards`, the first icon in the left menu bar. Choose the `spring-petclinic-easeagent` to open the dashboard we prepare for you.
  
- Step 3. You will get a visualization of metrics reported by the EaseAgent. In the dashboard, we classified into two groups. One is the JVM metrics which contain GC executing count, GC executing time, and used memory capacity (Eden, Olden, etc...).  The second is the important metrics of the application, including throughput, latency, in different measures, for example, HTTP request throughput and latency, JDBC SQL throughput, and latency.


![metric](./doc/images/metric.png)

- Step 4. If you want to check the tracing data, you could click the `explore` in the left menu bar. Click the `Search - beta` to switch search mode. Click `search query` button in the right up corner, there is a list containing many tracing. Chose one to click.

![tracing](./doc/images/tracing.png)


## Appendix

The introduction about full metrics collected by the Prometheus is at [here](https://github.com/megaease/easeagent/blob/master/doc/prometheus-metric-schedule.md)


*-- End --*
