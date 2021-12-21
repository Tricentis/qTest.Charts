## Setup IAM Policy for ServiceAccount for qTest Manager if using S3
Controller needs access to the AWS S3 resources via IAM permissions. The IAM permissions can either be setup via IAM roles for ServiceAccount or can be attached directly to the worker node IAM roles. Policies required:
```
Policies:
- PolicyName: 'poliicy-name'
    PolicyDocument:
    Version: '2012-10-17'
    Statement:
        - Effect: 'Allow'
        Action:
            - 's3:AbortMultipartUpload'
            - 's3:DeleteObject'
            - 's3:DeleteObjectTagging'
            - 's3:DeleteObjectVersion'
            - 's3:DeleteObjectVersionTagging'
            - 's3:Get*'
            - 's3:PutObject'
            - 's3:PutObjectTagging'
            - 's3:RestoreObject'
            - 's3:ListMultipartUploadParts'
```
More information on creating an IAM role and policy for your service account are located in [AWS EKS Userguide](https://docs.aws.amazon.com/eks/latest/userguide/create-service-account-iam-policy-and-role.html).

## Setup AWS Load Balancer Controller for ALB Ingress
AWS Load Balancer Controller is a controller to help manage Elastic Load Balancers for a Kubernetes cluster.

  - It satisfies Kubernetes [Ingress resources](https://kubernetes.io/docs/concepts/services-networking/ingress/) by provisioning [Application Load Balancers](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html).
  - It satisfies Kubernetes [Service resources](https://kubernetes.io/docs/concepts/services-networking/service/) by provisioning
[Network Load Balancers](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/introduction.html).

```sh
helm repo add eks https://aws.github.io/eks-charts
# If using IAM Roles for service account install as follows -  NOTE: you need to specify both of the chart values `serviceAccount.create=false` and `serviceAccount.name=aws-load-balancer-controller`
helm install aws-load-balancer-controller eks/aws-load-balancer-controller --set clusterName=my-cluster -n kube-system --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller
# If not using IAM Roles for service account
helm install aws-load-balancer-controller eks/aws-load-balancer-controller --set clusterName=my-cluster -n kube-system
```
More information on installing AWS LB Controller are located in [aws-load-balancer-controller](https://github.com/kubernetes-sigs/aws-load-balancer-controller/tree/main/helm/aws-load-balancer-controller).
