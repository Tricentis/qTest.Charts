# Helm Repository for qTest Manager and qTest Applications

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Chart Publish](https://github.com/Tricentis/qTest.Charts/actions/workflows/release.yaml/badge.svg?branch=main)](https://github.com/Tricentis/qTest.Charts/actions/workflows/release.yaml)

[Tricentis qTest](https://www.tricentis.com/products/unified-test-management-qtest/) is a centralized test management platform to help unify, manage, and rapidly scale testing across the enterprise, so teams can collaborate to ship faster with less risk.

## Introduction

This repository includes the following charts:

- clamav
- clamav-mirror
- qTest API Gateway
- qTest L2C Integration
- qTest Manager
- qTest Scenario
- qTest Launch
- qTest Automation Host
- qTest Session
- qTest Parameters
- qTest Pulse
- qTest Insights
- qTest Insights ETL
- qTest Insights i-ETL
- qTest Swagger-UI
- qTest Test Config

## Prerequisites

- Helm 3
- Kubernetes 1.24+
- PV provisioner support in the underlying infrastructure

## Authentication

qTest uses private Docker images and requires authentication via Docker.

```bash
docker login
```

When prompted, enter your Docker ID and access token. The login process creates or updates a `config.json` file that holds an authorization token, typically located under `$HOME/.docker/config.json`.

Next, create a corresponding Kubernetes secret named `regcred`. This can be created from you existing credentials:

> **Note:**  
> In all the `kubectl` and `helm` commands shown in this guide, we use `-n qtest` to specify the `qtest` namespace.
>
> If you want to skip creating/using a namespace, simply remove `-n qtest` from all commands, and resources will be created in the default namespace.


```bash
kubectl create namespace qtest --dry-run=client -o yaml | kubectl apply -f -

kubectl create secret generic regcred \
    --from-file=.dockerconfigjson=<path/to/.docker/config.json> \
    --type=kubernetes.io/dockerconfigjson -n qtest
```


```bash
kubectl create secret generic qtest-manager-secret -n qtest --from-literal=oauth.app.sp.access.validity="3600000"  --from-literal=oauth.app.sp.secret="{value}" --from-literal=oauth.app.sp.grants="" --from-literal=oauth.app.sessions.secret="{value}"  --from-literal=oauth.app.explorer.secret="{value}"  --from-literal=oauth.app.qmap.secret="{value}" --from-literal=oauth.app.jenkins.secret="{value}" --from-literal=oauth.app.bamboo.secret="{value}" --from-literal=oauth.app.pulse.secret="{value}"  --from-literal=oauth.app.tosca.secret="{value}" --from-literal=oauth.app.web-explorer.secret="{value}"   --dry-run=client -o yaml | kubectl apply -f -
```
Just replace {value} with the values.

If you do not wish to use the Docker `config.json` file, the secret can also be created directly from the command line:

```bash
kubectl create secret docker-registry regcred -n qtest --docker-server=<your-registry-server> --docker-username=<your-name> --docker-password=<your-pword> --docker-email=<your-email>
```

where:

- `<your-registry-server>` is your Private Docker Registry FQDN. Use https://index.docker.io/v1/ for DockerHub.
- `<your-name>` is your Docker username.
- `<your-pword>` is your Docker access token.
- `<your-email>` is your Docker email.

## Installation

Add the qTest Helm repo:

```bash
helm repo add qtest https://tricentis.github.io/qTest.Charts
helm repo update
```

## (End-to-End) Helm Chart Integrity Verification

To verify the integrity of the qTest Helm Chart for public consumption (**highly advised**, however **OPTIONAL**), the qTest Helm Charts follow the Helm Provenance Security Packaging Guidelines to 100% guarantee the qTest Helm Chart consumers download and deploy to their Kubernetes Clusters a 100% integrity (anti-highjacked) version of the Helm Chart. For a full-description and step-for-step guideline on how to issue the verification process see [Helm Provenance](docs/README-qtest-k8s-helm-chart-integrity-verification.md).

Install the qTest Manager chart with the release name `qtest-manager` in `qtest` namespace:

```bash
helm install qtest-manager qtest/qtest-mgr -f <values.yaml> -n qtest --create-namespace
```

Note that qTest Manager chart should be the **first** chart to be installed.
All other qTest charts may be installed subsequently in the similar manner. For example, to install qTest Parameters with the release name `qtest-parameters`:

```bash
helm install qtest-parameters qtest/qtest-parameters -n qtest
```

## Uninstallation

Removal is the reverse of installation. Start removal of the apps first and then Manager. Example:

```bash
helm uninstall qtest-parameters
helm uninstall qtest-manager
```

## Configurations

The following table lists the configurable parameters for qTest Manager and its applications.

### Ingress Controller

qTest relies an IngressController to route ingress traffic into the cluster. We recommend SSL offloading/termination be done at the IngressController. Specific TLS setup instructions depend on the IngressController you have.

qTest includes a sample NginX IngressController YAML file to demonstrate how qTest services may be exposed via an IngressController. Additional TLS configuration for the NginX IngressController can be found [here](https://kubernetes.github.io/ingress-nginx/user-guide/tls/).

### Common properties

Every chart has a set of common properties which influence deployment-related behavior.

| Parameter                     | Description                                                                                                                                                      | Default                                                                                |
| ----------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------- |
| `namespace.name`              | K8s namespace where to deploy the chart                                                                                                                          | `qtest`                                                                                |
| `image.repository`            | Docker repository where to get the image(s) from                                                                                                                 | _varies by a chart_                                                                    |
| `image.pullPolicy`            | Docker image pull policy                                                                                                                                         | `IfNotPresent`                                                                         |
| `deployment.annotations`      | Annotations to add to the k8s Deployment                                                                                                                         | _empty_                                                                                |
| `deployment.singlePodPerNode` | Whether to add the `podAntiAffinity` to not have multiple pods on a single Node, the `affinity` parameter takes precedence over generated `podAntiAffinity`      | _empty_                                                                                |
| `podAnnotations`              | Annotations to add to the k8s Pods                                                                                                                               | _empty_                                                                                |
| `resources`                   | K8s `resources` block, documentation [here](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)                                      | <pre>requests:<br> cpu: 1<br> memory: 1Gi<br> limits:<br> cpu: 1<br> memory: 1Gi</pre> |
| `nodeSelector`                | K8s Node selector to add to the Deployment, documentation [here](https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes/)                    | _empty_                                                                                |
| `tolerations`                 | K8s Tolerations to add to the Deployment, documentation [here](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)                    | _empty_                                                                                |
| `affinity`                    | K8s Affinity to add to the Deployment, documentation [here](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity) | _empty_                                                                                |

### qTest Manager

At a minimum, the `postgres` and `elasticSearch` parameters should be provided to match your environment.

| Parameter                                  | Description                                                                                            | Default                                                                                      |
| ------------------------------------------ |--------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------|
| `attachment.folder.path`                   | qTest attachement folder path                                                                          | `/mnt/data/qtest/attachments`                                                                |
| `blobstorage.type`                         | qTest Manager attachements folder type                                                                 | `disk_storage` (Accepted values disk_storage, amazon_s3_access_key)                          |
| `blobstorage.region`                       | S3 bucket region                                                                                       | `us-east-1` (Needed when blobstorage.type is amazon_s3_access_key)                           |
| `blobstorage.sharedBucket`                 | S3 bucket name                                                                                         | `qtest` (Needed when blobstorage.type is amazon_s3_access_key)                               |
| `client.jdbc.postgresUrl`                  | PSQL database URL                                                                                      | `jdbc:postgresql://host.docker.internal/qtest`                                               |
| `client.jdbc.postgresUserName`             | PSQL username                                                                                          | `postgres`                                                                                   |
| `client.jdbc.postgresPassword`             | PSQL password                                                                                          |                                                                                              |
| `client.jdbc.sslEnable`                    | Enable ssl connections                                                                                 | `false`                                                                                      |
| `client.jdbc.postgres.readonly.url`        | PSQL readonly database URL                                                                             | `jdbc:postgresql://host.docker.internal/qtest`                                               |
| `client.jdbc.postgres.readonly.username`   | PSQL username                                                                                          | `postgres`                                                                                   |
| `client.jdbc.postgres.readonly.password`   | PSQL password                                                                                          |                                                                                              |
| `client.jdbc.sslMountPath`                 | Postgresql ssl certificate mount directory                                                             | `\etc\ssl`                                                                                   |
| `client.jdbc.sslPath`                      | Postgresql ssl connection string                                                                       | `?ssl=true&sslmode=verify-full&sslrootcert=/etc/ssl/root.crt` (please chnage only cert path) |
| `client.jdbc.cert`                         | Postgresql client certificate                                                                          | `` (postgres client certificate, base64-encoded)                                             |
| `cors.allowed.all`                         | cors allowed                                                                                           | `true`                                                                                       |
| `cors.allowed.domains`                     | cors allowed domains                                                                                   | ``                                                                                           |
| `elasticSearch.host`                       | Elasticsearch host                                                                                     | `host.docker.internal`                                                                       |
| `elasticSearch.port`                       | Elasticsearch port                                                                                     | `9200`                                                                                       |
| `elasticSearch.scheme`                     | Elasticsearch port                                                                                     | `http`                                                                                       |
| `license.folder.path`                      | qTest Manager license folder path                                                                      | `/mnt/data/qtest/license`                                                                    |
| `mail.host`                                | SMTP host name                                                                                         | `smtp.local`                                                                                 |
| `mail.port`                                | SMTP port number                                                                                       | `465`                                                                                        |
| `mail.username`                            | SMTP username                                                                                          | `qtest`                                                                                      |
| `mail.password`                            | SMTP password                                                                                          |                                                                                              |
| `mail.supportEmailAddress`                 | qTest Support email address                                                                            | `supports@tricentis.com`                                                                     |
| `mail.starttls`                            | Use TLS to encrypt communication with the SMTP server (enables use of port 587).                       | `false`                                                                                      |
| `notification.urlExternal`                 | Notification URL                                                                                       | `https://nephele.qtest.local`                                                                |
| `preUrl`                                   | qTest Manager URL                                                                                      | `http://<sitename>.qtest.local`                                                              |
| `preUrlHttps`                              | qTest Manager URL                                                                                      | `https://<sitename>.qtest.local`                                                             |
| `qtest.request.nonce.disabled`             | qTest request nonce disabled                                                                           | `true`                                                                                       |
| `qtest.request.nonce.mode`                 | qTest request nonce mode                                                                               | `HighPrecision`                                                                              |
| `s3.accessKey`                             | S3 access key                                                                                          | ""                                                                                           |
| `s3.secretKey`                             | S3 secret key                                                                                          | ""                                                                                           |
| `s3.region`                                | S3 region                                                                                              | ""                                                                                           |
| `s3.bucketName`                            | S3 bucket name                                                                                         | ""                                                                                           |
| `s3.folder`                                | S3 folder                                                                                              | ""                                                                                           |
| `security.csrf.source.trust.pattern`       | qTest Manager csrf security pattern                                                                    | ``                                                                                           |
| `vera.auto.testrun.beta.clients`           | SMTP port number                                                                                       | `-1`                                                                                         |
| `autoscaling.enabled`                      | Minimum replicas                                                                                       | `true`                                                                                       |
| `autoscaling.minReplicas.ui`               | Minimum replicas                                                                                       | `1`                                                                                          |
| `autoscaling.maxReplicas.ui`               | Maximum replicas                                                                                       | `3`                                                                                          |
| `autoscaling.minReplicas.api`              | Minimum replicas                                                                                       | `1`                                                                                          |
| `autoscaling.maxReplicas.api`              | Maximum replicas                                                                                       | `3`                                                                                          |
| `autoscaling.minReplicas.notification`     | Minimum replicas                                                                                       | `1`                                                                                          |
| `autoscaling.maxReplicas.notification`     | Maximum replicas                                                                                       | `1`                                                                                          |
| `autoscaling.minReplicas.poller`           | Minimum replicas                                                                                       | `1`                                                                                          |
| `autoscaling.maxReplicas.poller`           | Maximum replicas                                                                                       | `1`                                                                                          |
| `ingress.enabled`                          | Is Ingress enabled?                                                                                    | `false`                                                                                      |
| `ingress.class`                            | Name of IngressClass                                                                                   | `nginx`                                                                                      |
| `ingress.host`                             | qTest Manager hostname                                                                                 | `nephele.qtest.local`                                                                        |
| `ingress.tls.hosts`                        | Configuration for TLS on the Ingress                                                                   | `mgr.qtest.local`                                                                            |
| `limitRange.enabled`                       | Set resource limits                                                                                    | `false`                                                                                      |
| `limitRange.limits.max.cpu`                | Max CPU                                                                                                | `2`                                                                                          |
| `limitRange.limits.max.memory`             | Max memory                                                                                             | `16Gi`                                                                                       |
| `limitRange.limits.default.cpu`            | Default CPU                                                                                            | `2`                                                                                          |
| `limitRange.limits.default.memory`         | Default memory                                                                                         | `16Gi`                                                                                       |
| `limitRange.limits.defaultRequest.cpu`     | Requested CPU                                                                                          | `2`                                                                                          |
| `limitRange.limits.defaultRequest.memory`  | Requested memory                                                                                       | `4Gi`                                                                                        |
| `resources.limits.cpu`                     | Set CPU limits for all deployments. Can be overidden with '[component].resources.limits.cpu'           |                                                                                              |
| `resources.limits.memory`                  | Set Memory limits for all deployments. Can be overidden with '[component].resources.limits.memory'     |                                                                                              |
| `resources.requests.cpu`                   | Set CPU requests for all deployments. Can be overidden with '[component].resources.requests.cpu'       |                                                                                              |
| `resources.requests.memory`                | Set Memory requests for all deployments. Can be overidden with '[component].resources.requests.memory' |                                                                                              |
| `persistence.enabled`                      | Is PersistentVolume enabled?                                                                           | `true`                                                                                       |
| `persistence.existingClaim`                | Existing PersistentVolumeClaim                                                                         | ""                                                                                           |
| `persistence.storageClass`                 | Existing StorageClass                                                                                  | ""                                                                                           |
| `persistence.accessMode`                   | Storage Access Mode                                                                                    | `ReadWriteOnce`                                                                              |
| `persistence.size`                         | Storage size                                                                                           | `10Gi`                                                                                       |
| `service.port`                             | Port on service for other pods to talk to                                                              | `8080`                                                                                       |
| `service.targetPort`                       | Port on container to serve traffic                                                                     | `8080`                                                                                       |
| `service.port`                             | Port on service for other pods to talk to                                                              | `8080`                                                                                       |
| `service.targetPort`                       | Port on container to serve traffic                                                                     | `8080`                                                                                       |
| `testconductor.environment.singleInstance` | Runs in qTest Manager in a single pod                                                                  | `true`                                                                                       |
| `serverAppSSLRequired`                     | Runs pod of qTest Manager on SSL                                                                       | `false`                                                                                      |
| `serverAppSSLCipherSuites`                 | Cipher suites for SSL/TLS connection                                                                   | []                                                                                           |
| `server.sslMountPath`                      | Pod certificate mounting path                                                                          | `/mnt/secrets/tls`                                                                           |
| `OauthAppSpSecret`                         | Get the value from AWS SM                                                                              | *(none)*                                                                                     |
| `OauthAppSpGrants`                         | Get the value from AWS SM                                                                              | *(none)*                                                                                     |
| `OauthAppSpAccessValidity`                 | Token validity (seconds)                                                                               | `300000`                                                                                     |
| `OauthAppSessionsSecret`                   | Get the value from AWS SM                                                                              | *(none)*                                                                                     |
| `OauthAppExplorerSecret`                   | Get the value from AWS SM                                                                              | *(none)*                                                                                     |
| `OauthAppWebExplorerSecret`                | Get the value from AWS SM                                                                              | *(none)*                                                                                     |
| `OauthAppQmapSecret`                       | Get the value from AWS SM                                                                              | *(none)*                                                                                     |
| `OauthAppJenkinsSecret`                    | Get the value from AWS SM                                                                              | *(none)*                                                                                     |
| `OauthAppBambooSecret`                     | Get the value from AWS SM                                                                              | *(none)*                                                                                     |
| `OauthAppPulseSecret`                      | Get the value from AWS SM                                                                              | *(none)*                                                                                     |
| `OauthAppToscaSecret`                      | Get the value from AWS SM                                                                              | *(none)*                                                                                     |
| `secret.javaCertsSecretEnabled`            | Enable the extra Java certs                                                                            | `false`                                                                                      |
| `secret.javaCertsSecretName`               | Name of the secret containing extra Java certs                                                         | `java-certs-secret`                                                                         |

## Parameters app configurations to change in "Charts/qtest-parameters/values.yaml"

| Parameter                        | Description                                                             | Default                                                       |
| -------------------------------- | ----------------------------------------------------------------------- | ------------------------------------------------------------- |
| `qTestParametersDBName`          | PSQL database name of the parameters app                                | `parameters`                                                  |
| `qTestParametersDBUserName`      | PSQL username                                                           | `postgres`                                                    |
| `qTestParametersDBHostName`      | PSQL database host name                                                 | `host.docker.internal`                                        |
| `qTestParametersDBSSLEnable`     | Enable ssl connections                                                  | `false`                                                       |
| `qTestParametersDBSSLMountPath`  | Postgresql ssl certificate mount directory                              | `\etc\ssl`                                                    |
| `qTestParametersDBSSL`           | SSL Connection which appends for SSL Connection (only change cert name) | `?ssl=true&sslmode=verify-full&sslrootcert=/etc/ssl/root.crt` |
| `qTestParametersDBRootCRT`       | Postgresql client certificate                                           | `` (postgres client certificate, base64-encoded)              |
| `qTestParametersDBPort`          | Postgresql database port                                                | `5432`                                                        |
| `qTestParametersSSLRequired`     | Pod Level SSL Traffic Encryption                                        | `false`                                                       |
| `qTestParametersSSLMountPath`    | Pod client certificate                                                  | `/mnt/secrets/tls`                                            |
| `qTestParametersSSLCipherSuites` | Cipher suites for SSL/TLS connection                                    | []                                                            |

## Launch app configurations to change in "Charts/qtest-launch/values.yaml"

| Parameter                    | Description                                                             | Default                                                       |
| ---------------------------- | ----------------------------------------------------------------------- | ------------------------------------------------------------- |
| `qTestLaunchDBName`          | PSQL database name of the qTest Manager                                 | `qtest`                                                       |
| `qTestLaunchDBUserName`      | PSQL username                                                           | `postgres`                                                    |
| `qTestLaunchDBHostName`      | PSQL database host name                                                 | `host.docker.internal`                                        |
| `qTestLaunchRootURL`         | qTest Launch url                                                        | `https://launch.qtest.local`                                  |
| `qTestLaunchDBSSLEnable`     | Enable ssl connections                                                  | `false`                                                       |
| `qTestLaunchDBSSLMountPath`  | Postgresql ssl certificate mount directory                              | `\etc\ssl`                                                    |
| `qTestLaunchDBSSL`           | SSL Connection which appends for SSL Connection (only change cert name) | `?ssl=true&sslmode=verify-full&sslrootcert=/etc/ssl/root.crt` |
| `qTestLaunchDBRootCRT`       | Postgresql client certificate                                           | `` (postgres client certificate, base64-encoded)              |
| `qTestLaunchDBPort`          | Postgresql database port                                                | `5432`                                                        |
| `qTestLaunchSSLRequired`     | Pod Level SSL Traffic Encryption                                        | `false`                                                       |
| `qTestLaunchSSLMountPath`    | Pod client certificate                                                  | `/mnt/secrets/tls`                                            |
| `qTestLaunchSSLCipherSuites` | Cipher suites for SSL/TLS connection                                    | []                                                            |
| `qTestLaunchDeploymentEnv`   | Type of deployment environment. Either SaaS or OP                       | `op`                                                          |

## Automation Host app configurations to change in "Charts/qtest-automation-host/values.yaml"

| Parameter                       | Description                                                  | Default              |
| ------------------------------- | ------------------------------------------------------------ | -------------------- |
| `qTestAutomationHostName`       | Name of the Automation Host in Launch UI                     | `AutomationHost`     |
| `qTestAutomationHostPort`       | Port of the Automation Host                                  | `6789`               |
| `qTestAutomationHostManagerUrl` | URL of qTest Manager to which Automation Host should connect | `https://manager.dc` |

## Pulse app configurations to change in "Charts/qtest-pulse/values.yaml"

Helm chart values for Pulse service to set either in `values-pulse.yaml` or `--set` flag.

Installation command for pulse service:

```bash
helm install qtest-pulse-executor qtest/qtest-pulse -n qtest -f values-pulse.yaml
```

| Parameter                   | Description                                                                                    | Default                                                       |
| --------------------------- | ---------------------------------------------------------------------------------------------- | ------------------------------------------------------------- |
| `qTestPulseDBName`          | PSQL database name of the pulse                                                                | `pulse`                                                       |
| `qTestPulseDBUserName`      | PSQL username                                                                                  | `postgres`                                                    |
| `qTestPulseDBHostName`      | PSQL database host name                                                                        | `host.docker.internal`                                        |
| `qTestPulseRootURL`         | qTest Pulse url                                                                                | `https://pulse.qtest.local`                                   |
| `qTestPulseScenarioURL`     | qTest Launch url                                                                               | `https://scenario.qtest.local`                                |
| `qTestPulseDBSSLEnable`     | Enable ssl connections                                                                         | `false`                                                       |
| `qTestPulseDBSSLMountPath`  | Postgresql ssl certificate mount directory                                                     | `\etc\ssl`                                                    |
| `qTestPulseDBSSL`           | SSL Connection which appends for SSL Connection (only change cert name)                        | `?ssl=true&sslmode=verify-full&sslrootcert=/etc/ssl/root.crt` |
| `qTestPulseDBRootCRT`       | Postgresql client certificate                                                                  | (postgres client certificate, base64-encoded)                 |
| `qTestPulseType`            | The type of Pulse service that is running, can be `qtest-pulse` or `executor`                          | `qtest-pulse`                                                 |
| `qTestPulseExecutorUrl`     | The URL of Pulse Executor, could be something like `http://pulse-executor-service.<namespace>` | empty string                                                  |
| `qTestPulseWebsocketServerPort`     | The websocket port of pulse server                                                     | `6001`                                                  |
| `qTestPulseWebsocketUrl`    | The URL used by Executor websocket client to connect to pulse server, could be something like `wss://pulse-service/ws` | empty string                                                  |
| `qTestPulseLogLevel`        | Log level setting for both Pulse and Executor apps                                             | `info`                                                        |
| `qTestPulseFlagEnableExecutorPolling`        | Flag that enables new way of communication for Pulse and Executor (needs to be enabled in both)                   | `0`                                                        |
| `qTestPulseDBPort`          | Postgresql database port                                                                       | `5432`                                                        |
| `qTestPulseSSLRequired`     | Pod Level SSL Traffic Encryption                                                               | `false`                                                       |
| `qTestPulseSSLMountPath`    | Pod client certificate                                                                         | `/mnt/secrets/tls`                                            |
| `qTestPulseSSLCipherSuites` | Cipher suites for SSL/TLS connection                                                           | []                                                            |
| `qtestPulseExecutorApiKey`  | Pulse Executor API key - random string used as an authorization between pulse service and executor service                                                                       | `''` empty string                |

## Pulse Executor app configurations to change in pulse-executor-values-kind.yaml

Helm chart values for Pulse Executor service to set either in `values-pulse.yaml` or `--set` flag.

Installation command for executor service:

```bash
helm install qtest-pulse-executor qtest/qtest-pulse -n qtest -f values-pulse-executor.yaml
```

| Parameter                  | Description                                                                                                                                                 | Default           |
|----------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------|
| `qTestPulseType`           | The type of Pulse service that is running, can be `qtest-pulse` or `executor`. Default is `qtest-pulse` for running executor should be change to `executor` | `qtest-pulse`     |
| `qtestPulseExecutorApiKey` | Pulse Executor API key - random string used as an authorization between pulse service and executor, should be same as in pulse service                      | `''` empty string |
| `nameOverride`             | Pulse and executor use the same chart. To not conflicting resources value should be set to 'qtest-pulse-executor                                            | `''`              |
| `service.serviceName`      | To rename the k8s service. Value should be set to something like `pulse-executor-service`. value has to be the same like the one on Pulse app above.        | `''`              |

## Scenario app configurations to change in "Charts/qtest-scenario/values.yaml"

| Parameter                         | Description                                                             | Default                                                       |
|-----------------------------------|-------------------------------------------------------------------------|---------------------------------------------------------------|
| `qTestScenarioDBName`             | PSQL database name of the scenario                                      | `scenario`                                                    |
| `qTestScenarioDBUserName`         | PSQL username                                                           | `postgres`                                                    |
| `qTestScenarioDBHostName`         | PSQL database host name                                                 | `host.docker.internal`                                        |
| `qTestScenarioLocalBaseURL`       | qTest Pulse url                                                         | `https://scenario.qtest.local`                                |
| `qTestScenarioQTestURL`           | qTest Launch url                                                        | `https://nephele.qtest.local`                                 |
| `qTestScenarioDBSSLEnable`        | Enable ssl connections                                                  | `false`                                                       |
| `qTestScenarioDBSSLMountPath`     | Postgresql ssl certificate mount directory                              | `\etc\ssl`                                                    |
| `qTestScenarioDBSSL`              | SSL Connection which appends for SSL Connection (only change cert name) | `?ssl=true&sslmode=verify-full&sslrootcert=/etc/ssl/root.crt` |
| `qTestScenarioDBRootCRT`          | Postgresql client certificate                                           | `` (postgres client certificate, base64-encoded)              |
| `qTestScenarioDBPort`             | Postgresql database port                                                | `5432`                                                        |
| `qTestScenarioSSLRequired`        | Pod Level SSL Traffic Encryption                                        | `false`                                                       |
| `qTestScenarioSSLMountPath`       | Pod client certificate                                                  | `/mnt/secrets/tls`                                            |
| `qTestScenarioSSLCipherSuites`    | Cipher suites for SSL/TLS connection                                    | []                                                            |
| `qTestScenarioDeploymentEnv`      | Type of deployment environment. Either SaaS or OP                       | `op`                                                          |
| `qTestScenarioRefreshTokenSecret` | Random string used as the refresh token secret                          | `secret`                                                      |

## Session app configurations to change in "Charts/qtest-session/values.yaml"

| Parameter                     | Description                                                             | Default                                                       |
| ----------------------------- | ----------------------------------------------------------------------- | ------------------------------------------------------------- |
| `qTestSessionDBName`          | PSQL database name of the session                                       | `sessions`                                                    |
| `qTestSessionDBUserName`      | PSQL username                                                           | `postgres`                                                    |
| `qTestSessionDBHostName`      | PSQL database host name                                                 | `host.docker.internal`                                        |
| `qTestStorageBucketName`      | Amazon S3 bucket name                                                   | `aws-session-bucket-name`                                     |
| `qTestSessionClamavURL`       | qTest clama url                                                         | `https://clam.qtest.local`                                    |
| `qTestSessionStorageType`     | Session storage type                                                    | `amazon_s3 disk_storage`                                      |
| `qTestSessionDBSSLEnable`     | Enable ssl connections                                                  | `false`                                                       |
| `qTestSessionDBSSLMountPath`  | Postgresql ssl certificate mount directory                              | `\etc\ssl`                                                    |
| `qTestSessionDBSSL`           | SSL Connection which appends for SSL Connection (only change cert name) | `?ssl=true&sslmode=verify-full&sslrootcert=/etc/ssl/root.crt` |
| `qTestSessionDBRootCRT`       | Postgresql client certificate                                           | `` (postgres client certificate, base64-encoded)`             |
| `qTestSessionDBPort`          | Postgresql database port                                                | `5432`                                                        |
| `qTestSessionSSLRequired`     | Pod Level SSL Traffic Encryption                                        | `false`                                                       |
| `qTestSessionSSLMountPath`    | Pod client certificate                                                  | `/mnt/secrets/tls`                                            |
| `qTestSessionSSLCipherSuites` | Cipher suites for SSL/TLS connection                                    | []                                                            |
| `qTestSessionDeploymentEnv`   | Type of deployment environment. Either SaaS or OP                       | `op`                                                          |

## Insights app configurations to change in "Charts/qtest-insights/values.yaml"

| Parameter                           | Description                             | Default                                     |
| ----------------------------------- | --------------------------------------- | ------------------------------------------- |
| `qTestInsightsDBName`               | PSQL database name of the qTest manager | `qTest`                                     |
| `qTestInsightsDBUser`               | PSQL username                           | `postgres`                                  |
| `qTestInsightsDBHost`               | PSQL database host name                 | `host.docker.internal`                      |
| `qTestInsightsDBSchema`             | Schema name for qTest Manager           | `public`                                    |
| `qTestInsightsWriteQTestDBName`     | PSQL database name of the qTest manager | `qTest`                                     |
| `qTestInsightsWriteQTestDBUser`     | PSQL username                           | `postgres`                                  |
| `qTestInsightsWriteQTestDBPassword` | PSQL password                           |                                             |
| `qTestInsightsWriteQTestDBHost`     | PSQL database host name                 | `host.docker.internal`                      |
| `qTestInsightsWriteQTestDBSchema`   | Schema name of qtest manager            | `public`                                    |
| `qTestInsightsSessionDBName`        | PSQL database name of the session       | `sessions`                                  |
| `qTestInsightsSessionDBSchema`      | PSQL session schema name                | `postgres`                                  |
| `qTestInsightsSessionDBUser`        | PSQL username                           | `postgres`                                  |
| `qTestInsightsSessionDBPassword`    | PSQL password                           |                                             |
| `qTestInsightsSessionDBHost`        | PSQL database host name                 | `host.docker.internal`                      |
| `serverAppSSLRequired`              | Runs pod of Insights on SSL             | `false`                                     |
| `sessionsPersistence`               | Persist user sessions                   | `false`                                     |
| `logsPersistence`                   | Persist logs sessions                   | `true`                                      |
| `qTestInsightsWriteQTestDBPort`     | Insights Postgresql database port       | `5432`                                      |
| `qTestInsightsSessionDBPort`        | Session Postgresql database port        | `5432`                                      |
| `server.sslMountPath`               | Pod Level SSL Traffic Encryption        | `/mnt/secrets/tls`                          |
| `qTestInsightsSSLCipherSuites`      | Cipher suites for SSL/TLS connection    | []                                          |

## Insights etl app configurations to change in "Charts/qtest-insights-etl/values.yaml"

| Parameter                          | Description                             | Default                |
| ---------------------------------- | --------------------------------------- | ---------------------- |
| `qTestInsightsEtlDBName`           | PSQL database name of the qTest manager | `qTest`                |
| `qTestInsightsEtlDBUser`           | PSQL username                           | `postgres`             |
| `qTestInsightsEtlDBHost`           | PSQL database host name                 | `host.docker.internal` |
| `qTestInsightsEtlWriteQTestDBName` | PSQL database name of the qTest manager | `qTest`                |
| `qTestInsightsEtlWriteQTestDBUser` | PSQL username                           | `postgres`             |
| `qTestInsightsEtlWriteQTestDBHost` | PSQL database host name                 | `host.docker.internal` |
| `qTestInsightsEtlDBSchemaName`     | qTest Manager schema name               | `public`               |
| `qTestInsightsEtlSessionDBName`    | PSQL database name of the session       | `sessions`             |
| `qTestInsightsEtlSessionDBUser`    | PSQL username                           | `postgres`             |
| `qTestInsightsEtlSessionDBSchema`  | PSQL sessions schema name               | `postgres`             |
| `qTestInsightsEtlSessionDBHost`    | PSQL database host name                 | `host.docker.internal` |
| `qTestInsightsEtlDBPort`           | Insights Postgresql database port       | `5432`                 |
| `qTestInsightsEtlWriteQTestDBPort` | qTest Postgresql database port          | `5432`                 |
| `writeSessionsDBPort`              | Session Postgresql database port        | `5432`                 |
| `qTestInsightsEtlDeploymentEnv`    | Deployment environment. saas or op      | `op`                   |

## Insights i-ETL app configurations to change in "Charts/qtest-i-etl/values.yaml"

| Parameter                                 | Description                                              | Value            |
|-------------------------------------------|----------------------------------------------------------|------------------|
| `readQTestDBHost`                         | Host for read qTest DB                                   | `postgres.local` |
| `readQTestDBPort`                         | Port for read qTest DB                                   | `5432`           |
| `readQTestDBName`                         | Name for read qTest DB                                   | `qtest`          |
| `readQTestDBUser`                         | User for read qTest DB                                   | `postgres`       |
| `readQTestDBMaxPoolSize`                  | Max pool size for read qTest DB                          | `25`             |
| `readQTestDBMinIdle`                      | Min idle connections for read qTest DB                   | `5`              |
| `writeQTestDBHost`                        | Host for write qTest DB                                  | `postgres.local` |
| `writeQTestDBPort`                        | Port for write qTest DB                                  | `5432`           |
| `writeQTestDBName`                        | Name for write qTest DB                                  | `qtest`          |
| `writeQTestDBUser`                        | User for write qTest DB                                  | `postgres`       |
| `writeQTestDBMaxPoolSize`                 | Max pool size for write qTest DB                         | `25`             |
| `writeQTestDBMinIdle`                     | Min idle connections for write qTest DB                  | `5`              |
| `qTestDBSchema`                           | Schema for qTest DB                                      | `public`         |
| `insightsDBSchema`                        | Schema for Insights DB                                   | `insights`       |
| `insightsDBUser`                          | User for Insights DB                                     | `postgres`       |
| `insightEtlDBSchema`                      | Schema for Insights ETL DB                               | `insights_etl`   |
| `sessionsReadDBHost`                      | Host for read Sessions DB                                | `postgres.local` |
| `sessionsReadDBPort`                      | Port for read Sessions DB                                | `5432`           |
| `sessionsReadDBName`                      | Name for read Sessions DB                                | `sessions`       |
| `sessionsReadDBUser`                      | User for read Sessions DB                                | `postgres`       |
| `sessionsReadDBSchema`                    | Schema for read Sessions DB                              | `public`         |
| `sessionsWriteDBHost`                     | Host for write Sessions DB                               | `postgres.local` |
| `sessionsWriteDBPort`                     | Port for write Sessions DB                               | `5432`           |
| `sessionsWriteDBName`                     | Name for write Sessions DB                               | `sessions`       |
| `sessionsWriteDBUser`                     | User for write Sessions DB                               | `postgres`       |
| `sessionsWriteDBSchema`                   | Schema for write Sessions DB                             | `public`         |
| `autoRefreshDBLink`                       | Enable auto-refresh of DB link                           | `true`           |
| `logEnvironment`                          | Log environment                                          | `opk8s`          |
| `iEtlQuartzThreadCount`                   | Number of threads for Quartz scheduler                   | `10`             |
| `iEtlBatchInitialSize`                    | Initial batch size                                       | `10000`          |
| `iEtlBatchMinSize`                        | Minimum batch size                                       | `1000`           |
| `iEtlBatchMaxSize`                        | Maximum batch size                                       | `"1000000"`      |
| `iEtlBatchSleepPercentage`                | Sleep percentage between batches                         | `50`             |
| `iEtlBatchOptimalDurationSeconds`         | Optimal duration for each batch                          | `60`             |
| `iEtlAggregationInterval`                 | Interval (seconds) between aggregation jobs              | `600`            |
| `iEtlMaterializedViewInterval`            | Interval (seconds) between refreshing materialized views | `600`            |
| `iEtlLongRunningMaterializedViewInterval` | Interval (seconds) for long-running materialized views   | `10800`          |
| `iEtlBetaJobsDisabled`                    | Flag to disable beta jobs                                | `false`          |
| `rapidDashboardsTaskInterval`             | Task interval for rapid dashboards (seconds)             | `60`             |
| `rapidDashboardsBatchSize`                | Batch size for rapid dashboards processing               | `100`            |
| `rapidDashboardsMaxConcurrentTasks`       | Max concurrent tasks for rapid dashboards                | `10`             |
| `rapidDashboardsPickerWindow`             | Picker window for rapid dashboards (seconds)             | `61`             |
| `rapidDashboardsRequestTimeout`           | Request timeout for rapid dashboards (seconds)           | `600`            |
| `rapidDashboardsConnectTimeout`           | Connect timeout for rapid dashboards (seconds)           | `10`             |
| `rapidDashboardsSocketTimeout`            | Socket timeout for rapid dashboards (seconds)            | `600`            |
| `rapidDashboardsConnectionRequestTimeout` | Connection request timeout for rapid dashboards (seconds)| `10`             |
| `rapidDashboardsEnableMisfireHandling`    | Enable misfire handling for rapid dashboards             | `true`           |
| `scheduledReportsEnableMisfireHandling`   | Enable misfire handling for scheduled reports            | `true`           |
| `scheduledReportsBatchSize`               | Batch size for scheduled reports processing              | `100`            |
| `scheduledReportsRequestTimeout`          | Request timeout for scheduled reports (seconds)          | `600`            |
| `scheduledReportsResultLogsPath`          | Path for scheduled reports result logs                   | `/tmp/scheduled-reports-logs` |
| `scheduledReportsConnectTimeout`          | Connect timeout for scheduled reports (seconds)          | `10`             |
| `scheduledReportsSocketTimeout`           | Socket timeout for scheduled reports (seconds)           | `600`            |
| `scheduledReportsConnectionRequestTimeout`| Connection request timeout for scheduled reports (seconds)| `10`            |
| `scheduledReportsMaxConcurrentTasks`      | Max concurrent tasks for scheduled reports               | `10`             |
| `scheduledReportsTaskInterval`            | Task interval for scheduled reports (seconds)            | `60`             |


For file persistence, only **one** of the following options is needed:

- _AWS S3_. File attachments are stored into the specified S3 bucket/folder.
- _StorageClass_. StorageClass used to carve out a PersistentVolumeClaim with the specified size and access mode. If empty, the default StorageClass will be used.
- _existingClaim_. If specified, the PersistentVolumeClaim will be used as file persistence for qTest.

## Uninstalling the qTest Manager Chart

To uninstall the qTest Manager chart with the release name `qtestmanager`:

```bash
$ helm uninstall qtestmanager
```
