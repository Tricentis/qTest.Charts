# Helm Repository for qTest Manager and qTest Applications
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Chart Publish](https://github.com/Tricentis/qTest.Charts/actions/workflows/release.yaml/badge.svg?branch=main)](https://github.com/Tricentis/qTest.Charts/actions/workflows/release.yaml)

<img src="https://assets-global.website-files.com/5dfb2c5f5b18187014b68b84/5e5765ef5072d028554d9233_qTest_logo.png" width="450" height="134">

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
## (End-to-End) Helm Chart Integrity Verification
To verify the integrity of the qTest Helm Chart for public consumption (**highly advised**, however **OPTIONAL**), the qTest Helm  Charts follow the Helm Provenance Security Packaging Guidelines to 100% guarantee the qTest Helm Chart consumers download and  deploy to their Kubernetes Clusters a 100% integrity (anti-highjacked) version of the Helm Chart. For a full-description and step-for-step guideline on how to issue the verification process see [Helm Provenance](docs/README-qtest-k8s-helm-chart-integrity-verification.md). 

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
| `attachment.folder.path` | qTest attachement folder path | `/mnt/data/qtest/attachments` |
| `blobstorage.type` | qTest Manager attachements folder type | `disk_storage` (Accepted values disk_storage, amazon_s3_access_key) |
| `blobstorage.region` | S3 bucket region | `us-east-1` (Needed when blobstorage.type is amazon_s3_access_key) |
| `blobstorage.sharedBucket` | S3 bucket name | `qtest` (Needed when blobstorage.type is amazon_s3_access_key) |
| `client.jdbc.postgresUrl` | PSQL database URL | `jdbc:postgresql://host.docker.internal/qtest` |
| `client.jdbc.postgresUserName` | PSQL username | `postgres` |
| `client.jdbc.postgresPassword` | PSQL password | `cG9zdGdyZXM=` (`postgres`, base64-encoded) |
| `client.jdbc.sslEnable` | Enable ssl connections | `false` |
| `client.jdbc.postgres.readonly.url` | PSQL readonly database URL | `jdbc:postgresql://host.docker.internal/qtest` |
| `client.jdbc.postgres.readonly.username` | PSQL username | `postgres` |
| `client.jdbc.postgres.readonly.password` | PSQL password | `cG9zdGdyZXM=` (`postgres`, base64-encoded) |
| `client.jdbc.sslMountPath` | Postgresql ssl certificate mount directory  | `\etc\ssl` |
| `client.jdbc.sslPath` | Postgresql ssl connection string | `?ssl=true&sslmode=verify-full&sslrootcert=/etc/ssl/root.crt` (please chnage only cert path) |
| `client.jdbc.cert` | Postgresql client certificate | `` (postgres client certificate, base64-encoded) |
| `cors.allowed.all` | cors allowed | `true` |
| `cors.allowed.domains` | cors allowed domains | `` |
| `elasticSearch.host` | Elasticsearch host | `host.docker.internal` |
| `elasticSearch.port` | Elasticsearch port | `9200` |
| `elasticSearch.scheme` | Elasticsearch port | `http` |
| `license.folder.path` | qTest Manager license folder path | `/mnt/data/qtest/license` |
| `mail.host` | SMTP host name | `smtp.local` |
| `mail.port` | SMTP port number | `465` |
| `mail.username` | SMTP username | `qtest` |
| `mail.password` | SMTP password | `cG9zdGdyZXM=` (`postgres`, base64-encoded) |
| `mail.supportEmailAddress` | qTest Support email address | `supports@tricentis.com` |
| `notification.urlExternal` | Notification URL | `https://nephele.qtest.local` |
| `preUrl` | qTest Manager URL | `http://<sitename>.qtest.local` |
| `preUrlHttps` | qTest Manager URL | `https://<sitename>.qtest.local` |
| `qtest.request.nonce.disabled` | qTest request nonce disabled | `true` |
| `qtest.request.nonce.mode` | qTest request nonce mode | `HighPrecision` |
| `s3.accessKey` | S3 access key | "" |
| `s3.secretKey` | S3 secret key | "" |
| `s3.region` | S3 region | "" |
| `s3.bucketName` | S3 bucket name | "" |
| `s3.folder` | S3 folder | "" |
| `security.csrf.source.trust.pattern` | qTest Manager csrf security pattern | `` |
| `vera.auto.testrun.beta.clients` | SMTP port number | `-1` |
| `autoscaling.enabled` | Minimum replicas | `true` |
| `autoscaling.minReplicas.ui` | Minimum replicas | `1` |
| `autoscaling.maxReplicas.ui` | Maximum replicas | `3` |
| `autoscaling.minReplicas.api` | Minimum replicas | `1` |
| `autoscaling.maxReplicas.api` | Maximum replicas | `3` |
| `autoscaling.minReplicas.notification` | Minimum replicas | `1` |
| `autoscaling.maxReplicas.notification` | Maximum replicas | `1` |
| `autoscaling.minReplicas.poller` | Minimum replicas | `1` |
| `autoscaling.maxReplicas.poller` | Maximum replicas | `1` |
| `ingress.enabled` | Is Ingress enabled? | `false` |
| `ingress.class` | Name of IngressClass | `nginx` |
| `ingress.host` | qTest Manager hostname | `nephele.qtest.local` |
| `ingress.tls.hosts` | Configuration for TLS on the Ingress | `mgr.qtest.local` |
| `limitRange.enabled` | Set resource limits? | `true` |
| `limitRange.limits.max.cpu` | Max CPU | `2` |
| `limitRange.limits.max.memory` | Max memory | `16Gi` |
| `limitRange.limits.default.cpu` | Default CPU | `2` |
| `limitRange.limits.default.memory` | Default memory | `16Gi` |
| `limitRange.limits.defaultRequest.cpu` | Requested CPU | `2` |
| `limitRange.limits.defaultRequest.memory` | Requested memory | `4Gi` |
| `persistence.enabled` | Is PersistentVolume enabled? | `true` |
| `persistence.existingClaim` | Existing PersistentVolumeClaim | "" |
| `persistence.storageClass` | Existing StorageClass | "" |
| `persistence.accessMode` | Storage Access Mode | `ReadWriteOnce` |
| `persistence.size` | Storage size | `10Gi` |
| `service.port` | Port on service for other pods to talk to | `8080` |
| `service.targetPort` | Port on container to serve traffic | `8080` |
| `service.port` | Port on service for other pods to talk to | `8080` |
| `service.targetPort` | Port on container to serve traffic | `8080` |
| `testconductor.environment.singleInstance` | Runs in qTest Manager in a single pod | `true` |
| `serverAppSSLRequired` | Runs pod of qTest Manager on SSL | `false` |
| `server.sslMountPath` | Pod certificate mounting path | `/mnt/secrets/tls` |

## Parameters app configurations to change in parameters-values-kind.yaml

 Parameter                   | Description                                          | Default |
| --------------------------- | ---------------------------------------------------- | ------- |
| `qTestParametersDBName` | PSQL database name of the parameters app | `parameters` |
| `qTestParametersDBUserName` | PSQL username | `postgres` |
| `qTestParametersDBHostName` | PSQL database host name | `host.docker.internal` |
| `qTestParametersDBSSLEnable` | Enable ssl connections | `false` |
| `qTestParametersDBSSLMountPath` | Postgresql ssl certificate mount directory | `\etc\ssl` |
| `qTestParametersDBSSL` | SSL Connection which appends for SSL Connection (only change cert name) | `?ssl=true&sslmode=verify-full&sslrootcert=/etc/ssl/root.crt` |
| `qTestParametersDBRootCRT` | Postgresql client certificate | `` (postgres client certificate, base64-encoded) |
| `serverAppSSLRequired` | Runs pod of Parameters app on SSL | `false` |

## Launch app configurations to change in launch-values-kind.yaml

| Parameter                   | Description                                          | Default |
| --------------------------- | ---------------------------------------------------- | ------- |
| `qTestLaunchDBName` | PSQL database name of the qTest Manager | `qtest` |
| `qTestLaunchDBUserName` | PSQL username | `postgres` |
| `qTestLaunchDBHostName` | PSQL database host name | `host.docker.internal` |
| `qTestLaunchRootURL` | qTest Launch url | `https://launch.qtest.local` |
| `qTestLaunchDBSSLEnable` | Enable ssl connections | `false` |
| `qTestLaunchDBSSLMountPath` | Postgresql ssl certificate mount directory | `\etc\ssl` |
| `qTestLaunchDBSSL` | SSL Connection which appends for SSL Connection (only change cert name) | `?ssl=true&sslmode=verify-full&sslrootcert=/etc/ssl/root.crt` |
| `qTestLaunchDBRootCRT` | Postgresql client certificate | `` (postgres client certificate, base64-encoded) |

## Pulse app configurations to change in pulse-values-kind.yaml

| Parameter                   | Description                                          | Default |
| --------------------------- | ---------------------------------------------------- | ------- |
| `qTestPulseDBName` | PSQL database name of the pulse | `pulse` |
| `qTestPulseDBUserName` | PSQL username | `postgres` |
| `qTestPulseDBHostName` | PSQL database host name | `host.docker.internal` |
| `qTestPulseRootURL` | qTest Pulse url | `https://pulse.qtest.local` |
| `qTestPulseScenarioURL` | qTest Launch url | `https://scenario.qtest.local` |
| `qTestPulseDBSSLEnable` | Enable ssl connections | `false` |
| `qTestPulseDBSSLMountPath` | Postgresql ssl certificate mount directory | `\etc\ssl` |
| `qTestPulseDBSSL` | SSL Connection which appends for SSL Connection (only change cert name) | `?ssl=true&sslmode=verify-full&sslrootcert=/etc/ssl/root.crt` |
| `qTestPulseDBRootCRT` | Postgresql client certificate | `` (postgres client certificate, base64-encoded) |

## Scenario app configurations to change in scenario-values-kind.yaml

| Parameter                   | Description                                          | Default |
| --------------------------- | ---------------------------------------------------- | ------- |
| `qTestScenarioDBName` | PSQL database name of the scenario | `scenario` |
| `qTestScenarioDBUserName` | PSQL username | `postgres` |
| `qTestScenarioDBHostName` | PSQL database host name | `host.docker.internal` |
| `qTestScenarioLocalBaseURL` | qTest Pulse url | `https://scenario.qtest.local` |
| `qTestScenarioQTestURL` | qTest Launch url | `https://nephele.qtest.local` |
| `qTestScenarioDBSSLEnable` | Enable ssl connections | `false` |
| `qTestScenarioDBSSLMountPath` | Postgresql ssl certificate mount directory | `\etc\ssl` |
| `qTestScenarioDBSSL` | SSL Connection which appends for SSL Connection (only change cert name) | `?ssl=true&sslmode=verify-full&sslrootcert=/etc/ssl/root.crt` |
| `qTestScenarioDBRootCRT` | Postgresql client certificate | `` (postgres client certificate, base64-encoded) |

## Session app configurations to change in sessions-values-kind.yaml

| Parameter                   | Description                                          | Default |
| --------------------------- | ---------------------------------------------------- | ------- |
| `qTestSessionDBName` | PSQL database name of the session | `sessions` |
| `qTestSessionDBUserName` | PSQL username | `postgres` |
| `qTestSessionDBHostName` | PSQL database host name | `host.docker.internal` |
| `qTestStorageBucketName` | Amazon S3 bucket name | `aws-session-bucket-name` |
| `qTestSessionClamavURL` | qTest clama url | `https://clam.qtest.local` |
| `qTestSessionStorageType` | Session storage type | `amazon_s3 | disk_storage` |
| `qTestSessionDBSSLEnable` | Enable ssl connections | `false` |
| `qTestSessionDBSSLMountPath` | Postgresql ssl certificate mount directory | `\etc\ssl` |
| `qTestSessionDBSSL` | SSL Connection which appends for SSL Connection (only change cert name) | `?ssl=true&sslmode=verify-full&sslrootcert=/etc/ssl/root.crt` |
| `qTestSessionDBRootCRT` | Postgresql client certificate | `` (postgres client certificate, base64-encoded) |

## Insights app configurations to change in insights-values-kind.yaml

| Parameter                  | Description                             | Default                                     |
| -------------------------- |-----------------------------------------|---------------------------------------------|
| `qTestInsightsDBName` | PSQL database name of the qTest manager | `qTest`                                     |
| `qTestInsightsDBUser` | PSQL username                           | `postgres`                                  |
| `qTestInsightsDBHost` | PSQL database host name                 | `host.docker.internal`                      |
| `qTestInsightsDBSchema` | Schema name for qTest Manager         | `public`                                    |
| `qTestInsightsWriteQTestDBName` | PSQL database name of the qTest manager | `qTest`                                     |
| `qTestInsightsWriteQTestDBUser` | PSQL username                           | `postgres`                                  |
| `qTestInsightsWriteQTestDBPassword` | PSQL password                           | `cG9zdGdyZXM=` (`postgres`, base64-encoded) |
| `qTestInsightsWriteQTestDBHost` | PSQL database host name                 | `host.docker.internal`                      |
| `qTestInsightsWriteQTestDBSchema` | Schema name of qtest manager            | `public`                                    |
| `qTestInsightsSessionDBName` | PSQL database name of the session       | `sessions`                                  |
| `qTestInsightsSessionDBSchema` | PSQL session schema name                | `postgres`                                  |
| `qTestInsightsSessionDBUser` | PSQL username                           | `postgres`                                  |
| `qTestInsightsSessionDBPassword` | PSQL password                           | `cG9zdGdyZXM=` (`postgres`, base64-encoded) |
| `qTestInsightsSessionDBHost` | PSQL database host name                 | `host.docker.internal`                      |
| `serverAppSSLRequired` | Runs pod of Insights on SSL             | `false`                                     |

## Insights etl app configurations to change in insights-etl-values-kind.yaml


| Parameter                        | Description                             | Default                |
|----------------------------------|-----------------------------------------|------------------------|
| `qTestInsightsEtlDBName`         | PSQL database name of the qTest manager | `qTest`                |
| `qTestInsightsEtlDBUser`         | PSQL username                           | `postgres`             |
| `qTestInsightsEtlDBHost`         | PSQL database host name                 | `host.docker.internal` |
| `qTestInsightsEtlWriteQTestDBName` | PSQL database name of the qTest manager | `qTest`                |
| `qTestInsightsEtlWriteQTestDBUser` | PSQL username                           | `postgres`             |
| `qTestInsightsEtlWriteQTestDBHost` | PSQL database host name                 | `host.docker.internal` |
| `qTestInsightsEtlDBSchemaName` | qTest Manager schema name               | `public`               |
| `qTestInsightsEtlSessionDBName`  | PSQL database name of the session       | `sessions`             |
| `qTestInsightsEtlSessionDBUser`  | PSQL username                           | `postgres`             |
| `qTestInsightsEtlSessionDBSchema` | PSQL sessions schema name               | `postgres`             |
| `qTestInsightsEtlSessionDBHost`  | PSQL database host name                 | `host.docker.internal` |


For file persistence, only **one** of the following options is needed:
- _AWS S3_. File attachments are stored into the specified S3 bucket/folder.
- _StorageClass_. StorageClass used to carve out a PersistentVolumeClaim with the specified size and access mode. If empty, the default StorageClass will be used.
- _existingClaim_. If specified, the PersistentVolumeClaim will be used as file persistence for qTest.

## Uninstalling the qTest Manager Chart

To uninstall the qTest Manager chart with the release name `qtestmanager`:
```bash
$ helm uninstall qtestmanager
```
