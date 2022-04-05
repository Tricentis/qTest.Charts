# Helm Repository for qTest Manager and qTest Applications
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Chart Publish](https://github.com/Tricentis/qTest.Charts/actions/workflows/release.yaml/badge.svg?branch=main)](https://github.com/Tricentis/qTest.Charts/actions/workflows/release.yaml)

[Tricentis qTest](https://www.tricentis.com/products/unified-test-management-qtest/) is a centralized test management platform to help unify, manage, and rapidly scale testing across the enterprise, so teams can collaborate to ship faster with less risk.

## Introduction
This repository includes the following charts:
* qTest Manager
* qTest Scenario
* qTest Launch
* qTest Session
* qTest Parameters
* qTest Pulse
* qTest Insights

## Prerequisites
* Helm 3
* Kubernetes 1.18+
* PV provisioner support in the underlying infrastructure

## Authentication
qTest uses private Docker images and requires authentication via Docker.

```bash
docker login
```
When prompted, enter your Docker ID and access token.  The login process creates or updates a `config.json` file that holds an authorization token, typically located under `$HOME/.docker/config.json`.

Next, create a corresponding Kubernetes secret named `regcred`.  This can be created from you existing credentials:

```bash
kubectl create secret generic regcred \
    --from-file=.dockerconfigjson=<path/to/.docker/config.json> \
    --type=kubernetes.io/dockerconfigjson
```
If you do not wish to use the Docker `config.json` file, the secret can also be created directly from the command line:

```bash
kubectl create secret docker-registry regcred --docker-server=<your-registry-server> --docker-username=<your-name> --docker-password=<your-pword> --docker-email=<your-email>
```
where:
* `<your-registry-server>` is your Private Docker Registry FQDN. Use https://index.docker.io/v1/ for DockerHub.
* `<your-name>` is your Docker username.
* `<your-pword>` is your Docker access token.
* `<your-email>` is your Docker email.

## Installation
Add the qTest Helm repo:
```bash
helm repo add qtest https://tricentis.github.io/qTest.Charts
helm repo update
```
Install the qTest Manager chart with the release name `qtest-manager` in `qtest` namespace:
```bash
helm install qtest-manager qtest/qtest-mgr -f <values.yaml> -n qtest --create-namespace
```
Note that qTest Manager chart should be the __first__ chart to be installed.
All other qTest charts may be installed subsequently in the similar manner.  For example, to install qTest Parameters with the release name `qtest-parameters`:
```bash
helm install qtest-parameters qtest/qtest-parameters -n qtest
```
## Uninstallation
Removal is the reverse of installation. Start removal of the apps first and then Manager.  Example:
```bash
helm uninstall qtest-parameters
helm uninstall qtest-manager
```
## Configurations
The following table lists the configurable parameters for qTest Manager and its applications.

## HPA Autoscaling
Autoscaling are define in values.yaml and enabled by default. To turn off HPA autoscaling,  `autoscaling.enabled` must be set to `false`.
The metrics.k8s.io API is usually provided by an add on named Metrics Server, which needs to be launched separately.
```
autoscaling:
  enabled: true
  minReplicas:
    ui: 1
    api: 1
    notification: 1
    poller: 1
    default: 1
  maxReplicas:
    ui: 3
    api: 3
    notification: 3
    poller: 1
  targetCPUUtilizationPercentage: 70
  targetMemoryUtilizationPercentage: 70
```
The default values would create an horizontal pod autoscaler in Kubernetes which is configured to:
- create at least 1 pods for the component
- scale the component up to a maximum of 3 pods
- observe the CPU usage of all replicas and try to scale between 1 and 3 replicas
- observe the memory usage of all replicas and try to scale between 1 and 3 replicas

### Ingress Controller
qTest relies an IngressController to route ingress traffic into the cluster. We recommend SSL offloading/termination be done at the IngressController. Specific TLS setup instructions depend on the IngressController you have.

qTest includes a sample NginX IngressController YAML file to demonstrate how qTest services may be exposed via an IngressController.  Additional TLS configuration for the NginX IngressController can be found [here](https://kubernetes.github.io/ingress-nginx/user-guide/tls/).

### qTest Manager

At a minimum, the `postgres` and `elasticSearch` parameters should be provided to match your environment.

| Parameter                   | Description                                          | Default |
| --------------------------- | ---------------------------------------------------- | ------- |
| `client.jdbc.postgresUrl` | PSQL database URL | `jdbc:postgresql://host.docker.internal/qtest` |
| `client.jdbc.postgresUserName` | PSQL username | `postgres` |
| `client.jdbc.postgresPassword` | PSQL password | `cG9zdGdyZXM=` (`postgres`, base64-encoded) |
| `elasticSearch.host` | Elasticsearch host | `host.docker.internal` |
| `elasticSearch.port` | Elasticsearch port | `9200` |
| `elasticSearch.scheme` | Elasticsearch port | `http` |
| `persistence.enabled` | Is PersistentVolume enabled? | `true` |
| `persistence.existingClaim` | Existing PersistentVolumeClaim | "" |
| `persistence.storageClass` | Existing StorageClass | "" |
| `persistence.accessMode` | Storage Access Mode | `ReadWriteOnce` |
| `persistence.size` | Storage size | `10Gi` |
| `s3.accessKey` | S3 access key | "" |
| `s3.secretKey` | S3 secret key | "" |
| `s3.region` | S3 region | "" |
| `s3.bucketName` | S3 bucket name | "" |
| `s3.folder` | S3 folder | "" |
| `service.port` | Port on service for other pods to talk to | `8080` |
| `service.targetPort` | Port on container to serve traffic | `8080` |
| `ingress.enabled` | Is Ingress enabled? | `true` |
| `ingress.class` | Name of IngressClass | "" |
| `ingress.host` | qTest Manager hostname | `nephele.qtest.local` |
| `ingress.tls` | Configuration for TLS on the Ingress | "" |
| `testconductor.environment.singleInstance` | Runs in qTest Manager in a single pod | `true` |
| `autoscaling.enabled` | Minimum replicas | `true` |
| `autoscaling.minReplicas.ui` | Minimum replicas | `1` |
| `autoscaling.maxReplicas.ui` | Maximum replicas | `3` |
| `autoscaling.minReplicas.api` | Minimum replicas | `1` |
| `autoscaling.maxReplicas.api` | Maximum replicas | `3` |
| `autoscaling.minReplicas.notification` | Minimum replicas | `1` |
| `autoscaling.maxReplicas.notification` | Maximum replicas | `1` |
| `autoscaling.minReplicas.poller` | Minimum replicas | `1` |
| `autoscaling.maxReplicas.poller` | Maximum replicas | `1` |
| `limitRange.enabled` | Set resource limits? | `true` |
| `limitRange.limits.max.cpu` | Max CPU | `2` |
| `limitRange.limits.max.memory` | Max memory | `16Gi` |
| `limitRange.limits.default.cpu` | Default CPU | `2` |
| `limitRange.limits.default.memory` | Default memory | `16Gi` |
| `limitRange.limits.defaultRequest.cpu` | Requested CPU | `2` |
| `limitRange.limits.defaultRequest.memory` | Requested memory | `4Gi` |

For file persistence, only **one** of the following options is needed:
- _AWS S3_. File attachments are stored into the specified S3 bucket/folder.
- _StorageClass_. StorageClass used to carve out a PersistentVolumeClaim with the specified size and access mode. If empty, the default StorageClass will be used.
- _existingClaim_. If specified, the PersistentVolumeClaim will be used as file persistence for qTest.

## Uninstalling the qTest Manager Chart

To uninstall the qTest Manager chart with the release name `qtestmanager`:
```bash
$ helm uninstall qtestmanager
```
