# qtest-chart
Kubernetes Helm Chart Repository for qTest Manager

## Chart Details
This chart will provision a functional and featured qTest Manager installation in the cluster that it is deployed to.

## Prerequisites

   • `Helm CLI`

   • `Kubernetes Cluster`

## Installing the Chart

To install the chart with the release name `qtestmanager`:
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

## Uninstalling the Chart

To uninstall the chart with the release name `qtestmanager`:
```bash
$ helm uninstall qtestmanager
```
