
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

The preceding Ingress Controller through the Ingress and new (as of Kubernetes >=1.18) IngressClass shows the Ingress K8s resource referencing the `ingressClassName` which is defined in the provided `ingress-class.yaml` in the qtest-mgr Helm Chart template as follows:

```
{{- if .Values.ingressClass.enabled }}
{{- if semverCompare ">=1.18" .Capabilities.KubeVersion.GitVersion -}}
apiVersion: networking.k8s.io/v1
{{- else -}}
apiVersion: networking.k8s.io/v1beta1
{{- end}}
kind: IngressClass
metadata:
  name: "{{ include "qtest-mgr.fullname" . }}-ingressclass"
  namespace: {{ .Values.namespace.name }}
  annotations:
    ingressclass.kubernetes.io/is-default-class: {{ .Values.ingressClass.isDefaultClass | quote }}
spec:
  controller: {{ .Values.ingressClass.controller }}
{{- end }}
```

And after rendering the provided `values.yaml` for the templated parameters in the `IngressClass` the rendered K8s IngressClass resource is as follows:

```
# Source: qtest-mgr/templates/ingress-class.yaml
apiVersion: networking.k8s.io/v1
kind: IngressClass
metadata:
  name: "qtest-mgr-ingressclass"
  namespace: qtest
  annotations:
    ingressclass.kubernetes.io/is-default-class: "true"
spec:
  controller: ingress.k8s.aws/alb
```

In the `values.yaml` defines its IngressClass values as follows:

```
#### Ingress/IngressClass (> K8s 1.18-1.22+) #####
ingressClass:
  enabled: true
  labels: {}
  controller: ingress.k8s.aws/alb
  isDefaultClass: true
  # Use to force a networking.k8s.io API Version for certain CI/CD applications. Such as : "v1"
  fallbackApiVersion: ""
```

Setting the ingressclass.kubernetes.io/is-default-class annotation (`isDefaultClass`) to true on an IngressClass resource will ensure that new Ingresses without an ingressClassName field specified will be assigned this default IngressClass.

The preceding K8s Ingress and IngressClass definitions and their renderings show the `controller: ingress.k8s.aws/alb` and this is the correct configuration for AWS EKS and AWS EKS Fargate ingress routing. For non-cloud K8s clusters (KinD, K3D, K0S, Rancher K8s, AWS EKS Anywhere) the Ingress Controller will cover a different range of IngressClasses (Kind defaults to using Nginx IngressController, K3D defaults to using Traefik) to function correctly. The default values.yaml currently defaults the IngressController kind to using `controller: ingress.k8s.aws/alb` which will not function with any of the listed non-cloud clusters. The new array of Helm Chart values-{target-env}.yaml files per its associated namespace is the correction for multi-tenant targeted deployments.

For non-cloud (local) K8s cluster, the preceding values.yaml section defining the IngressClass values for KiND or K3D would require the following changes to the `controller:` key as follows:

For KinD (default):

```
#### Ingress/IngressClass (> K8s 1.18-1.22+) #####
ingressClass:
  enabled: true
  labels: {}
  controller: nginx.org/ingress-controller   # For Nginx Inc Ingress
  isDefaultClass: true
  # Use to force a networking.k8s.io API Version for certain CI/CD applications. Such as : "v1"
  fallbackApiVersion: ""
```

or for Open-Source Nginx:

```
#### Ingress/IngressClass (> K8s 1.18-1.22+) #####
ingressClass:
  enabled: true
  labels: {}
  controller: k8s.io/ingress-nginx   # For Open Source Ingress
  isDefaultClass: true
  # Use to force a networking.k8s.io API Version for certain CI/CD applications. Such as : "v1"
  fallbackApiVersion: ""
```


For K3D (default):

```
#### Ingress/IngressClass (> K8s 1.18-1.22+) #####
ingressClass:
  enabled: true
  labels: {}
  controller: traefik.io/ingress-controller
  isDefaultClass: true
  # Use to force a networking.k8s.io API Version for certain CI/CD applications. Such as : "v1"
  fallbackApiVersion: ""
```

Thus a full rendering after the `helm template <release> <chart-dir>` or `helm install <release> <chart-dir> ` will yield the following K8s YAML for the IngressClass with the preceding values.yaml section:

```
# Source: qtest-mgr/templates/ingress-class.yaml
apiVersion: networking.k8s.io/v1
kind: IngressClass
metadata:
  name: "qtest-mgr-ingressclass"
  namespace: qtest
  annotations:
    ingressclass.kubernetes.io/is-default-class: "true"
spec:
  controller: traefik.io/ingress-controller
```

