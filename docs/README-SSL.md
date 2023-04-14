# Configure SSL
To configure qTest Manager to use SSL, follow these steps:

1. Create your certificates and deploy them as a secret in the same namespace where qTest will be deployed.

2. The name of the secret must be qtest-ssl-root-secret.

3. Set the parameter serverAppSSLRequired to true.

By default, the pod certificate mounting path is /mnt/secrets/tls. To mount a different directory, change the parameter server.sslMountPath accordingly.

Note that additional SSL validation at the pod level may impact the performance of qTest.