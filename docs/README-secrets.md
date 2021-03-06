## qTest Secrets Using External Secrets
Kubernetes External Secrets allows you to use external secret management systems, like AWS Secrets Manager or HashiCorp Vault, to securely add secrets in Kubernetes. More information at [Kubernetes External Secrets](https://github.com/external-secrets/kubernetes-external-secrets).
### Configuration for AWS Secrets Manager Example
```
apiVersion: "kubernetes-client.io/v1"
kind: ExternalSecret
metadata:
  name: qtest-liquibase-secret
  namespace: qtest
spec:
  backendType: secretsManager
  data:
    - key: <AWS SECRET KEY>
      name: client.jdbc.postgres.password
      property: password
---
apiVersion: "kubernetes-client.io/v1"
kind: ExternalSecret
metadata:
  name: qtest-manager-secret
  namespace: qtest
spec:
  backendType: secretsManager
  data:
    - key: <AWS SECRET MANAGER KEY>
      name: client.jdbc.postgres.password
      property: password
    - key: <AWS SECRET MANAGER KEY>
      name: mail.password
      property: password
    - key: <AWS SECRET MANAGER KEY>
      name: client.jdbc.postgres.readonly.password
      property: password
    - key: <AWS SECRET MANAGER KEY>
      name: s3.secretKey
      property: s3secretkey
    - key: <AWS SECRET MANAGER KEY>
      name: s3.accessKey
      property: s3accesskey
```
