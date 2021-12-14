## qTest Tenancy (Single-Tenancy and Multi-Tenancy) using K8s Namespaces and Multi-Values Helm Deploy Targets

qTest app provisioning to K8s clusters can fall into two tenancy categories (single-tenant non-virtually isolated and multi-tenant virtually isolated). The entire qTest app fleet (qtest-*) will vacant the `qtest` namespace. To provision `qTest` apps across a range of deployment targets following GitOps strategy the qTest Helm Charts (each of the qTest app Helm Charts) provides the following `values-{target}.yaml` to coincide with each K8s deployment target.



Helm Chart (Values)     | K8s Namespace Association                                                       
----------------------- | ----------------------------------------------------------------------------------------------------------------------------------------
values.yaml             | The root-level values serves only globally overriding values for all Helm Charts.
values-nonprod-op.yaml  | The override values for Helm Chart template for qTest deployment to namespaced non-production on-prem K8s (K3D, KinD) targets.
values-nonprod.yaml     | The override values for Helm Chart template for qTest deployment to namespaced non-production cloud K8s (AWS EKS, EKS Fargate) targets.
values-test-op.yaml     | The override values for Helm Chart template for qTest deployment to namespaced test on-prem K8s (K3D, KinD) targets.
values-test.yaml        | The override values for Helm Chart template for qTest deployment to namespaced test cloud K8s (AWS EKS, EKS Fargate) targets.
values-staging-op.yaml  | The override values for Helm Chart template for qTest deployment to namespaced staging on-prem K8s (K3D, KinD) targets.
values-staging.yaml     | The override values for Helm Chart template for qTest deployment to namespaced staging cloud K8s (AWS EKS, EKS Fargate) targets.
values-prod-op.yaml     | The override values for Helm Chart template for qTest deployment to namespaced production on-prem K8s (K3D, KinD) targets.
values-prod.yaml        | The override values for Helm Chart template for qTest deployment to namespaced production cloud K8s (AWS EKS, EKS Fargate) targets.


