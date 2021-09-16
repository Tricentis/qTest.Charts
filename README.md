# qtest-chart
Kubernetes Helm Chart Repository for qTest Applications

## Chart Details
This chart will provision a functional and featured qTest products installation in the cluster that it is deployed to.

## Prerequisites

   • `Helm CLI`

   • `Kubernetes Cluster`

## Installing the qTest Manager Chart

To install the qTest Manager chart with the release name `qtestmanager`:
```bash
$ helm repo add qtest https://qas-labs.github.io/qtest-chart/

Dry run test:
$ helm install qtestmanager qtest/qtest-chart --dry-run
Install:
$ helm install qtestmanager qtest/qtest-chart
```

## Configuration

Configurable values are documented in the `values.yaml`.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install qtestmanager -f values.yaml qtest/qtest-chart
```

## Configuration

| Parameter                                 | Description                                   | Default                                                 |
|-------------------------------------------|-----------------------------------------------|---------------------------------------------------------|
| `rollouts.enabled`                        | Enable Rollout deployment resource            | `false`                                                 |
| `deployments.enabled`                     | Enable Deployment resource                    | `true`                                                  |

## Uninstalling the qTest Manager Chart

To uninstall the qTest Manager chart with the release name `qtestmanager`:
```bash
$ helm uninstall qtestmanager
```



## qTest Secrets and ConfigMap Change Auto-Reload Updates Architecture using Reloader

The following diagram depicts the workflow of how `stakater/reloader` functions in K8s cluster.


![stakater/reloader Architecture](docs/stakater-reloader-arch-1.png)
