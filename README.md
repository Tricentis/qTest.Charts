# qTest Helm Charts
Kubernetes Helm Chart Repository for qTest Applications

## Chart Details
This chart will provision a functional and featured qTest products installation in the cluster that it is deployed to.

## Prerequisites

   • `Helm CLI`

   • `Kubernetes Cluster`

## Installing the qTest Manager Chart

To install the qTest Manager chart with the release name `qtestmanager`:
```bash
$ helm repo add qtest https://tricentis.github.io/qTest.Charts/

Dry run test:
$ helm install qtestmanager qTest.Charts/qtest-mgr --dry-run
Install:
$ helm install qtestmanager qTest.Charts/qtest-mgr
```

## Configuration

Configurable values are documented in the `values.yaml`.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install qtestmanager -f values.yaml qtest/qtest-mgr
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




## qTest Ingress/Ingress Controller and Ingress Changes for Service Mesh (Istio, Linkerd)

qTest (all of the qTest services) uses a new IngressClass provided in Kubernetes 1.18 which deprecates the annotation in the Ingress K8s resource:

In Kubernetes versions `>= 1.22` the following will no longer issue a warning for deprecation and will cause an error during helm installations with K8s Ingresss using this annotation syntax:

```
apiVersion: networking.k8s.io/v1beta1  # For 1.18-1.21 networking.k8s.io/v1 annotation is ok, however not for 1.22
kind: Ingress
metadata:
  name: mgr-ingress
  annotations:
    kubernetes.io/ingress.class: ingress.k8s.aws/alb
spec:
  rules:
    ...
```

The new standard for Kubernetes 1.18 is to use an IngressClass. For Kubernetes clusters using 1.18-1.21 the use of the preceding annotations syntax will result in a warning to change to an IngressClass. In Kubernetes 1.22+ the warning will escalate to a deployment error.

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: mgr-ingress
spec:
  ingressClassName: "qtest-mgr-ingressclass"
  rules:
    ...
```
