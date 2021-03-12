# test-conductor-chart
Kubernetes Helm Chart Repository for qTest Manager

## Chart Details
This chart will provision a functional and featured qTest Manager installation in the cluster that it is deployed to.

## Prerequisites

   • `Helm CLI`

   • `Kubernetes Cluster`

## Installing the Chart

To install the chart with the release name `qtest`:
```bash
$ git clone https://username:password@github.com/QAS-Labs/test-conductor-chart.git
$ cd test-conductor-chart
$ update values.yaml file
Dry run test:
$ helm install qtest test-conductor-chart --dry-run
Install:
$ helm install qtest test-conductor-chart
```

## Configuration

Configurable values are documented in the `values.yaml`.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install qtest -f values.yaml test-conductor-chart
```